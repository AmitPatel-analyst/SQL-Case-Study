# :pizza: Case Study #2: Pizza runner - Pizza Metrics

## Case Study Questions

1. How many pizzas were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each runner?
4. How many of each type of pizza was delivered?
5. How many Vegetarian and Meatlovers were ordered by each customer?
6. What was the maximum number of pizzas delivered in a single order?
7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8. How many pizzas were delivered that had both exclusions and extras?
9. What was the total volume of pizzas ordered for each hour of the day?
10. What was the volume of orders for each day of the week?

***
Total Tables -    
SELECT * FROM  updated_runner_orders;   
SELECT * FROM  Updated_customer_orders;   
SELECT * FROM pizza_runner.pizza_toppings;   
SELECT * FROM pizza_runner.pizza_recipes;   
SELECT * FROM pizza_runner.pizza_names;   
SELECT * FROM  pizza_runner.runners;

###  1. How many pizzas were ordered?
<details>
  <summary>Click here for solution</summary>
  
```sql
  select count(pizza_id) as pizza_count from Updated_customer_orders;
```
</details>

#### Output:
![image](https://user-images.githubusercontent.com/120770473/236623764-037c342f-f9ec-433b-bef9-c79426f880de.png)

###  2. How many unique customer orders were made?
<details>
  <summary>Click here for solution</summary>
  
```sql
select count(distinct order_id) as order_count from Updated_customer_orders;  
```
</details>

#### Output:
![image](https://user-images.githubusercontent.com/120770473/236623790-e401b7c5-c956-4b20-90d3-74649db8738d.png)

### 3. How many successful orders were delivered by each runner?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  runner_id,
  COUNT(order_id) [Successful Order]
FROM updated_runner_orders
WHERE cancellation IS NULL
OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id
ORDER BY 2 DESC;  
```
</details>

#### Output:
![image](https://user-images.githubusercontent.com/120770473/236623849-11c3fa59-dd6e-47be-b8e4-d44425eb0421.png)

#### 4. How many of each type of pizza was delivered?
<details>
  <summary>Click here for solution</summary>
  
```sql
 SELECT
  p.pizza_name,
  Pizza_count
FROM (SELECT
  c.pizza_id,
  COUNT(r.order_id) AS Pizza_count
FROM updated_runner_orders r
JOIN Updated_customer_orders c
  ON r.order_id = c.order_id
WHERE cancellation IS NULL
OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY c.pizza_id) k
INNER JOIN pizza_runner.[pizza_names] p
  ON k.pizza_id = p.pizza_id; 
```
</details>

#### Output:
![image](https://user-images.githubusercontent.com/120770473/236623909-7dc585d2-23d1-4bfe-818c-5a0b25c33cf0.png)

#### 5. How many Vegetarian and Meatlovers were ordered by each customer?
<details>
  <summary>Click here for solution</summary>
  
```sql
 SELECT
  customer_id,
  SUM(CASE
    WHEN pizza_id = 1 THEN 1
    ELSE 0
  END) AS Orderby_Meatlovers,
  SUM(CASE
    WHEN pizza_id = 2 THEN 1
    ELSE 0
  END) AS Orderby_Vegetarian
FROM Updated_customer_orders
GROUP BY customer_id; 
```
</details>

#### Output:
![image](https://user-images.githubusercontent.com/120770473/236624294-e6ea617b-8705-49ac-9586-e50dad1edf1f.png)

#### 6. What was the maximum number of pizzas delivered in a single order?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  order_id, pizza_count AS max_count_delivered_pizza
FROM (SELECT top 1
  r.order_id,
  COUNT(c.pizza_id) AS pizza_count
FROM updated_runner_orders r
JOIN Updated_customer_orders c
  ON r.order_id = c.order_id
WHERE cancellation IS NULL
OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY r.order_id
ORDER BY pizza_count desc) k;
```
</details>

#### Output:
![image](https://user-images.githubusercontent.com/120770473/236624380-5db1af42-d49f-4fac-b7d8-c4de70fb75ae.png)

#### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
- at least 1 change -> either exclusion or extras 
- no changes -> exclusion and extras are NULL
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  c.customer_id,
  SUM(CASE WHEN c.exclusions <> ' ' OR
      c.extras <> ' ' THEN 1 ELSE 0 END) AS Changes,
  SUM(CASE WHEN c.exclusions = ' ' AND
      c.extras = ' ' THEN 1 ELSE 0 END) AS No_changes
FROM updated_runner_orders r
INNER JOIN Updated_customer_orders c
  ON r.order_id = c.order_id
WHERE r.cancellation IS NULL
OR r.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY c.customer_id
ORDER BY c.customer_id;
```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/087d505a-68be-4e01-8e06-7410a8b52db4)


#### 8. How many pizzas were delivered that had both exclusions and extras?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  count(r.order_id) as Order_had_bothexclusions_and_extras
FROM updated_runner_orders r
inner JOIN Updated_customer_orders c
  ON r.order_id = c.order_id
WHERE r.cancellation IS NULL and c.exclusions <> ' ' AND
      c.extras <> ' ';
```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/8cb4cdba-2f0a-4628-8e2f-b6b4bc588d04)


#### 9. What was the total volume of pizzas ORDERED for each hour of the day?
<details>
  <summary>Click here for solution</summary>
  
```sql

SELECT
  DATEPART(HOUR, order_time) AS Hour,
  COUNT(1) AS Pizza_Ordered_Count
FROM Updated_customer_orders
WHERE order_time IS NOT NULL
GROUP BY DATEPART(HOUR, order_time)
ORDER BY 1;
```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/a15e261f-a199-4f54-9c6f-04550d2b9985)


#### 10. What was the volume of orders for each day of the week?
<details>
  <summary>Click here for solution</summary>
  
```sql
SELECT
  DATENAME(dw, order_time) AS Day_of_Week,
  COUNT(1) AS Pizza_Ordered_Count
FROM Updated_customer_orders
GROUP BY DATENAME(dw, order_time)
ORDER BY 2 DESC;

```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/7ef0d3d5-41f4-4cce-acf4-7418ea0c5d01)


  ***
 Click [here]() to view the solution of B. Runner and Customer Experience
