--============================================
-- Tabel : Set1
--============================================
drop table if exists set1;
create table set1 (
    col1 varchar(5),
    col2 varchar(5)
);
insert into set1
select 'A' as col1, 'B' as col2
union all
select 'A' as col1, 'B' as col2
union all
select 'B' as col1, 'C' as col2
;

--============================================
-- Tabel : Set2
--============================================
drop table if exists set2;
create table set2 (
    col1 varchar(5),
    col2 varchar(5)
);
insert into set2
select 'A' as col1, 'B' as col2
union all
select 'C' as col1, 'D' as col2
;

--============================================
-- union all
--============================================
select col1, col2
  from set1
union all
select col1, col2
  from set2
;

--============================================
-- union
--============================================
select col1, col2
  from set1
union
select col1, col2
  from set2
;

--============================================
-- intersect
--============================================
select col1, col2
  from set1
intersect
select col1, col2
  from set2
;

--============================================
-- except
--============================================
select col1, col2
  from set1
except
select col1, col2
  from set2
;

--============================================
-- Table : Customer
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
-- Table : Order
--============================================
drop table if exists "order";
create table "order" (
    userid     integer     not null,
    order_date varchar(10) not null,
    method     varchar(10) not null,
    amount     integer     not null,
    discount   numeric         null
);
insert into "order" values(1, '2015-08-01', 'CALL' , 10000, -998.7);
insert into "order" values(1, '2015-08-03', 'TOUCH', 10000, null);
insert into "order" values(1, '2015-08-10', 'TOUCH', 10000, -950.4);
insert into "order" values(1, '2015-08-14', 'CALL' , 10000, -1000);
insert into "order" values(1, '2015-08-25', 'TOUCH', 10000, null);
insert into "order" values(2, '2015-08-03', 'TOUCH',  5000, -500 );
insert into "order" values(2, '2015-08-11', 'TOUCH',  5000, -300 );
insert into "order" values(2, '2015-08-12', 'TOUCH',  5000, -700 );
insert into "order" values(2, '2015-08-22', 'TOUCH',  5000, -1000);
insert into "order" values(2, '2015-08-28', 'TOUCH',  5000, -600 );
insert into "order" values(3, '2015-08-07', 'CALL' , 10000, -1000);
insert into "order" values(3, '2015-08-19', 'TOUCH', 10000, -1000);
insert into "order" values(3, '2015-08-30', 'CALL' , 10000, -1000);
insert into "order" values(4, '2015-08-05', 'CALL' , 20000, -3000);
insert into "order" values(4, '2015-08-18', 'TOUCH', 30000, -5000);
insert into "order" values(5, '2015-08-15', 'CALL' , 10000, -1000);
insert into "order" values(5, '2015-08-17', 'CALL' , 10000, null);
insert into "order" values(5, '2015-08-21', 'CALL' , 10000, -1000);
insert into "order" values(5, '2015-08-23', 'CALL' , 10000, -1000);
insert into "order" values(5, '2015-08-29', 'CALL' , 10000, -1000);

--============================================
-- inner join
--============================================
select cus.userid
     , count(ord.userid) as orders
  from "customer" cus
       inner join
       "order" ord
    on cus.userid = ord.userid
 group by cus.userid
 order by cus.userid
;

--============================================
-- left outer join
--============================================
select cus.userid
     , count(ord.userid) as orders
  from "customer" cus
       left outer join
       "order" ord
    on cus.userid = ord.userid
 group by cus.userid
 order by cus.userid
;

--============================================
-- right outer join
--============================================
select ord.userid
     , count(ord.userid) as orders
  from "customer" cus
       right outer join
       "order" ord
    on cus.userid = ord.userid
 group by ord.userid
 order by ord.userid
;

--============================================
-- cross join
--============================================
select cus.userid
     , count(ord.userid) as orders
  from "customer" cus
       cross join
       "order" ord
 group by cus.userid
 order by cus.userid
;

--============================================
-- un-correlated, correlated scalar subquery
--============================================
select (select username 
         from "customer" cus
        where cus.userid = ord.userid) as un_correlated
     , (select min(join_date)
          from "customer" cus)         as correlated
     , ord.userid
     , ord.order_date
  from "order" ord
 limit 10
;

--============================================
-- inline view
--============================================
select ord.*
  from (select ord.userid
             , ord.order_date
             , ord.amount
             , row_number() over (partition by userid order by order_date) as rk
          from "order" ord) ord
 where ord.rk = 1
;

--============================================
-- un-correlated subquery
--============================================
select *
  from "customer" cus
 where exists (select
                 from "order" ord
                where ord.userid = cus.userid)
;

--============================================
-- correlated subquery
--============================================
select *
  from "customer" cus
 where cus.userid in (select ord.userid
                       from "order" ord
                      group by ord.userid)
;
