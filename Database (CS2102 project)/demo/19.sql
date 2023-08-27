\i schema.sql
select utime('2021-04-12');
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);

insert into Rooms values(1, 'room 1', 10);
insert into Rooms values(2, 'room 2', 1);
select add_course_offering(1,1,11.5,'2020-04-01'::date,'2021-04-15'::date,5,3,'[["2021-06-17",9,1],["2021-06-28",9,2]]'::json);

select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-05-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);

select update_course_session(1, 1, 2);--no session registered/redeemed yet
select register_session(1, 1, 1, 'credit card');
select update_course_session(1, 1, 2);
select * from Registers;

select update_course_session(1, 1, 1);
select add_course_package('package 1'::text, 1, '2021-01-01'::date, '2021-06-01'::date, 1.5);
select buy_course_package(2, 1);
select register_session(2, 1, 2, 'redemption');
select update_course_session(1, 1, 2);--room fully occupied

select cancel_registration(2, 1);
select update_course_session(1, 1, 1);

select utime('2021-06-23');
select update_course_session(1, 1, 2);--old session has passed
