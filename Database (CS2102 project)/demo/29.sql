\i schema.sql
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-01-01'::date, true, 3100, 'Manager'::text, '["area 1","area 2", "area 3", "area 4"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-01-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 2'::text, 'Blk 2'::text, '86329055'::text, 
'2@cs2102.com'::text, '2020-01-01'::date, false, 10, 'Instructor'::text, '["area 2"]'::json);
select add_employee('Part-time Instructor 3'::text, 'Blk 3'::text, '45429412'::text, 
'3@cs2102.com'::text, '2020-01-01'::date, false, 15, 'Instructor'::text, '["area 3","area 4"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-01-01'::date, true, 4100, 'Administrator'::text, '[]'::json);

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);
select add_course('Course 3'::text, 'Description 3'::text, 'area 3'::text, 10);
select add_course('Course 4'::text, 'Description 4'::text, 'area 4'::text, 10);

insert into Rooms values(1, 'room 1', 10);
select add_course_offering(1,1,20,'2020-01-01'::date,'2021-03-15'::date,7,5,'[["2021-03-25",9,1]]'::json);
select add_course_offering(2,4,30,'2020-01-02'::date,'2021-03-15'::date,7,5,'[["2021-03-26",9,1], ["2021-03-26",11,1]]'::json);

select add_course_offering(3,1,40,'2020-01-02'::date,'2021-04-15'::date,7,5,'[["2021-04-26",9,1]]'::json);
select add_course_offering(4,2,50,'2020-01-03'::date,'2021-04-15'::date,7,5,'[["2021-04-29",9,1], ["2021-04-29",11,1]]'::json);

select utime('2020-01-01');
select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-05-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);
select add_customer('Cus 3'::text, 'Blk 3'::text, '12345673'::text, 'c3@cs2102.com'::text, 3, '2021-05-20'::date, 'CVV_3'::text);
select add_customer('Cus 4'::text, 'Blk 4'::text, '12345674'::text, 'c4@cs2102.com'::text, 4, '2021-05-20'::date, 'CVV_4'::text);

select add_course_package('package 1'::text, 1, '2020-06-01'::date, '2021-12-01'::date, 1.5);
select add_course_package('package 2'::text, 2, '2020-06-01'::date, '2021-12-01'::date, 2.5);
select add_course_package('package 3'::text, 3, '2021-01-01'::date, '2021-06-01'::date, 3.5);

select utime('2021-03-01');
select register_session(1, 1, 1, 'credit card');
select register_session(2, 2, 1, 'credit card');
select buy_course_package(4,3);
select register_session(4, 2, 1, 'credit card');
select cancel_registration(4, 2);--early cancellation
select utime('2021-03-22');
select cancel_registration(2, 2);--late cancellation

select utime('2021-03-31');
select pay_salary();

select utime('2021-04-01');
select buy_course_package(3,1);
select register_session(3, 3, 1, 'credit card');
select register_session(3, 4, 2, 'redemption');
select buy_course_package(1,2);
select buy_course_package(2,3);
select register_session(1, 4, 1, 'redemption');
select register_session(2, 4, 1, 'redemption');
select cancel_registration(2, 4);
select register_session(2, 4, 1, 'credit card');
select utime('2021-04-01 00:00:01');
select cancel_registration(2, 4);
select view_summary_report(3);