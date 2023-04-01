/*****************************************************************************************
Name	: Code for Supplier DB
Author	: Amit Patel
Date	: Aug 21, 2022

Purpose: This script will create Db and few table in it to store info  about supplier
*****************************************************************************************/
create database Supplier
go

use Supplier
go

--SupplierMaster create table
create table SupplierMaster
(
	SID		Int			Primary Key,
	Name	Varchar(40)		not null,
	City	Char(20)		not null,
	Grade	Tinyint			not null	check(Grade	> 0 and Grade < 5)
)
go

-- Get the schema of the table
sp_help SupplierMaster
go

-- insert the data 
insert into SupplierMaster values(10,'Usman Khan','Delhi',1)
insert into SupplierMaster values(20,'Nitish K','Kanpur',2)
insert into SupplierMaster values(30,'Shiva','Mumbai',2)
insert into SupplierMaster values(40,'Simran','Raipur',3)
insert into SupplierMaster values(50,'Srikanth','HYD',4)
insert into SupplierMaster values(60,'Neeraj','Delhi',1)

insert into SupplierMaster values(70,'Hament','Delhi',4)
insert into SupplierMaster values(80,'SKumar','Surat',2)
insert into SupplierMaster values(90,'Sanjay','Nagpur',1)
insert into SupplierMaster values(100,'Amit','Kanpur',3)
insert into SupplierMaster values(110,'Animesh','Bhopal',3)
insert into SupplierMaster values(120,'Gaurav','Chennai',1)

insert into SupplierMaster values(130,'Hilay','Rajkot',4)
insert into SupplierMaster values(140,'Bhavik','Durgapur',4)
insert into SupplierMaster values(150,'Shyamlal','Dehradun',2)
insert into SupplierMaster values(160,'Anamika','Roorkee',3)
insert into SupplierMaster values(170,'harpreet','Madras',2)
insert into SupplierMaster values(180,'Venugopal','Mumbai',1)

insert into SupplierMaster values(190,'Hament','Mumbai',1)
insert into SupplierMaster values(200,'SKumar','Madras',4)
insert into SupplierMaster values(210,'Sanjay','Dehradun',2)
insert into SupplierMaster values(220,'Amit','Durgapur',3)
insert into SupplierMaster values(230,'Animesh','Delhi',1)
insert into SupplierMaster values(240,'Gaurav','Delhi',4)
go

--read the data
select *  from SupplierMaster
go        --  TOTAL 24 RECORDS

---PartMaster

create table PartMaster
(	PID			Tinyint		Primary Key,
	Name		Varchar(40)	not null,	
	Price		Money		not null,
	Category	Tinyint		not null, --- Category 1,2,3
	QtyOnHand	Int			null,
	
)
go

-- Insert

insert into	PartMaster values(1,'Lights',1000,1,1200)
insert into	PartMaster values(2,'Batteries',5600,1,500)
insert into	PartMaster values(3,'Engines',67000,2,4000)
insert into	PartMaster values(4,'Tyres',2400,3,5000)
insert into	PartMaster values(5,'Tubes',700,3,7800)
insert into	PartMaster values(6,'Screws',15,2,2000)
insert into	PartMaster values(7,'Mirrors',1000,1,400)
insert into	PartMaster values(8,'Clutches',1500,3,1000)

insert into	PartMaster values(9,'Bolts',400,1,12000)
insert into	PartMaster values(10,'Nuts',200,1,25000)
insert into	PartMaster values(11,'Washers',300,2,4000)
insert into	PartMaster values(12,'Gaskets',2400,3,5000)
insert into	PartMaster values(13,'Hammers',2000,2,1800)
insert into	PartMaster values(14,'Bedsheets',150,1,2200)
insert into	PartMaster values(15,'Blankets',350,1,850)
insert into	PartMaster values(16,'Windscreens',1800,3,350)
go

--read the data
select * from PartMaster
go   -- -- TOTAL 16 RECORDS

---SupplyDetails
create table SuplDetl
(
	PID				Tinyint		not null	Foreign Key references PartMaster(PID),
	SID				Int			not null	Foreign Key references SupplierMaster(SID),
	DOS				DateTime	not null,
	CITY			Varchar(40)	not null,
	QTYSUPPLIED		Int			not null
)
go

--insert data
insert into SuplDetl values(2,30,'2019/5/21','Delhi',45)
insert into SuplDetl values(3,60,'2019/6/25','Mumbai',80)
insert into SuplDetl values(1,40,'2019/6/30','Mumbai',120)
insert into SuplDetl values(5,10,'2019/7/02','Delhi',45)
insert into SuplDetl values(2,30,'2019/7/10','Kanpur',50)
insert into SuplDetl values(4,50,'2019/7/11','HYD',150)

insert into SuplDetl values(11,20,'2020/5/21','Bhopal',85)
insert into SuplDetl values(13,70,'2020/6/15','Chennai',100)
insert into SuplDetl values(11,20,'2020/6/10','Dehradun',110)
insert into SuplDetl values(15,50,'2022/7/02','Dehradun',50)
insert into SuplDetl values(12,40,'2022/7/10','HYD',250)
insert into SuplDetl values(14,30,'2022/7/11','Bhopal',450)

insert into SuplDetl values(16,30,'2022/9/1','Bhopal',155)
insert into SuplDetl values(3,60,'2022/9/5','Madras',180)
insert into SuplDetl values(1,40,'2021/6/30','HYD',200)
insert into SuplDetl values(5,10,'2022/7/02','Delhi',255)
insert into SuplDetl values(12,30,'2022/7/10','Kanpur',350)
insert into SuplDetl values(8,50,'2019/11/11','HYD',185)

insert into SuplDetl values(6,70,'2021/5/21','Rajkot',150)
insert into SuplDetl values(10,100,'2022/6/25','Roorkee',600)
insert into SuplDetl values(8,80,'2022/7/30','Surat',720)
insert into SuplDetl values(7,90,'2020/7/02','Mumbai',450)
insert into SuplDetl values(9,110,'2020/7/10','Nagpur',350)
insert into SuplDetl values(10,150,'2020/7/11','Madras',225)

insert into SuplDetl values(6,70,'2022/5/21','Chennai',150)
insert into SuplDetl values(10,100,'2022/5/15','HYD',600)
insert into SuplDetl values(8,80,'2022/6/13','Nagpur',720)
insert into SuplDetl values(7,90,'2022/7/12','Dehradun',450)
insert into SuplDetl values(9,110,'2022/7/11','Bhopal',350)
insert into SuplDetl values(10,150,'2022/8/15','HYD',225)

insert into SuplDetl values(16,70,'2019/4/11','Chennai',100)
insert into SuplDetl values(1,100,'2021/8/20','HYD',700)
insert into SuplDetl values(12,80,'2020/4/15','Nagpur',740)
insert into SuplDetl values(17,90,'2020/6/01','Dehradun',400)
insert into SuplDetl values(11,110,'2020/6/05','Bhopal',300)
insert into SuplDetl values(10,150,'2021/8/05','HYD',160)
go

--read the data
select * from SuplDetl
go   -- TOTAL 35 RECORDS
