\i schema.sql
select utime('2021-04-12');
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1","area 2"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 1'::text, 'Blk 1'::text, '65999427'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, false, 5, 'Instructor'::text, '["area 2"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);

insert into Rooms values(1, 'room 1', 10);
insert into Rooms values(2, 'room 2', 30);
insert into Rooms values(3, 'room 3', 2);
insert into Rooms values(4, 'room 4', 3);
insert into Rooms values(5, 'room 5', 30);
select add_course_offering(1,1,50,'2020-04-01'::date,'2021-04-15'::date,7,4,'[["2021-06-17",9,1]]'::json);
select add_course_offering(2,2,50,'2020-04-02'::date,'2021-04-15'::date,15,4,'[["2021-06-17",9,2], ["2021-06-17",11,2]]'::json);

select update_room(1, 1, 2);--room in use
select update_room(1, 1, 5);
select update_room(1, 1, 3);--target number for registrations is more than seating capacity
select update_room(1, 1, 1);

select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-05-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);
select add_customer('Cus 3'::text, 'Blk 3'::text, '12345673'::text, 'c3@cs2102.com'::text, 3, '2021-05-20'::date, 'CVV_3'::text);

select register_session(1, 2, 1, 'credit card');
select register_session(2, 2, 1, 'credit card');
select update_room(2, 1, 3);
select update_room(2, 1, 4);
select register_session(3, 2, 1, 'credit card');
select update_room(2, 1, 3);--room too small to hold all people who registered already

select * from Sessions;
select utime('2021-06-20');
select update_room(1, 1, 2);



