### School Case Study

1.	Create a DATABASE: SCHOOL
### TABLES
CREATE THE FOLLOWING THREE TABLES WITH SAME NAMES AND DATA TYPES AS PROVIDED BELOW:
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
