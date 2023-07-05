-- load the excel data into sql database named CS.

use CS
go

	
select * from [OYO].[Hotel_Sales];

select * from [OYO].[City];

-- add new columns 
/*
alter table [OYO].[Hotel_Sales]
add Price float null;

update [OYO].[Hotel_Sales]
set Price = amount + discount;

alter table [OYO].[Hotel_Sales]
add no_of_nights int null;

update [OYO].[Hotel_Sales]
set no_of_nights = DATEDIFF(day,check_in,check_out);

alter table [OYO].[Hotel_Sales]
add rate float null;

update [OYO].[Hotel_Sales]
set rate = ROUND( case when no_of_rooms = 1 then 
		Price/no_of_nights 
		else Price/no_of_nights/no_of_rooms end,2) 
*/

 select count(1) [total records]
 from OYO.Hotel_Sales;

 select count(1) [no of hotels]
 from OYO.City;

 select count(distinct city) [total cities]
 from OYO.City;
 
 -- No of hotels in different cities

 select city, COUNT	(hotel_id) [no of hotels]
 from OYO.City
 group by city
 order by 2 desc;

 -- average room rates of different cities


 select b.city ,ROUND( AVG(a.rate),2) [average room rates]
 from OYO.Hotel_Sales as a
 inner join OYO.City as b
 on a.hotel_id  = b.hotel_id
 group by b.city
 order by 2 desc;


 -- Cancellation rates of different cities

	 select b.city as City, 
			format(100.0* sum(case when status = 'Cancelled' then 1 else 0 end)
			/count(date_of_booking),'f1') [% Cancellation Rate]
	 from	[OYO].[Hotel_Sales] as a
	 inner join OYO.City as b
	 on a.hotel_id=b.hotel_id
	 group by b.city
	 order by 2 desc;

-- No of bookings of different cities in Jan Feb Mar Months.

select	b.city [City], datename(month,date_of_booking) [Months], count(date_of_booking) [No of bookings]
from	[OYO].[Hotel_Sales] as a
inner join OYO.City as b
on a.hotel_id=b.hotel_id
group by b.city, datepart(month,date_of_booking),datename(month,date_of_booking)
order by 1,datepart(month,date_of_booking) ;


select	b.city [City], datename(month,date_of_booking) [Months], count(date_of_booking) [No of bookings]
from	[OYO].[Hotel_Sales] as a
inner join OYO.City as b
on a.hotel_id=b.hotel_id
group by b.city,datename(month,date_of_booking)
order by 1,2 ;




-- Frequency of early bookings prior to check-in the hotel

select	DATEDIFF(day,date_of_booking,check_in)[Days before check-in] 
		, count(1)[Frequency_Early_Bookings_Days]
from	OYO.Hotel_Sales
group by DATEDIFF( day,date_of_booking,check_in);

-- Frequency of bookings of no of rooms in Hotel

select no_of_rooms, count(1) [frequency_of_bookings]
from oyo.Hotel_Sales
group by no_of_rooms
order by no_of_rooms;

-- net revenue to company (due to some bookings cancelled)  & Gross revenue to company

select	city, sum(amount) [gross revenue] , 
		sum(case when status in ('No Show' ,'Stayed') then amount end) as [net revenue]
from	OYO.Hotel_Sales as a
inner join OYO.City as b
on		a.hotel_id = b.hotel_id
group by city
order by 1;

-- Discount offered by different cities

select	city, format(AVG(100.0*discount/Price),'f1') [% Discount offered]
from	OYO.Hotel_Sales as a
inner join OYO.City as b
on		a.hotel_id = b.hotel_id
group by city
order by 2;

--done
---------------------------------------------------------------------------

-- NEW CUSTOMERS ON JAN MONTH - 719
-- REPEAT CUSTOMER ON FEB MONTH - 133
-- NEW CUSTOMERS ON feb MONTH - 566
-- total customer on feb month - 699 (566 + 133)


with Cust_jan as(
select distinct customer_id
					from OYO.Hotel_Sales
					where MONTH(date_of_booking) = 1
					)
, repeat_cust_feb as(
select distinct s.customer_id
					from OYO.Hotel_Sales as s
					inner join Cust_jan as b
					on b.customer_id = s.customer_id
					where MONTH(date_of_booking) = 2 
					)
,total_Cust_feb as (
select distinct customer_id
					from OYO.Hotel_Sales
					where MONTH(date_of_booking) = 2
					)
, new_cust_feb as
(
select customer_id [new customer in feb]
from total_Cust_feb as a 
except select customer_id
from repeat_cust_feb  as b
)
SELECT count(c.[new customer in feb]) [repeat customer in feb]
FROM new_cust_feb as c
ORDER BY 1;

Insights:-

1. Banglore , gurgaon & delhi were popular in the bookings, whereas Kolkata is less popular in bookings
2. Nature of Bookings:

• Nearly 50 % of the bookings were made on the day of check in only.
• Nearly 85 % of the bookings were made with less than 4 days prior to the date of check in.
• Very few no.of bookings were made in advance(i.e over a 1 month or 2 months).
• Most of the bookings involved only a single room.
• Nearly 80% of the bookings involved a stay of 1 night only.

3. Oyo should acquire more hotels in the cities of Pune, kolkata & Mumbai. Because their average room rates are comparetively higher so more revenue will come.

4. The % cancellation Rate is high on all 9 cities except pune ,so Oyo should focus on finding reasons about cancellation.
 
