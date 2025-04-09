/*  Version 1  */

WITH unique_events AS (
  SELECT
    user_pseudo_id,
    MIN(event_timestamp) AS first_event,
    event_name,
    country
  FROM `tc-da-1.turing_data_analytics.raw_events`
  GROUP BY user_pseudo_id, event_name, country
),
funnel AS (
  SELECT
    country,
    event_name,
    COUNT(*) AS event_count,
    CASE event_name
      WHEN "session_start" THEN 1
      WHEN "view_item" THEN 2
      WHEN "add_to_cart" THEN 3
      WHEN "begin_checkout" THEN 4
      WHEN "add_payment_info" THEN 5
      WHEN "purchase" THEN 6
      ELSE 0
    END AS event_order
  FROM unique_events
  GROUP BY country, event_name
),
first_event_counts AS (
  SELECT
    country,
    MAX(event_count) AS first_event_count
  FROM funnel
  WHERE event_order = 1
  GROUP BY country
)
SELECT
  event_order,
  event_name,
  SUM (CASE WHEN funnel.country = "United States" THEN event_count END) AS United_States_events,
  SUM (CASE WHEN funnel.country = "India" THEN event_count END) AS India_events,
  SUM (CASE WHEN funnel.country = "Canada" THEN event_count END) AS Canada_events,
  SUM (event_count) / MAX(SUM(event_count)) OVER () AS Full_perc,
  SUM (CASE WHEN funnel.country = "United States" THEN event_count END) / MAX(CASE WHEN funnel.country = "United States" THEN first_event_count END) AS United_States_perc_drop,
  SUM (CASE WHEN funnel.country = "India" THEN event_count END) / MAX(CASE WHEN funnel.country = "India" THEN first_event_count END) AS India_perc_drop,
  SUM (CASE WHEN funnel.country = "Canada" THEN event_count END) / MAX(CASE WHEN funnel.country = "Canada" THEN first_event_count END) AS Canada_perc_drop
FROM funnel
LEFT JOIN first_event_counts
       ON funnel.country = first_event_counts.country
WHERE event_order != 0
GROUP BY event_order, event_name
ORDER BY event_order;

/*  Version 2  (without hardcoding country name)*/

WITH unique_events AS (
  SELECT
    user_pseudo_id,
    MIN(event_timestamp) AS first_event,
    event_name,
    country
  FROM `tc-da-1.turing_data_analytics.raw_events`
  GROUP BY user_pseudo_id, event_name, country
),
top_countries AS (
  SELECT
    country,
    COUNT(*) AS events_per_country
  FROM unique_events
  GROUP BY country
  ORDER BY events_per_country DESC
  LIMIT 3
),
funnel AS (
  SELECT
    country,
    event_name,
    COUNT(*) AS event_count,
    CASE event_name
      WHEN "session_start" THEN 1
      WHEN "view_item" THEN 2
      WHEN "add_to_cart" THEN 3
      WHEN "begin_checkout" THEN 4
      WHEN "add_payment_info" THEN 5
      WHEN "purchase" THEN 6
      ELSE 0
    END AS event_order
  FROM unique_events
  GROUP BY country, event_name
),
first_event_counts AS (
  SELECT
    country,
    MAX(event_count) AS first_event_count
  FROM funnel
  WHERE event_order = 1
  GROUP BY country
)
SELECT
  event_order,
  event_name,
  SUM(CASE WHEN funnel.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 0) THEN event_count END) AS United_States_events,
  SUM(CASE WHEN funnel.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 1) THEN event_count END) AS India_events,
  SUM(CASE WHEN funnel.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 2) THEN event_count END) AS Canada_events,
  SUM(event_count) / MAX(SUM(event_count)) OVER () AS Full_perc,
  SUM(CASE WHEN funnel.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 0) THEN event_count END) / MAX(CASE WHEN funnel.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 0) THEN first_event_count END) AS United_States_perc_drop,
  SUM(CASE WHEN funnel.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 1) THEN event_count END) / MAX(CASE WHEN funnel.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 1) THEN first_event_count END) AS India_perc_drop,
  SUM(CASE WHEN funnel.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 2) THEN event_count END) / MAX(CASE WHEN funnel.country = (SELECT country FROM top_countries LIMIT 1 OFFSET 2) THEN first_event_count END) AS Canada_perc_drop
FROM funnel
LEFT JOIN first_event_counts
  ON funnel.country = first_event_counts.country
WHERE event_order != 0
GROUP BY event_order, event_name
ORDER BY event_order;
