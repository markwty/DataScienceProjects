\i schema.sql
select utime('2021-04-12');
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 1'::text, 'Blk 1'::text, '65999427'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, false, 5, 'Instructor'::text, '["area 1","area 2"]'::json);
select add_employee('Part-time Instructor 2'::text, 'Blk 2'::text, '86329055'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, false, 10, 'Instructor'::text, '["area 2"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);
select remove_employee(4, '2021-06-01');
select * from Employees;

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);

insert into Rooms values(1, 'room 1', 10);
select add_course_offering(1,1,50,'2020-04-01'::date,'2021-04-15'::date,5,5,'[["2021-06-17",9,1]]'::json);
select add_course_offering(2,2,50,'2020-04-02'::date,'2021-04-15'::date,5,5,'[["2021-06-16",11,1]]'::json);
select add_course_offering(3,2,12.5,'2020-10-02'::date,'2020-10-02'::date,5,5,'[
["2020-10-12",9,1], ["2020-10-12",11,1],["2020-10-12",14,1], ["2020-10-12",16,1],
["2020-10-13",9,1], ["2020-10-13",11,1],["2020-10-13",14,1], ["2020-10-13",16,1],
["2020-10-14",9,1], ["2020-10-14",11,1],["2020-10-14",14,1], ["2020-10-14",16,1],
["2020-10-15",9,1], ["2020-10-15",11,1],["2020-10-15",14,1], ["2020-10-15",16,1],
["2020-10-16",9,1], ["2020-10-16",11,1],["2020-10-16",14,1], ["2020-10-16",16,1],
["2020-10-19",9,1], ["2020-10-19",11,1],["2020-10-19",14,1], ["2020-10-19",16,1],
["2020-10-20",9,1], ["2020-10-20",11,1],["2020-10-20",14,1], ["2020-10-20",16,1],
["2020-10-21",9,1], ["2020-10-21",11,1]]'::json);

select * from Sessions;
select update_instructor(1, 1, 3);
select * from Sessions;

select update_instructor(2, 1, 2);--instructor does not specialise
select update_instructor(2, 1, 4);--departed

select update_instructor(1, 1, 2);
select update_instructor(1, 1, 3);
select utime('2021-06-20');
select update_instructor(1, 1, 2);

