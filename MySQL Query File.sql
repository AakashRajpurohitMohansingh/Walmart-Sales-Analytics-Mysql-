CREATE DATABASE IF NOT EXISTS Walmartsales;

USE walmartsales;

DROP TABLE sales;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


-- ---------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------Feature Engineering ---------------------------------------------------------

-- time_of_day

    SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE Sales 
ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales 
SET time_of_day =(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);

SET SQL_SAFE_UPDATES = 0;


-- DAY NAME

SELECT DATE,
 dayname(DATE)
 AS Day_Name
 FROM SALES ;
 
 
ALTER TABLE sales 
ADD COLUMN day_name VARCHAR(15);

UPDATE sales
SET day_name = dayname(DATE);

-- Month_name

SELECT DATE,
monthname(date) AS month_name
FROM sales ;

ALTER TABLE sales 
ADD COLUMN month_nameVARCHAR (15);

UPDATE sales 
SET month_name = monthname(date)
 
-- --------------------------------------------------------------------------------------------------------------------------------- 
-- ---------------------------------------------------------- Generic --------------------------------------------------------------
-- How many unique cities does the data have?

SELECT 
	DISTINCT city
FROM sales;

-- In which city is each branch?

SELECT 
	DISTINCT Branch
FROM sales;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------- Product ---------------------------------------------------------------------------------------------

-- How many unique product lines does the data have?

SELECT 
	DISTINCT Product_line
FROM sales;

-- What is the most common payment method

SELECT product_line,
count(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt desc
LIMIT 1
;

-- What is the total revenue by month

SELECT month_name as month, 
sum(total) AS total_revenue 
FROM sales 
GROUP BY month_name 
ORDER BY total_revenue DESC;

-- What month had the largest COGS?

SELECT month_name AS month,
sum(cogs) AS largest_Cogs
FROM sales 
GROUP BY month_name 
ORDER BY largest_cogs DESC
;

-- What product line had the largest revenue?

select product_line as category,
sum(total) as largest_revenue 
from sales 
group by category
order by largest_revenue desc;

-- What is the city with the largest revenue?

select city,
sum(total) as largest_revenue 
from sales 
group by city
order by largest_revenue desc;

-- What product line had the largest VAT?

select product_line,
sum(tax_pct) as Largest_Vat
from sales 
group by product_line
order by largest_vat desc; 

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

select avg(quantity) 
from sales;

select product_line, 
case 
when avg(quantity) > (select avg(quantity) from sales) then "Good"
else "Bad"
end as remark 
from sales 
group by product_line;

-- Which branch sold more products than average product sold?

select branch,
sum(quantity) as qty
from sales 
group by branch
having sum(quantity) > (select avg(quantity) from sales) ; 

-- What is the most common product line by gender

select gender,
product_line, 
count(gender) as total_gender
from sales 
group by gender,product_line 
order by total_gender desc;

-- What is the average rating of each product line

select product_line, 
avg(rating) as rating
from sales 
group by product_line 
order by rating desc;

-- ----------------------------------------------------------------------- Customers ------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- How many unique customer types does the data have?

USE WALMARTSALES;

SELECT DISTINCT(Customer_type) 
FROM SALES 

-- How many unique payment methods does the data have?

SELECT DISTINCT(payment) 
FROM SALES 

-- What is the most common customer type?

Select customer_type,
Count(*) as cnt
from sales
group by customer_type
order by cnt desc;

-- Which customer type buys the most?

select customer_type,
sum(total) as total
from sales
group by customer_type
order by total desc;

-- What is the gender of most of the customers?

select gender,
count(*) as gender_count
from sales
group by gender
order by gender_count desc

-- What is the gender distribution per branch?

select branch,gender,
count(gender) as cnt
from sales
group by branch,gender
order by branch


-- Which time of the day do customers give most ratings?

select time_of_day as day_cnt, 
count(rating) as cnt
from sales
group by day_cnt
order by cnt desc

-- Which time of the day do customers give most ratings per branch?

select time_of_day,branch,
count(rating) as cnt
from sales
group by time_of_day,branch
order by branch 

-- Which day of the week has the best avg ratings?

select day_name, 
round(avg(rating),2) as rating
from sales
group by day_name 
order by rating desc;

-- Which day of the week has the best average ratings per branch?

select branch,day_name, 
round(avg(rating),2) as rating
from sales
group by branch,day_name
order by rating desc
limit 3;

-- ------------------------------------------------- Sales --------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------

 -- Number of sales made in each time of the day per weekday 

SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?

select Customer_type,
sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax/VAT percent?

select city, 
max(tax_pct) as TAX
from sales
group by city 
order by TAX desc

-- Which customer type pays the most in VAT?

select customer_type,
max(tax_pct) as TAX
from sales
group by customer_type
order by tax desc









