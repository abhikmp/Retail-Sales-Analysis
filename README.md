# Retail-Sales-Analysis
This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
  ```sql SELECT COUNT(*) AS total_sales_count FROM retail_sales; ```

- **Customer Count**: Find out how many unique customers are in the dataset.
  ```sql SELECT COUNT(DISTINCT customer_id) AS customer_count FROM retail_sales; ```

- **Category Count**: Identify all unique product categories in the dataset.
  ```sql SELECT DISTINCT category AS distinct_categories FROM retail_sales; ```

- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
  ```sql
  SELECT * FROM retail_sales
  WHERE 
      sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
      gender IS NULL OR age IS NULL OR category IS NULL OR 
      quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

  DELETE FROM retail_sales
  WHERE 
      sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
      gender IS NULL OR age IS NULL OR category IS NULL OR 
      quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
  ```

### 3. Data Analysis & Findings

**Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05';
```

**Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is atleast 4 in the month of Nov-2022**
```sql
SELECT *
FROM retail_sales
WHERE category='Clothing' AND quantiy>=4 AND TO_CHAR(sale_date, 'mm-yyyy')='11-2022';
```

**Write a SQL query to calculate the total sales (total_sale) for each category.**
```sql
SELECT category, SUM(total_sale) AS total_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

**Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**
```sql
SELECT AVG(age)::int AS average_age
FROM retail_sales
WHERE category='Beauty';
```

**Find all transactions where total sales is greater than 1000**
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

**Find total number of transactions made by each gender in each category**
```sql
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY 1,2
ORDER BY category;
```

**Calculate average sales for each month, and find the best selling month for each year**
```sql
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
```

**Top 5 customers based on total_sales**
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY total_sales DESC
LIMIT 5;
```

**Number of unique customers who bought items from each category**
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customer_count
FROM retail_sales
GROUP BY category;
```

**Find number of orders in each shift**
- shifts are morning(<=12), afternoon(between 12 and 17), evening(>17)
```sql
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
GROUP BY shift;
```

**Sale demographics**
```sql
SELECT
  COUNT(transactions_id) AS total_transactions,
  COUNT(CASE WHEN total_sale > 1000 THEN 1 END) AS expensive_sale,
  COUNT(CASE WHEN total_sale <= 1000 THEN 1 END) AS normal_sale
FROM retail_sales;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, but the majority was transactions worth less than 1000.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons. In 2022 July was the best-selling month and in 2023 it was February.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Use postgres GUI to create database and use the create table query in `retail_sales_analysis.sql` to create the table and then use GUI to import data from csv given in repo.
3. **Run the Queries**: Use the SQL queries provided in the `retail_sales_analysis.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Abhijeeth S
