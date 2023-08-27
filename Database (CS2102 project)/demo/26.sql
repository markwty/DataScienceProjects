\i schema.sql
select utime('2020-01-10');
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-01-01'::date, true, 3100, 'Manager'::text, '["area 1","area 2", "area 3"]'::json);
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
select add_course('Course 1b'::text, 'Description 1b'::text, 'area 1'::text, 10);

insert into Rooms values(1, 'room 1', 10);
select add_course_offering(1,1,50,'2020-01-01'::date,'2020-04-15'::date,7,5,'[["2020-10-16",9,1]]'::json);
select add_course_offering(2,2,50,'2020-01-02'::date,'2020-04-15'::date,15,5,'[["2020-06-18",9,1], ["2020-06-19",11,1]]'::json);
select add_course_offering(3,2,50,'2020-01-05'::date,'2021-04-15'::date,15,5,'[["2021-06-28",9,1], ["2021-06-29",11,1]]'::json);
select add_course_offering(4,3,50,'2020-01-03'::date,'2021-04-15'::date,15,5,'[["2021-06-22",9,1], ["2021-06-23",11,1]]'::json);
select add_course_offering(5,4,50,'2020-01-04'::date,'2021-04-15'::date,15,5,'[["2021-06-24",9,1], ["2021-06-25",11,1]]'::json);

select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-01-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);
select add_customer('Cus 3'::text, 'Blk 3'::text, '12345673'::text, 'c3@cs2102.com'::text, 3, '2021-05-20'::date, 'CVV_3'::text);

select register_session(1, 1, 1, 'credit card');
select utime('2021-04-12');
select promote_courses();--only offerings that still accepts registrations in course area 1 are promoted

select register_session(2, 3, 1, 'credit card');
select promote_courses();--customer 2 is active
select cancel_registration(2, 3);
select promote_courses();--cancellation does not change state to inactive

select utime('2020-01-20');
select add_course_package('package 1'::text, 1, '2020-01-01'::date, '2020-12-01'::date, 1.5);
select buy_course_package(1,1);
select register_session(1, 2, 1, 'redemption');
select utime('2021-04-12');
select promote_courses();--also works for redemption, now there are 2 old offerings

select utime('2020-01-21');
select register_session(1, 3, 1, 'credit card');
select cancel_registration(1, 3);
select utime('2020-01-21 00:00:01');
select register_session(1, 3, 1, 'credit card');
select utime('2021-04-12');
select promote_courses();--now all 3 recent course offerings registered including those cancelled are all from 'area 2'

