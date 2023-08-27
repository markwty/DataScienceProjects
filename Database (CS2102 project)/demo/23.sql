\i schema.sql
select utime('2021-04-12');
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);

insert into Rooms values(1, 'room 1', 10);
select add_course_offering(1,1,50,'2020-04-01'::date,'2021-04-15'::date,7,3,'[["2021-06-17",9,1]]'::json);
select add_course_offering(2,1,50,'2020-04-02'::date,'2021-04-15'::date,15,3,'[["2021-06-18",9,1], ["2021-06-21",11,1]]'::json);
select add_course_offering(3,1,50,'2020-04-03'::date,'2021-04-15'::date,15,3,'[["2021-06-22",9,1], ["2021-06-23",11,1]]'::json);
select add_course_offering(4,1,50,'2020-04-04'::date,'2021-04-15'::date,15,3,'[["2021-06-24",9,1], ["2021-06-25",11,1]]'::json);
select * from Offerings;

select remove_session(1, 1);--Each offering must have at least 1 session
select remove_session(2, 1);--Allows the seating capacity to fall below target number for registration
select * from Offerings;--updated start_date/end_date

select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-05-20'::date, 'CVV_1'::text);

select register_session(1, 3, 1, 'credit card');
select remove_session(3, 1);--cannot remove, someone is registered
select cancel_registration(1, 3);
select remove_session(3, 1);
--there is a need the records so cannot use on delete cascade
--the foreign keys references to Sessions has to be dropped in Cancels, Registers and Redeems

select utime('2021-06-25');
select remove_session(4, 1);--Session is over, cannot remove it


