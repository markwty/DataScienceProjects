\i schema.sql
select utime('2021-04-12');
select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-01-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);
select add_customer('Cus 3'::text, 'Blk 3'::text, '12345673'::text, 'c3@cs2102.com'::text, 3, '2021-05-20'::date, 'CVV_3'::text);

select add_course_package('package 1'::text, 1, '2020-06-01'::date, '2020-12-01'::date, 1.5);
select add_course_package('package 2'::text, 2, '2021-01-01'::date, '2021-06-01'::date, 2.5);
select add_course_package('package 3'::text, 3, '2021-06-01'::date, '2021-12-01'::date, 3.5);
select add_course_package('package 4'::text, 4, '2021-04-01'::date, '2021-08-01'::date, 2.5);
select * from Course_packages;

select buy_course_package(1, 2);--credit card has expired
select update_credit_card(1, 11, '2021-06-01'::date, 'CVV_11'::text);
select buy_course_package(1, 2);
select * from Buys;

select buy_course_package(2, 3);--not available for sale
select buy_course_package(2, 4);
select * from Buys;
select buy_course_package(2, 2);
select * from Buys;
