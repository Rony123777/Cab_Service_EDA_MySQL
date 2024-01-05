use namaya_yatri;

show tables;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
select * from trips;

select * from trips_details;

select * from loc;

select * from duration;

select * from payment;


-- total trips

select count(distinct tripid) from trips_details1;

-- cheking if there is any duplicate tripID

select tripid,count(tripid) from trips group by tripid having count(tripid)>1 ;

-- total drivers

select * from trips;

select count(distinct driverid) from trips;

-- total earnings

select sum(fare) from trips;

-- total Completed trips

select * from trips_details1;
select sum(end_ride) from trips_details1;

-- total searches

select sum(searches),sum(searches_got_estimate),sum(searches_for_quotes),sum(searches_got_quotes),
sum(customer_not_cancelled),sum(driver_not_cancelled),sum(otp_entered),sum(end_ride)
from trips_details1;

-- total searches which got estimate
select * from trips_details1;
select sum(searches) searches from trips_details4;

-- total searches for quotes
select sum(searches_for_quotes) from trips_details4;

select * from trips_details4;
select sum(fare) from trips;
-- total searches which got quotes
select sum(searches_got_quotes) from trips_details4;


select * from trips;


select * from trips_details4;


-- total driver cancelled
-- select sum(driver_not_cancelled) from trips_details4;
select count(*) -  sum(driver_not_cancelled) from trips_details4;
-- total otp entered
select sum(otp_entered) from trips_details4;

-- total end ride
select sum(end_ride) from trips_details4;
select count(custid) from trips;

-- cancelled bookings by driver
select * from trips_details4;
select sum(driver_not_cancelled) from trips_details4;

-- cancelled bookings by customer


-- average distance per trip




-- average fare per trip

select sum(fare)/count(*) from trips;

-- distance travelled
select * from trips;
select faremethod,count(faremethod) most_payedmethod from trips group by faremethod order by most_payedmethod desc;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- which is the most used payment method 
select * from trips;
select faremethod,count(faremethod) cnt from trips group by faremethod;

select faremethod,count(faremethod) as cnt,method from trips t join payment p on t.faremethod=p.id
group by method,faremethod order by cnt desc;
 

select * from payment;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- the highest payment was made through which instrument

select * from trips order by fare desc limit 1;

select faremethod,method from payment p join trips t on p.id=t.faremethod where faremethod
=(select faremethod from trips order by fare desc limit 1) limit 1;

select * from trips;
select id,faremethod,sum(faremethod) sm from trips t join payment P 
on p.id=t.faremethod
group by faremethod order by sm desc;

select * from payment;
select * from trips;
select method,faremethod,sum(faremethod) sm from trips t join payment p on 
p.id= t.faremethod group by faremethod,method order by sm desc;

select method,faremethod,sum(fare) sm from trips t join payment p on 
+p.id= t.faremethod group by faremethod,method order by sm desc;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- which two locations had the most trips
select * from trips;
select * from loc;
select assembly1,loc_from from trips t join loc l on l.id=t.loc_from;
select assembly1,loc_to from trips t join loc l on l.id=t.loc_to;

select  assembly1,loc_from,loc_to,count(distinct tripid) trip from trips t join loc l on l.id=t.loc_from
group by loc_from,loc_to,assembly1 
order by count(distinct tripid) desc;

select  assembly1,loc_from,loc_to,count(distinct tripid) trip from trips t join loc l on l.id=t.loc_from
group by loc_from,loc_to,assembly1 
order by count(distinct tripid) desc limit 2;


-------------------------------------------------------------------------------------------------------------------------- 

-- top 5 earning drivers
-- using dense rank to make sure there can be multiple driver earning same amount in same day
select * from trips;
select driverid,sum(fare) from trips group by driverid order by sum(fare) desc limit 5;

select *,dense_rank() over (order by fare desc) from
(select driverid,sum(fare) fare from trips group by driverid order by sum(fare) desc limit 5)a;
select *,dense_rank() over(order by sm desc) from
(select driverid,sum(fare) sm from trips group by driverid order by sm desc)a;
----------------------------------------------------------------------------------------

-- which duration had more trips

select *  from trips;
select duration,count(tripid) total_trips from trips group by duration order by total_trips desc;

select *,rank() over (order by total_trips desc) from
(select duration,count(tripid) total_trips from trips group by duration order by total_trips desc)a;

select * from(
select *,rank() over (order by total_trips desc) rnk from
(select duration,count(tripid) total_trips from trips group by duration order by total_trips desc)a)b
where rnk=1;

--------------------------------------------------------------------------------------------------------------------
-- which driver , customer pair had more orders
select * from trips;
select * from
(select *,rank() over (order by cn desc) rnk from 
(select driverid,custid,count(tripid) cn from trips group by driverid,custid order by cn desc)a)b
where rnk=1;
---------------------------------------------------------------------------------------------------------------------
-- search to estimate rate
-- number of searches we get to number of fare actually we get 

select * from trips_details4;
select sum(searches_got_estimate)/sum(searches) * 100 from trips_details4;

-- estimate to search for quote rates
-- people who got the estimate after and go for taking the ride
select sum(searches_for_quotes)/sum(searches)*100 from trips_details4;

----------------------------------------------------------------------------------------------------------------------
-- quote acceptance rate
select * from trips;
select * from trips_details4;

select sum(end_ride)/sum(searches)*100 from trips_details4;

-- quote to booking rate
select * from trips_details4;
select * from trips;
select sum(searches_got_quotes)/sum(searches_got_estimate)*100 from trips_details4 t1 join trips t2 on t1.tripid=t2.tripid;

-- booking cancellation rate
select * from trips_details4;

select count(customer_not_cancelled) from trips_details4 where customer_not_cancelled=1;
select count(customer_not_cancelled) from trips_details4 where customer_not_cancelled=0;
select 1041/count(tripid) *100 from trips_details4 ;
--------------------------------------------------------------------------------------------------------------------
-- conversion rate
select * from trips_details4;
select count(end_ride)/count(searches)*100 from trips_details4 where end_ride=1;
select count(end_ride) from trips_details4 where end_ride=1;
select 983/count(searches)*100 from trips_details4;
---------------------------------------------------------------------------------------------------------------------
-- which area got highest trips in which duration
select * from trips;
select * from loc;
select assembly1,loc_to,duration,count(tripid) cn from trips t join loc l
on l.id=t.loc_to
group by loc_to,duration,assembly1 order by cn desc;

select assembly1,loc_from,duration,count(distinct tripid) cn from trips t join loc l
on l.id=t.loc_from
group by loc_from,duration,assembly1 order by cn desc;

select * from trips;
select * from 
(select *,rank() over (partition by duration order by cn desc) rnk from
(select duration,loc_from,count(distinct tripid) cn from trips group by loc_from,duration)a)b
where rnk=1;
----------------------------------------------------------------------------------------------------------------------
-- which area got the highest fares, cancellations,trips

select * from trips;
select * from trips_details;

select * from
(select *, rank() over (order by fare desc) rnk
from
(select loc_from,sum(fare) fare from trips
group by loc_from) b) c
where rnk-1;

select * from
(select *, rank() over (order by can desc) rnk
from
(select loc_from,count(*) - sum(driver_not_cancelled) can
from trips_details4
group by loc_from) b) c
where rnk=1;

select * from (select *, rank() over (order by can desc) rnk
from
(
select loc_from, count(*) - sum(customer_not_cancelled) can
from trips_details4
group by loc_from) b) c
where rnk=1;

-- which duration got the highest trips and fares
select * from (select *, rank() over (order by fare desc) rnk
from(
select duration,count(distinct tripid) fare from trips
group by duration) b) c
where rnk=1; 




