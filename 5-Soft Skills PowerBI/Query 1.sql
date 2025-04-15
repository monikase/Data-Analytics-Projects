/* FACT Sales Data */

-- CTE extracting product cost and applying date frame
WITH cte_productcost AS (
  SELECT
    productcosthistory.ProductID AS ProductID,
    CAST(productcosthistory.StartDate AS DATE) AS CostStartDate,
    IFNULL(CAST(productcosthistory.EndDate AS DATE), "2099-12-31") AS CostEndDate,
    productcosthistory.StandardCost AS ProductCost
  FROM `tc-da-1.adwentureworks_db.productcosthistory` AS productcosthistory
)
-- Main Query: salesorderheader & salesorderdetail tables
SELECT
  salesorderdetail.SalesOrderID AS OrderID,
  CAST(salesorderheader.OrderDate AS DATE) AS OrderDate,
  CAST(salesorderheader.ShipDate AS DATE) AS ShipDate,
  DATE_DIFF(CAST(salesorderheader.ShipDate AS DATE), CAST(salesorderheader.OrderDate AS DATE), DAY) AS ShippingDays,
  IFNULL(CAST(salesorderheader.SalesPersonID AS STRING), "Online") AS SalesPersonID,
  salesorderheader.CustomerID AS CustomerID,
  salesorderheader.TerritoryID AS TerritoryKey,
  stateprovince.CountryRegionCode AS CountryCode,
  country.Name AS Country,
  stateprovince.StateProvinceCode AS ProvinceCode,
  stateprovince.Name AS CountryStateName,
  salesorderdetail.ProductID AS ProductKey,
  salesorderdetail.OrderQty AS OrderQty,
  productcosts.ProductCost AS UnitCost,
  productcosts.ProductCost * salesorderdetail.OrderQty AS LineCost,
  salesorderdetail.LineTotal AS LineTotal
FROM `tc-da-1.adwentureworks_db.salesorderdetail` AS salesorderdetail
LEFT JOIN `tc-da-1.adwentureworks_db.salesorderheader` AS salesorderheader
       ON salesorderdetail.SalesOrderID = salesorderheader.SalesOrderID
LEFT JOIN `tc-da-1.adwentureworks_db.address` AS address
       ON salesorderheader.ShipToAddressID = address.AddressID
LEFT JOIN `tc-da-1.adwentureworks_db.stateprovince` AS stateprovince
       ON address.StateProvinceID = stateprovince.StateProvinceID
LEFT JOIN `tc-da-1.adwentureworks_db.countryregion` AS country
       ON stateprovince.CountryRegionCode = country.CountryRegionCode
LEFT JOIN cte_productcost AS productcosts
       ON salesorderdetail.ProductID = productcosts.ProductID
      AND CAST(salesorderheader.OrderDate AS DATE) >= productcosts.CostStartDate
      AND CAST(salesorderheader.OrderDate AS DATE) <= productcosts.CostEndDate
WHERE salesorderheader.Status NOT IN (4, 6)
