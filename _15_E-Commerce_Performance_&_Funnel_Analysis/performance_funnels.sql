SELECT
  PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
  COUNT(1) AS purchases_count
FROM `tc-da-1.turing_data_analytics.raw_events`
WHERE event_name = 'purchase'
GROUP BY purchase_date
ORDER BY purchase_date;

-- Segmented by country
SELECT
  PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
  country,
  COUNT(1) AS purchases_count
FROM `tc-da-1.turing_data_analytics.raw_events`
WHERE event_name = 'purchase'
GROUP BY purchase_date, country;

-- Segmented by device
SELECT
  PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
  category,
  COUNT(1) AS purchases_count
FROM `tc-da-1.turing_data_analytics.raw_events`
WHERE event_name = 'purchase'
GROUP BY purchase_date, category;


-- CTE used to count daily desktop and mobile purchases, and the results are used to calculate their respective ratios.
WITH purchases_raw AS (
   SELECT
     PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
     SUM(CASE WHEN category = 'desktop' THEN 1 ELSE 0 END) AS desktop_purchases,
     SUM(CASE WHEN category = 'mobile' THEN 1 ELSE 0 END) AS mobile_purchases,
     COUNT(1) AS all_purchases
   FROM `tc-da-1.turing_data_analytics.raw_events`
   WHERE event_name = 'purchase'
   GROUP BY purchase_date
)

SELECT
  purchase_date,
  desktop_purchases / all_purchases AS desktop_purchases_ratio,
  mobile_purchases / all_purchases AS mobile_purchases_ratio
FROM purchases_raw
ORDER BY purchase_date ASC;

-- Funnel analysis by browser version
WITH funnel_raw AS (
    SELECT
      user_pseudo_id,
      browser_version,
      MAX(CASE WHEN event_name = 'session_start' THEN 1 ELSE 0 END) AS did_session_start,
      MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS did_view_item,
      MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS did_add_to_cart,
      MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS did_begin_checkout,
      MAX(CASE WHEN event_name = 'add_payment_info' THEN 1 ELSE 0 END) AS did_add_payment_info,
      MAX(CASE WHEN event_name = 'add_shipping_info' THEN 1 ELSE 0 END) AS did_add_shipping_info,
      MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS did_purchase
    FROM `tc-da-1.turing_data_analytics.raw_events`
    WHERE mobile_brand_name = 'Apple'
    AND browser = 'Chrome'
    AND browser_version IN ('86.0', '87.0')
    GROUP BY user_pseudo_id, browser_version
)

SELECT
  browser_version,
  COUNT(1) AS all_count,
  SUM(did_session_start) AS did_session_start,
  SUM(did_view_item) AS did_view_item,
  SUM(did_add_to_cart) AS did_add_to_cart,
  SUM(did_begin_checkout) AS did_begin_checkout,
  SUM(did_add_shipping_info) AS did_add_shipping_info,
  SUM(did_add_payment_info) AS did_add_payment_info,
  SUM(did_purchase) AS did_purchase
FROM funnel_raw
GROUP BY browser_version;


-- Returning user extraction
WITH raw_purchases AS (
   SELECT
     PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
     user_pseudo_id
   FROM `tc-da-1.turing_data_analytics.raw_events`
   WHERE event_name = 'purchase'
   GROUP BY purchase_date, user_pseudo_id
)


SELECT
  user_pseudo_id,
  COUNT(1) AS purchase_count
FROM raw_purchases
GROUP BY user_pseudo_id
HAVING COUNT(1) > 1;

-- First CTE returns purchase data by date and user ID, and the second returns each user’s first purchase date. In the final query, joined and produced aggregated daily results, including a flag indicating whether each purchase was made by a returning user.

WITH raw_purchases AS (
    SELECT
      PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
      user_pseudo_id
    FROM `tc-da-1.turing_data_analytics.raw_events`
    WHERE event_name = 'purchase'
),


first_purchase AS (
    SELECT
      user_pseudo_id,
      MIN(purchase_date) AS first_purchase_date,
    FROM raw_purchases
    GROUP BY user_pseudo_id
)


SELECT
  rp.purchase_date AS purchase_date,
  CASE WHEN rp.purchase_date != fp.first_purchase_date THEN TRUE ELSE FALSE END AS is_returning_user_purchase,
  COUNT(1) AS purchases_cnt
FROM raw_purchases rp
JOIN first_purchase fp
ON rp.user_pseudo_id = fp.user_pseudo_id
GROUP BY purchase_date, is_returning_user_purchase;


-- Calculates the average time it takes for users to make their first purchase each day. It identifies each user’s first event and first purchase per day, computes the time difference in minutes, and then aggregates these durations daily, along with the number of users who made a purchase. The result shows the daily progression of average purchase time and purchase volume.
WITH events AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS date,
    user_pseudo_id,
    event_name,
    TIMESTAMP_MICROS(event_timestamp) AS ts
  FROM `tc-da-1.turing_data_analytics.raw_events`
),

-- First event per user per day
first_touch AS (
  SELECT
    date,
    user_pseudo_id,
    MIN(ts) AS first_event_ts
  FROM events
  GROUP BY date, user_pseudo_id
),

-- First purchase per user per day
first_purchase AS (
  SELECT
    date,
    user_pseudo_id,
    MIN(ts) AS first_purchase_ts
  FROM events
  WHERE event_name = 'purchase'
  GROUP BY date, user_pseudo_id
),

-- Join to calculate duration
user_durations AS (
  SELECT
    ft.date,
    ft.user_pseudo_id,
    TIMESTAMP_DIFF(fp.first_purchase_ts, ft.first_event_ts, MINUTE) AS minutes_to_purchase
  FROM first_touch ft
  JOIN first_purchase fp
    ON ft.date = fp.date
   AND ft.user_pseudo_id = fp.user_pseudo_id
)

-- MainQuery. Daily progression
SELECT
  date,
  AVG(minutes_to_purchase) AS avg_minutes_to_purchase,
  COUNT(*) AS num_users_with_purchase
FROM user_durations
GROUP BY date
ORDER BY date;



