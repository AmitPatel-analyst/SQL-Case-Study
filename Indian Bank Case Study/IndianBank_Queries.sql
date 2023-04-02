/*****************************************************************************************
Name	: Code for INDIAN BANK DB
Author	: Amit Patel


Purpose: This script will create Db and few table in it to store info about INDIAN BANK
*****************************************************************************************/
create database INDIAN_BANK
go

USE INDIAN_BANK
GO

---create table ProductMaster 
create table ProductMaster
(
	PID			char(2)		Primary Key,
	ProductName	varchar(25)	not null	
)
go


--insert

insert into ProductMaster values('SB','Savings Bank')
insert into ProductMaster values('LA','Loan Account')
insert into ProductMaster values('FD','Fixed Deposit')
insert into ProductMaster values('RD','Recurring Deposit')


-- read the data
select * from ProductMaster
go

---create table RegionMaster 
create table RegionMaster
(
	RID			Int		Primary key,
	RegionName	Char(6)	not null
)
go

--insert

insert into RegionMaster values(1,'South')
insert into RegionMaster values(2,'North')
insert into RegionMaster values(3,'East')
insert into RegionMaster values(4,'West')
go

--read the data

select * from RegionMaster
go


---create table BranchMaster 
create table BranchMaster
(
	BRID			CHAR(3)			Primary Key,
	BranchName		VARCHAR(30)		NOT NULL,
	BranchAddress	VARCHAR(50)		NOT NULL,
	RID				INT				Foreign Key references RegionMaster(RID)
)
go

--insert

insert into BranchMaster values('BR1','Goa','Opp: KLM Mall, Panaji, Goa-677123',4)

insert into BranchMaster values('BR2','Hyd','Hitech city, Hitex, Hyd-500012',1)
insert into BranchMaster values('BR3','Delhi','Opp: Ambuja Mall, Sadar Bazar, Delhi-110006',2)

insert into BranchMaster values('BR4','Mumbai','Suman city, Hitex, Mumbai-490001',4)
insert into BranchMaster values('BR5','Nagpur','Opp: Aman Mall, Nagpur-677178',4)

insert into BranchMaster values('BR6','Raipur','Chetak city, Raipur-492001',3)
insert into BranchMaster values('BR7','Kolkata','Opp: Shyam Mall, Howrah, Kolkata-485177',3)

insert into BranchMaster values('BR8','Chennai','Sona city, Chennai-504212',1)
insert into BranchMaster values('BR9','Trichy','Eltronic city, Hitex, Trichy-400012',1)
go

-- read the data
select * from BranchMaster
go

---create table UserMaster 
create table UserMaster
(
	UserID		int			Primary Key,
	UserName	varchar(30)	not null,
	Designation	CHAR(1)		NOT NULL	CHECK(Designation in ('M', 'T', 'C', 'O'))

)
go
--insert

insert into UserMaster values(1,'Bhaskar Jogi','M')
insert into UserMaster values(2,'Amit','O')
insert into UserMaster values(3,'Hemanth','M')
insert into UserMaster values(4,'John K','C')
insert into UserMaster values(5,'Aman Pandey','T')
insert into UserMaster values(6,'Priyanko','C')
go
--read the data
select * from UserMaster
go

---create table AccountMaster 
create table AccountMaster
(	ACID		INT			PRIMARY KEY,
	NAME		VARCHAR(40)	NOT NULL,
	ADDRESS		VARCHAR(50)	NOT NULL,	
	BRID		CHAR(3)		NOT NULL	Foreign key references 	BranchMaster(BRID),
	PID			CHAR(2)		NOT NULL	Foreign key references 	ProductMaster(PID),
	DOO			DATETIME	NOT NULL,
	CBALANCE	MONEY		NULL,
	UBALANCE	MONEY		NULL,
	STATUS		CHAR(1)		NOT NULL	CHECK(STATUS in ('O','I','C'))
)
go

--insert
insert into AccountMaster values(101,'Amit Patel','USA','BR1','SB','2018/12/23',1000,1000,'O')
insert into AccountMaster values(102,'Ahmed Patel','Mumbai','BR3','SB','2018/12/27',2000,2000,'O')
insert into AccountMaster values(103,'Ramesh Jogi','Hyd','BR2','LA','2019/01/01',4000,2000,'O')
insert into AccountMaster values(104,'Nita Sahu','Pune','BR4','FD','2019/01/11',9000,9000,'C')
insert into AccountMaster values(105,'Venu G','Chennai','BR5','SB','2019/01/15',10000,10000,'I')
insert into AccountMaster values(106,'Shyam Verma','Patna','BR6','RD','2019/02/07',15000,15000,'O')
insert into AccountMaster values(107,'Shundar Lal','Nagpur','BR7','SB','2019/02/25',20000,20000,'O')
insert into AccountMaster values(108,'Ramesh K','Vizag','BR8','FD','2019/03/01',7000,7000,'C')
insert into AccountMaster values(109,'Jeni','UK','BR9','SB','2019/03/10',3000,3000,'O')

insert into AccountMaster values(110,'Shamlal sharma','Pune','BR1','FD','2019/03/11',5000,15000,'O')
insert into AccountMaster values(111,'Shundar KUMAR','Nagpur','BR2','SB','2019/03/15',2000,20000,'C')
insert into AccountMaster values(112,'Namesh K','Virar','BR2','SB','2019/03/16',2000,25000,'O')
insert into AccountMaster values(113,'JYOTI','SURAT','BR5','SB','2019/03/20',3000,13000,'O')

insert into AccountMaster values(114,'aman Verma','Puri','BR7','RD','2019/03/27',1000,12000,'I')
insert into AccountMaster values(115,'Skumar baghel','Nasik','BR9','SB','2019/03/28',2000,22000,'O')
insert into AccountMaster values(116,'Ranjit sahu','raipur','BR8','RD','2019/04/01',7250,12200,'O')
insert into AccountMaster values(117,'sanjana patel','baroda','BR4','SB','2019/04/05',35000,37000,'O')

insert into AccountMaster values(118,'amanlal sharma','raipur','BR3','LA','2019/04/11',15000,25000,'O')
insert into AccountMaster values(119,'PREM KUMAR','Nagpur','BR6','RD','2019/04/15',12000,17500,'I')
insert into AccountMaster values(120,'ESHWAR JAIN','VARANASI','BR5','LA','2019/04/16',20000,25000,'O')
insert into AccountMaster values(121,'JYOTIKA','SURAT','BR7','LA','2019/04/20',3000,13000,'I')

insert into AccountMaster values(122,'SUNDER Verma','PANIPAT','BR5','FD','2019/04/27',1000,12000,'I')
insert into AccountMaster values(123,'GITA baghel','Nasik','BR7','SB','2019/04/28',2000,22000,'O')
insert into AccountMaster values(124,'Ranjit SINGH','raipur','BR1','LA','2019/05/01',750,1200,'O')
insert into AccountMaster values(125,'NAYAN patel','baroda','BR1','SB','2019/04/05',3000,7000,'C')
insert into AccountMaster values(126,'Naina patel','baroda','BR4','SB','2019/04/15',3500,7000,'C')
go

--read the data
select * from AccountMaster
go

---create table TransactionMaster  
create table TxnMaster
(	TNO				int		Primary key Identity(1,1),
	DOT				datetime	not null,
	ACID			int			not null Foreign key references	AccountMaster(ACID),
	BRID			CHAR(3)		not null Foreign key references	BranchMaster(BRID),
	TXN_TYPE		CHAR(3)		NOT NULL	CHECK(TXN_TYPE in ('CW','CD','COD')),
	CHQ_NO			INT				NULL,
	CHQ_DATE		SMALLDATETIME	NULL,
	TXN_AMOUNT		MONEY		NOT NULL,
	UserID			int			not null Foreign key references	UserMaster(UserID)
)
go


--insert
insert into TxnMaster values('2019/1/12',101,'BR1','CD',NULL,NULL,1000,1)
insert into TxnMaster values('2019/1/12',102,'BR3','CD',NULL,NULL,4000,3)
insert into TxnMaster values('2019/1/15',102,'BR3','CW',NULL,NULL,2000,4)
insert into TxnMaster values('2019/2/01',101,'BR1','CD',NULL,NULL,5000,6)
insert into TxnMaster values('2019/2/10',103,'BR2','COD',2354,'2019/2/7',500,4)
insert into TxnMaster values('2019/2/15',104,'BR4','COD',1254,'2019/2/12',1500,2)
insert into TxnMaster values('2019/2/01',105,'BR5','CD',NULL,NULL,7000,1)
insert into TxnMaster values('2019/3/10',106,'BR6','COD',7374,'2019/3/7',1500,3)
insert into TxnMaster values('2019/3/18',106,'BR6','CW',NULL,NULL,6000,6)
insert into TxnMaster values('2019/3/25',107,'BR7','CW',NULL,NULL,7000,1)
insert into TxnMaster values('2019/3/30',107,'BR7','CD',NULL,NULL,6000,6)
insert into TxnMaster values('2019/4/01',108,'BR8','CD',NULL,NULL,16000,2)
insert into TxnMaster values('2019/4/11',109,'BR9','COD',7874,'2019/4/17',9000,4)
go

--read the data
select * from TxnMaster
go

