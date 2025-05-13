# Fast Food Marketing Campaign A/B Test Analysis

This is an analysis of [Fast Food Marketing Campaign A/B Test dataset](https://www.kaggle.com/datasets/chebotinaa/fast-food-marketing-campaign-ab-test)


A fast-food chain plans to add a new item to its menu. However, they are still undecided between three possible marketing campaigns for promoting the new product. 
In order to determine which promotion has the greatest effect on sales, the new item is introduced at locations in several randomly selected markets. 
A different promotion is used at each location, and the weekly sales of the new item are recorded for the first four weeks.

## Quick Overview

![image](https://github.com/user-attachments/assets/421150d3-8b9f-4eea-a7ba-67f764c9f1a0)

## Goal of the Test

Evaluate A/B testing results and decide which marketing strategy works the best.

Since there are three marketing campaigns we will conduct several tests, comparing campaigns against one another. 
This kind of testing is known as pairwise comparisons, and it suffers from the multiple testing problem - if we run a lot of tests, there’s an increased chance of getting a type I error (false positive).  
**Therefore, for analysis of A/B test results we will use a confidence level of 99%. (1−α), where α = 0.01**

## General Approach

Since we have three promotions (1, 2, and 3), we'll perform three pairwise comparisons:

• Promotion 1 vs. Promotion 2  
• Promotion 1 vs. Promotion 3  
• Promotion 2 vs. Promotion 3  

• For each comparison, we'll set up a **null hypothesis (H<sub>0</sub>)** and an **alternative hypothesis (H<sub>a</sub>)**.  
• **Statistical Test:** we will use **Independent Samples t-test -** Used when comparing the means of two independent groups. 

## Hypotheses

**1. Promotion 1 vs. Promotion 2**

• H<sub>0</sub> (Null Hypothesis): There is no significant difference in the mean sales between Promotion 1 and Promotion 2.  
• H<sub>a</sub> (Alternative Hypothesis): There is a significant difference in the mean sales between Promotion 1 and Promotion 2.  

**2. Promotion 1 vs. Promotion 3**

• H<sub>0</sub> (Null Hypothesis): There is no significant difference in the mean sales between Promotion 1 and Promotion 3.   
• H<sub>a</sub> (Alternative Hypothesis): There is a significant difference in the mean sales between Promotion 1 and Promotion 3.  


**3. Promotion 2 vs. Promotion 3**

• H<sub>0</sub> (Null Hypothesis): There is no significant difference in the mean sales between Promotion 2 and Promotion 3.  
• H<sub>a</sub> (Alternative Hypothesis): There is a significant difference in the mean sales between Promotion 2 and Promotion 3.  
 

## Calculations

The table contains the numbers necessary to calculate the A/B test. You can find the query in the appendix.

| Metric | Promotion_1 | Promotion_2 | Promotion_3 |
| :-------: | :-----: | :-----: | :-----: |
| Sample mean ($\bar{x}$) | 232.396 | 189.318 | 221.458 |
| Sample size (n) | 43 | 47 | 47 |
| Std. deviation (s) | 64.113 | 57.988 | 65.535 |
| Variance (s<sup>2</sup>) | 4110.463 | 3362.653 | 4294.897 |
  
  
**Table 1.** Promotions Metrics needed for Independent samples t-test



### t-test 1. Promotion 1 vs. Promotion 2
  


$$ t = \frac{|\bar{x}_1 - \bar{x}_2|}{\sqrt{\frac{s_1^2}{n_1} + \frac{s_2^2}{n_2}}} = \frac{|232.398 - 189.318|}{\sqrt{\frac{4110.463}{43} + \frac{3362.653}{47}}} = \frac{43.078}{\sqrt{167.138}} = 3.332 $$  

$$ df = {n_1} + {n_2} - 2 = 43 + 47 - 2 = 88 $$  

$$ t\text{-critical}\ value \approx 2.632 $$

$$ p-value = 0.0013 $$

Conclusion: t-value is higher than a critical value 3.332 > 2.632

| t-value | critical value |
| :---: | :---: |
| 3.332 | 2.632 |


## Appendix

### Query for table 1

```sql
WITH
  AggregatedSales AS (
    -- Calculate total sales for each LocationID and PromotionID combination
    SELECT
      location_id AS LocationID,
      promotion AS PromotionID,
      SUM(sales_in_thousands) AS TotalSales
    FROM
      `tc-da-1.turing_data_analytics.wa_marketing_campaign`
    GROUP BY
      LocationID,
      PromotionID
  ),
  -- Calculate summary statistics for each promotion across all locations
  PromotionStats AS (
    SELECT
      PromotionID,
      AVG(TotalSales) AS Mean,
      COUNT(LocationID) AS SampleSize,
      STDDEV(TotalSales) AS StdDev,
      VAR_SAMP(TotalSales) AS Variance
    FROM
      AggregatedSales
    GROUP BY
      PromotionID
  )
-- Pivot the statistics into columns and add row labels
SELECT
  "Sample mean (μ)" AS Metric,
  -- Use a CASE statement to select the correct statistic for each PromotionID
  CAST(SUM(CASE WHEN PromotionID = 1 THEN Mean END) AS STRING) AS Promotion_1,
  CAST(SUM(CASE WHEN PromotionID = 2 THEN Mean END) AS STRING) AS Promotion_2,
  CAST(SUM(CASE WHEN PromotionID = 3 THEN Mean END) AS STRING) AS Promotion_3
FROM
  PromotionStats
UNION ALL
SELECT
  "Sample size (n)",
  CAST(SUM(CASE WHEN PromotionID = 1 THEN SampleSize END) AS STRING),
  CAST(SUM(CASE WHEN PromotionID = 2 THEN SampleSize END) AS STRING),
  CAST(SUM(CASE WHEN PromotionID = 3 THEN SampleSize END) AS STRING)
FROM
  PromotionStats
UNION ALL
SELECT
  "Std. deviation (s)",
  CAST(SUM(CASE WHEN PromotionID = 1 THEN StdDev END) AS STRING),
  CAST(SUM(CASE WHEN PromotionID = 2 THEN StdDev END) AS STRING),
  CAST(SUM(CASE WHEN PromotionID = 3 THEN StdDev END) AS STRING)
FROM
  PromotionStats
UNION ALL
SELECT
  "Variance (s2)",
  CAST(SUM(CASE WHEN PromotionID = 1 THEN Variance END) AS STRING),
  CAST(SUM(CASE WHEN PromotionID = 2 THEN Variance END) AS STRING),
  CAST(SUM(CASE WHEN PromotionID = 3 THEN Variance END) AS STRING)
FROM
  PromotionStats
```
