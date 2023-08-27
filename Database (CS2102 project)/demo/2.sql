\i schema.sql
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2"]'::json);

select remove_employee(1, '2021-04-21');--error for manager
delete from Course_areas;
select remove_employee(1, '2021-04-21');
select * from Employees;

\i schema.sql
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 1'::text, 'Blk 1'::text, '65999427'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, false, 5, 'Instructor'::text, '["area 2"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);
select add_employee('Admin 2'::text, 'Blk 2'::text, '86329054'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, true, 4200, 'Administrator'::text, '[]'::json);

select remove_employee(2, '2021-04-21');
select * from Employees;

insert into Rooms values(1, 'room 1', 5);
select add_course('Course 1'::text, 'Description 1'::text, 'area 2'::text, 10);
select add_course_offering(1,1,11.5,'2020-10-01'::date,'2020-10-01'::date,7,4,'[["2020-10-12",9,1], ["2020-10-13",10,1]]'::json);
select remove_employee(3, '2020-10-12');--error for instructor
select remove_employee(3, '2021-04-21');
select * from Employees;

select remove_employee(4, '2020-09-30');--error for administrator
select * from Employees;
select remove_employee(5, '2020-10-02');
