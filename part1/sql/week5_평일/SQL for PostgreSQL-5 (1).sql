--============================================
-- Tabel : Customers
--============================================
drop table if exists customer;
create table customer (
    userid    integer,
    username  varchar(10),
    join_date varchar(10)
)
;
insert into customer
select 1 as userid, 'A' as username, '2015-08-01' as join_date union all
select 2 as userid, 'B' as username, '2015-08-02' as join_date union all
select 3 as userid, 'C' as username, '2015-08-01' as join_date union all
select 4 as userid, 'D' as username, '2015-08-03' as join_date union all
select 5 as userid, 'E' as username, '2015-08-07' as join_date union all
select 6 as userid, 'F' as username, '2015-08-22' as join_date
;

--============================================
-- Tabel : Orders
--============================================
drop table if exists orders;
create table orders (
    userid     integer     not null,
    order_date varchar(10) not null,
    method     varchar(10) not null,
    amount     integer     not null,
    discount   numeric         null
);

insert into orders values(1, '2015-08-01', 'CALL' , 10000, -998.7);
insert into orders values(1, '2015-08-03', 'TOUCH', 10000, null);
insert into orders values(1, '2015-08-10', 'TOUCH', 10000, -950.4);
insert into orders values(1, '2015-08-14', 'CALL' , 10000, -1000);
insert into orders values(1, '2015-08-25', 'TOUCH', 10000, null);
insert into orders values(2, '2015-08-03', 'TOUCH',  5000, -500 );
insert into orders values(2, '2015-08-11', 'TOUCH',  5000, -300 );
insert into orders values(2, '2015-08-12', 'TOUCH',  5000, -700 );
insert into orders values(2, '2015-08-22', 'TOUCH',  5000, -1000);
insert into orders values(2, '2015-08-28', 'TOUCH',  5000, -600 );
insert into orders values(3, '2015-08-07', 'CALL' , 10000, -1000);
insert into orders values(3, '2015-08-19', 'TOUCH', 10000, -1000);
insert into orders values(3, '2015-08-30', 'CALL' , 10000, -1000);
insert into orders values(4, '2015-08-05', 'CALL' , 20000, -3000);
insert into orders values(4, '2015-08-18', 'TOUCH', 30000, -5000);
insert into orders values(5, '2015-08-15', 'CALL' , 10000, -1000);
insert into orders values(5, '2015-08-17', 'CALL' , 20000, null);
insert into orders values(5, '2015-08-21', 'CALL' ,  5000, -1000);
insert into orders values(5, '2015-08-23', 'CALL' , 10000, -1000);
insert into orders values(5, '2015-08-29', 'CALL' , 30000, -1000);


-- 참조 : http://www.postgresql.org/docs/current/static/functions-window.html
--============================================
-- 그룹내 순서 획득
--============================================
select userid
     , join_date
     , rank()         over (order by join_date)         as rank
     , dense_rank()   over (order by join_date)         as dense_rank
     , row_number()   over (order by join_date)         as row_number
     , percent_rank() over (order by join_date)         as percent_rank1
     , percent_rank() over (order by join_date, userid) as percent_rank2
  from customer
 order by join_date
        , userid
;

--============================================
-- 그룹내 특정위치 컬럼 획득
--============================================
select userid
     , order_date
     , method
     , first_value(method)      over (partition by userid                         ) as first_value
     , first_value(method)      over (partition by userid order by order_date     ) as first_value_order
     , last_value (method)      over (partition by userid                         ) as last_value
     , last_value (method)      over (partition by userid order by order_date     ) as last_value_order
     , lag (order_date, 1)      over (partition by userid order by order_date     ) as lag_value_asc
     , lag (order_date, 1)      over (partition by userid order by order_date desc) as lag_value_desc
     , lead(order_date, 1)      over (partition by userid order by order_date     ) as lead_value_asc
     , lead(order_date, 1)      over (partition by userid order by order_date desc) as lead_value_desc
     , nth_value(order_date, 2) over (partition by userid order by order_date     ) as nth_value_asc
     , nth_value(order_date, 2) over (partition by userid order by order_date desc) as nth_value_desc
  from orders
 where userid in (1, 3)
 order by userid
        , order_date
;

--============================================
-- 그룹내 집계정보 획득
--============================================
select userid
     , amount
     , sum  (amount) over (partition by userid                    ) as sum_over
     , sum  (amount) over (partition by userid order by order_date) as sum_over_order
     , max  (amount) over (partition by userid                    ) as max_over
     , max  (amount) over (partition by userid order by order_date) as max_over_order
     , min  (amount) over (partition by userid                    ) as min_over
     , min  (amount) over (partition by userid order by order_date) as min_over_order
     , avg  (amount) over (partition by userid                    ) as avg_over
     , avg  (amount) over (partition by userid order by order_date) as avg_over_order
     , count(amount) over (partition by userid                    ) as count_over
     , count(amount) over (partition by userid order by order_date) as count_over_order
  from orders
 where userid in (3, 4, 5)
;

--============================================
-- 기타
--============================================
select userid
     , join_date
     , cume_dist() over (order by join_date)         as cum_dist1
     , cume_dist() over (order by join_date, userid) as cum_dist2
     , ntile(3)    over (order by join_date)         as ntile3
     , ntile(4)    over (order by join_date)         as ntile4
  from customer
 order by join_date
        , userid
;