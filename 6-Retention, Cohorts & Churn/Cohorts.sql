WITH cohort AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(subscription_start,week(MONDAY)) AS cohort_week,   -- Monday based weeks
    DATE_TRUNC(subscription_end,week(MONDAY)) AS end_week,
  FROM `tc-da-1.turing_data_analytics.subscriptions`
  WHERE subscription_start BETWEEN '2020-11-02' AND '2021-01-24' -- Only include full weeks
)

-- Main Query aggregates retention for each cohort week, calculating how many users remained subscribed over successive weeks
SELECT
  cohort_week,
  SUM (CASE WHEN cohort_week IS NOT NULL THEN 1 ELSE 0 END) AS week_0,                                              
  SUM (CASE WHEN cohort_week < end_week OR end_week IS NULL THEN 1 ELSE 0 END) AS week_1,
  SUM (CASE WHEN (DATE_ADD(cohort_week, INTERVAL 1 week)) < end_week OR end_week IS NULL THEN 1 ELSE 0 END) AS week_2,
  SUM (CASE WHEN (DATE_ADD(cohort_week, INTERVAL 2 week)) < end_week OR end_week IS NULL THEN 1 ELSE 0 END) AS week_3,
  SUM (CASE WHEN (DATE_ADD(cohort_week, INTERVAL 3 week)) < end_week OR end_week IS NULL THEN 1 ELSE 0 END) AS week_4,
  SUM (CASE WHEN (DATE_ADD(cohort_week, INTERVAL 4 week)) < end_week OR end_week IS NULL THEN 1 ELSE 0 END) AS week_5,
  SUM (CASE WHEN (DATE_ADD(cohort_week, INTERVAL 5 week)) < end_week OR end_week IS NULL THEN 1 ELSE 0 END) AS week_6,
FROM cohort
GROUP BY cohort_week
ORDER BY cohort_week;
