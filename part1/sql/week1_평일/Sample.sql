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
