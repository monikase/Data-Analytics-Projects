/* Query to import 'FACT Sales Data' */

SELECT 
  salesheader.SalesOrderID,
  salesheader.OrderDate,
  salesheader.ShipDate,
  salesheader.SalesOrderNumber AS OrderNumber,
  salesheader.CustomerID AS CustomerKey,
  salesheader.TerritoryID AS TerritoryKey,
  salesdetail.ProductID AS ProductKey,
  salesdetail.OrderQty AS OrderQuantity,
  salesheader.TotalDue,
  salesheader.SalesPersonID
FROM `tc-da-1.adwentureworks_db.salesorderdetail` AS salesdetail
JOIN `tc-da-1.adwentureworks_db.salesorderheader` AS salesheader
ON salesdetail.SalesOrderID = salesheader.SalesOrderID

/* Query to import 'DIM Product' */

SELECT
  product.ProductID AS ProductKey,
  product.ProductSubcategoryID AS ProductSubcategoryKey,
  product.Name AS ProductName,
  product.ListPrice AS ProductPrice
FROM `tc-da-1.adwentureworks_db.product` AS product

/* Query to import 'DIM Product SubCategory' */

SELECT
  subcategory.ProductSubcategoryID AS ProductSubcategoryKey,
  subcategory.ProductCategoryID AS ProductCategoryKey,
  subcategory.Name AS SubcategoryName
FROM `tc-da-1.adwentureworks_db.productsubcategory` AS subcategory

/* Query to import 'DIM Product Category' */

SELECT
  category.ProductCategoryID AS ProductCategoryKey,
  category.Name AS CategoryName
FROM `tc-da-1.adwentureworks_db.productcategory` AS category

/* Query to import 'DIM Customer' */

SELECT
  customer.ContactId AS CustomerKey,
  customer.Title,
  customer.Firstname,
  customer.LastName
FROM `tc-da-1.adwentureworks_db.contact` AS customer

/* Query to import 'DIM Territory' */

SELECT
  territory.TerritoryID AS TerritoryKey,
  territory.Name AS Region,
  territory.CountryRegionCode,
  country.Name AS Country,  
  territory.Group AS Continent
FROM `tc-da-1.adwentureworks_db.salesterritory` AS territory
INNER JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
        ON territory.CountryRegionCode = country.CountryRegionCode
ORDER BY territory.TerritoryID

/* Query to import 'FACT Sales Reason' (From hands-on Task) */

WITH sales_per_reason AS (
 SELECT
   DATE_TRUNC(OrderDate, MONTH) AS year_month,
   sales_reason.SalesReasonID,
   SUM(sales.TotalDue) AS sales_amount
 FROM
   `tc-da-1.adwentureworks_db.salesorderheader` AS sales
 INNER JOIN
   `tc-da-1.adwentureworks_db.salesorderheadersalesreason` AS sales_reason
 ON
   sales.SalesOrderID = sales_reason.salesOrderID
 GROUP BY 1,2
)
SELECT
 sales_per_reason.year_month,
 reason.Name AS sales_reason,
 sales_per_reason.sales_amount
FROM
 sales_per_reason
LEFT JOIN
 `tc-da-1.adwentureworks_db.salesreason` AS reason
ON
 sales_per_reason.SalesReasonID = reason.SalesReasonID
