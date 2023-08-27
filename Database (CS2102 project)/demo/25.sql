\i schema.sql
select utime('2021-04-12');
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2","area 3","area 4"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 1'::text, 'Blk 1'::text, '65999427'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, false, 5, 'Instructor'::text, '["area 2","area 4"]'::json);
select add_employee('Part-time Instructor 2'::text, 'Blk 2'::text, '86329055'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, false, 10, 'Instructor'::text, '["area 3"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);
select add_employee('Admin 2'::text, 'Blk 2'::text, '86329054'::text, 
'2@cs2102.com'::text, '2021-04-20'::date, true, 4200, 'Administrator'::text, '[]'::json);

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);
select add_course('Course 3'::text, 'Description 3'::text, 'area 3'::text, 10);
select add_course('Course 4'::text, 'Description 4'::text, 'area 4'::text, 10);

insert into Rooms values(1, 'room 1', 10);
insert into Rooms values(2, 'room 2', 10);
select add_course_offering(1,1,11.5,'2020-10-01'::date,'2020-10-01'::date,5,5,'[["2021-04-12",10,1],["2021-04-13",14,1]]'::json);
select add_course_offering(2,4,12.5,'2020-10-02'::date,'2020-10-02'::date,5,5,'[
["2021-04-12",9,1], ["2021-04-12",11,1],["2021-04-12",14,1], ["2021-04-12",16,1],
["2021-04-13",9,1], ["2021-04-13",11,1],["2021-04-13",15,1], ["2021-04-13",17,1],
["2021-04-14",9,1], ["2021-04-14",11,1],["2021-04-14",14,1], ["2021-04-14",16,1],
["2021-04-15",9,1], ["2021-04-15",11,1],["2021-04-15",14,1], ["2021-04-15",16,1],
["2021-04-16",9,1], ["2021-04-16",11,1],["2021-04-16",14,1], ["2021-04-16",16,1],
["2021-04-19",9,1], ["2021-04-19",11,1],["2021-04-19",14,1], ["2021-04-19",16,1],
["2021-04-20",9,1], ["2021-04-20",11,1],["2021-04-20",14,1], ["2021-04-20",16,1],
["2021-04-21",9,1], ["2021-04-21",11,1]]'::json);
select count(*) from Sessions where eid=3;
select add_course_offering(3,3,11.5,'2020-10-01'::date,'2020-10-01'::date,5,5,'[["2021-04-12",10,2],["2021-04-13",14,2]]'::json);

select remove_employee(2, '2021-04-15');
select pay_salary();
select * from pay_slips;

select utime('2021-04-30');
select pay_salary();
select * from pay_slips;



