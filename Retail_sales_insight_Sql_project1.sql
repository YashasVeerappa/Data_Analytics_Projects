delete FROM retail_sales
WHERE
    transactions_id IS NULL OR transactions_id = 0 OR
    customer_id IS NULL OR customer_id = 0 OR
    gender IS NULL OR gender = '' OR gender = ' ' OR
    age IS NULL OR age = 0 OR
    category IS NULL OR category = '' OR category = ' ' OR
    quantity IS NULL OR quantity = 0 OR
    price_per_unit IS NULL OR price_per_unit = 0 OR
    cogs IS NULL OR cogs = 0 OR
    total_sale IS NULL OR total_sale = 0;


-- -------Data cleaning by deleting null value records---------
SET SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales
WHERE 
    CAST(transactions_id AS CHAR) IN ('NULL','null','',' ','N/A','NA') OR
    CAST(sale_date AS CHAR) IN ('NULL','null','',' ','N/A','NA') OR
    CAST(sale_time AS CHAR) IN ('NULL','null','',' ','N/A','NA') OR
    CAST(customer_id AS CHAR) IN ('NULL','null','',' ','N/A','NA') OR
    CAST(gender AS CHAR) IN ('NULL','null','',' ','N/A','NA') OR
    CAST(age AS CHAR) IN ('NULL','null','',' ','N/A','NA') OR
    CAST(category AS CHAR) IN ('NULL','null','',' ','N/A','NA') OR
    CAST(quantity AS CHAR) IN ('NULL','null','',' ','N/A','NA') OR
    CAST(price_per_unit AS CHAR) IN ('NULL','null','',' ','N/A','NA') OR
    CAST(cogs AS CHAR) IN ('NULL','null','',' ','N/A','NA') OR
    CAST(total_sale AS CHAR) IN ('NULL','null','',' ','N/A','NA');


-- --------------Data exploration----------------------

-- howmany sales we have
select count(*) as total_retail_sales from retail_sales;

-- howmany unique customers we have
select count(distinct customer_id) as total_retail_sales from retail_sales;

-- which all category we have 
select distinct category from retail_sales;



-- Data Analysis & business requirements / findings-------------------

-- Q1. write an sql query to retrive all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date='2022-11-05';

-- Q2. write a query to retrive all the transactions where the category is 'clothing'
-- and the quantity sold more than 4 in the month of nov-2022

SELECT *
FROM retail_sales
WHERE  category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  And quantity>=4;
  
-- Q3. Write a query to calculate the sales(total sale) fro each category

Select category,
		sum(total_sale) as net_sale,
        count(*) as total_orders
	from retail_sales
    group by category;

-- Q4 write a queryto find the avg age of customer who purchased items from beauty category.

select round(avg(age),1) as average_age from retail_sales
where category='beauty';

-- Q5 write a sql query to find all transactions where the total_sale is greater than 1000
select * from retail_sales
where total_sale>1000;

-- Q6 write query to find the total number of transactions 
-- made bygender in each category
select category,gender, count(*) as total_transaction from retail_sales
group by category,gender
order by 1;

-- Q7 write a query to calculate the average sale for each month. 
-- find out best selling month in each year
with best_sale_month as(select 
	year(sale_date) as year,
    month(sale_date)as month,
    round((total_sale),1) as avg_sales,
    rank() over(partition by year(sale_date) 
    order by avg(total_sale) desc) as ranks
from retail_sales
group by 1,2)
Select year,month,avg_sales from best_sale_month
where ranks = 1;

-- Q8 write query to find top 5 customer based on the highest total sales
select distinct customer_id,sum(total_sale) as total_sales from retail_sales
group by 1
order by 2 desc
limit 5;


-- Q9 find the number of unique customer who purchased tiems from each category
select 
	category,
    count(distinct customer_id) unique_customers 
from retail_sales
group by category;

-- Q10 create each shift and number of orders
-- (ex: morning <=12, afternoon between 12 & 17, evening >17
with total_order_in_shift as (
select *,
	case 
		when HOUR(sale_time) <= 12 then 'morning_shift'
        when HOUR(sale_time) between 12 and 17 then 'afternoon_shift'
        else 'evening'
	end as shift
from retail_sales
)
select 
	shift,
    count(*) as total_orders 
from total_order_in_shift
group by shift;

-- ------------------ END of project ------------------------