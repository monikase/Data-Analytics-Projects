/*
2.1 TASK
Create a query of monthly sales numbers in each Country & region. 
Include in the query a number of orders, customers and sales persons in each month with a total amount with tax earned. 
Sales numbers from all types of customers are required.
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
  )
-- MAIN QUERY
SELECT
  sales_table.order_month,
  territories_table.CountryRegionCode,
  territories_table.Region,
  sales_table.number_orders,
  sales_table.number_customers,
  sales_table.no_salesPerson,
  sales_table.Total_w_Tax
FROM sales_table
JOIN territories_table
  ON sales_table.TerritoryID = territories_table.TerritoryID
