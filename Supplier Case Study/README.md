### Supplier Case Study

1.	Create a DATABASE: SUPPLIER
### TABLES
CREATE THE FOLLOWING THREE TABLES WITH THE SAME NAMES AND DATA TYPES AS PROVIDED BELOW:

[Here are the scripts of these tables](https://github.com/AmitPatel-analyst/SQL-Case-Study/blob/main/Supplier%20Case%20Study/Supplier_Queries.sql)

#### SupplierMaster
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|SID	|Integer	|Primary Key
|NAME	|Varchar (40)	|NOT NULL 
|CITY	|Char(6)	|NOT NULL
|GRADE	|Tinyint	|NOT NULL ( 1 to 4)

#### PartMaster
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|PID	|TinyInt	|Primary Key
|NAME	|Varchar (40)	|NOT NULL
|PRICE	|Money	|NOT NULL
|CATEGORY	|Tinyint	|NOT NULL ( 1 to 3)
|QTYONHAND	|Integer	|NULL

#### SupplyDetails
|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|PID	|TinyInt	|Foreign Key
|SID	|Integer	|Foreign Key
|DATEOFSUPPLY	|DateTime	|NOT NULL
|CITY	|Varchar(40)	|NOT NULL
|QTYSUPPLIED	|Integer	|NOT NULL

Q.1. List the month-wise average supply of parts supplied for all parts. Provide the information only if the average is higher than 250.
```sql
SELECT	DATEPART(MM,DOS) AS MONTH_NO, 
        DATENAME(MM,DOS) AS MONTHS_NAME,	
        AVG(QTYSUPPLIED) AS AVG_QTYSUPPLIED
FROM    SUPLDETL
GROUP BY	DATENAME(MM,DOS), DATEPART(MM,DOS)
HAVING		AVG(QTYSUPPLIED) > 250
GO
```
![image](https://user-images.githubusercontent.com/120770473/229304684-dcfe381e-ef9d-4a49-9495-66756aea0ed9.png)

Q.2. List the names of the Suppliers who do not supply part with PID ‘1’.
```sql
SELECT DISTINCT NAME
FROM SUPPLIERMASTER
WHERE SID NOT IN (
					SELECT DISTINCT SID 
					FROM SUPLDETL
					WHERE PID = 1
					)
GO
```
![image](https://user-images.githubusercontent.com/120770473/229304795-a3f4299f-6f29-4db3-8454-4d85f83c7041.png)

Q.3. List the part id, name, price and difference between price and average price of all parts.
```sql
SELECT	PID,
        NAME,
        PRICE,
        PRICE - ( SELECT ROUND(AVG(PRICE),0) FROM PartMaster) AS DIFF
FROM PartMaster
GO
 ```
![image](https://user-images.githubusercontent.com/120770473/229305494-77660c4f-f67f-49af-ae3c-5973d2798907.png)

Q.4. List the names of the suppliers who have supplied at least Two parts where the quantity supplied is lower than 500.
```sql
SELECT	S.NAME , 
		COUNT(S.SID) AS #ofpartssupplied
FROM	SUPPLIERMASTER S JOIN SUPLDETL SD
		ON S.SID = SD.SID
		WHERE QTYSUPPLIED<500
		GROUP BY S.NAME	
HAVING	COUNT(S.SID) >=2
go
```
![image](https://user-images.githubusercontent.com/120770473/229305836-b96fb219-364e-4444-b298-56ac9890e546.png)

Q.5. List the names of the suppliers who live in a city where no supply has been made.
--		it means supplier iD should matched in both table but city should not be matched.
```sql
SELECT  DISTINCT NAME 
FROM  SUPPLIERMASTER AS SM
WHERE EXISTS ( SELECT *
                FROM SUPLDETL AS SD
                WHERE SM.SID=SD.SID AND SM.CITY<>SD.CITY
)
go
```
![image](https://user-images.githubusercontent.com/120770473/229305902-6d4123eb-d829-482e-9ef5-ba976a100816.png)

Q.6. List the names of the parts which have not been supplied in the month of May 2019.
```sql
SELECT  Name
FROM    PARTMASTER
WHERE   PID NOT IN (SELECT PID
                    FROM SUPLDETL
                     WHERE DATENAME(MM,DOS)='MAY' AND DATEPART(YY,DOS)=2019
)
go
```
![image](https://user-images.githubusercontent.com/120770473/229305947-a5ec8f7f-c6a6-4313-ac19-0681dd9d8577.png)

Q.7.  List name and Price category for all parts. Price category has to be displayed as “Cheap” 
--		if price is less than 200, “Medium” if the price is greater than or equal to 200 and less than 500,
--		and “Costly” if the price is greater than or equal to 500.
```sql
SELECT	NAME , 
        PRICE,
        CASE
          WHEN PRICE>=500 THEN 'COSTLY'
          WHEN PRICE <500 AND PRICE >=200 THEN 'MEDIUM'
        ELSE 'CHEAP'
        END AS PRICE_CATEGORY
FROM	PartMaster
go
```
![image](https://user-images.githubusercontent.com/120770473/229305996-c1975618-5d96-42fe-afc6-cc9edf3c3747.png)

Q.8. List the names of the suppliers who have supplied exactly 100 units of part P16.
```sql
SELECT  NAME , SID
FROM  SUPPLIERMASTER
WHERE SID IN (SELECT SID
              FROM SUPLDETL
              WHERE [QTYSUPPLIED] =100 AND PID = 16
)
go
```
![image](https://user-images.githubusercontent.com/120770473/229306114-024d78d6-6e8e-4a18-80c0-00bcb7b3d579.png)
  
Q.9. List the names of the parts whose price is more than the average price of parts.
```sql  
with AvgPrice
as
(select round(avg(Price),0) as AvgPrice 
from PartMaster)

select p.Name,p.Price,a.AvgPrice from PartMaster p 
left join AvgPrice a on p.Price>a.AvgPrice where a.AvgPrice is not null;
```
![image](https://user-images.githubusercontent.com/120770473/229306692-592dc733-3fe6-4dfd-8dd9-5a1cc96abc00.png)

Q.10. For all products supplied by Supplier S70, List the part name and total quantity SUPPLIED.
```sql 
SELECT	NAME AS PNAME,
		QTYSUPPLIED 
				FROM 	
					(   SELECT DISTINCT PID, SID , QTYSUPPLIED
						FROM SupLDETL
						WHERE SID = 70
					)	AS K  
					JOIN PARTMASTER AS PM 
					ON K.PID=PM.PID
         ;
```
![image](https://user-images.githubusercontent.com/120770473/229306743-b81328fa-5bac-413d-832d-138d98a32231.png)

Click [Here](https://github.com/AmitPatel-analyst/SQL-Case-Study/tree/main) to move back to my another case study repositories! 
