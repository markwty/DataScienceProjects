\i schema.sql
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2","area 3","area 4","area 5", "area 6"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 1'::text, 'Blk 1'::text, '65999427'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, false, 5, 'Instructor'::text, '["area 2", "area 5"]'::json);
select add_employee('Part-time Instructor 2'::text, 'Blk 2'::text, '86329055'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, false, 10, 'Instructor'::text, '["area 2", "area 6"]'::json);
select add_employee('Part-time Instructor 3'::text, 'Blk 3'::text, '45429412'::text, 
'3@cs2102.com'::text, '2020-10-01'::date, false, 15, 'Instructor'::text, '["area 3"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);
select * from Employees;

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);
select add_course('Course 3'::text, 'Description 3'::text, 'area 3'::text, 10);
select add_course('Course 4'::text, 'Description 4'::text, 'area 4'::text, 10);
select add_course('Course 5'::text, 'Description 5'::text, 'area 5'::text, 10);
select add_course('Course 6'::text, 'Description 6'::text, 'area 6'::text, 10);
insert into Rooms values(1, 'room 1', 10);

select add_course_offering(1,1,11.5,'2020-10-01'::date,'2020-10-01'::date,5,6,'[["2021-04-12",10,1],["2021-04-30",14,1]]'::json);

select add_course_offering(2,4,11.5,'2020-10-01'::date,'2020-10-01'::date,5,6,'[["2021-04-13",10,1]]'::json);
--no instructor that specialises, cannot allocate

select add_course_offering(2,3,11.5,'2020-10-01'::date,'2020-10-01'::date,5,6,'[["2021-04-13",9,1],["2021-04-13",10,1]]'::json);
--instructor needs rest, cannot allocate
select add_course_offering(2,3,11.5,'2020-10-01'::date,'2020-10-01'::date,5,6,'[["2021-04-13",9,1],["2021-04-13",11,1]]'::json);

select add_course_offering(3,3,12.5,'2020-10-02'::date,'2020-10-02'::date,5,6,'[
["2020-10-12",9,1], ["2020-10-12",11,1],["2020-10-12",14,1], ["2020-10-12",16,1],
["2020-10-13",9,1], ["2020-10-13",11,1],["2020-10-13",14,1], ["2020-10-13",16,1],
["2020-10-14",9,1], ["2020-10-14",11,1],["2020-10-14",14,1], ["2020-10-14",16,1],
["2020-10-15",9,1], ["2020-10-15",11,1],["2020-10-15",14,1], ["2020-10-15",16,1],
["2020-10-16",9,1], ["2020-10-16",11,1],["2020-10-16",14,1], ["2020-10-16",16,1],
["2020-10-19",9,1], ["2020-10-19",11,1],["2020-10-19",14,1], ["2020-10-19",16,1],
["2020-10-20",9,1], ["2020-10-20",11,1],["2020-10-20",14,1], ["2020-10-20",16,1],
["2020-10-21",9,1], ["2020-10-21",11,1]]'::json);
select add_course_offering(4,3,11.5,'2020-10-03'::date,'2020-10-03'::date,5,6,'[["2020-10-26",9,1]]'::json);
--30 hours maximum reached, cannot allocate

select add_course_offering(4,2,11.5,'2020-10-01'::date,'2020-10-01'::date,15,3,'[["2021-04-13",10,1]]'::json);--target number to registered more than seating capacity

select add_course_offering(4,2,11.5,'2020-10-01'::date,'2020-10-01'::date,0,3,'[]'::json);--need at least 1 session


--the session with the most violations in timings is allocated first
select add_course_offering(5,5,11.5,'2020-10-01'::date,'2020-10-01'::date,5,6,'[["2021-04-15",11,1]]'::json);
select add_course_offering(6,2,11.5,'2020-10-02'::date,'2020-10-02'::date,5,6,'[["2021-04-15",9,1], ["2021-04-15",10,1]]'::json);

select add_course_offering(7,6,11.5,'2020-10-01'::date,'2020-10-01'::date,5,6,'[["2021-04-16",11,1]]'::json);
select add_course_offering(8,2,11.5,'2020-10-03'::date,'2020-10-03'::date,5,6,'[["2021-04-16",9,1], ["2021-04-16",10,1]]'::json);
--can still allocate