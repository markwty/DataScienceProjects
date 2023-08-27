\i schema.sql
select utime('2021-04-12');
select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-05-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);
select add_customer('Cus 3'::text, 'Blk 3'::text, '12345673'::text, 'c3@cs2102.com'::text, 3, '2021-05-20'::date, 'CVV_3'::text);
select add_customer('Cus 4'::text, 'Blk 4'::text, '12345674'::text, 'c4@cs2102.com'::text, 4, '2021-05-20'::date, 'CVV_4'::text);
select add_customer('Cus 5'::text, 'Blk 5'::text, '12345675'::text, 'c5@cs2102.com'::text, 5, '2021-05-20'::date, 'CVV_5'::text);
select add_customer('Cus 6'::text, 'Blk 6'::text, '12345676'::text, 'c6@cs2102.com'::text, 6, '2021-05-20'::date, 'CVV_6'::text);
select add_customer('Cus 7'::text, 'Blk 7'::text, '12345677'::text, 'c7@cs2102.com'::text, 7, '2021-05-20'::date, 'CVV_7'::text);
select add_customer('Cus 8'::text, 'Blk 8'::text, '12345678'::text, 'c8@cs2102.com'::text, 8, '2021-05-20'::date, 'CVV_8'::text);

select add_course_package('package 1'::text, 1, '2020-06-01'::date, '2021-12-01'::date, 1.5);
select add_course_package('package 2'::text, 2, '2021-01-01'::date, '2021-12-01'::date, 2.5);
select add_course_package('package 3'::text, 3, '2021-01-02'::date, '2021-11-01'::date, 3.5);
select add_course_package('package 4'::text, 4, '2021-01-01'::date, '2021-06-01'::date, 4.5);

select buy_course_package(1,1);
select buy_course_package(2,1);
select buy_course_package(3,1);
select buy_course_package(4,2);
select buy_course_package(5,2);
select buy_course_package(6,3);
select buy_course_package(7,3);
select buy_course_package(8,4);
select top_packages(1);
select top_packages(2);
select top_packages(3);

select utime('2020-05-01');
select top_packages(10);