\i schema.sql
select utime('2021-04-12');
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 1'::text, 'Blk 1'::text, '65999427'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, false, 5, 'Instructor'::text, '["area 2"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);

insert into Rooms values(1, 'room 1', 10);
select add_course_offering(1,1,11.5,'2020-10-01'::date,'2020-10-01'::date,2,4,'[["2021-04-12",9,1]]'::json);
select add_course_offering(2,1,11.5,'2020-04-01'::date,'2021-04-15'::date,2,4,'[["2021-06-17",9,1],["2021-06-28",9,1]]'::json);

select get_available_course_offerings();--registration deadline passed for course_offering_id=1
select utime('2020-10-01');
select get_available_course_offerings();
select utime('2021-04-12');
select get_available_course_offerings();

select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-05-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);

select register_session(1, 2, 1, 'credit card');
select get_available_course_offerings();

select add_course_package('package 1'::text, 1, '2021-01-01'::date, '2021-06-01'::date, 2.5);
select buy_course_package(2, 1);
select register_session(2, 2, 1, 'redemption');
select get_available_course_offerings();

select cancel_registration(2, 2);
select get_available_course_offerings();
