WITH 
fm_data AS ( 
  SELECT CustomerID, 
    MAX(DATE_TRUNC(InvoiceDate, DAY)) AS last_purchase_date, 
    COUNT(DISTINCT InvoiceNo) AS frequency, 
    ROUND(SUM(UnitPrice * Quantity), 2) AS monetary 
  FROM tc-da-1.turing_data_analytics.rfm 
  WHERE DATE_TRUNC(InvoiceDate, DAY) BETWEEN '2010-12-01' AND '2011-12-01' 
  AND UnitPrice > 0 
  AND Quantity > 0 
  AND CustomerID IS NOT NULL 
  GROUP BY CustomerID 
), 
rfm_data AS ( 
  SELECT *, 
    DATE_DIFF(DATE('2011-12-01'), DATE(last_purchase_date), DAY) AS recency 
  FROM fm_data 
), 
rfm_quantiles AS ( 
  SELECT 
    APPROX_QUANTILES(recency, 4) AS recency_quantiles, 
    APPROX_QUANTILES(frequency, 4) AS frequency_quantiles, 
    APPROX_QUANTILES(monetary, 4) AS monetary_quantiles 
  FROM rfm_data 
), 
rfm_scores AS ( 
  SELECT 
    *, 
    CASE WHEN recency <= recency_quantiles[OFFSET(0)] THEN 4 
    WHEN recency <= recency_quantiles[OFFSET(1)] THEN 3 
    WHEN recency <= recency_quantiles[OFFSET(2)] THEN 2 
    ELSE 1 
    END AS R_score, 
    CASE WHEN frequency <= frequency_quantiles[OFFSET(0)] THEN 1 
    WHEN frequency <= frequency_quantiles[OFFSET(1)] THEN 2 
    WHEN frequency <= frequency_quantiles[OFFSET(2)] THEN 3 
    ELSE 4 
    END AS F_score, 
    CASE WHEN monetary <= monetary_quantiles[OFFSET(0)] THEN 1 
    WHEN monetary <= monetary_quantiles[OFFSET(1)] THEN 2 
    WHEN monetary <= monetary_quantiles[OFFSET(2)] THEN 3 
    ELSE 4 
    END AS M_score 
  FROM rfm_data, rfm_quantiles 
), 
rfm_segments AS ( 
  SELECT 
    CustomerID, 
    recency, 
    frequency, 
    monetary, 
    R_score, 
    F_score, 
    M_score, 
    CASE 
    -- High value customers 
    WHEN R_score = 4 AND F_score = 4 AND M_score = 4 THEN "Best Customers" 
    WHEN R_score >= 3 AND F_score >= 3 AND M_score >= 3 THEN "Loyal Customers" 
    -- Risk value customers 
    WHEN R_score = 1 AND F_score >= 3 AND M_score >= 3 THEN "Can't Lose Them"
    WHEN R_score = 1 AND F_score = 1 AND M_score = 4 THEN "Can't Lose Them" 
    WHEN R_score = 1 AND F_score = 1 AND M_score <= 2 THEN "Lost"
    WHEN R_score = 1 AND F_score <= 2 AND M_score <= 3 THEN "Hibernating" 
    WHEN R_score <= 2 AND F_score >= 3 AND M_score >= 2 THEN "At Risk" 
    -- Lower priority customers
    WHEN R_score = 2 AND F_score >= 2 AND M_score >= 2 THEN "Need Attention"
    WHEN R_score = 3 AND F_score = 1 AND M_score >= 3 THEN "Need Attention"
    WHEN R_score = 2 AND F_score = 1 AND M_score >= 3 THEN "Need Attention"
    WHEN R_score = 2 AND F_score = 1 AND M_score = 2 THEN "Need Attention"
    WHEN R_score = 4 AND F_score <= 2 AND M_score <= 3 THEN "Promising"
    WHEN R_score = 3 AND F_score <= 2 AND M_score <= 2 THEN "Promising"
    WHEN R_score >= 3 AND F_score >= 3 AND M_score = 2 THEN "Promising"
    -- Remaining combinations if exist
    ELSE "Miscellaneous" 
    END AS rfm_segment 
  FROM rfm_scores 
) 
SELECT * FROM rfm_segments
