## Fast Food Marketing Campaign A/B Test Analysis

This is an analysis of [Fast Food Marketing Campaign A/B Test dataset](https://www.kaggle.com/datasets/chebotinaa/fast-food-marketing-campaign-ab-test)

## About Dataset

A fast-food chain plans to add a new item to its menu. However, they are still undecided between three possible marketing campaigns for promoting the new product. 
In order to determine which promotion has the greatest effect on sales, the new item is introduced at locations in several randomly selected markets. 
A different promotion is used at each location, and the weekly sales of the new item are recorded for the first four weeks.

Columns(7):  

• *MarketID*: unique identifier for market (10 unique)  
• *MarketSize*: size of market area by sales (small, medium, large)  
• *LocationID*: unique identifier for store location (137 unique)  
• *AgeOfStore*: age of store in years (min: 1, avg: 8,5, max: 28)  
• *Promotion*: one of three promotions that were tested (1, 2, 3)  
• *week*: one of four weeks when the promotions were run (1, 2, 3, 4)  
• *SalesInThousands*: sales amount for a specific LocationID, Promotion, and week 

Total Rows(548)

## Quick Overview

![image](https://github.com/user-attachments/assets/421150d3-8b9f-4eea-a7ba-67f764c9f1a0)

## Goal of the Test

Evaluate A/B testing results and decide which marketing strategy works the best.

Since there are three marketing campaigns we will conduct several tests, comparing campaigns against one another. 
This kind of testing is known as pairwise comparisons, and it suffers from the multiple testing problem - if we run a lot of tests, there’s an increased chance of getting a type I error (false positive). 
**Therefore, for analysis of A/B test results we will use a confidence level of 99%. (1−α), where α = 0.01**

## Target metric

• sales_in_thousands - sales amount for a specific LocationID, Promotion, and week, we aggregate it by LocationID and PromotionID

## General Approach

Since we have three promotions (1, 2, and 3), we'll perform three pairwise comparisons:

• Promotion 1 vs. Promotion 2  
• Promotion 1 vs. Promotion 3  
• Promotion 2 vs. Promotion 3  

For each comparison, we'll set up a null hypothesis (H0) and an alternative hypothesis (Ha).

## Hypotheses

**1. Promotion 1 vs. Promotion 2**

• H0 (Null Hypothesis): There is no significant difference in the mean sales (SalesInThousands) between Promotion 1 and Promotion 2.  
• Ha (Alternative Hypothesis): There is a significant difference in the mean sales (SalesInThousands) between Promotion 1 and Promotion 2.  

**2. Promotion 1 vs. Promotion 3**

• H0 (Null Hypothesis): There is no significant difference in the mean sales (SalesInThousands) between Promotion 1 and Promotion 3.   
• Ha (Alternative Hypothesis): There is a significant difference in the mean sales (SalesInThousands) between Promotion 1 and Promotion 3.  


**3. Promotion 2 vs. Promotion 3**

• H0 (Null Hypothesis): There is no significant difference in the mean sales (SalesInThousands) between Promotion 2 and Promotion 3.  
• Ha (Alternative Hypothesis): There is a significant difference in the mean sales (SalesInThousands) between Promotion 2 and Promotion 3.  

### Additional Considerations

• **Confidence Level:** As stated, we will use a 99% confidence level. This means we are willing to accept a 1% chance of rejecting the null hypothesis when it is actually true (Type I error).  
• **Statistical Test:** To test these hypotheses, we will use **Independent Samples t-test -** Used when comparing the means of two independent groups.  
• **Pairwise Comparisons:** Since we are conducting multiple comparisons, we need to adjust the significance level (alpha) to control for the familywise error rate. Bonferroni correction is a common method for this.  
• **The sample sizes** between Promotion 1 vs. Promotion 2 (43 vs 47) & Promotion 1 vs. Promotion 3 (43 vs 47) **are different.**  
• - Are the sales normally distributed?  
• - Are the sales variances known? Population variance unknown & we have small samples, therefore, we use T-test  

## Calculations

| Metric | Promotion_1 | Promotion_2 | Promotion_3 |
| :-------: | :-----: | :-----: | :-----: |
| Sample mean (μ) | 232.396 | 189.318 | 221.458 |
| Sample size (n) | 43 | 47 | 47 |
| Std. deviation (s) | 64.113 | 57.988 | 65.535 |
| Variance (σ) | 4110.462 | 3362.653 | 4294.897 |





