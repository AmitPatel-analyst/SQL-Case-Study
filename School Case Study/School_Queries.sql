/********************************************************************
Name	: Code for School DB
Author	: Amit Patel

Purpose: This script will create Db and few table in it to store info 
about school

**********************************************************************/

--DB
create database School
go
use School
go
--CourseMaster
create table CourseMaster
(
	CID		INT 		primary key,
	CourseName	Varchar(40)	not null,
	Category	char(1)       	null	check (Category = 'B' or Category = 'M' or Category = 'A'),
	Fee		smallmoney	not null	check (Fee > 0)

)
go
--schema of table
sp_help CourseMaster
go



-- insert the data
insert into CourseMaster values(10,'Java','B', 5000)
insert into CourseMaster values(20,'Adv Java','A', 25000)
insert into CourseMaster values(30,'Big Data','A', 40000)
insert into CourseMaster values(40,'Sql Server','M', 20000)

insert into CourseMaster values(50,'Oracle','M', 15000)
insert into CourseMaster values(60,'Phthon','M', 15000)
insert into CourseMaster values(70,'MSBI','A', 35000)
insert into CourseMaster values(80,'Data Science','A', 90000)

insert into CourseMaster values(90,'Data Analyst','A', 120000)
insert into CourseMaster values(100,'Machine Learning','A', 125000)
insert into CourseMaster values(110,'Basic C++','B', 10000)
insert into CourseMaster values(120,'Intermediate C++','M', 15000)
insert into CourseMaster values(130,'Dual C & c++','M', 20000)
insert into CourseMaster values(140,'Azure','B', 35000)
insert into CourseMaster values(150,'Microsoft Office Intermediate','B', 22000)

select * from CourseMaster
go           -- TOTAL 15 RECORDS

-- StudentMaster Table create
create table StudentMaster
(
	SID	TINYINT		  PRIMARY KEY,
	Name	Varchar(40)	not null,
	Origin	Char(1)		  not null	check (Origin = 'L' or Origin = 'F'),
	Type	Char(1)		  not null	check (Type = 'U' or Type = 'G')
)
go


--insert data
insert into StudentMaster values(1, 'Bilen Haile','F','G')
insert into StudentMaster values(2, 'Durga Prasad','L','U')
insert into StudentMaster values(3, 'Geni','F','U')
insert into StudentMaster values(4, 'Gopi Krishna','L','G')
insert into StudentMaster values(5, 'Hemanth','L','G')
insert into StudentMaster values(6, 'K Nitish','L','G')
insert into StudentMaster values(7, 'Amit','L','G')
insert into StudentMaster values(8, 'Aman','L','U')
insert into StudentMaster values(9, 'Halen','F','G')
insert into StudentMaster values(10, 'John','F','U')

insert into StudentMaster values(11, 'Anil','L','U')
insert into StudentMaster values(12, 'Mike','F','G')
insert into StudentMaster values(13, 'Suman','L','U')
insert into StudentMaster values(14, 'Angelina','F','G')
insert into StudentMaster values(15, 'Bhavik','L','U')
insert into StudentMaster values(16, 'Bob Tyson','F','G')
insert into StudentMaster values(17, 'Salman','L','U')
insert into StudentMaster values(18, 'Selina','F','G')
insert into StudentMaster values(19, 'Rajkummar','L','U')
insert into StudentMaster values(20, 'Pooja','L','U')


--Read the table data
select * from StudentMaster
go        -- TOTAL 20 RECORDS

-- EnrollmentMaster Table
create table EnrollmentMaster
(
	CID	INT	 not null foreign key References CourseMaster(CID),
	SID	TINYINT	 not null foreign key References StudentMaster(SID),
	DOE	Datetime not null,
	FWF	Bit	 not null,
	Grade	Char(1)	 null	check(Grade ='O' or Grade ='A' or Grade ='B' or Grade ='C')

	)
	go


--insert data
insert into EnrollmentMaster values(40,1,'2020/11/19',0 ,'O')
insert into EnrollmentMaster values(70,1,'2020/11/21',0 ,'O')
insert into EnrollmentMaster values(30,2,'2020/11/22',1 ,'A')
insert into EnrollmentMaster values(60,4,'2020/11/25',1 ,'O')
insert into EnrollmentMaster values(40,5,'2020/12/2',1 ,'C')
insert into EnrollmentMaster values(50,7,'2020/12/5',0 ,'B')
insert into EnrollmentMaster values(50,4,'2020/12/10',0 ,'A')
insert into EnrollmentMaster values(80,3,'2020/11/11',1 ,'O')
insert into EnrollmentMaster values(80,4,'2020/12/22',0 ,'B')
insert into EnrollmentMaster values(70,6,'2020/12/25',0 ,'A')
insert into EnrollmentMaster values(60,7,'2021/1/1',0 ,'A')
insert into EnrollmentMaster values(40,8,'2021/1/2',1 ,'O')
insert into EnrollmentMaster values(80,9,'2021/1/3',0 ,'B')
insert into EnrollmentMaster values(20,4,'2021/1/4',0 ,'A')
insert into EnrollmentMaster values(40,9,'2021/4/1',1 ,'O')
insert into EnrollmentMaster values(90,4,'2021/4/5',0 ,'A')
insert into EnrollmentMaster values(30,11,'2021/4/8',0 ,'A')
insert into EnrollmentMaster values(110,11,'2021/4/11',1 ,'B')
insert into EnrollmentMaster values(30,18,'2021/4/12',1 ,'A')
insert into EnrollmentMaster values(130,12,'2021/4/13',0 ,'B')
insert into EnrollmentMaster values(40,10,'2021/4/18',1 ,'O')
insert into EnrollmentMaster values(150,12,'2021/4/22',1 ,'A')
insert into EnrollmentMaster values(70,17,'2021/4/25',0 ,'B')
insert into EnrollmentMaster values(120,1,'2021/4/30',0 ,'O')
insert into EnrollmentMaster values(90,8,'2021/5/02',0 ,'A')
insert into EnrollmentMaster values(100,18,'2021/5/05',0 ,'B')
insert into EnrollmentMaster values(90,10,'2021/5/12',1 ,'O')
insert into EnrollmentMaster values(110,15,'2021/5/15',0 ,'B')
insert into EnrollmentMaster values(120,5,'2021/5/20',1 ,'A')
insert into EnrollmentMaster values(130,6,'2021/5/25',1 ,'O')
insert into EnrollmentMaster values(140,15,'2021/5/28',0 ,'A')
insert into EnrollmentMaster values(120,6,'2021/5/31',0 ,'B')
insert into EnrollmentMaster values(150,5,'2021/6/12',1 ,'A')
insert into EnrollmentMaster values(80,8,'2021/6/15',1 ,'B')
insert into EnrollmentMaster values(140,14,'2021/6/20',0 ,'O')
insert into EnrollmentMaster values(90,3,'2021/6/23',1 ,'O')
insert into EnrollmentMaster values(100,3,'2021/7/02',0 ,'A')
insert into EnrollmentMaster values(40,13,'2021/7/22',0 ,'B')
go

--Read the table data
select * from EnrollmentMaster
go     -- TOTAL 38 RECORDS

UPDATE EnrollmentMaster
SET DOE='2022-09-12'
WHERE DOE >'2021-05-01'

