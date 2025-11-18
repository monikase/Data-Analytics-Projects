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

Field name                          | Type
-----------------------------------|---------
event_date                         | STRING
event_timestamp                    | INTEGER
event_name                         | STRING
event_value_in_usd                 | FLOAT
user_id                            | STRING
user_pseudo_id                     | STRING
user_first_touch_timestamp         | INTEGER
category                           | STRING
mobile_model_name                  | STRING
mobile_brand_name                  | STRING
operating_system                   | STRING
language                           | STRING
is_limited_ad_tracking             | STRING
browser                            | STRING
browser_version                    | STRING
country                            | STRING
medium                             | STRING
name                               | STRING
traffic_source                     | STRING
platform                           | STRING
total_item_quantity                | INTEGER
purchase_revenue_in_usd           | FLOAT
refund_value_in_usd                | FLOAT
shipping_value_in_usd             | FLOAT
tax_value_in_usd                   | FLOAT
transaction_id                     | STRING
page_title                         | STRING
page_location                      | STRING
source                             | STRING
page_referrer                      | STRING
campaign                           | STRING
