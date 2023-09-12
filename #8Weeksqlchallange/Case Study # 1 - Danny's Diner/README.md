# :ramen: :curry: :sushi: Case Study #1: Danny's Diner 
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" alt="Image" width="650" height="650">

You can find the complete challenge here: https://8weeksqlchallenge.com/case-study-1/

## Table Of Contents
  - [Introduction](#introduction)
  - [Problem Statement](#problem-statement)
  - [Datasets used](#datasets-used)
  - [Entity Relationship Diagram](#entity-relationship-diagram)
  - [Case Study Questions](#case-study-questions)
  
## Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

## Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.
He plans on using these insights to help him decide whether he should expand the existing customer loyalty program.

## Datasets used
Three key datasets for this case study
- sales: The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.
- menu: The menu table maps the product_id to the actual product_name and price of each menu item.
- members: The members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.

## Entity Relationship Diagram

![ERD](https://user-images.githubusercontent.com/120770473/234551667-d04ba731-3950-406b-96fc-4eedbbed924c.png)

## Case Study Questions
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
10. What is the total items and amount spent for each member before they became a member?
11. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
12. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

## Insights
◼Out of the three Customers A, B and C, 2 customers A & B have joined the membership and there are 3 products offered at Danny’s Diner: sushi, curry and ramen.     
◼Customer A has spent the highest amount of $76 at Danny’s Diner, followed by B and C     
◼Frequently visited Customers are A and B with 6 number of times and the Customer C has done the lowest no of visits.      
◼The First item opted by most of the customers to taste from Danny’s Diner is curry and then it was ramen.     
◼The most popular item in Danny’s diner is found as Ramen, followed by curry and sushi.     
◼The first item bought By Customers A and B after taking membership are Ramen and sushi respectively.     
◼Before taking membership the last item chosen by Customer A were sushi and curry and for B it was sushi    
◼Before taking the membership, Customer A has bought 2 items with a Total amount of $25 and B has bought 3 items with a total amount of $40    
◼Customers A, B and C have earned Total points of 860, 940 and 360 based on their purchases without their membership.    
◼As Customers A and B took membership and can earn 20 points for every $1 spent irrespective of the items, they earned total Points of 1010 and 820 by the end of January 2021.    
  
Click [here](https://github.com/AmitPatel-analyst/SQL-Case-Study/blob/main/%238Weeksqlchallange/Case%20Study%20%23%201%20-%20Danny's%20Diner/Danny's%20Diner%20Solution.md) to view the solution of the case study!
