/*
2.3 TASK
Enrich 2.2 query by adding ‘sales_rank’ column that ranks rows from best to worst for each country based on total amount with tax earned each month. 
I.e. the month where the (US, Southwest) region made the highest total amount with tax earned will be ranked 1 for that region and vice versa.
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
  sales_table.Total_w_Tax,
  RANK() OVER (PARTITION BY territories_table.CountryRegionCode ORDER BY SUM(sales_table.Total_w_Tax) DESC) AS sales_rank,
  SUM(sales_table.Total_w_Tax) OVER (PARTITION BY territories_table.Region ORDER BY sales_table.order_month) AS cumulative_sum
FROM sales_table
JOIN territories_table
  ON sales_table.TerritoryID = territories_table.TerritoryID
WHERE territories_table.Region = 'France'
ORDER BY territories_table.Region, sales_rank
