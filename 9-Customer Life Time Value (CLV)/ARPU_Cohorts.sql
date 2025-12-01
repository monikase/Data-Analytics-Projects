WITH
  cohorts AS (
    SELECT
      DISTINCT user_pseudo_id AS user_id,
      DATE_TRUNC(MIN(PARSE_DATE('%Y%m%d', event_date)), WEEK) AS registration_week
    FROM `tc-da-1.turing_data_analytics.raw_events`
    GROUP BY user_pseudo_id
),
orders AS (
  SELECT
    user_pseudo_id AS user_id,
    purchase_revenue_in_usd AS purchase,
    DATE_TRUNC(PARSE_DATE('%Y%m%d', event_date), WEEK) AS purchase_week
  FROM `tc-da-1.turing_data_analytics.raw_events`
  WHERE event_name = 'purchase' AND purchase_revenue_in_usd > 0
),
join_data AS (
  SELECT
    cohorts.user_id,
    cohorts.registration_week,
    orders.purchase,
    orders.purchase_week
  FROM cohorts
  LEFT JOIN orders
         ON cohorts.user_id = orders.user_id
  WHERE cohorts.registration_week <= '2021-01-24'
)
SELECT
  join_data.registration_week AS cohort_week,
  COUNT(join_data.user_id) AS registrations,
  SUM (CASE WHEN join_data.purchase_week = join_data.registration_week THEN join_data.purchase END) / (COUNT(DISTINCT user_id)) AS week_0,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 1 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_1,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 2 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_2,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 3 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_3,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 4 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_4,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 5 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_5,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 6 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_6,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 7 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_7,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 8 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_8,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 9 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_9,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 10 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_10,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 11 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_11,
  SUM (CASE WHEN join_data.purchase_week = DATE_ADD (join_data.registration_week, INTERVAL 12 WEEK) THEN join_data.purchase END) / (COUNT (DISTINCT user_id)) AS week_12
FROM join_data
GROUP BY cohort_week
ORDER BY cohort_week
