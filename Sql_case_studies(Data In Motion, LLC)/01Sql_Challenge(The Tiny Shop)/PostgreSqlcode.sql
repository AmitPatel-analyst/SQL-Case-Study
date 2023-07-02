-- Date : 27-May-2023
-- Public schema
create schema public;
-- Customers table
 CREATE TABLE customers (
    customer_id integer PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100)
);
-- Products Table
CREATE TABLE products (
    product_id integer PRIMARY KEY,
    product_name varchar(100),
    price decimal
);

-- Orders Table
CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    customer_id integer,
    order_date date
);

-- Order Items Table 
CREATE TABLE order_items (
    order_id integer,
    product_id integer,
    quantity integer
);

-- Customers Table
INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Alice', 'Brown', 'alicebrown@email.com'),
(5, 'Charlie', 'Davis', 'charliedavis@email.com'),
(6, 'Eva', 'Fisher', 'evafisher@email.com'),
(7, 'George', 'Harris', 'georgeharris@email.com'),
(8, 'Ivy', 'Jones', 'ivyjones@email.com'),
(9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
(10, 'Lily', 'Nelson', 'lilynelson@email.com'),
(11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
(12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
(13, 'Sophia', 'Thomas', 'sophiathomas@email.com');

-- Products Table
INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Product A', 10.00),
(2, 'Product B', 15.00),
(3, 'Product C', 20.00),
(4, 'Product D', 25.00),
(5, 'Product E', 30.00),
(6, 'Product F', 35.00),
(7, 'Product G', 40.00),
(8, 'Product H', 45.00),
(9, 'Product I', 50.00),
(10, 'Product J', 55.00),
(11, 'Product K', 60.00),
(12, 'Product L', 65.00),
(13, 'Product M', 70.00);

-- Orders Table
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-05-01'),
(2, 2, '2023-05-02'),
(3, 3, '2023-05-03'),
(4, 1, '2023-05-04'),
(5, 2, '2023-05-05'),
(6, 3, '2023-05-06'),
(7, 4, '2023-05-07'),
(8, 5, '2023-05-08'),
(9, 6, '2023-05-09'),
(10, 7, '2023-05-10'),
(11, 8, '2023-05-11'),
(12, 9, '2023-05-12'),
(13, 10, '2023-05-13'),
(14, 11, '2023-05-14'),
(15, 12, '2023-05-15'),
(16, 13, '2023-05-16');

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 2, 1),
(2, 3, 3),
(3, 1, 1),
(3, 3, 2),
(4, 2, 4),
(4, 3, 1),
(5, 1, 1),
(5, 3, 2),
(6, 2, 3),
(6, 1, 1),
(7, 4, 1),
(7, 5, 2),
(8, 6, 3),
(8, 7, 1),
(9, 8, 2),
(9, 9, 1),
(10, 10, 3),
(10, 11, 2),
(11, 12, 1),
(11, 13, 3),
(12, 4, 2),
(12, 5, 1),
(13, 6, 3),
(13, 7, 2),
(14, 8, 1),
(14, 9, 2),
(15, 10, 3),
(15, 11, 1),
(16, 12, 2),
(16, 13, 3);


select * from orders;
select * from customers;
select * from order_items;
select * from products;

--Questions:

1) Which product has the highest price? Only return a single row

select product_name,price
from products
order by price desc
limit 1;

2) Which customer has made the most orders?

select c.first_name ||' '|| c.last_name as fullname, count(o.order_id) as most_orders
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.first_name, c.last_name
having count(o.order_id) > 1;

3) What’s the total revenue per product?

select p.product_id,sum(p.price*o.quantity) as total_revenue_per_product
from products p 
inner join order_items o
on p.product_id = o.product_id
group by p.product_id
order by 1;

4) Find the day with the highest revenue.

with cte as
(
select o.order_id,p.product_id ,sum(p.price*o.quantity) as total_revenue_per_product
from products p 
inner join order_items o
on p.product_id = o.product_id
group by o.order_id,p.product_id 
order by o.order_id
),cte_a as
(select order_id, sum(total_revenue_per_product) as total_revenue from cte
group by order_id
order by 2 desc
)
select B.order_date,A.total_revenue from cte_a as A 
inner join orders B on A.order_id = B.order_id 
order by 2 desc 
limit 1;


5) Find the first order (by date) for each customer.

with cte_a as
(
select distinct customer_id as CId,
first_value(Order_date) over(partition by customer_id order by order_date)as first_order
from orders
order by customer_id
)
select first_order , first_name||' '||last_name as customer_name
from cte_a as A
inner join customers as B 
on A.CId = B.customer_id;


6) Find the top 3 customers who have ordered the most distinct products

select c.customer_id,
c.first_name || ' '|| c.last_name as customer_name,
count( distinct oi.product_id) as distinct_product
from customers c
inner join orders o
on c.customer_id = o.customer_id
inner join order_items oi
on oi.order_id = o.order_id
group by 1,2 
order by 3 desc
limit 3;

7) Which product has been bought the least in terms of quantity?

select product_id,sum(quantity) as least_ordered
from order_items
group by product_id
order by 2 
limit 1;

8 ) What is the median order total?

with order_total as(
select o.order_id,
	sum(oi.quantity * p.price) as total 
from orders o 
inner join order_items oi
	on o.order_id=oi.order_id
inner join products p
	on p.product_id= oi.product_id
group by o.order_id
)
select  percentile_cont(0.5) within group (order by total)
 as median_order_total
from order_total;

9) For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.

select o.order_id,
	sum(o.quantity * p.price) as total ,
	case when sum(o.quantity * p.price)>300 then 'Expensive'
	when sum(o.quantity * p.price)>100 then 'Affordable'
	else 'Cheap' end as purchase_type
from order_items o 
inner join products p
	on p.product_id=o.product_id
	group by o.order_id;


10) Find customers who have ordered the product with the highest price.

select c.customer_id , c.first_name || ' ' || c.last_name as customer_name , p.price as highest_price
from products as p
inner join order_items as r on p.product_id = r.product_id
inner join orders as o on o.order_id = r.order_id
inner join customers as c on c.customer_id = o.customer_id
where p.price = (select max(price) from products)
;
