-- CREATE DATABASE
-- CREATE TABLE
-- IMPORT DATA TO TABLE
-- UNDERSTAND THE DATA, HANDLE NULL AND DUPLICATE VALUES

SELECT * FROM retail_sales LIMIT 10;


-- DATA EXPLORATION

-- how many sales do we have?
SELECT COUNT(*) AS total_sales_count FROM retail_sales;

-- how many customers we have?
SELECT COUNT(DISTINCT customer_id) AS customer_count FROM retail_sales;

-- how many categories we have?
SELECT COUNT(DISTINCT category) AS category_count FROM retail_sales;



-- MAIN DATA ANALYSIS WITH KEY BUSINESS PROBLEMS AND ANSWERS
-- 1. sales made on a specific date, say '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05';


-- 2. transactions where atleast 4 clothes were bought
SELECT *
FROM retail_sales
WHERE category='Clothing' AND quantiy>=4 AND TO_CHAR(sale_date, 'mm-yyyy')='11-2022';


-- 3. compute total sales and orders for each category
SELECT category, SUM(total_sale) AS total_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;


-- 4. Find the average age of customers who bought beauty products
SELECT AVG(age)::int AS average_age
FROM retail_sales
WHERE category='Beauty';


-- 5. find all transactions where total sales is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;


-- 6. find total number of transactions made by each gender in each category
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY 1,2
ORDER BY category;

-- 7. calculate average sales for each month, and find the best selling month for each year
SELECT TO_CHAR(sale_date, 'yyyy'), TO_CHAR(sale_date, 'Month'), ROUND(AVG(total_sale)::decimal, 2) AS average_sales
FROM retail_sales
GROUP BY 1,2
ORDER BY 1

WITH cte AS (
	SELECT 
		TO_CHAR(sale_date, 'yyyy') AS year, TO_CHAR(sale_date, 'Month') AS month, AVG(total_sale) AS avg_sales,
		DENSE_RANK() OVER(PARTITION BY TO_CHAR(sale_date, 'yyyy') ORDER BY AVG(total_sale) DESC) as rnk
	FROM retail_sales
	GROUP BY 1,2
)

SELECT year, month AS best_selling_month, avg_sales
FROM cte
WHERE rnk=1;


-- 8. top 5 customers based on total_sales
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY total_sales DESC
LIMIT 5;


-- 9. number of unique customers who bought items from each category
SELECT category, COUNT(DISTINCT customer_id) AS unique_customer_count
FROM retail_sales
GROUP BY category;

-- 10. find number of orders in each shift
-- shifts are morning(<=12), afternoon(between 12 and 17), evening(>17)
SELECT shift, COUNT(*) AS total_orders
FROM(
	SELECT transactions_id, total_sale, sale_time, quantiy,
			CASE
				WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
				WHEN EXTRACT(HOUR FROM sale_time)>17 THEN 'Evening'
				ELSE 'Afternoon'
			END AS shift
	FROM retail_sales
)
GROUP BY shift

-- END OF PROJECT
