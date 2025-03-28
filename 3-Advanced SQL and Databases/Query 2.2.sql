/*
2.2 TASK
Enrich 2.1 query with the cumulative_sum of the total amount with tax earned per country & region.
- Hint: use CTE or subquery
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
  SUM(sales_table.Total_w_Tax) OVER (PARTITION BY territories_table.Region ORDER BY sales_table.order_month) AS cumulative_sum
FROM sales_table
JOIN territories_table
  ON sales_table.TerritoryID = territories_table.TerritoryID
