-- SQL Retail Sales Analysis Project 

-- Table Setup
create table retail_sales
(
	transactions_id integer primary key,
	sales_date date,
	sales_time time,
	customer_id integer,
	gender varchar(15),
	age integer,
	category varchar(30),
	quantity integer,
	price_per_unit float,
	cogs float,
	total_sale float
);

select * from retail_sales limit 10;

select count(*) from retail_sales;

-- Data Exploration & Cleaning
select count(*) from retail_sales;
select count(distinct customer_id) from retail_sales;
select distinct category from retail_sales;

select * from retail_sales
where
    transactions_id is null or sales_date is null or sales_time is null or customer_id is null
	or gender is null or age is null or category is null or quantity is null or price_per_unit is null
	or cogs is null or total_sale is null;
	
delete from retail_sales
where 
    transactions_id is null or sales_date is null or sales_time is null or customer_id is null
	or gender is null or category is null or quantity is null or price_per_unit is null
	or cogs is null or total_sale is null;

update retail_sales
set age = (select round(avg(age)) from retail_sales)
where age is null;

-- Data Analysis & Findings

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sales_date = '2022-11-05'

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales
where category = 'Clothing' 
  and sales_date::text like '2022-11-%' 
  and quantity >= 4;

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category
select category, sum(total_sale) as total_sales, count(*) as total_orders from retail_sales 
group by 1;

-- Q4. Write a sql query to find the average age of customers who purchased items from the 'Beauty' category
select round(avg(age)) as avg_age from retail_sales
where category = 'Beauty';

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000
select * from retail_sales
where total_sale > 1000;

-- Q6. Write a sql query to find the total number of transactions made by each gender in each category
select category, gender, count(*) as total_trans from retail_sales
group by category, gender 
order by 1;

-- Q7. Write a sql query to calculate the average sale for each month. Find out best selling month in each year
select year, month, avg_sale  
(    
select
    extract(year from sale_date) as year,
    extract(month from sale_date) as month,
    avg(total_sale) as avg_sale,
    rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1, 2
) as t1
where rank = 1

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sales from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q9. Write a sql query to find the number of unique customers who purchased items from each category
select category, count(distinct customer_id) as customers from retail_sales
group by category;

-- Q10. Write a SQL query to create with each shift and number of orders (Example Morning <=12, Afternoon between 12 & 17, Evening >17)
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
