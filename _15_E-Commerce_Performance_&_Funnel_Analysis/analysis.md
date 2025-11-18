## E-Commerce Performance & Funnel Analysis

This project focuses on understanding user behavior and purchase dynamics within an e-commerce web platform. Using event-level data collected from site interactions, the analysis explores:

- How customers move through the purchase funnel 
- How device type and geography influence behavior 
- How browser updates may impact conversion 
- How new versus returning users contribute to overall sales

The objective is to support product decision-making by identifying patterns, diagnosing potential issues, and highlighting opportunities for growth or optimization. 
Through a series of SQL-driven investigations and Power BI visualizations, the project provides a comprehensive view of the platform’s performance during the period from November 2020 to January 2021.

---

### DATA

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

### ANALYSIS

The analysis begins with a high-level look at sales volume over a three-month period to establish the overall business trend.





