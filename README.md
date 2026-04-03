# 🛒 Retail Sales Analysis & Executive Dashboard

## 📌 Project Overview
This project analyzes retail sales data to uncover purchasing trends, demographic behaviors, and peak shopping hours. The goal is to provide actionable insights for inventory management and marketing strategies.

## 🛠️ Tools & Technologies
* **Database:** PostgreSQL (Data Cleaning, Transformation, and Aggregation)
* **Visualization:** Tableau Public (Interactive Dashboard Design)
* **Techniques Used:** CTEs, Window Functions, Case Statements, Mean Imputation, Data Modeling.

## 📊 The Executive Dashboard
🔗 **[Click here to interact with the final dashboard on Tableau Public](YOUR-LINK-HERE)**

## 💡 Key Business Insights
* **Top-Performing Category:** Electronics drove the highest total revenue, generating £313,810, closely followed by Clothing (£311,070). This indicates a balanced reliance on both high-ticket items and apparel.
* **Peak Shopping Hours:** The 'Evening' shift is the undisputed primary revenue driver. Generating £572,420, it brought in more sales than the Morning and Afternoon shifts combined, highlighting critical post-work purchasing behaviors.
* **Distinct Seasonality:** The time-series analysis reveals massive revenue spikes in Q4 (specifically peaking in December 2022 at £72k+ and December 2023 at £69k+), followed by sharp declines in Q1. This dictates a clear need to scale inventory and marketing spend leading up to the holiday season.

## 💻 SQL Code Highlights

**Categorizing Sales Shifts using CTEs and Date Extraction**
```sql
with hourly_sales as 
(
    select *,
        case
            when extract(hour from sales_time) < 12 then 'Morning'
            when extract(hour from sales_time) >= 12 and extract(hour from sales_time) < 17 then 'Afternoon'
            else 'Evening'
        end as shift
    from retail_sales
)
select shift, count(transactions_id) as total_orders
from hourly_sales
group by shift;
