create database Telengana_Govt;

use Telengana_Govt;


select*from domestic;
select*from foreigner;



1) List down top 10 districts that have highest no of visitors overall(2016-2019)

select 
   top(10) district, sum(visitors) as total_visitors
from 
   domestic
group by 
   district
order by 
   sum(visitors) desc;

2) List down top 3 districts based on compounded annual growth rate(CAGR) during (2016-2019)

WITH CombinedData AS (
    SELECT
        District,[year], SUM(Visitors) AS TotalVisitors
    FROM
        (
		SELECT
                District,[year],Visitors
            FROM Domestic
            UNION ALL
            SELECT
                District,[year],Visitors
            FROM Foreigner
        ) AS Combined
    GROUP BY
        District,[year]
),
DistrictCAGR AS (
    SELECT
        District,
        MAX(CASE WHEN Year = 2019 THEN TotalVisitors END) AS Visitors2019,
        MIN(CASE WHEN Year = 2016 THEN TotalVisitors END) AS Visitors2016
    FROM
       CombinedData
    GROUP BY
        District
)

SELECT
    top (3) District,
	round((power((Visitors2019 / NULLIF(Visitors2016, 0)),(1.0 / 3)) - 1) * 100 ,2)as cagr_percentage
FROM
    DistrictCAGR
ORDER BY
    CAGR_percentage DESC;

3) List down bottom 3 districts based on compounded annual growth rate(CAGR) during (2016-2019)

WITH CombinedData AS (
    SELECT
        District,[year], SUM(Visitors) AS TotalVisitors
    FROM
        (
		SELECT
                District,[year],Visitors
            FROM Domestic
            UNION ALL
            SELECT
                District,[year],Visitors
            FROM Foreigner
        ) AS Combined
    GROUP BY
        District,[year]
),
DistrictCAGR AS (
    SELECT
        District,
        MAX(CASE WHEN Year = 2019 THEN TotalVisitors END) AS Visitors2019,
        MIN(CASE WHEN Year = 2016 THEN TotalVisitors END) AS Visitors2016
    FROM
       CombinedData
    GROUP BY
        District
)

SELECT
    top (3) District,
       round((power((Visitors2019 / NULLIF(Visitors2016, 0)),(1.0 / 3)) - 1) * 100,2)
    as cagr_percentage
FROM
    DistrictCAGR
where
    (power((Visitors2019 / NULLIF(Visitors2016, 0)),(1.0 / 3)) - 1) * 100 is not null
ORDER BY
    CAGR_percentage;


4.1) What are the peak months in Hyderabad based on the data from 2016 to 2019 ? (Domestic)

select 
    top(3) [month] , sum(visitors) as total_visitors
from 
    domestic 
where district='Hyderabad'
group by
    [month]
order by 
    total_visitors desc;

4.2) What are the low months in Hyderabad based on the data from 2016 to 2019 ? (Domestic)

select 
    top(3) [month] , sum(visitors) as total_visitors
from 
    domestic 
where district='Hyderabad'
group by
    [month]
order by 
    total_visitors;

4.3) What are the peak season months in Hyderabad based on the data from 2016 to 2019 ? (Foreign)

select 
    top(3) [month] , sum(visitors) as total_visitors
from 
    foreigner 
where district='Hyderabad'
group by
    [month]
order by 
    total_visitors desc;

4.4) What are the low season months in Hyderabad based on the data from 2016 to 2019 ? (Foreign)

select 
    top(3) [month] , sum(visitors) as total_visitors
from 
   foreigner
where district='Hyderabad'
group by
    [month]
order by 
    total_visitors;

5.1) List down top 3 districts with high domestic to foreign tourist ratio during (2016-2019)
select 
   top(3) f.district, round(sum(d.visitors)/nullif(sum(f.visitors),0),2)
    as [d to f ratio]
from 
   domestic d
join foreigner f
on d.id=f.id

group by
  f.district
  having
  sum(d.visitors)/nullif(sum(f.visitors),0) is not null
  
order by
   [d to f ratio] desc;   

5.2) List down bottom 3 districts with high domestic to foreign tourist ratio during (2016-2019)

select 
   top(3) f.district, round(sum(d.visitors)/nullif(sum(f.visitors),0),2)
    as [d to f ratio]
from 
   domestic d
join foreigner f
on d.id=f.id

group by
  f.district
  having
  sum(d.visitors)/nullif(sum(f.visitors),0) is not null
  
order by
   [d to f ratio] ;  

6) List down top and bottom 5 districts based on ‘population to tourist footfall ratio’ in 2019.

select*from demographics;


 
 with ratio as(
 select 
     f.district,d.[year] ,sum(d.visitors)+sum(f.visitors) as total_visitors, 
     sum(demo.males)+sum(demo.females) as total_population
 
from 
   domestic d
join foreigner f
on d.id=f.id
join demographics demo
on d.district=demo.Districts
group by 
     f.district,d.[year]

)
  select 
     top (5) district, round(total_visitors/total_population,2) as [P to T ratio],[year]
  from
     ratio
  where
     [year]='2019'

  order by
     [P to T ratio] desc;

  






















