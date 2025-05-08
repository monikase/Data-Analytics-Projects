## Fast Food Marketing Campaign A/B Test Analysis

This is an analysis of [Fast Food Marketing Campaign A/B Test dataset](https://www.kaggle.com/datasets/chebotinaa/fast-food-marketing-campaign-ab-test)

### About Dataset

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

### Quick Overview

![image](https://github.com/user-attachments/assets/421150d3-8b9f-4eea-a7ba-67f764c9f1a0)

### Goal 

Evaluate A/B testing results and decide which marketing strategy works the best.

Since there are three marketing campaigns we will conduct several tests, comparing campaigns against one another. 
This kind of testing is known as pairwise comparisons, and it suffers from the multiple testing problem - if we run a lot of tests, there’s an increased chance of getting a type I error (false positive). 
Therefore, for analysis of A/B test results we will use a confidence level of 99%.

### Hypothesis

Promotion Effectiveness: Do different promotions (promotion column) have a significantly different impact on sales (num_customers, revenue) at similar locations?





