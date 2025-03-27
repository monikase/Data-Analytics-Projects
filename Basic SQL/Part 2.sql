/* 2.1 Create an aggregated query to select the:
- Number of unique work orders.
- Number of unique products.
- Total actual cost.
- For each location Id from the 'workoderrouting' table for orders in January 2004. */

SELECT
  wr.LocationID,
  COUNT(wo.WorkOrderID) AS no_work_orders,
  COUNT(DISTINCT(wo.ProductID)) AS no_unique_product,
  SUM(wr.ActualCost) AS actual_cost
FROM `tc-da-1.adwentureworks_db.workorder` AS wo
JOIN `tc-da-1.adwentureworks_db.workorderrouting` AS wr
ON wo.WorkOrderID = wr.WorkOrderID
WHERE wr.ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY wr.LocationID
ORDER BY actual_cost DESC;

/* 2.2 Update your 2.1 query by adding:
- Name of the location
- The average days amount between actual start date and actual end date per each location. */

SELECT
  wr.LocationID, wl.Name AS Location,
  COUNT(wo.WorkOrderID) AS no_work_orders,
  COUNT(DISTINCT(wo.ProductID)) AS no_unique_product,
  SUM(wr.ActualCost) AS actual_cost,
  ROUND(AVG(DATE_DIFF(wr.ActualEndDate, wr.ActualStartDate, day)),2) AS avg_days_diffs
FROM `tc-da-1.adwentureworks_db.workorder` AS wo
JOIN `tc-da-1.adwentureworks_db.workorderrouting` AS wr
ON wo.WorkOrderID = wr.WorkOrderID
JOIN `tc-da-1.adwentureworks_db.location` AS wl
ON wr.LocationID = wl.LocationID
WHERE wr.ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY wr.LocationID, wl.Name
ORDER BY actual_cost DESC;

/* 2.3
- Select all the expensive work Orders (above 300 actual cost) that happened throught January 2004. */

SELECT
  wr.WorkOrderID,
  SUM(wr.ActualCost) AS actual_cost
FROM `tc-da-1.adwentureworks_db.workorderrouting` AS wr
WHERE wr.ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY wr.WorkOrderID
HAVING SUM(wr.ActualCost) > 300;

