\i schema.sql
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 1'::text, 'Blk 1'::text, '65999427'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, false, 5, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);

select * from Employees;
select * from Part_time_emp;
select * from Full_time_emp;
select * from Full_time_instructors;
select * from Part_time_instructors;
select * from Administrators;
