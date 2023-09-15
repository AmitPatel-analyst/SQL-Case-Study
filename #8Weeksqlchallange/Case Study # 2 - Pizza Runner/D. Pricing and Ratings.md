# :pizza: Case Study #2: Pizza runner - Pricing and Ratings

## Case Study Questions
1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?             
2. What if there was an additional $1 charge for any pizza extras?                        
     - Add cheese is $1 extra          
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
***
Total Tables are following:        
  	select * from updated_runner_orders;    
	select * from Updated_customer_orders;    
  	SELECT * FROM pizza_runner.[pizza_toppings];    
  	SELECT * FROM pizza_runner.[pizza_recipes];   
  	SELECT * FROM pizza_runner.[pizza_names];   
  	select * from pizza_runner.runners
	select * from customer_orders_new;   

 
