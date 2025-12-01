/*
1.1 TASK
You’ve been tasked to create a detailed overview of all individual customers (these are defined by customerType = ‘I’ and/or stored in an individual table). Write a query that provides:
- Identity information : CustomerId, Firstname, Last Name, FullName (First Name & Last Name).
- An Extra column called addressing_title i.e. (Mr. Achong), if the title is missing - Dear Achong.
- Contact information : Email, phone, account number, CustomerType.
- Location information : City, State & Country, address.
- Sales: number of orders, total amount (with Tax), date of the last order.
- Few customers have multiple addresses, to avoid duplicate data take their latest available address by choosing max(AddressId)
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
        ROUND((SUM(SubTotal) + SUM(TaxAmt) + SUM(Freight)), 3) AS total_amount, -- TotalDue display the same amount
        MAX(OrderDate) AS date_last_order
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
  orders_table.date_last_order
FROM customer_table
JOIN contacts_table
  ON customer_table.CustomerID = contacts_table.CustomerID
JOIN address_table
  ON customer_table.CustomerID = address_table.CustomerID
JOIN orders_table
  ON customer_table.CustomerID = orders_table.CustomerID
WHERE customer_table.CustomerType = 'I'
ORDER BY orders_table.total_amount DESC
LIMIT 200;
