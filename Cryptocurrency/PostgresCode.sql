/********************************************************************
Name	: Code for Cryptocurrency DB
Author	: Amit Patel
Date	: Apr 27, 2023

Purpose: This script will create Db and few table in it to store info 
about Cryptocurrency
				Code is written on PostgreSQL 
**********************************************************************/

 
 /*
This lab is from the SQL Simplified series by Danny Ma. These labs will help you familiarize yourself with the most useful SQL techniques for data analysis. 
Learn how to create SQL queries and solve a series of common business problems in a cryptocurrency SQL case study.
*/

/*
This entire SQL Simplified course focuses on a Cryptocurrency SQL Case Study.
In our fictitious case study - Danny's data mentors from the Data With Danny team have been busy trading cryptocurrency markets since 2017.

Our main purpose for this case study is to analyze the performance of the DWD mentors over time. 
We will accomplish this by writing SQL queries to utilize all available datasets to answer a series of realistic business questions.
*/

Available Datasets:-
There are 3 data tables available to us in this database which we can use to run our SQL queries with:

1- members ( this table consists of information about the mentors from the Data With Danny team.)
--Show all the rows and columns from this table by running the below code 

SELECT * FROM members;

|Column Name		Description
|member_id	= 		unique id for each mentor
|first_name	= 		first name for each mentor
|region		= 		region where each mentor is from

2- prices (This table consists of daily price and volume information from January 2017 through to August 2021 for the 2 most popular cryptocurrency tickers: Bitcoin and Ethereum)

--Show all the rows and columns from this table by running the below code 

select * from prices;

|Column Name		Description
|ticker				= one of either BTC or ETH
|market_date	    = the date for each record
|price				= closing price at end of day
|open				= the opening price
|high				= the highest price for that day
|low				= the lowest price for that day
|volume				= the total volume traded
|change				= % change in daily price

3- transactions (This table consists of buy and sell transactions data for each trade made by the DWD mentors.)

--Show all the rows and columns from this table by running the below code 
select * from transactions;

|Column Name		Description
|txn_id				= unique ID for each transaction
|member_id			= member identifier for each trade
|ticker				= the ticker for each trade
|txn_date			= the date for each transaction
|txn_type			= either BUY or SELL
|quantity			= the total quantity for each trade
|percentage_fee		= % of total amount charged as fees
|txn_time			= the timestamp for each trade

/*
-- Creating these indexes after loading data
-- will make things run much faster!!!

CREATE INDEX ON prices (ticker, market_date);
CREATE INDEX ON transactions (txn_date, ticker);
CREATE INDEX ON transactions (txn_date, member_id);
CREATE INDEX ON transactions (member_id);
CREATE INDEX ON transactions (ticker);

*/

There are total 5 SQL Simplified labs :
Lab 1: Basic Data Analysis Techniques
Lab 2: Aggregate Functions for Data Analysis
Lab 3: Understanding Case When Statements
Lab 4: Operating Window Functions
Lab 5: Using Table Joins

--Lab 1 of the SQL Simplified Labs!
	
Question 1:- Show only the top 5 rows from the members table ?

SELECT * FROM members
LIMIT 5;

Question 2:- Sort all the rows in the members table by first_name in alphabetical order and show the top 3 rows with all columns?

SELECT * FROM members
ORDER BY first_name
LIMIT 3;

Question 3:- Count the number of records from the members table which have United States as the region value?

SELECT
  COUNT(*) AS record_count
FROM members
WHERE region = 'United States';

Question 4:- Select only the first_name and region columns for mentors who are not from Australia?

SELECT
  first_name,
  region
FROM members
WHERE region != 'Australia';

Question 5:- Return only the unique region values from the members table and sort the output by reverse alphabetical order?

SELECT DISTINCT region
FROM members
ORDER BY region DESC;

--Lab 2 of the SQL Simplified Labs!

Question 1:- How many records are there per ticker value in the prices table?

SELECT
  ticker,
  COUNT(*) AS record_count
FROM prices
GROUP BY ticker;

Question 2:- What is the maximum, minimum values for the price column for both Bitcoin and Ethereum in 2020?

SELECT
  ticker,
  MIN(price) AS min_price,
  MAX(price) AS max_price
FROM prices
WHERE market_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY ticker;

Question 3:- What is the annual minimum, maximum and average price for each ticker?

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

Question 4:- What is the monthly average of the price column for each ticker from January 2020 and after?

SELECT
  ticker,
  DATE_TRUNC('MON', market_date)::DATE AS month_start,
  ROUND(AVG(price), 2) AS average_price
FROM prices
WHERE market_date >= '2020-01-01'
GROUP BY ticker, month_start
ORDER BY ticker, month_start;


--Lab 3 of the SQL Simplified Labs!
Topic - logical operations are an important tool in the data analysis toolbox for any data professional. In this lab you will learn how to implement these logical conditions using SQL to manipulate existing datasets 

Question 1:- Convert the volume column in the prices table with an adjusted integer value to take into the unit values
				Return only the market_date, price, volume and adjusted_volume columns for the first 10 days of August 2021 for Ethereum only

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


Question 2:- How many "breakout" days were there in 2020 where the price column is greater than the open column for each ticker? In the same query also calculate the number of "non breakout" days where the price column was lower than or equal to the open column.

SELECT
  ticker,
  SUM(CASE WHEN price > open THEN 1 ELSE 0 END) AS breakout_days,
  SUM(CASE WHEN price <= open THEN 1 ELSE 0 END) AS non_breakout_days
FROM prices
WHERE market_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY ticker;

Question 3:- What was the final quantity Bitcoin and Ethereum held by all Data With Danny mentors based off the transactions table?

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

-- Lab 4 of the SQL Simplified Labs!
Topic - Window functions are immensely useful analytical tools used to calculate a variety of metrics including rankings, moving averages, cumulative sums, daily differences and much more. In this lab you will learn how to implement some of the most frequently used window functions with a cryptocurrency daily prices dataset.

Question 1:- What are the market_date, price and volume and price_rank values for the days with the top 5 highest price values for each tickers in the prices table?

				a)The price_rank column is the ranking for price values for each ticker with rank = 1 for the highest value.
				b)Return the output for Bitcoin, followed by Ethereum in price rank order.

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

Question 2:- Calculate a 7 day rolling average for the price and volume columns in the prices table for each ticker.
				a)Return only the first 10 days of August 2021

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


Question 3:- Calculate the monthly cumulative volume traded for each ticker in 2020
				a)Sort the output by ticker in chronological order with the month_start as the first day of each month?

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

Question 4:- Calculate the daily percentage change in volume for each ticker in the prices table?
			a)Percentage change can be calculated as (current - previous) / previous
			b)Multiply the percentage by 100 and round the value to 2 decimal places
			c)Return data for the first 10 days of August 2021


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


-- Lab 5 of the SQL Simplified Labs!
Topic - Table joins are mandatory for all SQL queries that obtain columns from 2 or more different datasets. You will learn how to implement the most commonly used table joins and how to assess which type of table join to use with all available datasets in a cryptocurrency SQL case study.

Question 1 - Which top 3 mentors have the most Bitcoin quantity? Return the first_name of the mentors and sort the output from highest to lowest total_quantity?

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

Question 2 - Show the market_date values which have less than 5 transactions? Sort the output in reverse chronological order.

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

Question 3 - Multiple Table Joins
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
