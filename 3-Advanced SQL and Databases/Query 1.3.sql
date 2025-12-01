/*
1.3 TASK
Enrich your original 1.1 SELECT by creating a new column in the view that marks active & inactive customers based on whether they have ordered anything during the last 365 days.
- Copy only the top 500 rows from your written select ordered by CustomerId desc.
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
        COALESCE(address.AddressLine2, '') AS AddressLine2,
        state.Name AS State,
        country.Name AS Country
      FROM `tc-da-1.adwentureworks_db.customeraddress` AS customer_address
      JOIN latest_address_table
        ON customer_address.AddressID = latest_address_table.address_update
      JOIN `tc-da-1.adwentureworks_db.address` AS address
        ON customer_address.AddressID = address.AddressID
      JOIN `tc-da-1.adwentureworks_db.stateprovince` AS state
        ON address.StateProvinceID = state.StateProvinceID
      JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
        ON state.CountryRegionCode = country.CountryRegionCode
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
ORDER BY customer_table.CustomerId DESC
LIMIT 500;
