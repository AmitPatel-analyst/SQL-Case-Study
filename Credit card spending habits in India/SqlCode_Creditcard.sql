-- Date  : 01-June-2023
use Creditcard
go

--Questions:

--1. write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
--2. write a query to print highest spend month and amount spent in that month for each card type
--3. write a query to print the transaction details(all columns from the table) for each card type when
--it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
--4. write a query to find city which had lowest percentage spend for gold card type
--5. write a query to print 3 columns: city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
--6. write a query to find percentage contribution of spends by females for each expense type
--7. which card and expense type combination saw highest month over month growth in Jan-2014
--8. during weekends which city has highest total spend to total no of transcations ratio 
--9. which city took least number of days to reach its 500th transaction after first transaction in that city

select 
	SUM(case when "Index" IS NULL THEN 1 ELSE 0 END) AS index_null_count
	,sum(case when city IS NULL THEN 1 ELSE 0 END) AS city_null_count
	,sum(case when "Date" IS NULL THEN 1 ELSE 0 END) AS date_null_count
	,sum(case when Card_Type IS NULL THEN 1 ELSE 0 END) AS card_null_count
	,sum(case when Exp_Type IS NULL THEN 1 ELSE 0 END) AS exp_null_count
	,sum(case when Gender IS NULL THEN 1 ELSE 0 END) AS gender_null_count
	,sum(case when Amount IS NULL THEN 1 ELSE 0 END) AS Amt_null_count
from credit_card_transactions;

select top 1 Date
		from credit_card_transactions
		order by Date desc; -- 26-may-2015 is the last date of dataset

select top 1 Date
		from credit_card_transactions
		order by Date ;  --  04-oct-2013  is the first date of dataset
			

select count(1) from credit_card_transactions;
  -- total 26052 records are present in the dataset

select City , count(1) as Frequency_Usage
from credit_card_transactions
group by City
order by 2 desc; -- Show me the total frequency usage by city 

select Gender,Card_Type,count(1) as Frequency_Usage
from credit_card_transactions
group by Gender,Card_Type 
order by 3 desc;              -- Female do more credit card transactions as compared to male .


select Gender,Card_Type,count(1) as Total_users
from credit_card_transactions
group by Gender,Card_Type 
order by 3 desc; -- Show me the transaction frequency by Gender and credit card type


select gender,Exp_Type ,count(1) as Frequency_Usage
from credit_card_transactions
group by gender,Exp_Type
order by 3 desc;  --Show me the transactions frequency by Expense type and Gender

select gender,Card_Type , sum(Amount) as SpendingAmt_byExptype
from credit_card_transactions
group by gender,Card_Type
order by 3 desc;  -- Show me the Amount Spent by Gender and credit card type


--1. write a query to print top 5 cities with highest spends 
--   and their percentage contribution of total credit card spends?

With cte1 as (
select top 5 city ,sum(Amount) as Citywise_Spent_Amount
from credit_card_transactions
group by city
order by Citywise_Spent_Amount desc
),
cte2 as (
select sum(Amount) as total_amt
from credit_card_transactions
)
select	c1.City
		,c1.Citywise_Spent_Amount
		,100.0*c1.Citywise_Spent_Amount / c2.total_amt as Percentage_contribution
from cte1 as c1
inner join cte2 as c2
on 1=1;

--2. write a query to print highest spend month and amount spent in that month for each card type


with spent_amt_datewise as(
select	DATEPART(year,Date) as trans_year
		,DATENAME(month,date) as trans_month
		,Card_Type
		,sum(amount) as spent_amt
from	credit_card_transactions
group by DATEPART(year,Date) 
		,DATENAME(month,date)
		,Card_Type
)
,ranking as (
select	*
		,DENSE_RANK() over(partition by card_type order by spent_amt desc) as drank
from	spent_amt_datewise
)
select	trans_year,trans_month,Card_Type,spent_amt
from	ranking
where	drank = 1;

--3. write a query to print the transaction details(all columns from the table) for each card type
--   when it reaches a cumulative of 10,00,000 total spends(We should have 4 rows in the o/p one for each card type)

select City,Date,Card_Type,Exp_Type,Gender,Amount,cumulative_sum
from (
	select *
	,DENSE_RANK() over(Partition by card_type order by k.cumulative_sum) as drank
	from (
		select *
		,sum(Amount) over(partition by card_type order by Date,Amount) as cumulative_sum
		from credit_card_transactions
		) k
where k.cumulative_sum>=1000000
	) m
where m.drank = 1 ;

--4. write a query to find city which had lowest percentage spend for gold card type


with cte1 as (
select City, sum(Amount) as spend_amt_ingold_citywise
from credit_card_transactions
where Card_Type = 'Gold'
group by City,Card_Type
)
, cte2 as (
select City, Sum(Amount) as spent_amt_citywise
from credit_card_transactions
group by City
)
,cte3 as (
select	c1.City
		,c1.spend_amt_ingold_citywise as Citywise_Spent_money_ongold
		,c2.spent_amt_citywise as Citywise_Spent_money
		,100.0 * c1.spend_amt_ingold_citywise / c2.spent_amt_citywise   as perc_contribution
from cte1 c1
join cte2 c2
on c1.City = c2.City
)
select top 1 * 
from cte3
order by perc_contribution; -- Dhamtari, India has spent least amount in gold.

--5. write a query to print 3 columns: city, highest_expense_type , lowest_expense_type 
-- (example format : Delhi , bills, Fuel)


with cte_1 as (
select City ,Exp_Type, sum(Amount) as spent_amt
from credit_card_transactions
group by City , Exp_Type )
, cte_2 as (
select city,
min(spent_amt) as lowest_spent_amount,
MAX  (spent_amt) as highest_spent_amount
from cte_1
group by City
)
select c1.City,
max(case when c2.highest_spent_amount = c1.spent_amt then Exp_Type end) as highest_expense_type,
max(case when c2.lowest_spent_amount = c1.spent_amt then Exp_Type end ) as lowest_expense_type
from cte_1 as c1
inner join cte_2 as c2
on c1.City=c2.City
group by c1.City
order by c1.City;

-- 6. Write a query to find percentage contribution of spends by females for each expense type.

with cte_1 as (
select  Exp_Type , sum(Amount) as Exp_type_spent_amount
from credit_card_transactions
where Gender = 'F'
group by Exp_Type
), cte_2 as (
select sum(Amount) as total_spent
from credit_card_transactions
where Gender = 'F'
)
select 
Exp_Type,
format(100.0* Exp_type_spent_amount / total_spent ,'f2') as perc_contribution_spent_female
from  cte_1 inner join cte_2 on 1=1;

--7. which card and expense type combination saw highest month over month growth in january 2014?

with cte_1 as(
select Card_Type,Exp_Type,
DATEPART(year,Date) as Trans_Year,
DATEPART(month,Date) as Trans_Month,
sum(Amount)  as total_amount
from credit_card_transactions
group by Card_Type,Exp_Type,DATEPART(year,Date),DATEPART(month,Date)
)
,cte_2 as(
select *,
LAG(total_amount,1) over(partition by Card_Type,Exp_Type order by Trans_Year,Trans_Month) as prev_month_trans_amount
from cte_1
)
,cte_3 as(
select *,
100.0*(total_amount - prev_month_trans_amount)/ prev_month_trans_amount as growth_per_month
from cte_2
where Trans_Year = 2014 and Trans_Month = 1
)
select top 1 *
from cte_3
order by growth_per_month desc;

--8. during weekends which city has highest total spend to total no of transcations ratio 


select  top 1 city,
		sum(Amount) as total_spent
		,count(1) as Count_of_transaction
		,ratio = sum(Amount)/count(1) 
from	credit_card_transactions
where	DATEPART(weekday,Date)   in (7,1)
group by City
order by 4 desc;



--9. which city took least number of days to reach its 500th transaction after first transaction in that city

WITH CTE1 AS
(
select City,count(1) as count_of_trans,
min(Date) AS MIN_DATE,
MAX(DATE) AS MAX_DATE
from credit_card_transactions
group by City
HAVING count(1) >=500
)
, CTE2 AS (
SELECT
CITY,DATE,
ROW_NUMBER() OVER(PARTITION BY CITY ORDER BY DATE) AS ROW_NM
FROM credit_card_transactions
WHERE City IN ( SELECT City FROM CTE1)
)
, CTE3 AS (
SELECT		C1.CITY,C1.MIN_DATE , C1.MAX_DATE ,C1.count_of_trans 
			,C2.DATE 
FROM		CTE1 AS C1
INNER JOIN	CTE2 AS C2
ON			C1.CITY = C2.CITY 
WHERE		C2.ROW_NM = 500
)
SELECT		 CITY , MIN_DATE AS TRANS_START_DATE
			,DATE AS TRANS_DATE_FOR500TH_TRANS
			,DATEDIFF(DAY,MIN_DATE,DATE) AS DAYS_TO_REACH_500TH_TRANS
FROM		CTE3
ORDER BY	DAYS_TO_REACH_500TH_TRANS;

Some of the key insights are :
1) Allocate additional marketing resources and promotional campaigns to the top 5cities to capitalize on their high spending patterns.
2) Plan targeted promotional offers or campaigns during the highest spending monthsfor each card type to encourage increased spending.
3) Investigate the reasons behind the low spending in the identified city and considertargeted marketing strategies or partnerships to increase spending in that location.
4) Allocate additional staffing or resources in the city with the highest spend-to-transaction ratio during weekends to capitalize on increased spending opportunities.
5) Identify market potential and consider targeted marketing efforts in the city withthe fastest transaction growth to capture new customers and increase businessgrowth.
6) Develop specific product or service offerings targeted towards females based ontheir significant contribution to spending in specific expense categories.
