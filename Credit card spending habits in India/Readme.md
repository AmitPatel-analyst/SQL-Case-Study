![custom](https://github.com/AmitPatel-analyst/SQL-Case-Study/blob/main/Credit%20card%20spending%20habits%20in%20India/Credit%20Card%20Image.jpg)
I recently came across a case study on the Kaggle website. As a data analyst, I found this challenge to be a great way to showcase my SQL skills and improve my problem-solving abilities.

Imported the dataset in SQL server with table name: credit_card_transcations             
Here is the link to download the credit card transactions [dataset](https://lnkd.in/dBkkCw2n)          
             

I used various SQL functions such as :                               
✅ Case When Statements           
✅ CTE            
✅ Joins         
✅ Logical Operator              
✅ Group by, Order by, Where         
✅ Aggregate functions Sum, Count                
✅ Date functions Datepart , Datename, Datediff               
✅ Window functions(DENSE_RANK, LAG) 
                   
Some of the key insights are :
1) Allocate additional marketing resources and promotional campaigns to the top 5 cities to capitalize on their high spending patterns.
2) Plan targeted promotional offers or campaigns during the highest spending months for each card type to encourage increased spending.
3) Investigate the reasons behind the low spending in the identified city and consider targeted marketing strategies or partnerships to increase spending in that location.
4) Allocate additional staffing or resources in the city with the highest spend-to-transaction ratio during weekends to capitalize on increased spending opportunities.
5) Identify market potential and consider targeted marketing efforts in the city with the fastest transaction growth to capture new customers and increase business growth.
6) Develop specific product or service offerings targeted towards females based on their significant contribution to spending in specific expense categories.

## Order of execution of SQL queries

```
FROM – the database gets the data from tables in FROM clause and if necessary performs the JOINs,
WHERE – the data are filtered with conditions specified in WHERE clause,
GROUP BY – the data are grouped by with conditions specified in WHERE clause,
aggregate functions – the aggregate functions are applied to the groups created in the GROUP BY phase,
HAVING – the groups are filtered with the given condition,
window functions,
SELECT – the database selects the given columns,
DISTINCT – repeated values are removed,
UNION/INTERSECT/EXCEPT – the database applies set operations,
ORDER BY – the results are sorted,
OFFSET – the first rows are skipped,
LIMIT/FETCH/TOP – only the first rows are selected
```
