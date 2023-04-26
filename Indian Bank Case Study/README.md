### IndianBank Case Study

1.	Create a DATABASE: Ibank
### TABLES
CREATE THE FOLLOWING TABLES WITH SAME NAMES AND DATA TYPES AS PROVIDED BELOW:
Tips : First create only Those tables and insert data who has a Primary column , after that create other Foriegn key Col Tables.
[Here are the scripts of these tables](https://github.com/AmitPatel-analyst/SQL-Case-Study/blob/main/Indian%20Bank%20Case%20Study/IndianBank_Queries.sql)
#### ProductMaster
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|PID	|CHAR(2)	|Primary Key
|PRODUCT NAME	|VARCHAR(25)	|NULL not allowed

#### RegionMaster 
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|RID	|INTEGER	|Primary Key|
|REGION NAME	|CHAR(6)	|NOT NULL|

#### BranchMaster 
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|BRID	|CHAR(3)	|Primary Key
|BRANCH NAME	|VARCHAR(30)	|NOT NULL
|BRANCH ADDRESS	|VARCHAR(50)	|NOT NULL
|RID	|INT	|Foreign Key; NOT NULL

#### UserMaster 
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|USERID	|INTEGER	|Primary Key
|USER NAME	|VARCHAR(30)	|NOT NULL
|DESIGNATION	|CHAR(1)	|‘M’ for ‘MANAGER’, ‘T’ for ‘TELLER’, ‘C’ for ‘CLERK’, ‘O’ for ‘OFFICER’; NOT NULL.

#### AccountMaster
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|ACID	|INTEGER	|Primary Key
|NAME	|VARCHAR(40)	|NOT NULL 
|ADDRESS	|VARCHAR(50)	|NOT NULL
|BRID	|CHAR(3)	|NOT NULL, Foreign Key
|PID	|CHAR(2)	|Foreign Key; NOT NULL
|DATE OF OPENING	|DATETIME	|NOT NULL
|CLEAR BALANCE	|MONEY	|NULL ALLOWED
|UNCLEAR BALANCE	|MONEY	|NULL ALLOWED
|STATUS	|CHAR(1)	|‘O’ for ‘OPERATIVE’,     ‘I’ for ‘INOPERATIVE’, ‘C’ for ‘CLOSED’; NOT NULL; DEFAULT value is ‘O’ (OPERATIVE)

#### TransactionMaster
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|--------|
|TRANSACTION NUMBER	|INTEGER(4)	|Primary Key; Identity, seed=1, Increment=1; 
|DATE OF TRANSACTION	|DATETIME	|NOT NULL
|ACID	|INTEGER	|Foreign Key; NOT NULL
|BRID	|CHAR(3)	|Foreign Key; NOT NULL
|TXN_TYPE	|CHAR(3)	|‘CW’ for ‘CASH WITHDRAWAL’, ‘CD’ for ‘CASH DEPOSIT’, ‘CQD’ for ‘CHEQUE DEPOSIT’; NOT NULL 
|CHQ_NO	|INTEGER	|NULL ALLOWED
|CHQ_DATE	|SMALLDATETIME	|NULL ALLOWED
|TXN_AMOUNT	|MONEY	|NOT NULL
|USERID	|INTEGER	|Foreign Key; NOT NULL

Q.1. List the names of the account holders with corresponding branch names,	in respect of the second-highest maximum and minimum Cleared balance
```sql
SELECT  NAME , BranchName ,CBALANCE
FROM    AccountMaster AS A
JOIN    BranchMaster AS B
ON      A.BRID=B.BRID
WHERE   CBALANCE IN (SELECT CBALANCE
                    FROM (SELECT CBALANCE , ROW_NUMBER() OVER(ORDER BY CBALANCE DESC) AS RNK
                          FROM AccountMaster) AS T
                          WHERE RNK = 2 
                    UNION 
                    SELECT MIN(CBALANCE) FROM AccountMaster ) ;
 ```
 ![image](https://user-images.githubusercontent.com/120770473/229336554-ca5dde9a-9334-458c-9818-affac2deb437.png)

Q.2. Give the TransactionType-wise, branch-wise, total amount for the day.
```sql
SELECT	TXN_TYPE,BRID, SUM([TXN_AMOUNT]) AS TOTAL_AMT
FROM    TxnMaster
GROUP BY TXN_TYPE,BRID
```
![image](https://user-images.githubusercontent.com/120770473/229336604-81894552-616a-46c1-b73c-f3b15b860e95.png)

Q.3. List the product having the maximum number of accounts
```sql
SELECT  ProductName,MAX_NO_OF_ACCOUNTS
FROM  ProductMaster AS P
JOIN (SELECT PID,COUNT(ACID) AS MAX_NO_OF_ACCOUNTS
      FROM AccountMaster
GROUP BY PID ) AS L
ON  P.PID=L.PID;
```
![image](https://user-images.githubusercontent.com/120770473/229336685-1f8b4c89-1280-43e4-bce6-0fab59518d59.png)

Q.4 List the names of the account holders and the number of transactions put thru by them, in a given day ( 2022-05-12 )
```sql
SELECT  A.NAME, NOOFTXN
FROM (
      SELECT ACID,COUNT(DOT) AS NOOFTXN
      FROM TXNMASTER 
      WHERE DOT = '2022-05-12'
GROUP BY ACID
) AS T
JOIN  ACCOUNTMASTER AS A ON T.ACID=A.ACID;
```
![image](https://user-images.githubusercontent.com/120770473/229336773-7bb2eba5-bf25-40af-a494-2c1215398053.png)

Q.5. List the number of transactions that have been authorized by the Manager so far today
```sql
SELECT COUNT(*) AS NO_OF_TXNS
FROM TxnMaster
WHERE UserID IN (1,3);
```
![image](https://user-images.githubusercontent.com/120770473/229337103-b86d825f-8007-45e3-8142-01544bf4fb43.png)

Q.6 Provide the following information from the ‘Account Master’ table:   
a) Product-wise, month-wise, number of accounts   
b) Total number of accounts for each product   
c) Total number of accounts for each month   
d) Total number of accounts in our bank   

		
```sql
SELECT PID,DATENAME(MM,DOO) AS MONTH_NM ,count(distinct ACID) as Nos_acc
FROM ACCOUNTMASTER
GROUP BY PID,DATEPART(MM,DOO),DATENAME(MM,DOO)
ORDER BY DATEPART(MM,DOO)

SELECT PID ,COUNT(ACID) AS NOS_ACC
FROM ACCOUNTMASTER
GROUP BY PID

SELECT DATENAME(MM,DOO) AS MONTH_NM ,count(ACID) as Nos_acc
FROM ACCOUNTMASTER
GROUP BY DATEPART(MM,DOO),DATENAME(MM,DOO)
ORDER BY DATEPART(MM,DOO)

SELECT COUNT(*) AS NOS_ACC_in_bank
FROM ACCOUNTMASTER
```
![image](https://user-images.githubusercontent.com/120770473/229337585-8fa10798-0ba0-44d6-8fff-cf22b8cfeec7.png)
![image](https://user-images.githubusercontent.com/120770473/229337596-62cd8b85-2588-4425-b525-8a39430d6e1f.png)
![image](https://user-images.githubusercontent.com/120770473/229337615-13afb294-1498-4241-8151-b3d133a5cb6d.png)
![image](https://user-images.githubusercontent.com/120770473/229337629-122a3592-aab6-4a4c-9029-d64f4fbbecd9.png)

