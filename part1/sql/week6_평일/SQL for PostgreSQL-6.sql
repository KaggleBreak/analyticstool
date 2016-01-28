--============================================
-- Tabel : Customers
--============================================
drop table if exists customers;
create table customers (
    userid    integer,
    username  varchar(10),
    join_date varchar(10)
)
;
insert into customers
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


--============================================
-- 1. 회원별로 주문의 순서를 알고 싶다.(중복 배제)
--============================================
select ord.userid
     , ord.order_date
     , row_number() over (partition by ord.userid order by order_date) as rk
  from orders ord
;

--============================================
-- 2. 주문의 방법의 TOUCH 인 주문들 중 가장 먼저 주문한 주문을 알고 싶다.(중복 허용)
--============================================
select ord.userid
     , ord.order_date
     , ord.method
     , ord.rk
  from (select ord.userid
             , ord.order_date
             , ord.method
             , dense_rank() over (order by order_date) as rk -- rank 가능
          from orders ord
         where ord.method = 'TOUCH') ord
 where ord.rk = 1
;

--============================================
-- 3. 주문의 방법이 TOUCH인 주문들 중 TOP 3의 주문 정보를 알고 싶다.(중복 허용, 무조건 1,2,3 포함)
--============================================
select ord.userid
     , ord.order_date
     , ord.method
     , ord.rk
  from (select ord.userid
             , ord.order_date
             , ord.method
             , dense_rank() over (order by order_date) as rk
          from orders ord
         where ord.method = 'TOUCH') ord
 where ord.rk between 1 and 3
;

--============================================
-- 4. 회원 1과 3의 각 주문 정보를 회원의 가장 빠른 주문 일자와 함께 보고 싶다.
--============================================
select ord.userid
     , first_value(order_date) over (partition by ord.userid order by order_date) as first_order_date
     , ord.order_date
     , ord.method
  from orders ord
 where ord.userid in (1, 3)
;

--============================================
-- 5. 회원 4과 5의 각 주문의 주문 금액과 회원의 전체 주문 금액에서의 비중을 보고 싶다.
--============================================
select ord.userid
     , ord.order_date
     , ord.amount
     , sum(ord.amount) over (partition by ord.userid)              as total_amount
     , round(ord.amount::numeric / sum(ord.amount) over (partition by ord.userid) * 100, 2) as amount_rate
  from orders ord
 where ord.userid in (4, 5)
;
