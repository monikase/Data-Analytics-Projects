/* DIM Customer */

WITH MaxOrderDates AS (
  SELECT 
    customer.CustomerID,
    customer.CustomerType,
    MAX(CAST(salesheader.OrderDate AS DATE)) AS LastOrderDate
  FROM `tc-da-1.adwentureworks_db.customer` AS customer
  LEFT JOIN `tc-da-1.adwentureworks_db.salesorderheader` AS salesheader
  ON customer.CustomerID = salesheader.CustomerID
  GROUP BY customer.CustomerID, customer.CustomerType
),
    LastOrder AS(
  SELECT
    MAX(CAST(OrderDate AS DATE)) AS LastTotalOrder
  FROM `tc-da-1.adwentureworks_db.salesorderheader`
)
SELECT
  customertable.CustomerID,
  customertable.CustomerType,
  CASE
    WHEN contact.LastName IS NULL THEN 'Store'
    ELSE CONCAT(contact.Firstname, ' ', contact.LastName)
  END AS ContactName,
  CASE
    WHEN DATE_DIFF((SELECT LastTotalOrder FROM LastOrder), customertable.LastOrderDate, DAY) >= 365 THEN 'Inactive'
    ELSE 'Active'
  END AS CustomerStatus
FROM MaxOrderDates AS customertable
LEFT JOIN `tc-da-1.adwentureworks_db.individual` AS individual
ON customertable.CustomerID = individual.CustomerID
LEFT JOIN `tc-da-1.adwentureworks_db.contact` AS contact
ON individual.ContactID = contact.ContactId
