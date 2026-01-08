# Advanced SQL: Subscription Cohort Analysis

## 🎯 Strategic Objective
This project demonstrates the use of complex SQL to track user cohorts, identifying churn patterns and retention "cliffs" to drive LTV growth. This is a critical instrument for any data-driven growth strategy in subscription-based models.

## 🛠 Key SQL Techniques
- **Common Table Expressions (CTEs):** Used for modular, readable, and scalable data processing.
- **Window Functions:** Utilizing `FIRST_VALUE` and `LAG/LEAD` to establish cohort baselines and track month-over-month behavior.
- **Relative Indexing:** Dynamically calculating user "lifespan" months independently of calendar dates.

## 📈 Executive Impact
Automating this analysis transforms raw transaction data into a strategic roadmap. It allows leadership to:
1. Identify high-value acquisition cohorts vs. high-churn periods.
2. Optimize marketing spend by focusing on channels that deliver long-term retention.
3. Build a foundation for predictive LTV modeling.