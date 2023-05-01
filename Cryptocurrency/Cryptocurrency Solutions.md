# 🔯 :moneybag: Case Study : Cryptocurrency
There are total 5 SQL Simplified labs :   
Lab 1: Basic Data Analysis Techniques   
Lab 2: Aggregate Functions for Data Analysis   
Lab 3: Understanding Case When Statements   
Lab 4: Operating Window Functions   
Lab 5: Using Table Joins

## Lab 1 of the SQL Simplified Labs!
	
###  Question 1:- Show only the top 5 rows from the members table ?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT * FROM members
LIMIT 5;
```
</details>

#### Output:
![01 sol-1](https://user-images.githubusercontent.com/120770473/235413337-545d9cf4-4f05-484e-adbc-bfa9f8726f87.png)
	
###  Question 2:- Sort all the rows in the members table by first_name in alphabetical order and show the top 3 rows with all columns?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT * FROM members
ORDER BY first_name
LIMIT 3;
```
</details>

#### Output:
![01 sol-2](https://user-images.githubusercontent.com/120770473/235413443-ddda35f2-e901-4b3a-8e5b-dd6c675c5299.png)
	
###  Question 3:- Count the number of records from the members table which have United States as the region value?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  COUNT(*) AS record_count
FROM members
WHERE region = 'United States';
```
</details>

#### Output:
![01 sol-3](https://user-images.githubusercontent.com/120770473/235413521-4d604c72-46d6-44b8-8635-358cc984c32a.png)
	
###  Question 4:- Select only the first_name and region columns for mentors who are not from Australia?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT first_name,
       region
FROM members
WHERE region != 'Australia'; 
```
</details>

#### Output:
![01 sol-4](https://user-images.githubusercontent.com/120770473/235413602-713e243d-9937-4ba3-af9c-1cd7f6f63056.png)
	
###  Question 5:- Return only the unique region values from the members table and sort the output by reverse alphabetical order?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT DISTINCT region
FROM members
ORDER BY region DESC;
```
</details>

#### Output:  
![01 sol-5](https://user-images.githubusercontent.com/120770473/235413680-6a72c22b-37c8-48c3-b235-7adbba6d16dd.png)

## Lab 2 of the SQL Simplified Labs!
	
### Question 1:- How many records are there per ticker value in the prices table?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  ticker,
  COUNT(*) AS record_count
FROM prices
GROUP BY ticker; 
```
</details>

#### Output:  
![02 sol-1](https://user-images.githubusercontent.com/120770473/235413853-e27d2a40-ba0a-45b2-a29c-aaaccfd4f4f3.png)
	
### Question 2:- What is the maximum, minimum values for the price column for both Bitcoin and Ethereum in 2020?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  ticker,
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM prices
WHERE market_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY ticker;
 ```
</details>

#### Output:  
![02 sol-2](https://user-images.githubusercontent.com/120770473/235414033-c9978194-1de0-41e8-9502-ee86179a9814.png)
	
### Question 3:- What is the annual minimum, maximum and average price for each ticker?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  EXTRACT(YEAR FROM market_date) AS calendar_year,
  ticker,
  MIN(price) AS min_price,
  MAX(price) AS max_price,
  -- Need to cast average to numeric for rounding
  ROUND(AVG(price)::NUMERIC, 2) AS average_price,
  MAX(price) - MIN(price) AS spread
FROM prices
GROUP BY calendar_year, ticker
ORDER BY calendar_year, ticker;
 ```
</details>

#### Output: 
![02 sol-3](https://user-images.githubusercontent.com/120770473/235414107-a9123182-f376-4ade-a1d9-1ff20df8680e.png)
	
### Question 4:- What is the monthly average of the price column for each ticker from January 2020 and after?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  ticker,
  DATE_TRUNC('MON', market_date)::DATE AS month_start,
  ROUND(AVG(price), 2) AS average_price
FROM prices
WHERE market_date >= '2020-01-01'
GROUP BY ticker, month_start
ORDER BY ticker, month_start;
 ```
</details>

#### Output: Show only 15 records -actual total records are 40
![02 sol-4 (Show only 15 records -actual total records are 40](https://user-images.githubusercontent.com/120770473/235414186-745bc1bc-d422-4c3c-a86b-b63748400e7a.png)

## Lab 3 of the SQL Simplified Labs!
	
Topic - logical operations are an important tool in the data analysis toolbox for any data professional. In this lab you will learn how to implement these logical conditions using SQL to manipulate existing datasets 
	
### Question 1:- Convert the volume column in the prices table with an adjusted integer value to take into the unit values   
###              Return only the market_date, price, volume and adjusted_volume columns for the first 10 days of August 2021 for Ethereum only
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  market_date,
  price,
  volume,
  CASE
    WHEN RIGHT(volume, 1) = 'K' THEN LEFT(volume, LENGTH(volume)-1)::NUMERIC * 1000
    WHEN RIGHT(volume, 1) = 'M' THEN LEFT(volume, LENGTH(volume)-1)::NUMERIC * 1000000
    WHEN volume = '-' THEN 0
  END AS adjusted_volume
FROM prices
WHERE ticker = 'ETH'
  AND market_date BETWEEN '2021-08-01' AND '2021-08-10'
ORDER BY market_date;
 ```
</details>

#### Output:
![03 sol-1](https://user-images.githubusercontent.com/120770473/235414561-2188e4e3-3dc0-4504-9978-cea1d2e693ae.png)
	
### Question 2:- How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker? In the same                  query also calculate the number of "non breakout" days where the price column was lower than or equal to the open column.
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  ticker,
  SUM(CASE WHEN price > open THEN 1 ELSE 0 END) AS breakout_days,
  SUM(CASE WHEN price <= open THEN 1 ELSE 0 END) AS non_breakout_days
FROM prices
WHERE market_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY ticker;
 ```
</details>

#### Output:         
![03 sol-2](https://user-images.githubusercontent.com/120770473/235414670-cff5b8fc-1cfb-4010-9a24-2650a01954fd.png)
	
### Question 3:- What was the final quantity Bitcoin and Ethereum held by all Data With Danny mentors based off the transactions table?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  ticker,
  SUM(
    CASE
      WHEN txn_type = 'SELL' THEN -quantity
      ELSE quantity
    END
  ) AS final_btc_holding
FROM transactions
GROUP BY ticker;
 ```
</details>

#### Output:
  ![03 sol-3](https://user-images.githubusercontent.com/120770473/235414909-e9f526e1-328e-4a23-97ec-8252b180a3d9.png)
	
## Lab 4 of the SQL Simplified Labs!
  
Topic - Window functions are immensely useful analytical tools used to calculate a variety of metrics including rankings, moving averages, cumulative sums, daily differences and much more. In this lab you will learn how to implement some of the most frequently used window functions with a cryptocurrency daily prices dataset.

### Question 1:- What are the market_date, price and volume and price_rank values for the days with the top 5 highest price values for each tickers in the prices table?
###				a)The price_rank column is the ranking for price values for each ticker with rank = 1 for the highest value.
###				b)Return the output for Bitcoin, followed by Ethereum in price rank order.
<details>
  <summary>Click here for solution</summary>
  
```sql
  WITH cte_rank AS (
SELECT
  ticker,
  market_date,
  price,
  volume,
  RANK() OVER (
    PARTITION BY ticker
    ORDER BY price DESC
  ) AS price_rank
FROM prices
)

SELECT * FROM cte_rank
WHERE price_rank <= 5
ORDER BY ticker, price_rank;
  ```
</details>

#### Output:       
  ![04 sol-1](https://user-images.githubusercontent.com/120770473/235415080-0230b847-eb18-40cc-bc47-e5dadf8117ad.png)
 	
### Question 2:- Calculate a 7 day rolling average for the price and volume columns in the prices table for each ticker.
###				       a)Return only the first 10 days of August 2021
<details>
  <summary>Click here for solution</summary>
  
```sql
WITH cte_adjusted_prices AS (
SELECT
  ticker,
  market_date,
  price,
  CASE
    WHEN RIGHT(volume, 1) = 'K' THEN LEFT(volume, LENGTH(volume)-1)::NUMERIC * 1000
    WHEN RIGHT(volume, 1) = 'M' THEN LEFT(volume, LENGTH(volume)-1)::NUMERIC * 1000000
    WHEN volume = '-' THEN 0
  END AS volume
FROM prices
),
cte_moving_averages AS (
  SELECT
    ticker,
    market_date,
    price,
    AVG(price) OVER (
      PARTITION BY ticker
      ORDER BY market_date
      RANGE BETWEEN '7 DAYS' PRECEDING AND CURRENT ROW
    ) AS moving_avg_price,
    volume,
    AVG(volume) OVER (
      PARTITION BY ticker
      ORDER BY market_date
      RANGE BETWEEN '7 DAYS' PRECEDING AND CURRENT ROW
    ) AS moving_avg_volume
  FROM cte_adjusted_prices
)
-- final output (total output rows 20)
SELECT * FROM cte_moving_averages
WHERE market_date BETWEEN '2021-08-01' AND '2021-08-10'
ORDER BY ticker, market_date; 
    ```
</details>

#### Output:  
![04 sol-2](https://user-images.githubusercontent.com/120770473/235415313-937ec296-df75-4f05-95dc-eef3d6897a43.png)
 	
### Question 3:- Calculate the monthly cumulative volume traded for each ticker in 2020
###				       a)Sort the output by ticker in chronological order with the month_start as the first day of each month?
<details>
  <summary>Click here for solution</summary>
  
```sql
WITH cte_monthly_volume AS (
  SELECT
    ticker,
    DATE_TRUNC('MON', market_date)::DATE AS month_start,
    SUM(
      CASE
      WHEN RIGHT(volume, 1) = 'K' THEN LEFT(volume, LENGTH(volume)-1)::NUMERIC * 1000
      WHEN RIGHT(volume, 1) = 'M' THEN LEFT(volume, LENGTH(volume)-1)::NUMERIC * 1000000
      WHEN volume = '-' THEN 0
    END
  ) AS monthly_volume
  FROM prices
  WHERE market_date BETWEEN '2020-01-01' AND '2020-12-31'
  GROUP BY ticker, month_start
)
-- final output( total output rows 24)
SELECT
  ticker,
  month_start,
  SUM(monthly_volume) OVER (
    PARTITION BY ticker
    ORDER BY month_start
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS cumulative_monthly_volume
FROM cte_monthly_volume
ORDER BY ticker, month_start;
   ```
</details>

#### Output: 
  ![04 sol-3](https://user-images.githubusercontent.com/120770473/235415454-c8f6ea99-08ff-4ff3-ac29-14a1bc392c88.png)
 	
### Question 4:- Calculate the daily percentage change in volume for each ticker in the prices table?
###			        a)Percentage change can be calculated as (current - previous) / previous
###			        b)Multiply the percentage by 100 and round the value to 2 decimal places
###     			  c)Return data for the first 10 days of August 2021
<details>
  <summary>Click here for solution</summary>
  
```sql
WITH cte_adjusted_prices AS (
  SELECT
    ticker,
    market_date,
    CASE
      WHEN RIGHT(volume, 1) = 'K' THEN LEFT(volume, LENGTH(volume)-1)::NUMERIC * 1000
      WHEN RIGHT(volume, 1) = 'M' THEN LEFT(volume, LENGTH(volume)-1)::NUMERIC * 1000000
      WHEN volume = '-' THEN 0
    END AS volume
  FROM prices
),
cte_previous_volume AS (
  SELECT
    ticker,
    market_date,
    volume,
    LAG(volume) OVER (
      PARTITION BY ticker
      ORDER BY market_date
    ) AS previous_volume
  FROM cte_adjusted_prices
  -- need to remove the single outlier record!
  WHERE volume != 0
)
-- final output
SELECT
  ticker,
  market_date,
  volume,
  previous_volume,
  ROUND(
    100 * (volume - previous_volume) / previous_volume,
    2
  ) AS daily_change
FROM cte_previous_volume
WHERE market_date BETWEEN '2021-08-01' AND '2021-08-10'
ORDER BY ticker, market_date;
   ```
</details>

#### Output:  
  ![04 sol-4](https://user-images.githubusercontent.com/120770473/235415615-4a0b578d-575b-4e18-87ba-41d3fe95b013.png)

## Lab 5 of the SQL Simplified Labs!
  
Topic - Table joins are mandatory for all SQL queries that obtain columns from 2 or more different datasets. You will learn how to implement the most commonly used table joins and how to assess which type of table join to use with all available datasets in a cryptocurrency SQL case study.

### Question 1 - Which top 3 mentors have the most Bitcoin quantity? Return the first_name of the mentors and sort the output from highest to   lowest total_quantity?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  members.first_name,
  SUM(
    CASE
      WHEN transactions.txn_type = 'BUY'  THEN transactions.quantity
      WHEN transactions.txn_type = 'SELL' THEN -transactions.quantity
    END
  ) AS total_quantity
FROM transactions
INNER JOIN members
  ON transactions.member_id = members.member_id
WHERE transactions.ticker = 'BTC'
GROUP BY members.first_name
ORDER BY total_quantity DESC
LIMIT 3;
   ```
</details>

#### Output:   
![05 sol-1](https://user-images.githubusercontent.com/120770473/235415742-81fec6ba-2729-4d4f-9a1b-8acc6e1d4fe2.png)
  
### Question 2 - Show the market_date values which have less than 5 transactions? Sort the output in reverse chronological order.
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  prices.market_date,
  COUNT(transactions.txn_id) AS transaction_count
FROM prices
LEFT JOIN transactions
  ON prices.market_date = transactions.txn_date
  AND prices.ticker = transactions.ticker
GROUP BY prices.market_date
HAVING COUNT(transactions.txn_id) < 5
ORDER BY prices.market_date DESC; 
   ```
</details>

#### Output:  
  ![05 sol-2](https://user-images.githubusercontent.com/120770473/235415849-cc9b9d76-ddd0-4209-b173-7d53ca544c54.png)

###  Question 3 - Multiple Table Joins
For this question - we will generate a single table output which solves a multi-part problem about the dollar cost average of BTC purchases.

Part 1: Calculate the Dollar Cost Average
		a) What is the dollar cost average (btc_dca) for all Bitcoin purchases by region for each calendar year?
Create a column called year_start and use the start of the calendar year
The dollar cost average calculation is btc_dca = SUM(quantity x price) / SUM(quantity)

Part 2: Yearly Dollar Cost Average Ranking
		b) Use this btc_dca value to generate a dca_ranking column for each year
The region with the lowest btc_dca each year has a rank of 1

Part 3: Dollar Cost Average Yearly Percentage Change
		c) Calculate the yearly percentage change in DCA for each region to 2 decimal places
This calculation is (current - previous) / previous
Finally order the output by region and year_start columns.
<details>
  <summary>Click here for solution</summary>
  
```sql
WITH cte_dollar_cost_average AS (
  SELECT
    DATE_TRUNC('YEAR', transactions.txn_date)::DATE AS year_start,
    members.region,
    SUM(transactions.quantity * prices.price) / SUM(transactions.quantity) AS btc_dca
  FROM transactions
  INNER JOIN prices
    ON transactions.ticker = prices.ticker
    AND transactions.txn_date = prices.market_date
  INNER JOIN members
    ON transactions.member_id = members.member_id
  WHERE transactions.ticker = 'BTC'
    AND transactions.txn_type = 'BUY'
  GROUP BY year_start, members.region
),
cte_window_functions AS (
SELECT
  year_start,
  region,
  btc_dca,
  RANK() OVER (
    PARTITION BY year_start
    ORDER BY btc_dca
  ) AS dca_ranking,
  LAG(btc_dca) OVER (
    PARTITION BY region
    ORDER BY year_start
  ) AS previous_btc_dca
FROM cte_dollar_cost_average
)
-- final output
SELECT
  year_start,
  region,
  btc_dca,
  dca_ranking,
  ROUND(
    (100 * (btc_dca - previous_btc_dca) / previous_btc_dca)::NUMERIC,
    2
  ) AS dca_percentage_change
FROM cte_window_functions
ORDER BY region, year_start;
   ```
</details>

#### Output:   
![05 sol-3](https://user-images.githubusercontent.com/120770473/235416000-b4643a61-4555-47a4-8286-05d6d69b6cf8.png)
  
CLick [Here](https://github.com/AmitPatel-analyst/SQL-Case-Study/tree/main) to move back to other case studies repository! 
