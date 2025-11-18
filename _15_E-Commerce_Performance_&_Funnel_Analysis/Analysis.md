## E-Commerce Performance & Funnel Analysis

This project focuses on understanding user behavior and purchase dynamics within an e-commerce web platform. Using event-level data collected from site interactions, the analysis explores:

- How customers move through the purchase funnel 
- How device type and geography influence behavior 
- How browser updates may impact conversion 
- How new versus returning users contribute to overall sales

The objective is to support product decision-making by identifying patterns, diagnosing potential issues, and highlighting opportunities for growth or optimization. 
Through a series of SQL-driven investigations and Power BI visualizations, the project provides a comprehensive view of the platform’s performance during the period from November 2020 to January 2021.

---

### Data

A single parsed events table, `turing_data_analytics.raw_events`, records various frontend actions on the site from 2020-11-01 to 2021-01-31.

- event_date 
- event_timestamp 
- event_name 
- event_value_in_usd 
- user_id 
- user_pseudo_id 
- user_first_touch_timestamp 
- category 
- mobile_model_name 
- mobile_brand_name 
- operating_system 
- language 
- is_limited_ad_tracking 
- browser 
- browser_version
- country 
- medium 
- name ng
- traffic_source 
- platform 
- total_item_quantity 
- purchase_revenue_in_usd 
- refund_value_in_usd 
- shipping_value_in_usd 
- tax_value_in_usd 
- transaction_id 
- page_title 
- page_location 
- source 
- page_referrer 
- campaign

---

### Analysis

The analysis begins with a high-level look at sales volume over a three-month period to establish the overall business trend.

```sql
SELECT
  PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
  COUNT(1) AS purchases_count
FROM `tc-da-1.turing_data_analytics.raw_events`
WHERE event_name = 'purchase'
GROUP BY purchase_date
ORDER BY purchase_date
```

<img width="1991" height="554" alt="image" src="https://github.com/user-attachments/assets/4293a533-976c-4569-b41e-b9f561e56a24" />

After observing a post-holiday decline, the data is segmented by country and device category to understand whether certain markets or platforms behaved differently. This helps determine whether the decline is systemic or localized.

#### Segmented by country:

```sql
SELECT
  PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
  country,
  COUNT(1) AS purchases_count
FROM `tc-da-1.turing_data_analytics.raw_events`
WHERE event_name = 'purchase'
GROUP BY purchase_date, country
```

<img width="1995" height="585" alt="image" src="https://github.com/user-attachments/assets/170db5b6-5c21-4de8-9e54-36c323a0574a" />

**Insight:** When segmented by country, purchases decline across all markets. The drop is most pronounced in the US, while post-holiday sales in key markets like India are almost not-existent.

#### Segmented by device:

```sql
SELECT
  PARSE_DATE('%Y%m%d', event_date) AS purchase_date,
  category,
  COUNT(1) AS purchases_count
FROM `tc-da-1.turing_data_analytics.raw_events`
WHERE event_name = 'purchase'
GROUP BY purchase_date, category
```
<img width="1986" height="526" alt="image" src="https://github.com/user-attachments/assets/b96bc28c-b773-45e8-a611-aeeb6c3e7bfe" />

**Insight:** No unexpected trends are observed, except that desktop purchases slightly exceeded mobile purchases during the pre-Christmas season.

---

Continuing the analysis, SQL is written to confirm that desktop purchases slightly exceeded mobile purchases.   
*CTEs are used to count daily desktop and mobile purchases, and the results are used to calculate their respective ratios.*

```sql
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
ORDER BY purchase_date ASC
```
<img width="1996" height="539" alt="image" src="https://github.com/user-attachments/assets/1f2ad8a5-037e-482d-a2fa-ae134e927b98" />

**Insight:** Desktop purchase ratios showed no unusual patterns before the holidays.

---

Next, the analysis shifts to user experience issues, prompted by a hypothesis that a **`recent Chrome browser update may have affected Apple users’ ability to complete purchases.`** A funnel analysis by browser version helps validate whether the conversion drop is meaningful or simply statistical noise.

```sql
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
GROUP BY browser_version
```

<img width="1937" height="461" alt="image" src="https://github.com/user-attachments/assets/9f1b482b-89be-47bf-82d0-d97bcdff1f7f" />


Given the sample sizes at the start and end of the funnel, we check if the difference is statistically significant. To validate this, used an online [A/B testing calculator:](https://www.surveymonkey.com/mp/ab-testing-significance-calculator/)

<img width="1734" height="668" alt="image" src="https://github.com/user-attachments/assets/04db3ef7-0e10-4fe0-8964-e0480607b9e2" />

**Insight:** Observed difference does not provide sufficient evidence to conclude that one browser version performs better than the other.

---

A researcher wants to know if returning customers can be identified and whether their user IDs and emails can be shared.
Because emails are GDPR-sensitive and not stored in the data warehouse, we can only provide user IDs. The CRM team can then map these IDs to emails in a GDPR-compliant way.

A “returning user” is defined as someone who makes a second (or later) purchase on a different day.

```sql
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
HAVING COUNT(1) > 1
```

<img width="629" height="306" alt="image" src="https://github.com/user-attachments/assets/d06c745f-2148-4885-a20d-749c50edf889" />

---

As the team becomes more interested in customer retention, the objective is to determine what proportion of total purchases is made by returning users.   

*Query: the first CTE returns purchase data by date and user ID, and the second returns each user’s first purchase date. In the final query, joined and produced aggregated daily results, including a flag indicating whether each purchase was made by a returning user.*

```sql
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
GROUP BY purchase_date, is_returning_user_purchase
```

<img width="1760" height="411" alt="image" src="https://github.com/user-attachments/assets/111d7dc3-c681-44fe-a001-e4c42cb1b8d0" />

**Insight:** The data shows that the majority of purchases are made by new users, with returning users contributing only a small share. This raises questions about retention strategy.

---

Determine the time users take to complete a purchase by measuring the duration between their first site visit and their first purchase on the same day.  

*Query: Calculates the average time it takes for users to make their first purchase each day. It identifies each user’s first event and first purchase per day, computes the time difference in minutes, and then aggregates these durations daily, along with the number of users who made a purchase. The result shows the daily progression of average purchase time and purchase volume.*

```sql
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
ORDER BY date
```
<img width="1763" height="580" alt="image" src="https://github.com/user-attachments/assets/3060ea14-d4bd-4a4c-bd4f-4ec37e5a2d57" />

**Insights:** The daily average time to purchase generally stays within the 40–100 minute range, suggesting a consistent user decision cycle. 

---

### Dashboard

<img width="2136" height="1331" alt="image" src="https://github.com/user-attachments/assets/23a44167-357b-40cc-9b24-4d8314636786" />

| # | Insight                                   | Summary                                                                                                           |
|---|--------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| 1 | Clear seasonal pattern in purchases              | Purchase volume peaks before holidays and drops sharply afterward across all major markets.                      |
| 2 | U.S. shows the steepest post-holiday decline     | All countries show a decline, but the U.S. experiences the most pronounced drop. India shows minimal post-holiday sales. |
| 3 | Stable device usage with December desktop bump   | Device usage is steady overall, with a slight increase in desktop purchases during December holiday shopping.    |
| 4 | No impact from browser version differences       | Chrome 86 vs. 87 on Apple devices shows no statistically significant conversion difference.                      |
| 5 | Returning users remain a small portion of buyers | Most purchases are from first-time customers, indicating limited repeat activity.                                |
| 6 | Time to purchase is consistent                   | Users typically convert within 40–100 minutes, averaging 67 minutes. Spikes occur but don’t indicate friction.   |


## Further Considerations & Recommendations

### 1. Strengthen retention strategy
Since returning users contribute very little to total purchases:
- Introduce targeted re-engagement campaigns via CRM  
- Evaluate onboarding flow and post-purchase experience  
- Consider integrating loyalty programs or personalized reminders  

### 2. Investigate post-holiday demand drop
Although seasonal, the drop is steep. Recommendations:
- Analyze marketing spend and campaign timing  
- Identify whether customer acquisition slowed disproportionately  
- Explore whether product assortment or pricing changes contributed to lower demand  

### 3. Improve cross-device and cross-platform consistency
The slight device-based differences suggest:
- Review desktop vs. mobile UX for conversion friction  
- Ensure layout, speed, and checkout flow are optimized across platforms  

### 4. Monitor browser version changes proactively
Even though no significant issues were found this time:
- Automate funnel tracking by browser + OS combinations  
- Set alerting thresholds for conversion drops  

### 5. Investigate time-to-purchase outliers
Spikes in time-to-purchase could indicate:
- Slow-loading pages  
- Confusing flows causing users to return later  
- Low-intent sessions that eventually convert  









