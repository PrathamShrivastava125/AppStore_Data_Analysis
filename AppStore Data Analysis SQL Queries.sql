create table applestore_description_combined AS
select * from appleStore_description1
union ALL
select * from appleStore_description2
union ALL
select * from appleStore_description3
union ALL
select * from appleStore_description4


-------EDA-------------


select count(DISTINCT id) as UniqueAppIds
from AppleStore

select count(DISTINCT id) as UniqueAppIds
from applestore_description_combined


----check for any missing values------------

select count(*) as missing_values
from AppleStore
where track_name is null or user_rating is null or prime_genre is NULL

select count(*) as missing_values
from applestore_description_combined
where app_desc is null 



------CHECK FOR THE NUMBER OF APPS----------	


select prime_genre, count(*) as NumApps
from AppleStore
GROUP by prime_genre
order by 2 DESC



--------Get an overview of app ratings----------

SELECT min(user_rating) as min_ratings,
       max(user_rating) as max_ratings,
       avg(user_rating) as avg_ratings
from AppleStore       
      
      
      
select 
      case 
           WHEn price > 0 then 'Paid'
           else 'Free' end as App_Type,
      count(*) as NumApps,     
      avg(user_rating) as avg_ratings
from AppleStore
group by App_Type







-----Check if apps with more languages have higher ratings-------AppleStore


select case 
           WHEn lang_num < 10 then '< 10 Languages'
           WHEn lang_num BETWEEN 10 and 30 then 'Between 10-30 Languages'
           else '>30 Languages' end as App_Lang,
      count(*) as NumApps,     
      avg(user_rating) as avg_ratings
from AppleStore
group by App_Lang
order by avg_ratings DESC






----Check avg rating w.r.t. genre--------


select prime_genre,
       avg(user_rating) as avg_ratings
from AppleStore
group by prime_genre
order by avg_ratings 
LIMIT 10






----Check if their exist any correlation between app description and user ratings---------



SELECT CASE
           when length(app_desc) < 500 then 'Short'
           When length(app_desc) BETWEEN 500 and 1000 then 'Medium'
           else 'Long' end as App_Description_Length,           
       avg(user_rating) as avg_ratings
from 
    AppleStore as a 
join 
    applestore_description_combined as appdesc
on 
   a.id = appdesc.id
GROUP by App_Description_Length
order by avg_ratings desc





       
--------Check the top-rated apps for each genre---------

SELECT prime_genre, track_name, user_rating
from 
(
  select prime_genre, track_name, user_rating, 
         rank()over(partition by prime_genre order by user_rating desc, rating_count_tot DESC) as rank
  from AppleStore
) as a 
WHERE a.rank=1
-------------------------------------------------------------



