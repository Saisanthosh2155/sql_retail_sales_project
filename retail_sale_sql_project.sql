-- creates database for our project
Create database retails_sales_db;

-- use that database
USE retails_sales_db;

-- create the table as per our requirments
Drop table if exists retail_sales;
Create table retail_sales
(
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(20),
age INT,
category VARCHAR(20),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);


-- just see the how our data is 
SELECT * FROM retail_sales
LIMIT 10;

-- find the total rows of the table
SELECT 
	COUNT(*)
FROM retail_sales

-- data cleaning 
SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- data exploraion

-- 1.Total sales we have
SELECT COUNT(*) AS total_sale 
FROM retail_sales;

-- 2.How many unique customers we have
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

-- 3.How many unique category we have
SELECT COUNT(DISTINCT category) AS total_category
FROM retail_sales;
-- what are they
SELECT DISTINCT category AS total_category
FROM retail_sales;

-- Data analysis 

-- Q1) write a query to retrive all coulums for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2) write a query to retrive all transactions where the category is 'clothing' and the quantity sold is more than 4 in month of nov-2022
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND
    quantity >= 4;
    
-- Q3) write a sql query to calculate the total sales for each category
SELECT 
	category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4) write a query to find the average age of customer who purchased items from the 'Beauty' category 
SELECT 
	ROUND(AVG(age),2) AS avg_age_beauty
FROM retail_sales
WHERE category = 'Beauty';

-- Q5) write a query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6) write a query to find the total number of transactions made by each gender in each categoty
SELECT 
	category,
    gender,
    COUNT(*) AS toal_transactions
FROM retail_sales
GROUP 
	BY
    category,
    gender
order by 1;

-- Q7) write a sql query to calculate the average sale for each month find out selling month in each year.
SELECT 
	year,
    month,
    ROUND(avg_sale,2) AS avg_sale
FROM (SELECT 
	year,
    month,
    avg_sale,
    RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rnk
FROM(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date)AS month,
        AVG(total_sale) AS avg_sale
	FROM retail_sales
    GROUP BY year,month
    ) AS sub
) AS ranked 
WHERE rnk=1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
	customer_id,
    SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale desc
LIMIT 5;


-- Q9) write a sql query to find the number of unique customers who purchased items from each category
SELECT 
	category,
    COUNT( distinct customer_id) AS num_customers
FROM retail_sales
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourLy_sale AS(
					SELECT *,
                    CASE
						WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'morning'
                        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
                        ELSE 'evening'
					END AS shift
					FROM retail_sales)
SELECT 
	shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;


-- END OF PROJECT