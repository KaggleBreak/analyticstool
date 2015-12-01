-- ==================================================
-- SELECT
-- ==================================================
select all order_date from "order" order by 1;
select order_date from "order" order by 1;
select distinct order_date from "order" order by 1;
select * from "order";
select distinct order_date as ord_dt from "order" order by 1;
select distinct order_date ord_dt from "order" order by 1;

-- ==================================================
-- Top N Query
-- ==================================================
select * from "order" order by amount desc limit 5;

-- ==================================================
-- OPERATOR(WHERE 조건절) - 1
-- ==================================================
-- 비교 연산자
select * from "order" where order_date =  '2015-08-05';
select * from "order" where order_date >  '2015-08-05' order by order_date;
select * from "order" where order_date >= '2015-08-05' order by order_date;
select * from "order" where order_date <  '2015-08-05' order by order_date;
select * from "order" where order_date <= '2015-08-05' order by order_date;

-- ==================================================
-- OPERATOR(WHERE 조건절) - 2
-- ==================================================
-- SQL 연산자
select * from "order" where order_date between '2015-08-05' and '2015-08-20' order by order_date;
select * from "order" where order_date in ('2015-08-05', '2015-08-07');
select * from "order" where order_date LIKE '2015%2%' order by order_date;
select * from "order" where order_date LIKE '2015-08-1_';
select * from "order" where discount is null;

-- ==================================================
-- OPERATOR(WHERE 조건절) - 3
-- ==================================================
-- 논리 연산자
select * from "order" where order_date ='2015-08-12' and userid = 2;
select * from "order" where order_date ='2015-08-12' or userid = 2;
select * from "order" where not order_date ='2015-08-12' and userid = 2;

-- ==================================================
-- OPERATOR(WHERE 조건절) - 4
-- ==================================================
-- 부정 비교 연산자
select * from "order" where order_date !='2015-08-12' and userid = 2;
select * from "order" where order_date ^='2015-08-12' and userid = 2; -- X
select * from "order" where order_date <>'2015-08-12' and userid = 2;
select * from "order" where not order_date ='2015-08-12' and userid = 2;
select * from "order" where not order_date >'2015-08-12' and userid = 2;

-- ==================================================
-- OPERATOR(WHERE 조건절) - 5
-- ==================================================
-- 부정 SQL 연산자
select * from "order" where order_date not between'2015-08-05' and '2015-08-20';
select * from "order" where order_date not in ('2015-08-15', '2015-08-23') and userid = 5;
select * from "order" where order_date is not null;

-- ==================================================
-- Build-In Function(WHERE 조건절) - 3
-- ==================================================
select userid
     , order_date
     , concat('date : ', order_date)                as concat1
     , 'date : ' || order_date                      as concat2
     , concat_ws(' / ', 'start', order_date, 'end') as concat2
     , substring(order_date from 1 for 4)           as substring1
     , substring(order_date from 6 for 2)           as substring2
     , position('-' in order_date)                  as position
     , replace(order_date, '-', '/')                as replace
     , length(order_date)                           as length
     , trim('  date   ')                            as trim
     , upper('date')                                as upper
     , lower('DATE')                                as lower
     , left(order_date, 4)                          as left
     , right(order_date, 2)                         as right
     , lpad(cast(userid as varchar), 10, '0')       as lapd
     , rpad(cast(userid as varchar), 10, '0')       as rpad
  from "order"
 limit 5
 ;

-- ==================================================
-- Build-In Function(WHERE 조건절) - 5
-- ==================================================
select amount
     , discount
     , abs(discount)      as abs
     , ceil(discount)     as ceil
     , ceiling(discount)  as ceiling
     , floor(discount)    as floor
     , round(discount, 0) as round
     , trunc(discount, 0) as trunc
     , mod(9, 4)          as mod
     , exp(1)             as exp
     , power(3, 2)        as power
     , rk
     , sign(rk)           as sign
     , sqrt(amount)       as sqrt
  from (select ord.*
             , row_number() over (order by userid, order_date) - 3 as rk
          from "order" ord
         limit 5) ord
;

-- ==================================================
-- Build-In Function(WHERE 조건절) - 5
-- ==================================================
select amount
     , discount
     , abs(discount)      as abs
     , ceil(discount)     as ceil
     , ceiling(discount)  as ceiling
     , floor(discount)    as floor
     , round(discount, 0) as round
     , trunc(discount, 0) as trunc
     , mod(9, 4)          as mod
     , exp(1)             as exp
     , power(3, 2)        as power
     , rk
     , sign(rk)           as sign
     , sqrt(amount)       as sqrt
  from (select ord.*
             , row_number() over (order by userid, order_date) - 3 as rk
          from "order" ord
         limit 5) ord
;

-- ==================================================
-- Build-In Function(WHERE 조건절) - 7
-- ==================================================
select order_dttm
     , current_date                    as current_date
     , current_time                    as current_time
     , current_timestamp               as current_timestamp
     , date_part('month', order_dttm)  as date_part
     , date_trunc('month', order_dttm) as date_trunc
     , extract(month from order_dttm)  as extract
     , now()                           as now
  from (select ord.*
             , to_date(order_date, 'YYYY-MM-DD') as order_dttm
          from "order" ord
         limit 5) ord
;

-- ==================================================
-- Build-In Function(WHERE 조건절) - 9
-- ==================================================
select amount
     , discount
     , amount + discount              as discount_amonut
     , amount + coalesce(discount, 0) as coalesce
     , nullif(discount, discount)     as nullif
     , greatest(100, 1, 3, 5, -1)     as greatest
     , least(100, 1, 3, 5, -1)        as least
  from "order"
 limit 5
;

-- ==================================================
-- Build-In Function(WHERE 조건절) - 11
-- ==================================================
select order_date::timestamp                        as order_dttm
     , to_char(order_date::timestamp, 'YYYY-MM-DD') as to_char
     , to_date(order_date, 'YYYY-MM-DD')            as to_date
     , to_timestamp(order_date, 'YYYY-MM-DD')       as to_timestamp
     , to_number('19,999.9', '99G999.9')            as to_number
     , cast(current_date as varchar)                as cast1
     , cast(order_date as timestamp)                as cast2
     , cast('1999' as integer)                      as cast3
     , cast('1999.9' as numeric)                    as cast4
     , '1999.9'::numeric                            as cast5
  from "order"
 limit 5
;

-- ==================================================
-- CASE Expression(WHERE 조건절) - 1
-- ==================================================
select userid
     , orders
     , gmv
     , case orders
           when 1 then 'A'
           when 2 then 'B'
           when 3 then 'C'
           else        'D'
       end as simple_case
     , case when orders >= 4 and gmv >= 40000 then 'A'
            when orders >= 3 and gmv >= 30000 then 'B'
            when orders >= 2 and gmv >= 10000 then 'C'
            else                                   'D'
       end as searched_case
  from (select userid
             , count(userid) as orders
             , sum(amount)   as gmv
          from "order"
         group by userid) ord
;
