\i schema.sql
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2"]'::json);
select add_employee('Manager 2'::text, 'Blk 2'::text, '86329057'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, true, 3200, 'Manager'::text, '["area 3"]'::json);
select add_employee('Manager 3'::text, 'Blk 3'::text, '45429414'::text, 
'3@cs2102.com'::text, '2020-11-01'::date, true, 3300, 'Manager'::text, '["area 4", "area 5"]'::json);

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);
select add_course('Course 3'::text, 'Description 3'::text, 'area 3'::text, 10);
select add_course('Course 4'::text, 'Description 4'::text, 'area 4'::text, 10);
select add_course('Course 5'::text, 'Description 5'::text, 'area 5'::text, 10);

select * from Courses;