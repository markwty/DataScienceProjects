\i schema.sql
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text,
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);
select * from Employees;

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);

insert into Rooms values(1, 'room 1', 10);
insert into Rooms values(2, 'room 2', 10);
insert into Rooms values(3, 'room 3', 10);
select find_rooms('2021-04-12', 10, 2);
select add_course_offering(1,1,11.5,'2020-10-01'::date,'2020-10-01'::date,5,3,'[["2021-04-12",10,1],["2021-04-12",14,1]]'::json);
select find_rooms('2021-04-12', 10, 2);--room 1 is used
select find_rooms('2021-04-12', 15, 2);
