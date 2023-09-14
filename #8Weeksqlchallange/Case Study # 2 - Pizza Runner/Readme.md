# :pizza: :runner:  Case Study #2: Pizza Runner 
<p align="center">
<img src="https://user-images.githubusercontent.com/120770473/236620731-3809e43a-835d-4ef1-ac58-84c300de6856.png" alt="Image" width="650" height="650">

You can find the complete challenge here:https://8weeksqlchallenge.com/case-study-2/
## Table Of Contents
  - [Introduction](#introduction)
  - [Datasets used](#datasets-used)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Data Cleaning](#data-cleaning)
  - [Case Study Solutions](#case-study-solutions)
  
## Introduction
  Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”
  Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!
  Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

    
## Datasets used
Key datasets for this case study
- **runners** : The table shows the registration_date for each new runner
- **customer_orders** : Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order. The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.
- **runner_orders** : After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer. The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.
- **pizza_names** : Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!
- **pizza_recipes** : Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.
- **pizza_toppings** : The table contains all of the topping_name values with their corresponding topping_id value

## Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/120770473/236621181-4c34ea27-706f-4f02-bf1a-d4b8ec5b3ba4.png)

## Case Study Question:
                                                  A. Pizza Metrics
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
                                                  B. Runner and Customer Experience
1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
4. What was the average distance travelled for each customer?
5. What was the difference between the longest and shortest delivery times for all orders?
6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
7. What is the successful delivery percentage for each runner?
                                                 C. Ingredient Optimisation
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
                                                D. Pricing and Ratings
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2. What if there was an additional $1 charge for any pizza extras?
  ◼ Add cheese is $1 extra
3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
  ◼ customer_id
  ◼ order_id
  ◼ runner_id
  ◼ rating
  ◼ order_time
  ◼ pickup_time
  ◼ Time between order and pickup
  ◼ Delivery duration
  ◼ Average speed
  ◼ Total number of pizzas
5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
   
## Data Cleaning
There are some known data issues with few tables. Data cleaning was performed and saved in temporary tables before attempting the case study.

**customer_orders table**
- The exclusions and extras columns in customer_orders table will need to be cleaned up before using them in the queries
- In the exclusions and extras columns, there are blank spaces and null values.

**runner_orders table**
- The pickup_time, distance, duration and cancellation columns in runner_orders table will need to be cleaned up before using them in the queries
- In the pickup_time column, there are null values.
- In the distance column, there are null values. It contains unit - km. The 'km' must also be stripped
- In the duration column, there are null values. The 'minutes', 'mins' 'minute' must be stripped
- In the cancellation column, there are blank spaces and null values.

Click [here](https://github.com/AmitPatel-analyst/SQL-Case-Study/blob/main/%238Weeksqlchallange/Case%20Study%20%23%202%20-%20Pizza%20Runner/0.%20Data%20Cleaning.md) to view the code of data cleaning task.

# Insights

                                                  A. Pizza Metrics
◼ Total Unique orders customers made were 10 and total 14 pizzas were ordered.      
◼ Runner 1 had Delivered highest number of pizzas , whereas Runner 3 had delivered Least.      
◼ Meatlovers pizza was delivered 9 times , whereas Vegetarian pizza was delivered 3 times only.      
◼ Customer 101,102,103,105 had ordered Vegetarian pizza only 1 time, whereas Customer 104 had ordered Meatlovers pizza 3 times.    
◼ Customer 101,102 liked his/her pizza as per the original recipe, whereas customer 103,104,105 had their own  
 preference for pizza toppings and requested atleast 1 change on their pizza.    
◼ Only One customer had ordered 1 pizza having both exclusions and extra toppings.    
◼ Highest number of pizza ordered were at 1:00 pm , 6:00 pm , 9:00 pm & 11:00 pm, whereas Least number of pizza were   ordered at 11:00 am  & 7:00 pm.   
◼ On Saturday and Wednesday highest number of pizza were ordered , whereas on Friday least number of pizza were ordered 

## Case Study Solutions
- [A. Pizza Metrics](https://github.com/AmitPatel-analyst/SQL-Case-Study/blob/main/%238Weeksqlchallange/Case%20Study%20%23%202%20-%20Pizza%20Runner/A.%20Pizza%20Metrics.md)
