# :pizza: Case Study #2: Pizza runner - Runner and Customer Experience

## Case Study Questions

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?

***
Total Tables are following:        
  select * from updated_runner_orders;    
	select * from Updated_customer_orders;    
  SELECT * FROM pizza_runner.[pizza_toppings];    
  SELECT * FROM pizza_runner.[pizza_recipes];   
  SELECT * FROM pizza_runner.[pizza_names];   
  select * from pizza_runner.runners;
  
###  1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
<details>
  <summary>Click here for solution</summary>
  
```sql
   SELECT   
 CASE
    WHEN registration_date BETWEEN '2021-01-01' AND '2021-01-07' THEN '2021-01-01'
    WHEN registration_date BETWEEN '2021-01-08' AND '2021-01-14' THEN '2021-01-08'
    WHEN registration_date BETWEEN '2021-01-15' AND '2021-01-21' THEN '2021-01-15'
  END AS [Week Start_Period],count(runner_id) as cnt
  from pizza_runner.runners
  group by CASE
    WHEN registration_date BETWEEN '2021-01-01' AND '2021-01-07' THEN '2021-01-01'
    WHEN registration_date BETWEEN '2021-01-08' AND '2021-01-14' THEN '2021-01-08'
    WHEN registration_date BETWEEN '2021-01-15' AND '2021-01-21' THEN '2021-01-15'
  END ;
```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/a11f65b6-6b0b-433c-9f84-8bff4e6fd44f)

###  2.What was the AVERAGE TIME IN MINUTES it took for EACH RUNNER to arrive at the Pizza Runner HQ to PICKUP the order?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT r.runner_id
	,Avg_Arrival_minutes = avg(datepart(minute, (pickup_time - order_time)))
FROM updated_runner_orders r
INNER JOIN Updated_customer_orders c ON r.order_id = c.order_id
WHERE r.cancellation IS NULL
	OR r.cancellation NOT IN (
		'Restaurant Cancellation'
		,'Customer Cancellation'
		)
GROUP BY r.runner_id;
```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/27c8c42f-dcca-492a-89cf-6c118dc7832b)

###  3.	Is there any relationship between the number of pizzas and how long the order takes to prepare?
<details>
  <summary>Click here for solution</summary>
  
```sql
with order_count as
(
	select	order_id,order_time,count(pizza_id) as pizza_order_count
	from	Updated_customer_orders
	group by order_id,order_time
),
prepare_time as
(
	select	c.*,r.pickup_time
			,datepart(minute,(r.pickup_time-c.order_time)) as prepare_time
	from	updated_runner_orders r
	join	order_count c
	on		r.order_id=c.order_id
	where	r.pickup_time is not null
)
select		pizza_order_count,avg(prepare_time) as avg_prepare_time from prepare_time
group by	pizza_order_count
order by	pizza_order_count;
```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/5bc3bf1c-e6ab-44ee-a15f-6f6c2659b1f2)


###  4.	What was the AVERAGE DISTANCE travelled for EACH RUNNER?
<details>
  <summary>Click here for solution</summary>
  
```sql
select	runner_id,
		Avg_distance_travel = round(avg(distance),2)
from	updated_runner_orders 
where	cancellation is null
or		cancellation not in ('Restaurant Cancellation','Customer Cancellation')
group by  runner_id
order by  runner_id;
```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/62ee549d-7e6b-4f54-88fa-6548fbc00393)



