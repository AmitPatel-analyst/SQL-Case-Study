Questions:-

1. How many pubs are located in each country??
2. What is the total sales amount for each pub, including the beverage price and quantity sold?
3. Which pub has the highest average rating?
4. What are the top 5 beverages by sales quantity across all pubs?
5. How many sales transactions occurred on each date?
6. Find the name of someone that had cocktails and which pub they had it in.
7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'?
8. Which pubs have a rating higher than the average rating of all pubs?
9. What is the running total of sales amount for each pub, ordered by the transaction date?
10. For each country, what is the average price per unit of beverages in each category, and what is the overall average price per unit of beverages across all categories?
11. For each pub, what is the percentage contribution of each category of beverages to the total sales amount, and what is the pub's overall sales amount?


1. How many pubs are located in each country??

select country ,count(*) as Total_pubs
from pubs
group by country;


2. What is the total sales amount for each pub, including the beverage price and quantity sold?

select p.pub_name, sum(s.quantity * b.price_per_unit) as Total_SalesAmt
from pubs p
inner join sales s on p.pub_id=s.pub_id
inner join beverages b on b.beverage_id=s.beverage_id
group by p.pub_name;




3. Which pub has the highest average rating?

select top 1 p.pub_id , round(avg(r.rating),2) as Highest_avg_rating
from ratings r
inner join pubs p on r.pub_id=p.pub_id
group by p.pub_id
order by 2 desc; -- The Red Lion pub has highest rating of 4.67


4. What are the top 5 beverages by sales quantity across all pubs?

-- I used Row_number Window function,  we can use below window functions as well ;
		-- Rank Functions skips the rank if there are duplicate row values. 
		-- Dense_rank Functions will never skip the rank.
with cte_rank as (
select beverage_id,
		sum(quantity) as total_quantity,
		row_number()over(order by sum(quantity) desc) as rnum
from sales
group by beverage_id
)
select b.beverage_name as [Top 5 beverages]
from cte_rank as c
inner join beverages as b on c.beverage_id = b.beverage_id
where rnum <=5;


5. How many sales transactions occurred on each date?

  select transaction_date,count(*) as Sales_Frequency -- count the total sales transactions
  from sales
  group by transaction_date   -- to create a unique record of each value
  order by 1;



6. Find the name of someone that had cocktails and which pub they had it in.

 -- Approch -1

	select p.pub_name ,k.customer_name
	from pubs as p
	join ( select customer_name ,pub_id 
	 from ratings
	 where pub_id in (			 
		select distinct pub_id 
		from sales
		where beverage_id =  (
						select beverage_id 
						from beverages 
						where category = 'Cocktail')
		)
	) as k
	on k.pub_id = p.pub_id
	order by 1 ;


-- Approach - 2  (Using Inner join)
select p.pub_name ,r.customer_name
	from pubs as p
	inner join ratings as r
	on p.pub_id = r.pub_id
	inner join sales as s
	on s.pub_id = r.pub_id
	inner join beverages as b
	on b.beverage_id = s.beverage_id
	where b.category = 'Cocktail'  -- to include in the filter criteriaS
	order by 1;



7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'?


select category as Beverage_category, avg(price_per_unit) as average_price_per_unit
from beverages
where category <> 'Spirit'  -- to not include in the filter criteria
group by category;

8. Which pubs have a rating higher than the average rating of all pubs?

with cte_ratings as(
select	Pub_id
		,rating
		,dense_rank() over(partition by Pub_id Order by rating desc) as dRank 
		-- used partition by to find any duplicate records 
	from ratings
	where rating > (select avg(rating) from ratings) 
	-- avg rating of all pubs has value of 4.5
	)
select		p.*,c.rating
from		cte_ratings as c
inner join	pubs as p
on			c.pub_id = p.pub_id
where		dRank = 1; -- filter by only rank 1 (to filter duplicate records)

9. What is the running total of sales amount for each pub, ordered by the transaction date?

--
 with Cte_SalesAmt as (
	select	s.pub_id,(s.quantity * b.price_per_unit) as SalesAmt,s.transaction_date
	from	sales s
	inner join beverages as b
	on		s.beverage_id = b.beverage_id
	)
	select	*,Sum(SalesAmt) 
			over(partition by pub_id order by transaction_date) as Running_Total_SalesAmt
	from   Cte_SalesAmt;


10. For each country, what is the average price per unit of beverages in each category, 
	and what is the overall average price per unit of beverages across all categories?

with cte_avg_price as (
select	p.country,b.category,AVG(b.price_per_unit) as [Average_price]
from	pubs p
inner join sales s on s.pub_id = p.pub_id
inner join beverages b on b.beverage_id = s.beverage_id 
group by p.country,b.category 
),
cte_total_avg_price as (
select	p.country,AVG(b.price_per_unit) as [Total_Average_price]
from	pubs p
inner join sales s on s.pub_id = p.pub_id
inner join beverages b on b.beverage_id = s.beverage_id 
group by p.country 
)
select	a.country as Country , a.category as category 
		,a.Average_price as [Avg_price_per_unit] , b.Total_Average_price as [Total_Average_price_unit]
from	cte_avg_price a
inner join cte_total_avg_price b
on		a.country = b.country;

-------------------------------------------------------------
