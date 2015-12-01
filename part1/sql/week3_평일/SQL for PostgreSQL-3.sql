
SQL - 1 : 회원의 첫 주문일자와 마지막 주문일자를 알고 싶다.
-- GROUP BY를 이해 하였는가?

select userid
     , min(order_date) as first_order_date
     , max(order_date) as last_order_date
  from "order"
 group by userid
 order by userid
;

SQL - 2 : 회원의 첫 주문일자와 마지막 주문일자의 간격을 알고 싶다.
-- 변환함수를 잘 이해 하였는가?

select userid
     , to_date(max(order_date), 'YYYY-MM-DD') - to_date(min(order_date), 'YYYY-MM-DD') as order_range
     , min(order_date) as first_order_date
     , max(order_date) as last_order_date
  from "order"
 group by userid
 order by userid
;

SQL - 3 : 회원별 TOUCH와 CALL 주문수를 알고 싶다.
-- CASE를 사용하여 항목별로 집계를 할 수 있는가? - COUNT()

select userid
     , count(userid)                                     as total_orders
     , count(case when method = 'TOUCH' then userid end) as touch_orders
     , count(case when method = 'CALL'  then userid end) as call_orders
  from "order"
 group by userid
 order by userid
;

SQL - 4 : 회원별 TOUCH와 CALL 전체주문금액을 알고 싶다.
-- CASE를 사용하여 항목별로 집계를 할 수 있는가? - SUM()

select userid
     , sum(amount)                                     as total_amount
     , sum(case when method = 'TOUCH' then amount end) as touch_amount
     , sum(case when method = 'CALL'  then amount end) as call_amount
  from "order"
 group by userid
 order by userid
;

-- NULL을 0으로 처리
select userid
     , coalesce(sum(amount), 0)                                     as total_amount
     , coalesce(sum(case when method = 'TOUCH' then amount end), 0) as touch_amount
     , coalesce(sum(case when method = 'CALL'  then amount end), 0) as call_amount
  from "order"
 group by userid
 order by userid
;

SQL - 5 : 회원별 TOUCH와 CALL 평균주문금액을 알고 싶다.
-- CASE를 사용하여 항목별로 집계를 할 수 있는가? - AVG()

select userid
     , avg(amount)                                     as total_amount_avg
     , avg(case when method = 'TOUCH' then amount end) as touch_amount_avg
     , avg(case when method = 'CALL'  then amount end) as call_amount_avg
  from "order"
 group by userid
 order by userid
;

-- 반올림
select userid
     , round(avg(amount), 1)                                     as total_amount_avg
     , round(avg(case when method = 'TOUCH' then amount end), 1) as touch_amount_avg
     , round(avg(case when method = 'CALL'  then amount end), 1) as call_amount_avg
  from "order"
 group by userid
 order by userid
;

-- 정수로 변환
select userid
     , avg(amount)::integer                                     as total_amount_avg
     , avg(case when method = 'TOUCH' then amount end)::integer as touch_amount_avg
     , avg(case when method = 'CALL'  then amount end)::integer as call_amount_avg
  from "order"
 group by userid
 order by userid
;

SQL - 6 : 회원별 TOUCH와 CALL 전체주문금액(할인된)을 알고 싶다.
-- NULL을 잘 처리할 수 있는가?

-- NULL 처리후 연산
select userid
     , sum(amount + coalesce(discount, 0))                                     as total_amount_discount
     , sum(case when method = 'TOUCH' then amount + coalesce(discount, 0) end) as touch_amount_discount
     , sum(case when method = 'CALL'  then amount + coalesce(discount, 0) end) as call_amount_discount
  from "order"
 group by userid
 order by userid
;

-- 따로 계산
select userid
     , sum(amount + coalesce(discount, 0))                  as total_amount_discount
     , sum(case when method = 'TOUCH' then amount   end) +
       sum(case when method = 'TOUCH' then discount end)    as touch_amount_discount
     , sum(case when method = 'CALL'  then amount   end) +
       sum(case when method = 'CALL'  then discount end)    as call_amount_discount
  from "order"
 group by userid
 order by userid
;

SQL - 7 : 8월 11일에서 8월 20일까지 주문이 2개 이상인 회원을 알고 싶다.
-- WHERE 조건절과 HAVING절을 잘 이해하고 있는가?

select userid
     , count(userid) as orders
  from "order"
 where order_date between '2015-08-11' and '2015-08-20'
 group by userid
having count(userid) >= 2
;

SQL - 8 : 8월 10일을 포함한 향후 10일간의 전체주문금액(할인된)이 2만원 이상인 회원을 알고 싶다.
-- WHERE 조건절과 HAVING절을 잘 이해하고 있는가?

select userid
     , sum(amount - coalesce(discount, 0)) as amount_discount
  from "order"
 where order_date between '2015-08-11' and to_char(to_date('2015-08-11', 'YYYY-MM-DD') + '9 days'::interval, 'YYYY-MM-DD')
 group by userid
having sum(amount - coalesce(discount, 0)) >= 20000
;

SQL - 9 : 8월 10일에서 8월 15일까지 주문한 회원수와 주문수를 알고 싶다.
-- DISTINCT를 잘 이해하고 있는가?

select count(distinct userid) as users
     , count(userid)          as orders
  from "order"
 where order_date between '2015-08-10' and '2015-08-15'
;

SQL - 10 : 8월 10일에서 8월 15일까지 TOUCH와 CALL로 주문한 회원수와 주문수를 각각 알고 싶다.
-- DISTINCT를 잘 이해하고 있는가?

select count(distinct case when method = 'TOUCH' then userid end) as touch_users
     , count(distinct case when method = 'CALL'  then userid end) as call_users
     , count(         case when method = 'TOUCH' then userid end) as touch_orders
     , count(         case when method = 'CALL'  then userid end) as call_orders
  from "order"
 where order_date between '2015-08-10' and '2015-08-15'
;
