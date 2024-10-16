# <p align="center" style="margin-top: 0px;">  **`OYO business`**
# <p align="center" style="margin-top: 0px;"> ![Oyo1](https://github.com/AmitPatel-analyst/SQL-Case-Study/assets/120770473/1796bf70-d14d-4295-ae5b-018f0f14fa80)
This repository hosts the solutions for Oyo business room sales analysis.        
I used various SQL functions such as :          
✅ Case When Statements           
✅ CTE           
✅ Joins           
✅ Logical Operator          
✅ Group by, Order by, Where         
✅ Aggregate functions Sum, Count, Average                
✅ Date functions Datename, Datediff, Month           

Database Used - Microsoft SQL Server           
Insights:-

1. Banglore , gurgaon & delhi were popular in the bookings, whereas Kolkata is less popular in bookings
2. Nature of Bookings:         
       
• Nearly 50 % of the bookings were made on the day of check in only.       
• Nearly 85 % of the bookings were made with less than 4 days prior to the date of check in.    
• Very few no.of bookings were made in advance(i.e over a 1 month or 2 months).      
• Most of the bookings involved only a single room.    
• Nearly 80% of the bookings involved a stay of 1 night only.     
           
3. Oyo should acquire more hotels in the cities of Pune, Kolkata & Mumbai. Because their average room rates are comparetively higher so more revenue will come.         
     
4. The % cancellation Rate is high on all 9 cities except pune , so Oyo should focus on finding reasons about cancellation.    
        
***
## Case Study Solutions
Click [here](https://github.com/AmitPatel-analyst/SQL-Case-Study/blob/main/OYO%20business%20case%20study/SqlCode_OYO_business.sql)

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
