### Incredible 120 Years of Olympic Games
Introduction

The modern Olympics represents an evolution of all games from 1986 to 2016. Because the Olympics is an international sports event. It is affected by global issues such as the COVID-19 pandemic, and world wars. Nevertheless, there are positive movements such as women's empowerment and the development of the game itself.

In this project, I used a 120-year-old dataset containing a massive collection of data. I downloaded the data from Kaggle Website.  https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results
There are total 2 Csv files "athlete_events.csv" and "noc_regions.csv" and I imported the table into MS-SQL Server and created a database in my local machine and saved these 2 tables in the following names.
1) olympics_history
2) Olympics_history_noc_regions

I performed intermediate to advanced SQL queries (Subqueries, CTE, Joins) for better analysis.
First and foremost, I wanted to study the dataset to get answers to the following questions: How many columns and rows are in the dataset? Ans:- ~271K Rows and 15 Columns

How many total datasets are there? Ans:- 2 datasets

```sql
select count(1) as Total_rows from  olympics_history;
```
![image](https://user-images.githubusercontent.com/120770473/220054252-f442e35a-c2ff-4c3f-b073-429ee015c327.png)
```sql
select COUNT(*) as Total_Columns
from sys.all_columns
where object_id = (
		select object_id
				from sys.tables
				where name = 'olympics_history');
```
![image](https://user-images.githubusercontent.com/120770473/220054633-fc379b63-483b-4aa1-b0aa-96821aabac74.png)
--------------------------------------------------------------------------------------------------
Derived answers of some questions by writing sql queries.
### Ques-1 How many olympics games have been held? 
: For this query I used 2 commands ie.distinct Command to get rid of any duplicate values and then Count of That result to show the number of Total Olympics games.
```sql
select count(distinct games) as total_olympics_games 
from olympics_history;
```
![image](https://user-images.githubusercontent.com/120770473/220057463-efee6918-e4c8-4ca5-a756-5af0542cfc43.png)
### Ques-2 Mention the total no of nations who participated in each olympics game
: Use a JOIN to display a table showing Countries who participated olympics game and then Count All countries with respect to each Olympic games By Grouping .
```sql
WITH ALL_COUNTRIES AS 
(
	SELECT		GAMES,NR.REGION AS COUNTRY
	FROM		OLYMPICS_HISTORY AS OH
	JOIN		OLYMPICS_HISTORY_NOC_REGIONS NR ON OH.NOC=NR.NOC
	GROUP BY	GAMES,NR.REGION
)
	SELECT		GAMES,COUNT(1) AS TOTAL_NATIONS_PARTICIPATED
	FROM		ALL_COUNTRIES
	GROUP BY	GAMES
	ORDER BY	GAMES	;
```
![image](https://user-images.githubusercontent.com/120770473/220058410-39520caa-ba15-4cdc-b392-a041728ef93c.png)
![image](https://user-images.githubusercontent.com/120770473/220058581-06ba4173-30aa-4ac8-aa12-66ca6178bf22.png)
### Ques-3 Which year saw the highest and lowest no of countries participating in olympics?
: For this query First I need to know the Total Countries Participated for each Olympics Games , here I used CTE to create a Temporary result sets. and then I used Window function "First_value" and Over() function  to fetch both Lowest Participation Country name and Highest Participation Country name by using total_nations_participated Column and also fetch their respective Olympic games name and last I merge the Olympic games name with Number of Participation using "Concat" Command.
```sql
with all_countries as 
(
	select 	Games,nr.region
	from 	olympics_history as oh
	join 	Olympics_history_noc_regions nr on oh.NOC=nr.NOC
	group by games,nr.region
),
tot_countries as(
select Games,count(1) as total_nations_participated
from all_countries
group by Games
)	
select distinct
      concat(first_value(games) over(order by total_nations_participated)
      , ' - '
      , first_value(total_nations_participated) over(order by total_nations_participated)) as Lowest_Countries,
      concat(first_value(games) over(order by total_nations_participated desc)
      , ' - '
      , first_value(total_nations_participated) over(order by total_nations_participated desc)) as Highest_Countries
      from tot_countries
      order by 1;
```   
![image](https://user-images.githubusercontent.com/120770473/220059898-a315859a-269d-4315-8f97-709f1863b373.png)
### Ques-4 Which country has participated in all of the olympic games?
: For this query , I used a CTE to create multiple temporary result sets like 1st find a Total Olymics games held till last date . 2nd find the all Countries who participated olympics game and last use a JOIN to display only those countries name who have played all Olympics games till last date  by matching the values of total_olympics_games column of Total Games Table and total_participated_games column of countries_participated.
 ```sql
with tot_games as 
    (
    select count(distinct games) as total_olympics_games 
    from olympics_history),
all_countries as 
    (
    select Games,nr.region as country
    from olympics_history as oh
    join Olympics_history_noc_regions nr on oh.NOC=nr.NOC
    group by games,nr.region
    ),
countries_participated as
    (select country,count(1) as all_participated_games
    from all_countries
    group by country
    )
					
select cp.* 
from countries_participated as cp 
join tot_games as tg
on cp.all_participated_games=tg.total_olympics_games;
```
![image](https://user-images.githubusercontent.com/120770473/223629512-34da0b38-1db0-482b-a695-a7b09f1a264d.png)

### Ques-5 Identify the sports which were played in all summer olympics.
: With the help of CTE I find total no of distinct summer olympics games(Ans. Total 29 Games). 
then after count the total Summer olympics games played for each Sports by Grouping.
and last Join both the result sets on matching of Total_summer_games column and no_of_games column to fetch only that Sports who has Played total 29 summer olympics games .
```sql
with t1 as 
	(select count(distinct Games) as Total_summer_games 
	from olympics_history
	where Season = 'Summer'),
t2 as
	(select  Sport,count(distinct Games) as no_of_games
	from olympics_history
	where Season = 'Summer' 
	group by Sport
	)
select * 
	from t2 join t1
	on t2.no_of_games=t1.Total_summer_games;
```
Another approach to solve this query is by Subquery
```sql	
SELECT A.*
	FROM
	(
	select  Sport,count(distinct Games) as Total_summergames
	from olympics_history
	where Season = 'Summer' 
	group by Sport
) A
WHERE A.Total_summergames = (select count(distinct Games) as Total_summer_games 
	from olympics_history
	where Season = 'Summer');
```
![image](https://user-images.githubusercontent.com/120770473/223631994-196f1580-a764-46b8-863e-f42e05a6cd70.png)
### Ques-6 Which Sports were just played only once in the entire olympics?

```sql
with t2 as
	(select distinct Sport,Games
	from olympics_history
	),
t3 as 
	(select Sport,count(Games) as Games_Played_Once
	from t2
	group by Sport
	having count(Games) = 1)

	 select t3.Sport,t2.Games as Olympics_games ,Games_Played_Once
	 from t3 join t2 
	 on t3.Sport=t2.Sport;
```
![image](https://user-images.githubusercontent.com/120770473/223632810-30f05a56-8ba8-4463-b16e-2253ddfc97f2.png)
### Ques-7 Fetch the total no of sports played in each olympic games.
: The goal is a table that shows how many Sports have played on each Olympic games. and sort the rows by latest Games played . 
```sql
SELECT Games,count(distinct Sport) as no_of_sports
FROM olympics_history
group by Games
order by 1 desc;
```
![image](https://user-images.githubusercontent.com/120770473/223651858-99d5c229-cc2b-4f72-90f4-e3a66bdff1f3.png)
![image](https://user-images.githubusercontent.com/120770473/223651937-7db7e3f2-8a8e-4355-9d7d-11e065b8f64d.png)
![image](https://user-images.githubusercontent.com/120770473/223652132-e0ea78f3-5db4-4ddd-b54f-73d6a827688b.png)

### Ques-8 Fetch oldest athletes to win a gold medal.
:To display the Oldest athletes who won the gold medal on any Olympics games or any Sports .
First I Replaced NA Value with "0" on that records where Data is missing on Age Column by using CASE with the age column
and then filter the records by Gold Medal and then Store in Temporary result sets named "temp". then using Ranking Functions Rank() 
,I fetched only those records whose age is highest among the Athletes. 
```sql
with temp as
            (select 	name,sex,
			cast(case when age = 'NA' then '0' else age end as int) as age
			,team,games,city,sport
			,event,medal
            from	olympics_history
			where Medal = 'gold'),
       ranking	as
            (select	*
			,rank() over(order by age desc) as rnk
            from	temp
            )
	     select	name,sex,age,team,games,city,sport,event,medal
	     from	ranking
	     where	rnk = 1;
```
![image](https://user-images.githubusercontent.com/120770473/223654078-3ff5d303-90b9-4b35-9843-4d9247ee091e.png)
### Ques-9 Find the Total Athletes participated in the olympic games?
: Using Distinct Command and Count function we can display the total athletes Participated.
```sql
select count(distinct Name)
	from olympics_history;
```
![image](https://user-images.githubusercontent.com/120770473/224466671-41f2050c-8490-4c4f-a7ff-ff89f45be4c4.png)
### Ques-10 Find the Ratio of male and female athletes participated in all olympic games?
```sql
with t1 as
        	(select sex, count(1) as cnt
        	from olympics_history
        	group by sex),
        t2 as
        	(select *, row_number() over(order by cnt) as rn
        	 from t1),
        female_cnt as
        	(select cnt from t2	where rn = 1),
        male_count as
        	(select cnt from t2	where rn = 2)

	select format(round(male_count.cnt*1.0/female_cnt.cnt,2),'f2') as ratio
	from female_cnt cross join male_count;
```
![image](https://user-images.githubusercontent.com/120770473/224466748-89da22a8-7f99-46e9-8c5a-aa315f6b719f.png)
### Ques-11  Find the top 5 athletes who have won the most gold medals? (we also consider those athletes who have same number of Gold Medals )
```sql
WITH T1 AS 
	(SELECT	Name,COUNT(1) AS TOTALMEDALS
	FROM	olympics_history
	WHERE	Medal = 'GOLD'
	GROUP BY Name
	),
	T2 AS 
	(SELECT *,DENSE_RANK() OVER(ORDER BY TOTALMEDALS DESC) AS RNK
	FROM T1 )
	SELECT * FROM T2 WHERE RNK <=5;
```
![image](https://user-images.githubusercontent.com/120770473/224773345-c5cdba53-2353-43db-902a-927c66758e19.png)
### Ques-12  Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
```sql
with medals as
(   SELECT	Name,COUNT(1) AS TOTALMEDALS
	FROM	olympics_history
	WHERE	Medal in ('GOLD','silver','bronze')
	group by Name),
ranking as 
(   select *,DENSE_RANK() over (order by TOTALMEDALS desc) as rnk
    from	medals)
select	Name,TOTALMEDALS
from	ranking
where	rnk<=5;
```
![image](https://user-images.githubusercontent.com/120770473/224774137-2de72cda-36d9-4750-9961-c3c271503594.png)
### Ques-13  Fetch the top 5 most successful countries in olympics. (Success is defined by Highest no of medals won.)
: Here in this Query , I Joined both tables using Common columns "NOC" and filter only those records where Medals are NA.
Then group the final result set into Region Field ,count the total Medals and Fetch Only Top 5 Countries who has earned Highest Medals.
```sql
select	TOP 5 nr.region as country
	,count(Medal) as Total_Medals	
from	olympics_history as oh
inner join	Olympics_history_noc_regions as nr
on	oh.NOC=nr.NOC
where	Medal <> 'NA'
group by nr.region
order by Total_Medals desc;
```
![image](https://user-images.githubusercontent.com/120770473/224774795-81d336f9-ce6e-45fb-a128-4ac9383442c9.png)

### Ques-14  In which Sport/event, India has won highest medals.
```sql
SELECT	 A.Sport AS SPORT,COUNT(1) AS TOTAL_MEDALS
FROM	olympics_history AS A
INNER JOIN(SELECT NOC,region
FROM	Olympics_history_noc_regions
WHERE	NOC = 'IND') AS K
ON		K.NOC = A.NOC
WHERE	Medal <> 'NA'
GROUP BY A.Sport
ORDER BY 2 DESC;
```
![image](https://user-images.githubusercontent.com/120770473/224779725-fd978fb5-2f06-4f7f-8f4c-8a5ee5913b03.png)
### Ques-15  Break down all olympic games where India won medal for Hockey and how many medals in each olympic games.
```SQL
SELECT TEAM,SPORT,Games,Event,COUNT(1) AS TOTAL
FROM olympics_history
WHERE Medal <> 'NA'
AND Team = 'INDIA'
AND Sport = 'HOCKEY'
GROUP BY TEAM,SPORT,Games,Event
ORDER BY Games ;
```
![image](https://user-images.githubusercontent.com/120770473/224780942-3c62504d-2c93-422b-a57d-368b0a75bd40.png)




