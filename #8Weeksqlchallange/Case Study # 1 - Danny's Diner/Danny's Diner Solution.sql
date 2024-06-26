----------------------------------
-- CASE STUDY #1: DANNY'S DINER --
----------------------------------

-- Author: Amit Patel
-- Date: 25/04/2023 
-- Tool used: MSSQL Server

--------------------------
-- CASE STUDY QUESTIONS --
--------------------------

-- 1. What is the total amount each customer spent at the restaurant?

SELECT s.customer_id AS customer, SUM(m.price) AS spentamount_cust 
FROM sales s 
JOIN menu m 
ON s.product_id = m.product_id 
GROUP BY s.customer_id;


-- 2. How many days has each customer visited the restaurant?

SELECT	customer_id, COUNT(DISTINCT order_date) AS Visit_frequency
FROM	sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
-- -- Asssumption: Since the timestamp is missing, all items bought on the first day is considered as the first item(provided multiple items were purchased on the first day)

SELECT	s.customer_id AS customer, m.product_name AS food_item
FROM	sales s
JOIN	menu m
ON		s.product_id = m.product_id
WHERE	s.order_date = (SELECT MIN(order_date) FROM sales WHERE customer_id = s.customer_id)
ORDER BY s.product_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT		TOP 1 m.product_name, COUNT(s.product_id) AS order_count
FROM		sales s
JOIN		menu m ON s.product_id=m.product_id
GROUP BY	m.product_name
ORDER BY	order_count DESC;

-- 5. Which item was the most popular for each customer?
-- Asssumption: Products with the highest purchase counts are all considered to be popular for each customer

with cte_order_count as
(
select  s.customer_id,
	m.product_name,
	count(*) as order_count
from 	   sales as s
inner join menu as m
on 	   s.product_id = m.product_id 
group by   s.customer_id,m.product_name
),
cte_popular_rank AS (
  SELECT *,
	rank() over(partition by customer_id order by order_count desc) as rn
  from	cte_order_count )

SELECT customer_id as customer, product_name as food_item,order_count
FROM cte_popular_rank
WHERE	rn = 1;

-- 6. Which item was purchased first by the customer after they became a member?
-- Before answering question 6, I created a membership_validation table to validate only those customers joining in the membership program:

DROP TABLE #Membership_validation;
CREATE TABLE #Membership_validation
(
   customer_id varchar(1),
   order_date date,
   product_name varchar(5),
   price int,
   join_date date,
   membership varchar(5)
)

INSERT INTO #Membership_validation
SELECT s.customer_id, s.order_date, m.product_name, m.price, mem.join_date,
       CASE WHEN s.order_date >= mem.join_date THEN 'X' ELSE '' END AS membership
FROM sales s
INNER JOIN menu m ON s.product_id = m.product_id
LEFT JOIN members mem ON mem.customer_id = s.customer_id
WHERE join_date IS NOT NULL
ORDER BY customer_id, order_date;

select * from #Membership_validation;
Soln No. 6
WITH cte_first_after_mem AS (
  SELECT 
    customer_id,
    product_name,
    order_date,
    RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS purchase_order
  FROM #Membership_validation
  WHERE membership = 'X'
)
SELECT * FROM cte_first_after_mem
WHERE purchase_order = 1;

-- 7. Which item was purchased just before the customer became a member?

WITH cte_last_before_mem AS (
  SELECT 
    customer_id,
    product_name,
    order_date,
    RANK() OVER( PARTITION BY customer_id ORDER BY order_date DESC) AS purchase_order
  FROM #Membership_validation
  WHERE membership = ''
)
SELECT * FROM cte_last_before_mem 
WHERE purchase_order = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
WITH cte_spent_before_mem AS (
  SELECT 
    customer_id,
    product_name,
    price
  FROM #Membership_validation
  WHERE membership = ''
)
SELECT 
	customer_id,
  SUM(price) AS total_spent,
  COUNT(*) AS total_items
FROM cte_spent_before_mem
GROUP BY customer_id
ORDER BY customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT
  customer_id,
  SUM( CASE 
	WHEN product_name = 'sushi' THEN (price * 20) ELSE (price * 10)
		END
	) AS total_points
FROM #Membership_validation
WHERE order_date >= join_date
GROUP BY customer_id
ORDER BY customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January
Asssumption: Points is rewarded only after the customer joins in the membership program

Steps
Find the program_last_date which is 7 days after a customer joins the program (including their join date)
Determine the customer points for each transaction and for members with a membership a. During the first week of the membership -> points = price20 irrespective of the purchase item b. Product = Sushi -> and order_date is not within a week of membership -> points = price20 c. Product = Not Sushi -> and order_date is not within a week of membership -> points = price*10
Conditions in WHERE clause a. order_date <= '2021-01-31' -> Order must be placed before 31st January 2021 b. order_date >= join_date -> Points awarded to only customers with a membership

with program_last_day_cte as 
(
select join_date ,
		Dateadd(dd,7,join_date) as program_last_date,
		customer_id
from members
)
SELECT s.customer_id,
       SUM(CASE
               WHEN order_date BETWEEN join_date AND program_last_date THEN price*10*2
               WHEN order_date NOT BETWEEN join_date AND program_last_date
                    AND product_name = 'sushi' THEN price*10*2
               WHEN order_date NOT BETWEEN join_date AND program_last_date
                    AND product_name != 'sushi' THEN price*10
           END) AS customer_points
FROM				MENU as m
INNER JOIN			sales as s on m.product_id = s.product_id
INNER JOIN			program_last_day_cte as k on k.customer_id = s.customer_id
AND				order_date <='2021-01-31'
AND				order_date >=join_date
GROUP BY			s.customer_id
ORDER BY			s.customer_id;
