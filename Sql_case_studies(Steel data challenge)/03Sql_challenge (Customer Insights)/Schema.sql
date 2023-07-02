/*****************************************************************************************
Name	: Code for Steel_Data DB
Author	: Amit Patel
Date   : 12-May-2023

Purpose: This script will create Db and few table in it to store info about Customer Insights
*****************************************************************************************/
create database Steel_Data
go

USE Steel_Data
GO
---create table country
CREATE TABLE country (
country_id INT PRIMARY KEY,
country_name VARCHAR(50),
head_office VARCHAR(50)
);
---create table customers 
CREATE TABLE customers (
customer_id INT PRIMARY KEY,
first_shop DATE,
age INT,
rewards VARCHAR(50),
can_email VARCHAR(50)
);
---create table orders 
CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
date_shop DATE,
sales_channel VARCHAR(50),
country_id INT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (country_id) REFERENCES country(country_id)
);
---create table products 
CREATE TABLE products (
product_id INT PRIMARY KEY,
category VARCHAR(50),
price NUMERIC(5,2)
);
---create table baskets 
CREATE TABLE baskets (
order_id INT,
product_id INT,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);

--insert data
INSERT INTO country (country_id, country_name, head_office)
VALUES (1, 'UK', 'London'),
(2, 'USA', 'New York'),
(3, 'China', 'Beijing');
--------------------
INSERT INTO customers (customer_id, first_shop, age, rewards, can_email)
VALUES (1, '2022-03-20', 23, 'yes', 'no'),
(2, '2022-03-25', 26, 'no', 'no'),
(3, '2022-04-06', 32, 'no', 'no'),
(4, '2022-04-13', 25, 'yes', 'yes'),
(5, '2022-04-22', 49, 'yes', 'yes'),
(6, '2022-06-18', 28, 'yes', 'no'),
(7, '2022-06-30', 36, 'no', 'no'),
(8, '2022-07-04', 37, 'yes', 'yes');
--------------------
INSERT INTO orders (order_id, customer_id, date_shop, sales_channel, country_id)
VALUES (1, 1, '2023-01-16', 'retail', 1),
(2, 4, '2023-01-20', 'retail', 1),
(3, 2, '2023-01-25', 'retail', 2),
(4, 3, '2023-01-25', 'online', 1),
(5, 1, '2023-01-28', 'retail', 3),
(6, 5, '2023-02-02', 'online', 1),
(7, 6, '2023-02-05', 'retail', 1),
(8, 3, '2023-02-11', 'online', 3);
--------------------
INSERT INTO products (product_id, category, price)
VALUES (1, 'food', 5.99),
(2, 'sports', 12.49),
(3, 'vitamins', 6.99),
(4, 'food', 0.89),
(5, 'vitamins', 15.99);
--------------------
INSERT INTO baskets (order_id, product_id)
VALUES (1, 1),
(1, 2),
(1, 5),
(2, 4),
(3, 3),
(4, 2),
(4, 1),
(5, 3),
(5, 5),
(6, 4),
(6, 3),
(6, 1),
(7, 2),
(7, 1),
(8, 3),
(8, 3);
