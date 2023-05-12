--Questions

1. What are the names of all the customers who live in New York?
2. What is the total number of accounts in the Accounts table?
3. What is the total balance of all checking accounts?
4. What is the total balance of all accounts associated with customers who live in Los Angeles?
5. Which branch has the highest average account balance?
6. Which customer has the highest current balance in their accounts?
7. Which customer has made the most transactions in the Transactions table?
8.Which branch has the highest total balance across all of its accounts?
9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?
10. Which branch has the highest number of transactions in the Transactions table?


1. What are the names of all the customers who live in New York?

SELECT
  concat(concat(firstName, ' '), Lastname) AS Customer , City
FROM customers
WHERE city = 'New York';

2. What is the total number of accounts in the Accounts table?

SELECT
  COUNT(accountid) AS No_of_accounts
FROM accounts;

3. What is the total balance of all checking accounts?

SELECT
  SUM(Balance) AS Total_balance
FROM accounts
WHERE accounttype = 'Checking';

4. What is the total balance of all accounts associated with customers who live in Los Angeles?

SELECT
  A.CustomerId,
  SUM(A.Balance) AS Total_Balance
FROM accounts AS A
WHERE CustomerID IN (SELECT
  C.CustomerId
FROM customers AS C
INNER JOIN accounts AS A
  ON A.CustomerID = C.CustomerID
WHERE C.City = 'Los Angeles')
GROUP BY A.CustomerId;

5. Which branch has the highest average account balance?

WITH AVG_BALANCE
AS (SELECT
  BRANCHID,
  AVG(BALANCE) AS AVG_BAL
FROM ACCOUNTS
GROUP BY BRANCHID)
SELECT
  B.*,
  A.AVG_BAL
FROM AVG_BALANCE AS A
LEFT JOIN BRANCHES AS B
  ON A.BRANCHID = B.BRANCHID
WHERE A.AVG_BAL = (SELECT
  MAX(AVG_BAL)
FROM AVG_BALANCE);

7. Which customer has made the most transactions in the Transactions table?

Approch - 1 (Cte and joins)
WITH NO_OF_TRANSACTIONS
AS (SELECT
  T.ACCOUNTID,
  COUNT(TRANSACTIONDATE) AS CNT
FROM transactions T
INNER JOIN accounts A
  ON A.ACCOUNTID = T.ACCOUNTID
GROUP BY T.ACCOUNTID),
CUSTOMER_INFO
AS (SELECT DISTINCT
  A.CUSTOMERID,
  CONCAT(CONCAT(B.FIRSTNAME, ' '), B.LASTNAME) AS CUSTOMERNAME
FROM NO_OF_TRANSACTIONS AS C
INNER JOIN accounts AS A
  ON A.ACCOUNTID = C.ACCOUNTID
INNER JOIN customers AS B
  ON B.CUSTOMERID = A.CUSTOMERID
WHERE CNT = (SELECT
  MAX(CNT)
FROM NO_OF_TRANSACTIONS))
SELECT *
FROM CUSTOMER_INFO;

-- OR Approach-2 (Subquery and joins)

SELECT DISTINCT A.CUSTOMERID
FROM transactions T
INNER JOIN accounts A ON A.ACCOUNTID = T.ACCOUNTID
WHERE T.ACCOUNTID IN (
    SELECT ACCOUNTID
    FROM (
        SELECT T.ACCOUNTID, COUNT(TRANSACTIONDATE) AS CNT 
        FROM transactions T
        INNER JOIN accounts A ON A.ACCOUNTID = T.ACCOUNTID
        GROUP BY T.ACCOUNTID
    ) subquery
    WHERE CNT = (
        SELECT MAX(CNT) 
        FROM (
            SELECT T.ACCOUNTID, COUNT(TRANSACTIONDATE) AS CNT 
            FROM transactions T
            INNER JOIN accounts A ON A.ACCOUNTID = T.ACCOUNTID
            GROUP BY T.ACCOUNTID
        ) subquery2
    )
)


8.Which branch has the highest total balance across all of its accounts?

WITH TOTAL_BALANCE
AS (SELECT
  BRANCHID,
  SUM(BALANCE) AS SUM_BAL
FROM ACCOUNTS
GROUP BY BRANCHID)
SELECT
  B.*,
  A.SUM_BAL
FROM TOTAL_BALANCE AS A
LEFT JOIN BRANCHES AS B
  ON A.BRANCHID = B.BRANCHID
WHERE A.SUM_BAL = (SELECT
  MAX(SUM_BAL)
FROM TOTAL_BALANCE);

9. Which customer has the highest total balance across all of their accounts, including savings and checking accounts?

WITH TOTAL_BALANCE
AS (SELECT
  CUSTOMERID,
  SUM(BALANCE) AS SUM_BAL
FROM ACCOUNTS
GROUP BY CUSTOMERID)

SELECT
  C.*
FROM TOTAL_BALANCE AS A
INNER JOIN CUSTOMERS AS C
  ON A.CUSTOMERID = C.CUSTOMERID
WHERE A.SUM_BAL = (SELECT
  MAX(SUM_BAL)
FROM TOTAL_BALANCE);


10. Which branch has the highest number of transactions in the Transactions table?

WITH NO_OF_TRANSACTIONS
AS (SELECT
  T.ACCOUNTID,
  COUNT(TRANSACTIONDATE) AS CNT
FROM transactions T
INNER JOIN accounts A
  ON A.ACCOUNTID = T.ACCOUNTID
GROUP BY T.ACCOUNTID),
BRANCH_INFO
AS (SELECT DISTINCT
  A.BRANCHID,
  B.BRANCHNAME,
  B.CITY
FROM NO_OF_TRANSACTIONS AS C
INNER JOIN accounts AS A
  ON A.ACCOUNTID = C.ACCOUNTID
INNER JOIN BRANCHES AS B
  ON B.BRANCHID = A.BRANCHID
WHERE CNT = (SELECT
  MAX(CNT)
FROM NO_OF_TRANSACTIONS))
SELECT *
FROM BRANCH_INFO;
