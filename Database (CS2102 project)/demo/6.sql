\i schema.sql
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2","area 3","area 4"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 1'::text, 'Blk 1'::text, '65999427'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, false, 5, 'Instructor'::text, '["area 2","area 4"]'::json);
select add_employee('Part-time Instructor 2'::text, 'Blk 2'::text, '86329055'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, false, 10, 'Instructor'::text, '["area 2"]'::json);
select add_employee('Part-time Instructor 3'::text, 'Blk 3'::text, '45429412'::text, 
'3@cs2102.com'::text, '2020-11-01'::date, false, 15, 'Instructor'::text, '["area 3"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);
select * from Employees;

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);
select add_course('Course 3'::text, 'Description 3'::text, 'area 3'::text, 10);
select add_course('Course 4'::text, 'Description 4'::text, 'area 4'::text, 10);

select find_instructors(1, '2021-04-12', 10);--okay
insert into Rooms values(1, 'room 1', 10);
select add_course_offering(1,1,11.5,'2020-10-01'::date,'2020-10-01'::date,5,6,'[["2021-04-12",9,1]]'::json);
select find_instructors(1, '2021-04-12', 10);--clash

select find_instructors(2, '2020-10-26', 10);--shared specialisation
select add_course_offering(2,4,12.5,'2020-10-02'::date,'2020-10-02'::date,5,6,'[
["2020-10-12",9,1], ["2020-10-12",11,1],["2020-10-12",14,1], ["2020-10-12",16,1],
["2020-10-13",9,1], ["2020-10-13",11,1],["2020-10-13",14,1], ["2020-10-13",16,1],
["2020-10-14",9,1], ["2020-10-14",11,1],["2020-10-14",14,1], ["2020-10-14",16,1],
["2020-10-15",9,1], ["2020-10-15",11,1],["2020-10-15",14,1], ["2020-10-15",16,1],
["2020-10-16",9,1], ["2020-10-16",11,1],["2020-10-16",14,1], ["2020-10-16",16,1],
["2020-10-19",9,1], ["2020-10-19",11,1],["2020-10-19",14,1], ["2020-10-19",16,1],
["2020-10-20",9,1], ["2020-10-20",11,1],["2020-10-20",14,1], ["2020-10-20",16,1],
["2020-10-21",9,1], ["2020-10-21",11,1]]'::json);
select count(*) from Sessions where eid=3;
select find_instructors(2, '2020-10-26', 10);--30 hours maximum every month

select find_instructors(2, '2021-04-12', 12);--timing issue
select find_instructors(2, '2021-04-11', 10);--Sunday
select find_instructors(3, '2021-04-12', 10);
select remove_employee(5, '2021-04-10');
select find_instructors(3, '2021-04-12', 10);--departed

