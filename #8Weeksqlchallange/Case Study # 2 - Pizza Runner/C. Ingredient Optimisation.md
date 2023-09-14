# :pizza: Case Study #2: Pizza runner - Ingredient Optimisation

## Case Study Questions

1. What are the standard ingredients for each pizza?         
2. What was the most commonly added extra?           
3. What was the most common exclusion?               
4. Generate an order item for each record in the customers_orders table in the format of one of the following:                
  ◼ Meat Lovers          
  ◼ Meat Lovers - Exclude Beef              
  ◼ Meat Lovers - Extra Bacon            
  ◼ Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers              
5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients   
 ◼ For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"     
6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

***
Total Tables are following:        
  select * from updated_runner_orders;    
	select * from Updated_customer_orders;    
  SELECT * FROM pizza_runner.[pizza_toppings];    
  SELECT * FROM pizza_runner.[pizza_recipes];   
  SELECT * FROM pizza_runner.[pizza_names];   
  select * from pizza_runner.runners;

###  1. What are the standard ingredients for each pizza?
<details>
  <summary>Click here for solution</summary>
  
```sql
with cte as
	(	select pizza_id,value as topping_id
		 from pizza_runner.[pizza_recipes]
		cross apply string_split (toppings,',')
	),
  final as
  (
    SELECT pizza_id,topping_name 
	FROM pizza_runner.[pizza_toppings] as t
	inner join cte 
	on cte.topping_id=t.topping_id
	)
	select c.pizza_name,STRING_AGG(topping_name,',') as Ingredients
	from final inner join pizza_runner.[pizza_names] as c on c.pizza_id=final.pizza_id
	group by c.pizza_name;
```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/0a12be59-6573-405b-8e94-e6cf3595eab1)

###  2. What was the most commonly added extra?  
<details>
  <summary>Click here for solution</summary>
  
```sql
	with Get_toppingid as
		(select	 value as topping_id
		 from	Updated_customer_orders
		cross apply string_split (extras,',')
		)
		select t2.topping_name ,count(1) as added_extras_count
		from Get_toppingid as t1 inner join pizza_runner.[pizza_toppings] as t2
		on t1.topping_id=t2.topping_id
		where t2.topping_name is not null
		group by  t2.topping_name
		order by 2 desc;
```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/e9f3aa75-6d7e-48f0-a648-3666e2624a46)

###  3. What was the most common exclusion?
<details>
  <summary>Click here for solution</summary>
  
```sql
with Get_toppingid as
		(select	 value as topping_id
		 from	Updated_customer_orders
		cross apply string_split (exclusions,',')
		)
		select  t2.topping_name ,count(1) as added_exclusions_count
		from Get_toppingid as t1 inner join pizza_runner.[pizza_toppings] as t2
		on t1.topping_id=t2.topping_id
		where t2.topping_name is not null
		group by  t2.topping_name
		order by 2 desc;
```
</details>

#### Output:
![image](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/d2de817c-4bfd-4545-9d1f-90b1fdd01c64)

###  4. Generate an order item for each record in the customers_orders table 
<details>
  <summary>Click here for solution</summary>
  
```sql
