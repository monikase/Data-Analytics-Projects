# SQL Tasks (II) using BigQuery

Explanations and queries: [Google Sheet](https://docs.google.com/spreadsheets/d/1dtS0I7dlqFrQQmTqkeSznCe86vQnYJearFEqzydz3ME/edit?usp=sharing)

- Query 1.4 : An overview of customers

```sql
/*
Business would like to extract data on all active customers from North America. Only customers that have either ordered no less than 2500 in total amount (with Tax) or ordered 5 + times should be presented.
- In the output for these customers divide their address line into two columns
- Order the output by country, state and date_last_order.
*/

-- CTES:
WITH
    customer_table AS (
      SELECT
        CustomerID,
        AccountNumber,
        CustomerType
      FROM `tc-da-1.adwentureworks_db.customer` AS customer
    ),
    contacts_table AS (
      SELECT
        CustomerID,
        contact.FirstName,
        contact.LastName,
        CONCAT(FirstName, ' ', contact.LastName) AS full_name,
        CONCAT((
        CASE
           WHEN contact.title IS NULL THEN 'Dear'
           ELSE contact.title
        END), ' ', contact.lastname) AS addressing_title,
        contact.emailaddress,
        contact.phone
      FROM `tc-da-1.adwentureworks_db.contact` AS contact
      JOIN `tc-da-1.adwentureworks_db.individual` AS individual
        ON contact.ContactId = individual.ContactID
    ),
    latest_address_table AS (
      SELECT
        customer_address.CustomerID,
        MAX(customer_address.AddressID) AS address_update
      FROM `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
      GROUP BY customer_address.CustomerID
    ),
    address_table AS (
      SELECT
        latest_address_table.CustomerID,
        address.City,
        address.AddressLine1,
        REGEXP_EXTRACT(address.AddressLine1, '^([0-9]+) .+') AS address_no,
        REGEXP_EXTRACT(address.AddressLine1, '^[0-9]+ (.+)') AS Address_st,
        COALESCE(address.AddressLine2, '') AS AddressLine2,
        state.Name AS State,
        country.Name AS Country,
        territory.Group AS territory
      FROM `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
      JOIN latest_address_table
        ON customer_address.AddressID = latest_address_table.address_update
      JOIN `tc-da-1.adwentureworks_db.address` AS address
        ON customer_address.AddressID = address.AddressID
      JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
        ON address.StateProvinceID = state.StateProvinceID
      JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
        ON state.CountryRegionCode = country.CountryRegionCode
"      JOIN `tc-da-1.adwentureworks_db.salesterritory` AS territory
        "
        ON state.TerritoryID = territory.TerritoryID
    ),
    orders_table AS (
      SELECT
        CustomerID,
        COUNT(*) AS number_orders,
        ROUND((SUM(SubTotal) + SUM(TaxAmt) + SUM(Freight)), 3) AS total_amount,
        MAX(OrderDate) AS date_last_order,
        CASE
          WHEN MAX(OrderDate) > DATE_SUB((SELECT MAX(OrderDate) FROM `tc-da-1.adwentureworks_db.salesorderheader`), INTERVAL 365 DAY)
          THEN 'active' ELSE 'inactive'
        END AS activity
      FROM `tc-da-1.adwentureworks_db.salesorderheader` AS orders
      GROUP BY CustomerID
    )
-- MAIN QUERY
SELECT
  customer_table.CustomerId,
  contacts_table.FirstName,
  contacts_table.LastName,
  contacts_table.full_name,
  contacts_table.addressing_title,
  contacts_table.EmailAddress,
  contacts_table.Phone,
  customer_table.AccountNumber,
  customer_table.CustomerType,
  address_table.City,
  address_table.AddressLine1,
  address_table.address_no,
  address_table.Address_st,
  address_table.AddressLine2,
  address_table.State,
  address_table.Country,
  orders_table.number_orders,
  orders_table.total_amount,
  orders_table.date_last_order,
  orders_table.activity
FROM customer_table
JOIN contacts_table
  ON customer_table.CustomerID = contacts_table.CustomerID 
JOIN address_table
  ON customer_table.CustomerID = address_table.CustomerID
JOIN orders_table
  ON customer_table.CustomerID = orders_table.CustomerID
WHERE customer_table.CustomerType = 'I'
AND orders_table.activity = 'active'
-- AND address_table.Country IN ('Canada', 'United States')
AND address_table.territory = 'North America'
AND (orders_table.total_amount >= 2500 OR orders_table.number_orders >= 5)
ORDER BY address_table.Country, address_table.State, orders_table.date_last_order
LIMIT 500;
```

- Query 2.4 : Reporting Sales' numbers

```sql
/*
2.4 TASK
Enrich 2.3 query by adding taxes on a country level:
- As taxes can vary in country based on province, the needed column is ‘mean_tax_rate’ -> average tax rate in a country.
- Also, as not all regions have data on taxes, you also want to be transparent and show the ‘perc_provinces_w_tax’ -> a column representing the percentage of provinces with available tax rates for each country 
(i.e. If US has 53 provinces, and 10 of them have tax rates, then for US it should show 0,19)
- Hint: If a state has multiple tax rates, choose the higher one. Do not double count a state in country average rate calculation if it has multiple tax rates.
- Hint: Ignore the isonlystateprovinceFlag rate mechanic, it is beyond the scope of this exercise. Treat all tax rates as equal.
*/

-- CTES
WITH
  sales_table AS (
    SELECT
      TerritoryID,
      LAST_DAY(CAST(OrderDate AS DATE)) AS order_month,
      COUNT(SalesOrderID) AS number_orders,
      COUNT(DISTINCT(CustomerID)) AS number_customers,
      COUNT(DISTINCT(SalesPersonID)) AS no_salesPerson,
      CAST(ROUND((SUM(SubTotal) + SUM(TaxAmt) + SUM(Freight))) AS INT64) AS Total_w_Tax
    FROM `tc-da-1.adwentureworks_db.salesorderheader`
    GROUP BY TerritoryID, order_month
  ),
  territories_table AS (
    SELECT
      TerritoryID,
      CountryRegionCode,
      Name AS Region
    FROM `tc-da-1.adwentureworks_db.salesterritory`
  ),
  max_taxes_table AS (
    SELECT
      state.StateProvinceID,
      MAX(tax_rate.TaxRate) AS max_tax_rate
    FROM `tc-da-1.adwentureworks_db.stateprovince` AS state
    LEFT JOIN `tc-da-1.adwentureworks_db.salestaxrate` AS tax_rate
    ON state.StateProvinceID = tax_rate.StateProvinceID
    GROUP BY state.StateProvinceID
),
  taxes_table AS (
    SELECT
      state.CountryRegionCode,
      ROUND(AVG(max_taxes_table.max_tax_rate), 1) AS mean_tax_rate,
      ROUND( ( COUNT(max_taxes_table.max_tax_rate) / COUNT(state.StateProvinceID) ), 2 ) AS perc_provinces_w_tax
    FROM `tc-da-1.adwentureworks_db.stateprovince` AS state
    JOIN max_taxes_table 
      ON max_taxes_table.StateProvinceID = state.StateProvinceID
    GROUP BY state.CountryRegionCode
)
-- MAIN QUERY
SELECT
  sales_table.order_month,
  territories_table.CountryRegionCode,
  territories_table.Region,
  sales_table.number_orders,
  sales_table.number_customers,
  sales_table.no_salesPerson,
  sales_table.Total_w_Tax,
  DENSE_RANK() OVER (PARTITION BY territories_table.CountryRegionCode, territories_table.Region ORDER BY sales_table.Total_w_Tax DESC) AS sales_rank,
  SUM(sales_table.Total_w_Tax) OVER (PARTITION BY territories_table.Region ORDER BY sales_table.order_month) AS cumulative_sum,
  taxes_table.mean_tax_rate,
  taxes_table.perc_provinces_w_tax
FROM sales_table
JOIN territories_table
  ON sales_table.TerritoryID = territories_table.TerritoryID
JOIN taxes_table
  ON territories_table.CountryRegionCode = taxes_table.CountryRegionCode
WHERE territories_table.CountryRegionCode = 'US'
ORDER BY sales_table.Total_w_Tax DESC
```
