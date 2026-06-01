# DVD Rental Business Intelligence Analysis

## Project Overview

This project explores the PostgreSQL DVD Rental database from a business intelligence and analytics perspective.

The objective is not only to retrieve data but also to demonstrate how SQL can be used to answer real business questions regarding:

- Customer behavior
- Revenue generation
- Customer retention
- Content profitability
- Inventory efficiency

The project simulates analytical tasks commonly performed by Data Analysts, Analytics Engineers, and Decision Scientists.

---

## Dataset

The project uses the PostgreSQL DVD Rental sample database.

Main tables used:

| Table | Description |
|---------|---------|
| customer | Customer information |
| rental | Rental transactions |
| payment | Payment records |
| inventory | Physical DVD inventory |
| film | Film details |
| category | Film categories |
| film_category | Film-category mapping |
| actor | Actor information |
| film_actor | Actor-film mapping |

---

# Business Questions

## Part 1 — Customer Lifetime Value Analysis

### Business Problem

The retention team wants to identify the most valuable customers and prioritize them for loyalty campaigns.

### Objectives

- Calculate customer revenue
- Measure rental activity
- Rank customers by value
- Identify Top 20 customers

### SQL Concepts

- CTEs
- Aggregations
- Window Functions
- RANK()

```sql
/* ------------------- 1.1 CUSTOMER METRICS ------------------- */

-- Payment records represent customer spending.

-- Rental activity represents customer engagement.

-- The objective is to combine both perspectives into a
-- single customer performance dataset.

WITH customer_metrics AS (

 SELECT
        customer.customer_id,

        INITCAP(customer.first_name)
        || ' '
        || INITCAP(customer.last_name)
        AS customer_name,

        COUNT(DISTINCT rental.rental_id)
        AS total_rentals,

        SUM(payment.amount)
        AS total_revenue,

        ROUND(
             AVG(payment.amount),
             2
        ) AS average_payment

 FROM public.customer

 INNER JOIN public.rental
         ON customer.customer_id =
            rental.customer_id

 INNER JOIN public.payment
         ON rental.rental_id =
            payment.rental_id

 GROUP BY
        customer.customer_id,
        customer_name

)

SELECT
customer_name,
total_rentals,
total_revenue,
average_payment,

   RANK() OVER (
        ORDER BY total_revenue DESC
   ) AS customer_rank

FROM customer_metrics

ORDER BY customer_rank
LIMIT 20;

/* -------------------- 1.2 COMPARISON ------------------------

Traditional Aggregation:

Calculates customer metrics successfully
Cannot rank customers without additional logic

Window Functions:

Allow ranking while preserving customer-level detail
Ideal for segmentation and prioritization

Production Choice:

Window Functions are preferred because they simplify
ranking logic and improve readability.

============================================================ */
```

---

## Part 2 — Revenue Trend Analysis

### Business Problem

Management wants to monitor revenue growth and identify periods of strong performance.

### Objectives

- Monthly revenue
- Cumulative revenue
- Revenue ranking

### SQL Concepts

- DATE_TRUNC()
- SUM() OVER()
- Window Functions

```sql
/* ============================================================
PART 2 — MONTHLY REVENUE TREND ANALYSIS

BUSINESS PROBLEM

Management wants to evaluate revenue growth trends
over time and understand cumulative business growth.

Requirements:

Calculate monthly revenue
Calculate cumulative revenue
Identify strongest revenue months

============================================================ */

/* ------------------- 2.1 MONTHLY REVENUE -------------------- */

WITH monthly_revenue AS (

 SELECT

        DATE_TRUNC(
             'month',
             payment.payment_date
        ) AS revenue_month,

        SUM(payment.amount)
        AS monthly_revenue

 FROM public.payment

 GROUP BY revenue_month

)

SELECT

   revenue_month,

   monthly_revenue,

   SUM(monthly_revenue)
   OVER (
        ORDER BY revenue_month
   ) AS cumulative_revenue,

   RANK() OVER (
        ORDER BY monthly_revenue DESC
   ) AS revenue_rank

FROM monthly_revenue

ORDER BY revenue_month;

/* -------------------- 2.2 COMPARISON ------------------------

Standard Aggregation:

Produces monthly revenue values

Window Functions:

Enable cumulative revenue calculations
Enable revenue ranking

Production Choice:

Window Functions provide richer insights while
avoiding additional joins or subqueries.

============================================================ */
```

---

## Part 3 — Category Profitability Analysis

### Business Problem

The content acquisition team wants to understand which movie categories generate the highest revenue.

### Objectives

- Revenue per category
- Revenue share calculation
- Profitability ranking

### SQL Concepts

- DENSE_RANK()
- Window Functions
- Revenue Share Analysis

```sql
/* ------------------- 3.1 CATEGORY REVENUE ------------------ */

-- Revenue is generated through rentals and payments.

-- Each payment is linked to a film through the
-- inventory and rental tables.

-- Revenue share is calculated using a window function,
-- allowing comparison against total company revenue.

WITH category_revenue AS (

 SELECT

        category.name
        AS category_name,

        SUM(payment.amount)
        AS category_revenue

 FROM public.category

 INNER JOIN public.film_category
         ON category.category_id =
            film_category.category_id

 INNER JOIN public.inventory
         ON film_category.film_id =
            inventory.film_id

 INNER JOIN public.rental
         ON inventory.inventory_id =
            rental.inventory_id

 INNER JOIN public.payment
         ON rental.rental_id =
            payment.rental_id

 GROUP BY category.name

)

SELECT

   category_name,

   ROUND(
        category_revenue,
        2
   ) AS category_revenue,

   ROUND(
        category_revenue * 100.0
        / SUM(category_revenue)
          OVER (),
        2
   ) AS revenue_share_pct,

   DENSE_RANK()
   OVER (
        ORDER BY category_revenue DESC
   ) AS profitability_rank

FROM category_revenue

ORDER BY profitability_rank;

/* -------------------- 3.2 COMPARISON ------------------------

Standard Aggregation:

Calculates category revenue

Window Functions:

Enable revenue share calculations
Enable category ranking
Avoid additional aggregation queries

Production Choice:

Window Functions are preferred because they allow
category comparison within a single result set.
```

---

## Part 4 — Customer Retention Cohort Analysis

### Business Problem

Customer acquisition is expensive. Understanding retention is critical for long-term growth.

### Objectives

- Create customer cohorts
- Measure retention over time
- Analyze customer behavior

### SQL Concepts

- Multi-step CTEs
- Cohort Analysis
- Date Manipulation

```sql
/* -------------------- 4.1 FIRST RENTAL ---------------------- */

-- Each customer's earliest rental defines
-- the cohort they belong to.

WITH first_rental AS (

 SELECT

        rental.customer_id,

        DATE_TRUNC(
             'month',
             MIN(rental.rental_date)
        ) AS cohort_month

 FROM public.rental

 GROUP BY rental.customer_id

),

/* -------------------- 4.2 ACTIVITY -------------------------- */

-- Customer activity is measured by identifying
-- all future rental months.

customer_activity AS (

 SELECT

        first_rental.customer_id,

        first_rental.cohort_month,

        DATE_TRUNC(
             'month',
             rental.rental_date
        ) AS activity_month

 FROM first_rental

 INNER JOIN public.rental
         ON first_rental.customer_id =
            rental.customer_id

),

/* -------------------- 4.3 RETENTION ------------------------- */

-- Calculate the number of months between
-- the cohort month and future activity.

retention AS (

 SELECT

        cohort_month,

        EXTRACT(
             MONTH FROM AGE(
                  activity_month,
                  cohort_month
             )
        ) AS months_after_signup,

        COUNT(
             DISTINCT customer_id
        ) AS active_customers

 FROM customer_activity

 GROUP BY
        cohort_month,
        months_after_signup

)

SELECT

   cohort_month,

   months_after_signup,

   active_customers

FROM retention

ORDER BY
cohort_month,
months_after_signup;

/* -------------------- 4.4 COMPARISON ------------------------

Standard Aggregation:

Measures activity counts

Cohort Analysis:

Measures customer retention over time
Identifies long-term engagement patterns
Provides stronger business insight

Production Choice:

Cohort Analysis is preferred because it focuses
on customer behavior rather than simple activity.
```

---

## Part 5 — Customer Segmentation

### Business Problem

The marketing team wants to classify customers based on spending behavior.

### Objectives

- Create customer segments
- Compare segment distributions
- Measure average revenue by segment

### SQL Concepts

- CASE Statements
- Aggregations
- Customer Analytics

```sql
WITH customer_revenue AS (

 SELECT

        customer.customer_id,

        SUM(payment.amount)
        AS total_revenue

 FROM public.customer

 INNER JOIN public.payment
         ON customer.customer_id =
            payment.customer_id

 GROUP BY customer.customer_id

)

SELECT

   CASE

        WHEN total_revenue >= 200
        THEN 'High Value'

        WHEN total_revenue >= 100
        THEN 'Medium Value'

        ELSE 'Low Value'

   END AS customer_segment,

   COUNT(*) AS customer_count,

   ROUND(
        AVG(total_revenue),
        2
   ) AS average_revenue

FROM customer_revenue

GROUP BY customer_segment

ORDER BY average_revenue DESC;

/* -------------------- 5.2 COMPARISON ------------------------

Segmentation converts numerical metrics into
actionable business groups.

This enables targeted campaigns and better
allocation of marketing resources.
```

---

## Part 6 — Actor Revenue Analysis

### Business Problem

The marketing team wants to identify actors associated with the highest revenue-generating films.

### Objectives

- Revenue generated by actor
- Film participation
- Actor ranking

### SQL Concepts

- DENSE_RANK()
- Multi-table JOINs
- Revenue Analytics

```sql
/* ------------------- 6.1 ACTOR PERFORMANCE ------------------ */

-- Revenue is generated through rentals and payments.

-- Since actors are linked to films through film_actor,
-- revenue must be traced through multiple relationships:
--
-- actor → film_actor → film → inventory → rental → payment

-- DENSE_RANK() is used instead of RANK()
-- to avoid gaps in ranking positions.

WITH actor_performance AS (

     SELECT

            actor.actor_id,

            INITCAP(actor.first_name)
            || ' '
            || INITCAP(actor.last_name)
            AS actor_name,

            COUNT(DISTINCT film.film_id)
            AS total_films,

            ROUND(
                 SUM(payment.amount),
                 2
            ) AS revenue_generated

     FROM public.actor

     INNER JOIN public.film_actor
             ON actor.actor_id =
                film_actor.actor_id

     INNER JOIN public.film
             ON film_actor.film_id =
                film.film_id

     INNER JOIN public.inventory
             ON film.film_id =
                inventory.film_id

     INNER JOIN public.rental
             ON inventory.inventory_id =
                rental.inventory_id

     INNER JOIN public.payment
             ON rental.rental_id =
                payment.rental_id

     GROUP BY
            actor.actor_id,
            actor_name
)

SELECT

       actor_name,

       total_films,

       revenue_generated,

       DENSE_RANK()
       OVER (
            ORDER BY revenue_generated DESC
       ) AS revenue_rank

FROM actor_performance

ORDER BY revenue_rank;


/* -------------------- 6.2 COMPARISON ------------------------

   Traditional Aggregation:

   - Calculates actor revenue
   - Does not provide ranking

   Window Functions:

   - Allow actor comparison
   - Enable ranking without losing detail

   Production Choice:

   DENSE_RANK() is preferred because it avoids
   skipped ranking positions when ties occur.

   ============================================================ */
```

---

## Part 7 — Inventory Efficiency Analysis

### Business Problem

Operations teams want to understand inventory utilization and rental duration patterns.

### Objectives

- Average rental duration
- Most efficient inventory
- Operational performance indicators

### SQL Concepts

- Date Arithmetic
- Window Functions
- Operational Analytics

```sql
/* ------------------- 7.1 RENTAL DURATION -------------------- */

-- Rental duration is calculated as the difference
-- between return_date and rental_date.

-- Only completed rentals are included.

WITH rental_durations AS (

     SELECT

            film.title,

            rental.rental_date,

            rental.return_date,

            EXTRACT(
                 DAY FROM
                 rental.return_date -
                 rental.rental_date
            ) AS rental_duration_days

     FROM public.film

     INNER JOIN public.inventory
             ON film.film_id =
                inventory.film_id

     INNER JOIN public.rental
             ON inventory.inventory_id =
                rental.inventory_id

     WHERE rental.return_date IS NOT NULL
)

SELECT

       title,

       ROUND(
            AVG(rental_duration_days),
            2
       ) AS average_rental_duration,

       COUNT(*) AS total_rentals

FROM rental_durations

GROUP BY title

HAVING COUNT(*) >= 10

ORDER BY average_rental_duration DESC;

/* ------------------- 7.2 LAG ANALYSIS ----------------------- */

-- LAG() compares the current rental duration
-- against the previous rental duration for
-- the same movie.

-- This allows identification of changing
-- rental behavior patterns.

WITH rental_history AS (

     SELECT

            film.title,

            rental.rental_date,

            EXTRACT(
                 DAY FROM
                 rental.return_date -
                 rental.rental_date
            ) AS rental_duration_days

     FROM public.film

     INNER JOIN public.inventory
             ON film.film_id =
                inventory.film_id

     INNER JOIN public.rental
             ON inventory.inventory_id =
                rental.inventory_id

     WHERE rental.return_date IS NOT NULL
)

SELECT

       title,

       rental_date,

       rental_duration_days,

       LAG(rental_duration_days)
       OVER (
            PARTITION BY title
            ORDER BY rental_date
       ) AS previous_rental_duration,

       rental_duration_days
       -
       LAG(rental_duration_days)
       OVER (
            PARTITION BY title
            ORDER BY rental_date
       ) AS duration_difference

FROM rental_history

ORDER BY title,
         rental_date;


/* -------------------- 7.3 COMPARISON ------------------------

   Aggregation:

   - Provides average rental duration

   LAG():

   - Enables sequential analysis
   - Detects behavioral changes
   - Preserves row-level detail

   Production Choice:

   LAG() is preferred whenever temporal
   comparisons are required.

   ============================================================ */

```

---
# Executive Summary

## Objective

The objective of this project was to analyze customer behavior, revenue generation, content performance, and operational efficiency using the PostgreSQL DVD Rental database.

The analyses were designed to simulate real-world business intelligence tasks and demonstrate how SQL can be used to transform transactional data into actionable insights.

---

## Key Findings

### Customer Lifetime Value

Customer spending is not distributed evenly across the customer base. A relatively small group of customers generates a disproportionately large share of total revenue. Identifying these high-value customers can support loyalty programs and targeted retention strategies.

### Revenue Trends

Monthly revenue analysis provides visibility into business performance over time. Tracking cumulative revenue helps monitor overall growth and identify periods of stronger or weaker customer activity.

### Category Profitability

Movie categories contribute differently to total revenue. Understanding category profitability can support content acquisition decisions and help prioritize marketing investments toward higher-performing categories.

### Customer Retention

Cohort analysis provides insight into how customer engagement changes over time. Measuring retention after a customer's first rental helps evaluate long-term customer value and the effectiveness of retention initiatives.

### Customer Segmentation

Grouping customers according to spending behavior creates actionable customer segments. These segments can be used to personalize marketing campaigns and allocate resources more effectively.

### Actor Performance

Revenue analysis revealed that certain actors consistently appear in higher-performing films. These insights may support promotional campaigns and future content acquisition decisions.

### Inventory Efficiency

Rental duration analysis highlighted differences in customer rental behavior across films. Temporal analysis using window functions provided additional insight into changes in rental patterns over time.

---

The analyses combine technical SQL implementation with business-oriented thinking, focusing on customer behavior, revenue performance, retention, and operational efficiency.

---
