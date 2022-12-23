-- Case Study - SQL Murder Mystery 
-- Credits - The SQL Murder Mystery was created by Joon Park and Cathy He 
/*	A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. 
	You vaguely remember that the crime was a ​murder​ that occurred sometime on ​Jan 15, 2018​ and that it took place in ​SQL City​. Start by retrieving the corresponding crime scene report from the police department’s database.
	so, my first step to solving the mystery is to retrieve the corresponding crime scene report from the police department’s database. 
*/

select * from [Crime Scene]
where Type = 'murder' and cast(Date as date) ='2018-01-15' and City='sql city';

/* I got an information that said Security footage shows that there were 2 witnesses. 
The first witness lives at the last house on "Northwestern Dr". and 
The second witness, named Annabel, lives somewhere on "Franklin Ave".
*/
/* so i have to look for another table to locate these two addresses where these two witness lives
so now i have retrieved the corresponding person report from the police department’s database.*/ 

select top 1 *
from Person
where Address_Street_Name = 'Northwestern Dr'
order by Address_Number desc;

/* first witness name is Morty Schapiro .
	his license_id is 118009.
	his Personel id is 14887.
*/

select *
from Person
where Address_Street_Name = 'Franklin Ave'
and name like 'Annabel%'

/* Second witness name is Annabel Miller .
	his license_id is 490173.
	his Personel id is 16371.
Now we have to find what both had said about the Crime which was happend there */

select *
from Interviews
where Person_Id in (16371,14887);
/*	Morty Schapiro said I heard a gunshot and then saw a man run out. 
	He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". 
	Only gold members have those bags. The man got into a car with a plate that included "H42W".
	and Annabel Miller said I saw the murder happen, and I recognized the killer from my gym 
	when I was working out last week on January the 9th.
 */
 select *
from [GetFitNow check in]
where Membership_Id like '48Z%' and Check_In_Date ='2018-01-09'
/*	As per Annabel Miller said ,on date jan 9th 2018 she saw the killer face on his gym 
	and his membership_id starts with '48Z', so i have to look his membership_id from the "GetFitNow check in" table as per clue.
	I got two membership_id 48Z7A and 48Z55. So i have to find those two person name from the "GetFitNow members" table.
*/


select *
from [GetFitNow members]
where Membership_Status = 'Gold' and Id in('48Z7A' ,'48Z55');
/* these two people (Joe Germuska and Jeremy Bowers) check-in on jan 9th 2018 as per annabel miller's clue.
Now i have to search Who is the Main Person who's did murder ,so now retrieve the data from the driver license table
try to filter the data by plate number that included "H42W"
*/

select	p.Name,p.License_Id,k.Plate_Number
		from Person as p join
					(select * 
					 	from [Drivers license] 
						where [Plate_Number] like '%H42W%') as k
				 on p.License_Id=k.Id;

-- So we knew that the MasterMind person who did murder is "Jeremy Bowers".
