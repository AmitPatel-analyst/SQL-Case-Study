### School Case Study

1.	Create a DATABASE: SCHOOL
### TABLES
CREATE THE FOLLOWING THREE TABLES WITH SAME NAMES AND DATA TYPES AS PROVIDED BELOW:

[Here are the scripts of these tables](https://github.com/AmitPatel-analyst/SQL-Case-Study/blob/main/School%20Case%20Study/School_Queries.sql)
#### CourseMaster

|Column Name |	Data Type	 | Remarks |
|------------|-------------|---------|
|CID	       |   Integer	 | Primary Key
|CourseName	 |  Varchar(40)|	NOT NULL 
|Category	   |  Char(1)	   | NULL, Basic/Medium/Advanced
|Fee	       | Smallmoney	 | NOT NULL; Fee can’t be negative

#### StudentMaster

|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|SID	|TinyInt	|Primary Key
|StudentName	|Varchar(40)	|NOT NULL
|Origin	|Char(1)	|NOT NULL, Local/Foreign
|Type	|Char(1)	|NOT NULL, UnderGraduate/Graduate

#### EnrollmentMaster 

|Column Name 	|Data Type	|Remarks|
|-------------|-----------|-------|
|CID	|Integer	|NOT NULL Foreign Key
|SID	|Tinyint	|NOT NULL Foreign Key
|DOE	|DateTime	|NOT NULL
|FWF (Fee Waiver Flag)	|Bit	|NOT NULL
|Grade	|Char(1)	|O/A/B/C

Q.1. List the names of the Students who have not enrolled for Java course.
```sql
SELECT NAME 
FROM StudentMaster
WHERE SID in (
			SELECT DISTINCT SID 
			FROM EnrollmentMaster
			WHERE CID not in (
								SELECT DISTINCT CID
								FROM CourseMaster
								WHERE CourseName = 'JAVA'
								)
				)
```
![image](https://user-images.githubusercontent.com/120770473/228857023-3d241278-be9a-43ff-9f2b-c5c31432fd66.png)

Q.2. List the name of the advanced course where the enrollment by foreign students is the highest.
```sql
with cte 
as (
	SELECT CourseName,COUNT(*) AS CNT
	FROM CourseMaster AS CM
	JOIN EnrollmentMaster AS EM
	ON CM.CID=EM.CID
	JOIN StudentMaster AS SM
	ON SM.SID=EM.SID
	WHERE Category='A' AND ORIGIN = 'F'
	GROUP BY CourseName
	)
	select CourseName
	from cte
	where CNT = (select max(cnt) from cte)
	go
```
![image](https://user-images.githubusercontent.com/120770473/229302096-f2323ad1-f9bd-4858-8420-04307118c1ca.png)

Q.3. List the names of the Undergraduate, local students who have got a “B” grade in any basic course.

```sql
SELECT 	Name
FROM 	EnrollmentMaster as em
join 	StudentMaster as sm
on 	sm.SID=em.sid
join 	CourseMaster as cm
on 	cm.CID=em.cid
WHERE 	Type = 'U' and Origin = 'L' and Grade = 'B'
```
![image](https://user-images.githubusercontent.com/120770473/229302279-7883c325-e554-4fc5-8f59-b6271f4475de.png)

Q.4. List the names of the courses for which no student has enrolled in the month of SEPT 2022.

```sql
SELECT	CM.CID , CM.COURSENAME
FROM 	COURSEMASTER AS CM
LEFT JOIN (	
		SELECT DISTINCT CM.CID , COURSENAME
		FROM 	ENROLLMENTMASTER AS EM
		JOIN 	STUDENTMASTER AS SM
		ON 	SM.SID=EM.SID
		JOIN 	COURSEMASTER AS CM
		ON 	CM.CID=EM.CID
		WHERE 	DATENAME(MM,DOE) = 'SEPTEMBER' AND DATEPART(YY,DOE) = 2022
		) AS NEWT
ON NEWT.CID = CM.CID
WHERE NEWT.CID IS NULL
go
```
![image](https://user-images.githubusercontent.com/120770473/229302409-b939ddc3-c842-454c-9dcc-31fc25a7a2c4.png)

Q.5. List name, Number of Enrollments and Popularity for all Courses. 
	Popularity has to be displayed as “High” if number of enrollments is higher than 5,  
	“Medium” if greater than or equal to 3 and less than or equal to 5, and “Low” if the no. is less than 3.

```sql
SELECT [COURSENAME] , COUNT(*) AS #ofenrolls,
CASE
	WHEN COUNT(*) >5 THEN 'HIGH'
	WHEN COUNT(*) BETWEEN 3 AND 5 THEN 'MEDIUM'
	ELSE 'LOW'
	END AS POPULARITY
FROM COURSEMASTER AS CM JOIN ENROLLMENTMASTER AS EM ON CM.CID=EM.CID
GROUP BY COURSENAME
go
```
![image](https://user-images.githubusercontent.com/120770473/229302549-67b36348-8688-4a06-8660-7894beeed337.png)

Q.6. List the names of the Local students who have enrolled for exactly 2 basic courses. 

```sql
SELECT SM.NAME , COUNT(*) AS CourseEnrolled
FROM 	STUDENTMASTER AS SM 
JOIN 	ENROLLMENTMASTER AS EM
ON 	SM.SID=EM.SID
JOIN 	COURSEMASTER AS CM
ON 	CM.CID=EM.CID
WHERE 	ORIGIN = 'L' AND CATEGORY = 'B'
GROUP BY SM.NAME
HAVING COUNT(*) = 2
go
```
![image](https://user-images.githubusercontent.com/120770473/229302706-e95a964e-0c54-4d79-b5e2-ac9f0d51af21.png)

Q.7. List the names of the Courses enrolled by all (every) students.

```sql
SELECT 	DISTINCT CourseName
FROM 	CourseMaster AS CM
LEFT JOIN ENROLLMENTMASTER AS EM
ON 	CM.CID = EM.CID
WHERE 	EM.CID IS NOT NULL
go
```
![image](https://user-images.githubusercontent.com/120770473/229302846-6c393b3a-39c7-41fc-a839-8a36fdb11da4.png)

Q.8. For those enrollments for which fee have been waived, when fwf = 1 means yes ,provide the names of students who have got ‘O’ grade.

```sql
SELECT	NAME as studentname, SID
FROM 	STUDENTMASTER 
WHERE 	SID IN	(SELECT DISTINCT SID
		FROM ENROLLMENTMASTER
		WHERE FWF = 1 AND GRADE = 'O'
		)
	go
```
![image](https://user-images.githubusercontent.com/120770473/229303079-dac9ca63-9f82-44f4-8f11-d9537a9be522.png)

Q.9. List the names of the foreign, undergraduate students who have got grade ‘O’ in any Advanced course.

```sql
SELECT 	sm.SID , sm.Name as [Student Name]
from 	StudentMaster as sm 
join 	EnrollmentMaster as em
on 	sm.SID=em.sid
join 	CourseMaster as cm
on 	cm.CID=em.cid
where 	Origin='F' and Type = 'U' and grade = 'o' and Category = 'A'
go
```
![image](https://user-images.githubusercontent.com/120770473/229303299-e68c13c7-49a0-4778-84c7-f78074a4a663.png)

Q.10. List the course name, total no. of enrollments in the month of April 2021.

```sql
SELECT 	COURSENAME , #ofenrolls
FROM 	COURSEMASTER AS CM
JOIN 
	(SELECT CID, COUNT(*) AS #ofenrolls
	 FROM 	ENROLLMENTMASTER 
	WHERE 	MONTH(DOE) =4 AND YEAR(DOE) = 2021
	GROUP BY CID) AS K
ON 	K.CID=CM.CID
order by CourseName
go
```
![image](https://user-images.githubusercontent.com/120770473/229303691-cf27b9a1-9fa9-4efe-bb0e-b3c0872b715f.png)



