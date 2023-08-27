\i schema.sql
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-01-01'::date, true, 3100, 'Manager'::text, '["area 1","area 2"]'::json);
select add_employee('Manager 2'::text, 'Blk 2'::text, '86329057'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, true, 3200, 'Manager'::text, '["area 3"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-01-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 2'::text, 'Blk 2'::text, '86329055'::text, 
'2@cs2102.com'::text, '2020-01-01'::date, false, 10, 'Instructor'::text, '["area 2"]'::json);
select add_employee('Part-time Instructor 3'::text, 'Blk 3'::text, '45429412'::text, 
'3@cs2102.com'::text, '2020-01-01'::date, false, 15, 'Instructor'::text, '["area 3"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-01-01'::date, true, 4100, 'Administrator'::text, '[]'::json);

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);
select add_course('Course 3'::text, 'Description 3'::text, 'area 3'::text, 10);
select add_course('Course 1b'::text, 'Description 4'::text, 'area 1'::text, 10);

insert into Rooms values(1, 'room 1', 10);
select add_course_offering(1,1,20,'2020-01-01'::date,'2020-03-15'::date,7,6,'[["2020-03-25",9,1]]'::json);--not counted eventually because end date is not within this year
select add_course_offering(2,1,30,'2021-01-02'::date,'2021-03-15'::date,7,6,'[["2021-03-30",9,1], ["2021-03-29",11,1]]'::json);
select add_course_offering(3,4,40,'2021-01-02'::date,'2021-03-15'::date,7,6,'[["2021-03-26",9,1], ["2021-03-26",11,1]]'::json);

select add_course_offering(4,2,50,'2020-01-02'::date,'2021-04-15'::date,7,6,'[["2021-04-26",9,1]]'::json);
select add_course_offering(5,3,60,'2020-01-03'::date,'2021-04-15'::date,7,6,'[["2021-04-29",9,1], ["2021-04-29",11,1]]'::json);

select utime('2020-01-01');
select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-05-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);
select add_customer('Cus 3'::text, 'Blk 3'::text, '12345673'::text, 'c3@cs2102.com'::text, 3, '2021-05-20'::date, 'CVV_3'::text);
select add_customer('Cus 4'::text, 'Blk 4'::text, '12345674'::text, 'c4@cs2102.com'::text, 4, '2021-05-20'::date, 'CVV_4'::text);

select add_course_package('package 1'::text, 1, '2020-06-01'::date, '2021-12-01'::date, 1.5);
select add_course_package('package 2'::text, 2, '2020-06-01'::date, '2021-12-01'::date, 2.5);
select add_course_package('package 3'::text, 3, '2021-01-01'::date, '2021-06-01'::date, 3.5);

select register_session(1, 1, 1, 'credit card');
select register_session(2, 2, 1, 'credit card');
select register_session(2, 3, 2, 'credit card');

select utime('2021-01-01');
select buy_course_package(2, 3);
select register_session(2, 4, 1, 'redemption');

select buy_course_package(3, 2);
select register_session(3, 5, 1, 'redemption');
--select view_manager_report();

select add_course_offering(6,1,40,'2021-01-04'::date,'2021-03-15'::date,7,6,'[["2021-04-30",9,1]]'::json);
select register_session(4, 6, 1, 'credit card');
select view_manager_report();