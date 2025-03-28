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
