# Fast Food Marketing Campaign A/B Test Analysis

[Project on GitHub](https://github.com/monikase/Data-Analytics-Projects/blob/main/_10-AB%20Testing/AB%20Analysis.md)  
Query is in Appendix (Page 13)

A fast-food chain tested three marketing campaigns for a new menu item by launching it across randomly selected locations, each using a different promotion. Weekly sales were tracked over four weeks to assess performance.

The data analysis included making sure that the attributes of each promotion group were symmetrically distributed to ensure the A/B test results were fair and correct. Ultimately, examining variable distributions and adjusting the sample size ensured group similarity for a trustworthy A/B test.

## Goal of Analysis

Evaluate which marketing strategy works the best and has statistically significant differences among the test groups.


### Dataset

Dataset is taken from [Kaggle](https://www.kaggle.com/datasets/chebotinaa/fast-food-marketing-campaign-ab-test) with these columns:
 
- *MarketID:* unique identifier for market
- *MarketSize:* size of market area by sales
- *LocationID:* unique identifier for store location
- *AgeOfStore:* age of store in years
- *Promotion:* one of three promotions that were tested
- *week:* one of four weeks when the promotions were run
- *SalesInThousands:* sales amount for a specific LocationID, Promotion, and week


## General Approach

- **Data Analysis :** Making sure that the attributes of each promotion group are symmetrically distributed so that the results of this A/B test are fair and correct.
- **Pairwise Comparison :** Since we have three promotions (1, 2, and 3), we'll perform three pairwise comparisons:  
  • Promotion 1 vs. Promotion 2  
  • Promotion 1 vs. Promotion 3  
  • Promotion 2 vs. Promotion 3  

*This increases the chance of a false positive due to multiple comparisons. Therefore, for analysis of A/B test results we will use a **confidence level of 99%.**
- **Hypotheses :** For each comparison, we'll set up a **null hypothesis (H<sub>0</sub>)** and an **alternative hypothesis (H<sub>a</sub>)**.
- **Statistical Test :** we will use **Independent Samples two-tailed t-test -** Used when comparing the means of two independent groups.  
**Note:** we could do a single hypothesis test by using ANOVA. However, ANOVA only tells us that there is a difference between groups. We also care about the direction of the difference, in addition to significance, and that requires another test.
- **Interpret Results :** In which direction metrics are significant statistically and practically.
- **Launch Decision :** Arrive at the final data-driven decision - which marketing strategy considered best for launching.


## Data Analysis 

**Deal with Outliers and set equal sample proportion:**
- After analyzing dataset outliers were found and eliminated: Promotion 1 **(7)**, Promotion 2 **(6)**, Promotion 3 **(5)**. Therefore, the sample size reduced to 36 random samples per each promotion group.

<img width="1963" height="585" alt="image" src="https://github.com/user-attachments/assets/cb7c8662-9262-4e50-9429-e60dc9046f6b" />

- Promotions were evenly assigned across 36 locations, eliminating location bias.
- Promotion 3 led in total sales (35.67%), slightly outperforming Promotion 2 (35.43%) and Promotion 1 (28.90%).
- Weekly sales distribution remained stable, with Promotion 3 peaking in Week 2 and Promotion 2 lowest in Week 4.
- Market size variation offers strategic insight into performance differences.


$\implies$ **Examining variable distributions and adjusting sample size ensured group similarity, for meaningful and trustworthy A/B testing.**  

---

## Hypotheses

**1. Promotion 1 vs. Promotion 2**
- H<sub>0</sub> (Null Hypothesis): There is no significant difference in the mean sales between Promotion 1 and Promotion 2.  
- H<sub>a</sub> (Alternative Hypothesis): There is a significant difference in the mean sales between Promotion 1 and Promotion 2.  

**2. Promotion 1 vs. Promotion 3**
- H<sub>0</sub> : There is no significant difference in the mean sales between Promotion 1 and Promotion 3.   
- H<sub>a</sub> : There is a significant difference in the mean sales between Promotion 1 and Promotion 3.  


**3. Promotion 2 vs. Promotion 3**
- H<sub>0</sub> : There is no significant difference in the mean sales between Promotion 2 and Promotion 3.  
- H<sub>a</sub> : There is a significant difference in the mean sales between Promotion 2 and Promotion 3.  

## Target Metrics

**Primary Metrics**
- Mean Sales: This metric is used to identify the promotion that leads the highest average sales.
- Statistical Significance of the Difference in Mean Sales (p-value): This is used to determine if the differences observed in mean sales between promotions are statistically significant.

**Secondary Metrics**
- Effect Size (Cohen's d): This metric helps determine the practical significance of the difference in mean sales.
- Distribution within Each Promotion Group: This is used for ensuring that the distribution of market sizes is similar across the promotion groups, which is important for the validity of the A/B test.

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
    <td> 207.859 </td>
    <td> 165.275 </td>
    <td> 190.053 </td>
  </tr>
  <tr>
    <td> Sample size (n) </td>
    <td> 36 </td>
    <td> 36 </td>
    <td> 36 </td>
  </tr>
  <tr>
    <td> Std. deviation (s) </td>
    <td> 33.249 </td>
    <td> 30.015 </td>
    <td> 30.876 </td>
  </tr>
  <tr>
    <td> Variance (s<sup>2</sup>) </td>
    <td> 1105.489 </td>
    <td> 900.895 </td>
    <td> 953.342 </td>
  </tr>
</table>
<p align="center"> <sup>Table 1. Metrics needed for Independent samples t-test</sup> </p align="center">


## 1. Promotion 1 vs. Promotion 2

#### Using extracted metrics perform t-test calculations:
(Also can be found on [Google Spreadsheet](https://docs.google.com/spreadsheets/d/1MHubB4LabEpGiU_laga0oTvKTTpvIa4w-OtuR-zoGzU/edit?usp=sharing)) 

$$ t-value = \frac{|\bar{x}_1 - \bar{x}_2|}{\sqrt{\frac{s_1^2}{n_1} + \frac{s_2^2}{n_2}}} = \frac{|207.859 - 165.275|}{\sqrt{\frac{1105.489}{36} + \frac{900.895}{36}}} =  5.704$$  


$$ df = {n_1} + {n_2} - 2 = 36 + 36 - 2 = 70 $$  

<table align="center">
<tr>
  <th> t-value </th>
  <th> critical t-value </th>
  <th> p-value </th>
  <th> α </th>
</tr>
<tr>
  <td> 5.704 </td>
  <td> 2.648 </td>
  <td> 0.00000026 </td>
  <td> 0.01 </td>
</tr>
</table>

#### Summary:

<table align="center">
<tr>
  <th> Decision Rule </th>
  <th> Comparison </th>
  <th> Conclusion </th>
</tr>
<tr>
  <td> Reject if t-value > critical t-value </td>
  <td> t=5.704 > critical t=2.648 </td>
  <td> $\implies$ We can reject H<sub>0</sub> hypothesis </td>
</tr>
 <tr>
  <td> Reject if p-value < α </td>
  <td> p=0.00000026 < α=0.01 </td>
  <td> $\implies$ We can reject H<sub>0</sub> hypothesis  </td>
</tr>
</table>

<p align="center"> We can also use <a href="https://www.evanmiller.org/ab-testing/t-test.html">Evan Miller 2 Sample T-Test</a> to do this test from raw sales data. </p align="center">

<p align="center"> <sub> Sample 1 - Promotion 1, Sample 2 - Promotion 2 </sub></p>


<p align="center">
  <img width="325" height="406" alt="image" src="https://github.com/user-attachments/assets/70c64382-eb36-4425-bf22-c7714fcf89bb" />

</p>

---

There is no overlap between these intervals (Promotion 2's highest value, 178.901, is below Promotion 1's lowest, 192.765), suggesting a significant difference in mean sales.   

Treatment Effect $\implies$ Promotion 1 led to ~42.584 more in mean sales than Promotion 2


### Practical significance calculations:

**Pooled Standard Deviation :**  
Calculate the variance of two campaigns, assuming that they have equal variances.

$s_p^2 = \frac{(n_1 - 1)s_1^2 + (n_2 - 1)s_2^2}{n_1 + n_2 - 2} = 31.673$

**Effect size (Cohen's d):**  
Calculate the measure of effect size that quantifies the standardized difference between the means of two groups. (How far apart two group means are in terms of their standard deviation)

$d=(\bar{x}_1-\bar{x}_2)/s_p^2=1.344$

| Decision Rule |
| :----- |
| d≈0.2 - Small effect  | 
| d≈0.5 - Medium effect |
| d≈0.8 or greater - Large effect |  


$\implies$ Cohen's d = 1.344 indicates a large effect size.

  
### Validation: 

$\implies$ Since t-value > critical t-value, and p-value < α, **H<sub>0</sub> is rejected.</font>**  
- **There is a significant difference** in the mean sales between Promotion 1 and Promotion 2. 
- Treatment Effect: Promotion 1 led to aproximately 42.584 more of sales than Promotion 2
- The 99% confidence intervals for the mean sales of Promotion 1 and Promotion 2 do not overlap, and provides evidence that the mean sales between the two promotions are significantly different.
- **The chance of type I error** (rejecting a correct H<sub>0</sub>) **is small**: 0.000026 (0.000026%).
- Practical significance: Cohen's d of 1.34 indicates a **large effect size**.
     

## 2. Promotion 1 vs. Promotion 3

#### T-test calculations:

$$ t-value = \frac{|\bar{x}_1 - \bar{x}_3|}{\sqrt{\frac{s_1^2}{n_1} + \frac{s_3^2}{n_3}}} = \frac{|207.859 - 190.053|}{\sqrt{\frac{1105.489}{36} + \frac{953.342}{36}}} = 2.354 $$  


$$ df = {n_1} + {n_3} - 2 = 36 + 36 - 2 = 70 $$  

<table align="center">
<tr>
  <th> t-value </th>
  <th> critical t-value </th>
  <th> p-value </th>
  <th> α </th>
</tr>
<tr>
  <td> 2.354 </td>
  <td> 2.648 </td>
  <td> 0.0214 </td>
  <td> 0.01 </td>
</tr>
</table>

</br>
</br>
</br>
</br>

#### Summary:

<table align="center">
<tr>
  <th> Decision Criteria </th>
  <th> Comparison </th>
  <th> Conclusion </th>
</tr>
<tr>
  <td> Reject if t-value > critical t-value </td>
  <td> t-value=2.354 < critical t=2.648 </td>
  <td> $\implies$ We cannot reject H<sub>0</sub> hypothesis </td>
</tr>
 <tr>
  <td> Reject if p-value < α </td>
  <td> p-value=0.0214 > α=0.01 </td>
  <td> $\implies$ We cannot reject H<sub>0</sub> hypothesis </td>
</tr>
</table>


<p align="center"> <a href="https://www.evanmiller.org/ab-testing/t-test.html">Evan Miller 2 Sample T-Test</a> </p align="center">

<p align="center"> <sub> Sample 1 - Promotion 1, Sample 2 - Promotion 3 </sub></p>



<p align="center">
  <img width="325" height="406" alt="image" src="https://github.com/user-attachments/assets/945fc8ed-f69b-45c0-93da-2b8ea893145a" />
</p>

Treatment Effect $\implies$ Promotion 1 resulted to aproximately 17.806 more in mean sales than Promotion 3.

Despite Promotion 1 resulting in ~17.806 more in mean sales than Promotion 3, the 99% confidence intervals exhibit a small overlap. This overlap occurs where Promotion 1's interval falls within Promotion 3's interval, suggesting that their mean sales could be similar in that specific range, even though Promotion 1 generally has higher sales. This finding is supported by the statistical analysis, which determined there is no significant difference in the mean sales between Promotion 1 and Promotion 3.    

</br>

### Practical significance

**Pooled Standard Deviation :**  
Calculate the variance of two campaigns, assuming that they have equal variances.  

$s_p^2 = \frac{(n_1 - 1)s_1^2 + (n_3 - 1)s_3^2}{n_1 + n_3 - 2} = 32.0845$

**Effect size (Cohen's d):**
Calculate the measure of effect size that quantifies the standardized difference between the means of two groups. (How far apart two group means are in terms of their standard deviation)  

$d=(\bar{x}_1-\bar{x}_3)/s_p^2=0.555$

| Decision Rule |
| :----- |
| d≈0.2 - Small effect  | 
| d≈0.5 - Medium effect |
| d≈0.8 or greater - Large effect | 

$\implies$ Cohen's d = 0.555 indicates a medium effect size. 

### Validation: 

$\implies$ Since t-value < critical t-value, and p-value > α,  **H<sub>0</sub> cannot be rejected.**   
- **There is no significant difference** in the mean sales between Promotion 1 and Promotion 3.
- Treatment Effect: Promotion 1 resulted to aproximately 17.806 more in mean sales than Promotion 3.
- The 99% confidence interval hasve a small overlap, indicating that their mean sales could be similar in that range, although Promotion 1 generally has higher sales.
- **The chance of type I error** (rejecting a correct H<sub>0</sub>) **is high**: 0.02136 (2.14%).
- Practical significance: Cohen's d of 0.555 indicates a **medium effect size**.


## 3. Promotion 2 vs. Promotion 3

#### T-test calculations:

$$ t-value = \frac{|\bar{x}_2 - \bar{x}_3|}{\sqrt{\frac{s_2^2}{n_2} + \frac{s_3^2}{n_3}}} = \frac{|165.275 - 190.053|}{\sqrt{\frac{900.895}{36} + \frac{953.342}{36}}} = 3.453 $$  


$$ df = {n_2} + {n_3} - 2 = 36 + 36 - 2 = 70 $$  


<table align="center">
<tr>
  <th> t-value </th>
  <th> critical t-value </th>
  <th> p-value </th>
  <th> α </th>
</tr>
<tr>
  <td> 3.453 </td>
  <td> 2.648 </td>
  <td> 0.000946 </td>
  <td> 0.01 </td>
</tr>
</table>

#### Summary:

<table align="center">
<tr>
  <th> Decision Criteria </th>
  <th> Comparison </th>
  <th> Conclusion </th>
</tr>
<tr>
  <td> Reject if t-value > critical t-value </td>
  <td> t-value=3.453 > critical t=2.648 </td>
  <td> $\implies$ We reject H<sub>0</sub> hypothesis </td>
</tr>
 <tr>
  <td> Reject if p-value < α </td>
  <td> p-value=0.000946 < α=0.01 </td>
  <td> $\implies$ We reject H<sub>0</sub> hypothesis </td>
</tr>
</table>

<p align="center"> <a href="https://www.evanmiller.org/ab-testing/t-test.html">Evan Miller 2 Sample T-Test</a> </p align="center">

<p align="center"> <sub> Sample 1 - Promotion 2, Sample 2 - Promotion 3 </sub></p>


<p align="center">
  <img width="325" height="406" alt="image" src="https://github.com/user-attachments/assets/b700a126-87b6-443b-9e63-de8eb0193606" />


Treatment Effect $\implies$ Promotion 3 resulted to aproximately 24.778 more in mean sales than Promotion 2.

Despite Promotion 3 resulting in ~24.778 more in mean sales than Promotion 2, the 99% confidence intervals show a small overlap, where Promotion 3's interval falls within Promotion 2's. However, the statistical analysis confirms a significant difference in mean sales between Promotion 2 and Promotion 3, indicating that Promotion 3 generally has higher sales.

 
### Practical significance

**Pooled Standard Deviation :**
Calculate the variance of two campaigns, assuming that they have equal variances.  

$s_p^2 = \frac{(n_2 - 1)s_2^2 + (n_3 - 1)s_3^2}{n_2 + n_3 - 2} = 30.449$

**Effect size (Cohen's d):**
Calculate the measure of effect size that quantifies the standardized difference between the means of two groups. (How far apart two group means are in terms of their standard deviation)  

$d=(\bar{x}_2-\bar{x}_3)/s_p^2=-0.814$

| Decision Rule |
| :----- |
| d≈0.2 - Small effect  | 
| d≈0.5 - Medium effect |
| d≈0.8 or greater - Large effect | 

$\implies$ Cohen's d = -0.814 indicates a large effect size, with the negative sign signifying that the Promotion 3 has a higher mean than Promotion 2.
  
### Validation: 

$\implies$ Since t-value < critical t-value, and p-value > α, **H<sub>0</sub> is rejected.</font>**  
- **There is a significant difference** in the mean sales between Promotion 2 and Promotion 3.
- Treatment Effect: Promotion 3 resulted to aproximately 24.778 more in mean sales than Promotion 2.
- In 99% confidence interval there is a small overlap (Promotion 3's value falls within Promotion 2's interval), indicating that their mean sales could be similar in that range, although Promotion 3 generally has higher sales.   
- **The chance of type I error** (rejecting a correct H<sub>0</sub>) **is small**: 0.000946 (0.095%).
- Practical significance: Cohen's d of -0.814 indicates a **large effect size**, with the negative sign signifying that the **Promotion 3 has a higher mean than Promotion 2**.


---
</br>

# Decision

Given all the insights from the A/B test analysis, the most logical and data-driven final decision would be to roll out **Promotion 1** as the primary marketing campaign for the new menu item across all locations.


**Rationale for this decision:**  

<table align="center">
  <tr>
    <td> <b>Statistically Significant Higher Sales</b> </td>
    <td> Promotion 1 significantly increased mean sales over Promotion 2 (99% confidence), proving its greater effectiveness in driving purchases. </td>
  </tr>
  <tr>
    <td> <b>No Significant Difference with Promotion 3</b> </td>
    <td> Despite Promotion 3 showing numerically better mean sales than Promotion 2, it wasn't significantly different from Promotion 1, so we can't conclude it outperformed the latter. </td>
  </tr>
  <tr>
    <td> <b>Prioritizing Proven Effectiveness</b> </td>
    <td> When launching a new product, prioritize the option demonstrably and confidently impacting the key metric (sales). Promotion 1 shows this impact. </td>
  </tr>
</table>


**However, this final decision should be implemented with the following considerations:**  

<table align="center">
  <tr>
    <td> <b>Cost Analysis</b> </td>
    <td> A thorough cost analysis of implementing Promotion 1 across all locations is needed before full launch to guarantee increased sales outweigh costs for a positive return on investment (ROI). </td>
  </tr>
  <tr>
    <td> <b>Further Exploration of Promotion 3</b> </td>
    <td> Although not the primary choice, Promotion 3's statistically better performance than Promotion 2 deserves further investigation for insights into future campaigns or refining Promotion 1. </td>
  </tr>
  <tr>
    <td> <b>Discontinuation or Significant Revision of Promotion 2</b> </td>
    <td> Given its underperformance, Promotion 2 should likely be discontinued or undergo a significant overhaul if there's a strong strategic reason to keep exploring it. </td>
  </tr>
 <tr>
    <td> <b>Ongoing Monitoring</b> </td>
    <td> Even after implementing Promotion 1, continuous performance monitoring is crucial due to changing market conditions, competitor actions, and customer preferences, ensuring sustained success through sales and other relevant metric tracking. </td>
  </tr>
</table> 

</br>

## Appendix

### Query for table 1

```sql
WITH AggregatedSales AS (
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
PromotionStats AS (
  -- Calculate summary statistics for each promotion across all locations
  SELECT
    PromotionID,
    AVG(TotalSales) AS Mean,
    COUNT(LocationID) AS OriginalSampleSize,
    STDDEV(TotalSales) AS StdDev,
    VAR_SAMP(TotalSales) AS Variance
  FROM
    AggregatedSales
  GROUP BY
    PromotionID
),
PercentileStats AS (
  -- Use APPROX_QUANTILES for approximate percentiles to determine Q1 and Q3 for outlier detection
  SELECT
    PromotionID,
    (APPROX_QUANTILES(TotalSales, 100))[OFFSET(25)] AS Q1,
    (APPROX_QUANTILES(TotalSales, 100))[OFFSET(75)] AS Q3
  FROM
    AggregatedSales
  GROUP BY
    PromotionID
),
PromotionStatsCombined AS (
  -- Combine initial statistics with percentile data for outlier calculation
  SELECT
    ps.*,
    pstats.Q1,
    pstats.Q3
  FROM
    PromotionStats ps
    JOIN PercentileStats pstats ON ps.PromotionID = pstats.PromotionID
),
OutlierHandledSales AS (
  -- Flag outliers based on the IQR method (1.5 * IQR rule)
  SELECT
    s.LocationID,
    s.PromotionID,
    s.TotalSales,
    ps.Q1,
    ps.Q3,
    ps.OriginalSampleSize,
    CASE
      WHEN s.TotalSales < (ps.Q1 - 1.5 * (ps.Q3 - ps.Q1))
      OR s.TotalSales > (ps.Q3 + 1.5 * (ps.Q3 - ps.Q1))
      THEN 1
      ELSE 0
    END AS IsOutlier
  FROM
    AggregatedSales AS s
    JOIN PromotionStatsCombined AS ps ON s.PromotionID = ps.PromotionID
),
SubsampledSales AS (
  -- Subsample each promotion group to have exactly 36 data points after outlier removal.
  -- RAND() ensures a random selection, avoiding bias.
  SELECT
    LocationID,
    PromotionID,
    TotalSales,
    ROW_NUMBER() OVER (
      PARTITION BY PromotionID
      ORDER BY RAND()
    ) AS rn
  FROM
    OutlierHandledSales
  WHERE
    IsOutlier = 0
),
FinalStats AS (
  -- Compute final statistics (Mean, Sample Size, StdDev, Variance) for the subsampled data
  SELECT
    PromotionID,
    AVG(TotalSales) AS Mean,
    COUNT(LocationID) AS SampleSize,
    STDDEV(TotalSales) AS StdDev,
    VAR_SAMP(TotalSales) AS Variance
  FROM
    SubsampledSales
  WHERE
    rn <= 36
  GROUP BY
    PromotionID
)
-- Format the final output into a single table structure, casting numeric values to STRING
-- to match the desired presentation format for "Table 1" in the analysis.
SELECT
  "Sample mean (μ)" AS Metric,
  CAST(SUM(CASE WHEN PromotionID = 1 THEN Mean END) AS STRING) AS Promotion_1,
  CAST(SUM(CASE WHEN PromotionID = 2 THEN Mean END) AS STRING) AS Promotion_2,
  CAST(SUM(CASE WHEN PromotionID = 3 THEN Mean END) AS STRING) AS Promotion_3
FROM
  FinalStats
UNION ALL
SELECT
  "Sample size (n)",
  CAST(SUM(CASE WHEN PromotionID = 1 THEN SampleSize END) AS STRING) AS Promotion_1,
  CAST(SUM(CASE WHEN PromotionID = 2 THEN SampleSize END) AS STRING) AS Promotion_2,
  CAST(SUM(CASE WHEN PromotionID = 3 THEN SampleSize END) AS STRING) AS Promotion_3
FROM
  FinalStats
UNION ALL
SELECT
  "Std. deviation (s)",
  CAST(SUM(CASE WHEN PromotionID = 1 THEN StdDev END) AS STRING) AS Promotion_1,
  CAST(SUM(CASE WHEN PromotionID = 2 THEN StdDev END) AS STRING) AS Promotion_2,
  CAST(SUM(CASE WHEN PromotionID = 3 THEN StdDev END) AS STRING) AS Promotion_3
FROM
  FinalStats
UNION ALL
SELECT
  "Variance (s²)",
  CAST(SUM(CASE WHEN PromotionID = 1 THEN Variance END) AS STRING) AS Promotion_1,
  CAST(SUM(CASE WHEN PromotionID = 2 THEN Variance END) AS STRING) AS Promotion_2,
  CAST(SUM(CASE WHEN PromotionID = 3 THEN Variance END) AS STRING) AS Promotion_3
FROM
  FinalStats;
```
