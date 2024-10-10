-- Data Cleaning
alter table retail_data.retail_sales_data
rename column ï»¿transactions_id to transaction_id;

alter table retail_data.retail_sales_data
rename column quantiy to quantity;

-- Checking null values
select * 
from retail_data.retail_sales_data
where transaction_id is null
or
sale_date is null
or 
sale_time is null 
or 
customer_id is null
or
gender is null 
or
age is null
or
category is null
or
quantity is null
or 
price_per_unit is null 
or
cogs is null
or
total_sale is null;

-- Data Exploration
-- Total Sales we have
Select count(total_sale) as Number_of_sales;

-- Number of unique customers
Select count(distinct customer_id) as Number_of_customers
from retail_data.retail_sales_data;

-- Different categories we have
select distinct category
from retail_data.retail_sales_data;


-- Solving Business Problem
-- Q.1 Write a SQL query to retrieve all columns for sales made on 2022-11-05
select *
from retail_data.retail_sales_data
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all the information where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
select *
from retail_data.retail_sales_data
where category = 'Clothing' 
and
	quantity > 3
and
	sale_date between '2022-11-1' and '2022-11-30';

-- Q.3 Write a SQL query to calculate the total sales for each category.
select category,
sum(total_sale) as Total_sales
from retail_data.retail_sales_data
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as Average_age
from retail_data.retail_sales_data
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_data.retail_sales_data
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender, count(transaction_id) as Number_of_transactions
from retail_data.retail_sales_data
group by category, gender
order by category, gender desc;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
with ranked_sale as (
select year(sale_date) as Year, month(sale_date) as Month, round(avg(total_sale),2) as Average_sales, rank() over ( partition by year(sale_date) order by avg(total_sale) desc) as `rank`
from retail_data.retail_sales_data
group by 1,2)
select Year, Month, Average_sales
from ranked_sale
where `rank` = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale) as Total_sales	
from retail_data.retail_sales_data
group by customer_id
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct(customer_id)) as Number_of_unique_customer
from retail_data.retail_sales_data
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
select count(*) as Number_of_orders,
case
 when hour(sale_time) < 12 then 'Morning'
 when hour(sale_time) between 12 and 17 then 'Afternoon'
 else 'Evening'
 end  as shift
 from retail_data.retail_sales_data
 group by shift;