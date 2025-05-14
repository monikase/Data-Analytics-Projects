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

• H<sub>0</sub> : There is no significant difference in the mean sales between Promotion 1 and Promotion 3.   
• H<sub>a</sub> : There is a significant difference in the mean sales between Promotion 1 and Promotion 3.  


**3. Promotion 2 vs. Promotion 3**

• H<sub>0</sub> : There is no significant difference in the mean sales between Promotion 2 and Promotion 3.  
• H<sub>a</sub> : There is a significant difference in the mean sales between Promotion 2 and Promotion 3.  
 

## Calculations

The table contains the metrics necessary to calculate the A/B test. Query is in the appendix.

<table align="center">
  <tr>
    <th> Metric </th>
    <th> Promotion_1 </th>
    <th> Promotion_2 </th>
    <th> Promotion_3 </th>
  </tr>
  <tr>
    <td> Sample mean ($\bar{x}$) </td>
    <td> 232.396 </td>
    <td> 189.318 </td>
    <td> 221.458 </td>
  </tr>
  <tr>
    <td> Sample size (n) </td>
    <td> 43 </td>
    <td> 47 </td>
    <td> 47 </td>
  </tr>
  <tr>
    <td> Std. deviation (s) </td>
    <td> 64.113 </td>
    <td> 57.988 </td>
    <td> 65.535 </td>
  </tr>
  <tr>
    <td> Variance (s<sup>2</sup>) </td>
    <td> 4110.463 </td>
    <td> 3362.653 </td>
    <td> 4294.897 </td>
  </tr>
</table>
<p align="center"> <sub>Table 1. Metrics needed for Independent samples t-test</sub> </p align="center">
</br>

## 1. Promotion 1 vs. Promotion 2
</br>
</br>

$$ t-value = \frac{|\bar{x}_1 - \bar{x}_2|}{\sqrt{\frac{s_1^2}{n_1} + \frac{s_2^2}{n_2}}} = \frac{|232.396 - 189.318|}{\sqrt{\frac{4110.463}{43} + \frac{3362.653}{47}}} = \frac{43.078}{\sqrt{167.138}} = 3.332 $$  

</br>

$$ df = {n_1} + {n_2} - 2 = 43 + 47 - 2 = 88 $$  

</br>

$$ t\text{-critical}\ value\ (\ from\ t-table\ )\ \approx 2.632 $$

</br>

<table align="center">
<tr>
  <th> t-value </th>
  <th> t-critical value </th>
  <th> p-value </th>
  <th> α </th>
</tr>
<tr>
  <td> 3.332 </td>
  <td> 2.632 </td>
  <td> 0.0013 </td>
  <td> 0.01 </td>
</tr>
</table>
</br>

<table align="center">
<tr>
  <th> Explanation </th>
  <th> Comparison </th>
  <th> Conclusion </th>
</tr>
<tr>
  <td> t-value > critical value </td>
  <td> 3.332 > 2.632 </td>
  <td> $\implies$ We can reject H<sub>0</sub> hypothesis </td>
</tr>
 <tr>
  <td> p-value < α </td>
  <td> 0.0013 < 0.01 </td>
  <td> $\implies$ We can reject H<sub>0</sub> hypothesis  </td>
</tr>
</table>
</br>

<p align="center"> We can also use <a href="https://www.evanmiller.org/ab-testing/t-test.html">Evan Miller 2 Sample T-Test</a> to do this test from raw sales data. Query is in the appendix. </p align="center">

<p align="center"> <sub> Sample 1 - Promotion 1, Sample 2 - Promotion 2 </sub></p>

</br>

<p align="center">
  <img width="750" height="520" src="https://github.com/user-attachments/assets/14dd6ed7-f798-4a7f-a4fc-ba9fbcaa6704">
</p>

</br>
  
Verdict:  
**There is a significant difference in the mean sales between Promotion 1 and Promotion 2.  
Promotion 1 Mean is greater than Promotion 2.**


## 2. Promotion 1 vs. Promotion 3
</br>
</br>

$$ t-value = \frac{|\bar{x}_1 - \bar{x}_3|}{\sqrt{\frac{s_1^2}{n_1} + \frac{s_3^2}{n_3}}} = \frac{|232.396 - 221.458|}{\sqrt{\frac{4110.463}{43} + \frac{4294.897}{47}}} = \frac{10.938}{\sqrt{186.973}} = 0.7999 $$  

</br>

$$ df = {n_1} + {n_3} - 2 = 43 + 47 - 2 = 88 $$  

</br>

$$ t\text{-critical}\ value\ (\ from\ t-table\ )\ \approx 2.635 $$

</br>

<table align="center">
<tr>
  <th> t-value </th>
  <th> critical t-value </th>
  <th> p-value </th>
  <th> α </th>
</tr>
<tr>
  <td> 0.7999 </td>
  <td> 2.635 </td>
  <td> 0.4259 </td>
  <td> 0.01 </td>
</tr>
</table>
</br>

<table align="center">
<tr>
  <th> Explanation </th>
  <th> Comparison </th>
  <th> Conclusion </th>
</tr>
<tr>
  <td> t-value < critical value </td>
  <td> 0.7999 < 2.635 </td>
  <td> $\implies$ We cannot reject H<sub>0</sub> hypothesis </td>
</tr>
 <tr>
  <td> p-value > α </td>
  <td> 0.4259 > 0.01 </td>
  <td> $\implies$ We cannot reject H<sub>0</sub> hypothesis </td>
</tr>
</table>
</br>

<p align="center"> <a href="https://www.evanmiller.org/ab-testing/t-test.html">Evan Miller 2 Sample T-Test</a> </p align="center">

<p align="center"> <sub> Sample 1 - Promotion 1, Sample 2 - Promotion 3 </sub></p>

</br>

<p align="center">
  <img width="750" height="520" src="https://github.com/user-attachments/assets/ca8e3c47-2281-4ea2-9204-f53d32d1aad5">
</p>

</br>
  
Verdict:  
**There is no significant difference in the mean sales between Promotion 1 and Promotion 3.**

## 3. Promotion 2 vs. Promotion 3
</br>
</br>

$$ t-value = \frac{|\bar{x}_2 - \bar{x}_3|}{\sqrt{\frac{s_2^2}{n_2} + \frac{s_3^2}{n_3}}} = \frac{|189.318 - 221.458|}{\sqrt{\frac{3362.653}{47} + \frac{4294.897}{47}}} = \frac{10.938}{\sqrt{186.973}} = 2.518 $$  

</br>

$$ df = {n_2} + {n_3} - 2 = 47 + 47 - 2 = 92 $$  

</br>

$$ t\text{-critical}\ value\ (\ from\ t-table\ )\ \approx 2.627 $$

</br>

<table align="center">
<tr>
  <th> t-value </th>
  <th> critical t-value </th>
  <th> p-value </th>
  <th> α </th>
</tr>
<tr>
  <td> 2.518 </td>
  <td> 2.627 </td>
  <td> 0.0135 </td>
  <td> 0.01 </td>
</tr>
</table>
</br>

<table align="center">
<tr>
  <th> Explanation </th>
  <th> Comparison </th>
  <th> Conclusion </th>
</tr>
<tr>
  <td> t-value < critical value </td>
  <td> 2.518 < 2.627 </td>
  <td> $\implies$ We cannot reject H<sub>0</sub> hypothesis </td>
</tr>
 <tr>
  <td> p-value > α </td>
  <td> 0.0135 > 0.01 </td>
  <td> $\implies$ We cannot reject H<sub>0</sub> hypothesis </td>
</tr>
</table>
</br>

<p align="center"> <a href="https://www.evanmiller.org/ab-testing/t-test.html">Evan Miller 2 Sample T-Test</a> </p align="center">

<p align="center"> <sub> Sample 1 - Promotion 2, Sample 2 - Promotion 3 </sub></p>

</br>

<p align="center">
  <img width="750" height="520" src="https://github.com/user-attachments/assets/eecb4cbb-398d-4c3a-9101-59fb87799d69">
</p>

</br>
  
Verdict:  
**There is no significant difference in the mean sales between Promotion 2 and Promotion 3.**

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
### Query for Evan Miller Test

```sql
WITH AggregatedSales AS (
    SELECT
        location_id AS LocationID,
        promotion AS PromotionID,
        SUM(sales_in_thousands) AS TotalSales
    FROM
        `tc-da-1.turing_data_analytics.wa_marketing_campaign` 
    GROUP BY
        LocationID,
        PromotionID
)
SELECT 
    LocationID,
    SUM(CASE WHEN PromotionID = 1 THEN TotalSales END) AS Promotion_1,
    SUM(CASE WHEN PromotionID = 2 THEN TotalSales END) AS Promotion_2,
    SUM(CASE WHEN PromotionID = 3 THEN TotalSales END) AS Promotion_3
FROM 
    AggregatedSales
GROUP BY LocationID
ORDER BY LocationID;
```
