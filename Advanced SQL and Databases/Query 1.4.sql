/*
1.4 TASK
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
        LEFT(address.AddressLine1, STRPOS(address.AddressLine1, ' ')) AS address_no,
        RIGHT(address.AddressLine1, (LENGTH(address.AddressLine1) - LENGTH(LEFT(address.AddressLine1, STRPOS(address.AddressLine1, ' '))))) AS Address_st,
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
