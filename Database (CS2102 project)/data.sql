select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2"]'::json);
select add_employee('Manager 2'::text, 'Blk 2'::text, '86329057'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, true, 3200, 'Manager'::text, '["area 3"]'::json);
select add_employee('Manager 3'::text, 'Blk 3'::text, '45429414'::text, 
'3@cs2102.com'::text, '2020-11-01'::date, true, 3300, 'Manager'::text, '["area 4", "area 5"]'::json);
select add_employee('Manager 4'::text, 'Blk 4'::text, '37580071'::text, 
'4@cs2102.com'::text, '2020-11-01'::date, true, 3400.50, 'Manager'::text, '["area 6"]'::json);
select add_employee('Manager 5'::text, 'Blk 5'::text, '02402524'::text, 
'5@cs2102.com'::text, '2020-12-01'::date, true, 3500, 'Manager'::text, '["area 7"]'::json);
select add_employee('Manager 6'::text, 'Blk 6'::text, '32379798'::text, 
'6@cs2102.com'::text, '2020-12-01'::date, true, 3600, 'Manager'::text, '["area 8"]'::json);
select add_employee('Manager 7'::text, 'Blk 7'::text, '64524714'::text, 
'7@cs2102.com'::text, '2021-01-01'::date, true, 3700, 'Manager'::text, '["area 9"]'::json);
select add_employee('Manager 8'::text, 'Blk 8'::text, '79617373'::text, 
'8@cs2102.com'::text, '2021-01-01'::date, true, 3800, 'Manager'::text, '["area 10"]'::json);
select add_employee('Manager 9'::text, 'Blk 9'::text, '51876126'::text, 
'9@cs2102.com'::text, '2021-02-01'::date, true, 3700, 'Manager'::text, '["area 11"]'::json);
select add_employee('Manager 10'::text, 'Blk 10'::text, '21883269'::text, 
'10@cs2102.com'::text, '2021-02-01'::date, true, 3800, 'Manager'::text, '["area 12"]'::json);

select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Full-time Instructor 2'::text, 'Blk 2'::text, '86329056'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, true, 2200, 'Instructor'::text, '["area 2"]'::json);
select add_employee('Full-time Instructor 3'::text, 'Blk 3'::text, '45429413'::text, 
'3@cs2102.com'::text, '2020-11-01'::date, true, 2300, 'Instructor'::text, '["area 3"]'::json);
select add_employee('Full-time Instructor 4'::text, 'Blk 4'::text, '37580070'::text, 
'4@cs2102.com'::text, '2020-11-01'::date, true, 2400.50, 'Instructor'::text, '["area 2", "area 4"]'::json);
select add_employee('Full-time Instructor 5'::text, 'Blk 5'::text, '02402523'::text, 
'5@cs2102.com'::text, '2020-12-01'::date, true, 2500, 'Instructor'::text, '["area 1", "area 5"]'::json);
select add_employee('Full-time Instructor 6'::text, 'Blk 6'::text, '32379797'::text, 
'6@cs2102.com'::text, '2020-12-01'::date, true, 2600, 'Instructor'::text, '["area 2", "area 3","area 6"]'::json);
select add_employee('Full-time Instructor 7'::text, 'Blk 7'::text, '64524713'::text, 
'7@cs2102.com'::text, '2021-01-01'::date, true, 2700, 'Instructor'::text, '["area 7"]'::json);
select add_employee('Full-time Instructor 8'::text, 'Blk 8'::text, '79617372'::text, 
'8@cs2102.com'::text, '2021-01-01'::date, true, 2800, 'Instructor'::text, '["area 2", "area 4", "area 8"]'::json);
select add_employee('Full-time Instructor 9'::text, 'Blk 9'::text, '51876125'::text, 
'9@cs2102.com'::text, '2021-02-01'::date, true, 2700, 'Instructor'::text, '["area 3", "area 9"]'::json);
select add_employee('Full-time Instructor 10'::text, 'Blk 10'::text, '21883268'::text, 
'10@cs2102.com'::text, '2021-02-01'::date, true, 2800, 'Instructor'::text, '["area 2", "area 5", "area 10", "area 11"]'::json);

select add_employee('Part-time Instructor 1'::text, 'Blk 1'::text, '65999427'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, false, 5, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 2'::text, 'Blk 2'::text, '86329055'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, false, 10, 'Instructor'::text, '["area 1", "area 2"]'::json);
select add_employee('Part-time Instructor 3'::text, 'Blk 3'::text, '45429412'::text, 
'3@cs2102.com'::text, '2020-11-01'::date, false, 15, 'Instructor'::text, '["area 3"]'::json);
select add_employee('Part-time Instructor 4'::text, 'Blk 4'::text, '37580069'::text, 
'4@cs2102.com'::text, '2020-11-01'::date, false, 20.50, 'Instructor'::text, '["area 1", "area 2", "area 4"]'::json);
select add_employee('Part-time Instructor 5'::text, 'Blk 5'::text, '02402522'::text, 
'5@cs2102.com'::text, '2020-12-01'::date, false, 25, 'Instructor'::text, '["area 3", "area 5"]'::json);
select add_employee('Part-time Instructor 6'::text, 'Blk 6'::text, '32379796'::text, 
'6@cs2102.com'::text, '2020-12-01'::date, false, 30, 'Instructor'::text, '["area 6"]'::json);
select add_employee('Part-time Instructor 7'::text, 'Blk 7'::text, '64524712'::text, 
'7@cs2102.com'::text, '2021-01-01'::date, false, 35, 'Instructor'::text, '["area 7", "area 9", "area 10"]'::json);
select add_employee('Part-time Instructor 8'::text, 'Blk 8'::text, '79617371'::text, 
'8@cs2102.com'::text, '2021-01-01'::date, false, 40, 'Instructor'::text, '["area 8", "area 10"]'::json);
select add_employee('Part-time Instructor 9'::text, 'Blk 9'::text, '51876124'::text, 
'9@cs2102.com'::text, '2021-02-01'::date, false, 45, 'Instructor'::text, '["area 11"]'::json);
select add_employee('Part-time Instructor 10'::text, 'Blk 10'::text, '21883267'::text, 
'10@cs2102.com'::text, '2021-02-01'::date, false, 50, 'Instructor'::text, '["area 12"]'::json);

select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);
select add_employee('Admin 2'::text, 'Blk 2'::text, '86329054'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, true, 4200, 'Administrator'::text, '[]'::json);
select add_employee('Admin 3'::text, 'Blk 3'::text, '45429411'::text, 
'3@cs2102.com'::text, '2020-11-01'::date, true, 4300, 'Administrator'::text, '[]'::json);
select add_employee('Admin 4'::text, 'Blk 4'::text, '37580068'::text, 
'4@cs2102.com'::text, '2020-11-01'::date, true, 4400.50, 'Administrator'::text, '[]'::json);
select add_employee('Admin 5'::text, 'Blk 5'::text, '02402521'::text, 
'5@cs2102.com'::text, '2020-12-01'::date, true, 4500, 'Administrator'::text, '[]'::json);
select add_employee('Admin 6'::text, 'Blk 6'::text, '32379795'::text, 
'6@cs2102.com'::text, '2020-12-01'::date, true, 4600, 'Administrator'::text, '[]'::json);
select add_employee('Admin 7'::text, 'Blk 7'::text, '64524711'::text, 
'7@cs2102.com'::text, '2021-01-01'::date, true, 4700, 'Administrator'::text, '[]'::json);
select add_employee('Admin 8'::text, 'Blk 8'::text, '79617370'::text, 
'8@cs2102.com'::text, '2021-01-01'::date, true, 4800, 'Administrator'::text, '[]'::json);
select add_employee('Admin 9'::text, 'Blk 9'::text, '51876123'::text, 
'9@cs2102.com'::text, '2021-02-01'::date, true, 4700, 'Administrator'::text, '[]'::json);
select add_employee('Admin 10'::text, 'Blk 10'::text, '21883266'::text, 
'10@cs2102.com'::text, '2021-02-01'::date, true, 4800, 'Administrator'::text, '[]'::json);

select utime('2020-06-01');
select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-01-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);
select add_customer('Cus 3'::text, 'Blk 3'::text, '12345673'::text, 'c3@cs2102.com'::text, 3, '2021-05-20'::date, 'CVV_3'::text);
select add_customer('Cus 4'::text, 'Blk 4'::text, '12345674'::text, 'c4@cs2102.com'::text, 4, '2021-05-20'::date, 'CVV_4'::text);
select add_customer('Cus 5'::text, 'Blk 5'::text, '12345675'::text, 'c5@cs2102.com'::text, 5, '2021-05-20'::date, 'CVV_5'::text);
select add_customer('Cus 6'::text, 'Blk 6'::text, '12345676'::text, 'c6@cs2102.com'::text, 6, '2021-05-20'::date, 'CVV_6'::text);
select add_customer('Cus 7'::text, 'Blk 7'::text, '12345677'::text, 'c7@cs2102.com'::text, 7, '2021-05-20'::date, 'CVV_7'::text);
select add_customer('Cus 8'::text, 'Blk 8'::text, '12345678'::text, 'c8@cs2102.com'::text, 8, '2021-05-20'::date, 'CVV_8'::text);
select add_customer('Cus 9'::text, 'Blk 9'::text, '12345679'::text, 'c9@cs2102.com'::text, 9, '2021-05-20'::date, 'CVV_9'::text);
select add_customer('Cus 10'::text, 'Blk 10'::text, '12345680'::text, 'c10@cs2102.com'::text, 10, '2021-05-20'::date, 'CVV_10'::text);

insert into Rooms values(1, 'room 1', 2);
insert into Rooms values(2, 'room 2', 4);
insert into Rooms values(3, 'room 3', 6);
insert into Rooms values(4, 'room 4', 8);
insert into Rooms values(5, 'room 5', 10);
insert into Rooms values(6, 'room 6', 12);
insert into Rooms values(7, 'room 7', 14);
insert into Rooms values(8, 'room 8', 16);
insert into Rooms values(9, 'room 9', 18);
insert into Rooms values(10, 'room 10', 20);

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);
select add_course('Course 3'::text, 'Description 3'::text, 'area 3'::text, 10);
select add_course('Course 4'::text, 'Description 4'::text, 'area 4'::text, 10);
select add_course('Course 5'::text, 'Description 5'::text, 'area 5'::text, 10);
select add_course('Course 6'::text, 'Description 6'::text, 'area 6'::text, 10);
select add_course('Course 7'::text, 'Description 7'::text, 'area 7'::text, 10);
select add_course('Course 8'::text, 'Description 8'::text, 'area 8'::text, 10);
select add_course('Course 9'::text, 'Description 9'::text, 'area 9'::text, 10);
select add_course('Course 10'::text, 'Description 10'::text, 'area 10'::text, 10);
select add_course('Course 1b'::text, 'Description 1b'::text, 'area 1'::text, 40);
select add_course('Course 2b'::text, 'Description 2b'::text, 'area 2'::text, 40);
select add_course('Course 3b'::text, 'Description 3b'::text, 'area 3'::text, 40);

select add_course_offering(1,1,11.5,'2020-10-01'::date,'2020-10-01'::date,5,31,'[["2020-10-12",9,1], ["2020-10-13",10,2]]'::json);
select add_course_offering(2,2,12.5,'2020-10-02'::date,'2020-10-02'::date,5,32,'[["2020-10-12",10,1], ["2020-10-12",14,2]]'::json);
select add_course_offering(3,3,13.5,'2020-11-01'::date,'2020-11-01'::date,5,33,'[["2020-11-11",10,1], ["2020-11-11",14,2]]'::json);
select add_course_offering(4,4,14.5,'2020-11-02'::date,'2020-11-02'::date,2,34,'[["2020-11-12",11,1]]'::json);
select add_course_offering(5,5,15.5,'2020-12-01'::date,'2020-12-01'::date,4,35,'[["2020-12-11",11,2]]'::json);
select add_course_offering(6,6,16.5,'2020-12-02'::date,'2020-12-02'::date,6,36,'[["2020-12-14",11,3]]'::json);
select add_course_offering(7,7,17.5,'2021-01-01'::date,'2021-01-01'::date,8,37,'[["2021-01-11",11,4]]'::json);
select add_course_offering(8,8,18.5,'2021-01-02'::date,'2021-01-02'::date,10,38,'[["2021-01-12",11,5]]'::json);
select add_course_offering(9,9,19.5,'2021-02-01'::date,'2021-02-01'::date,10,39,'[["2021-02-12",11,6]]'::json);
select add_course_offering(10,10,20.5,'2021-02-02'::date,'2021-02-02'::date,14,40,'[["2021-02-12",11,7]]'::json);
select add_course_offering(11,11,21.5,'2021-03-01'::date,'2021-03-01'::date,16,31,'[["2021-03-12",11,8]]'::json);
select add_course_offering(12,12,22.5,'2021-03-02'::date,'2021-03-02'::date,18,32,'[["2021-03-12",11,9]]'::json);
select add_course_offering(13,13,23.5,'2021-04-01'::date,'2021-04-01'::date,20,33,'[["2021-04-12",11,10]]'::json);
select add_course_offering(14,11,22.5,'2021-05-01'::date,'2021-05-01'::date,16,31,'[["2021-05-12",11,8]]'::json);
select add_course_offering(15,12,23.5,'2021-06-02'::date,'2021-06-02'::date,18,32,'[["2021-06-14",11,9]]'::json);
select add_course_offering(16,13,24.5,'2021-07-01'::date,'2021-07-01'::date,20,33,'[["2021-07-12",11,10]]'::json);
select add_course_offering(17,13,25.5,'2022-01-01'::date,'2022-01-01'::date,20,33,'[["2022-01-12",11,10]]'::json);

select add_course_package('package 1'::text, 1, '2020-06-01'::date, '2020-12-01'::date, 1.5);
select add_course_package('package 2'::text, 2, '2020-06-01'::date, '2021-12-01'::date, 2.5);
select add_course_package('package 3'::text, 3, '2021-01-01'::date, '2021-06-01'::date, 3.5);
select add_course_package('package 4'::text, 4, '2020-01-01'::date, '2021-06-01'::date, 4.5);
select add_course_package('package 5'::text, 5, '2020-01-01'::date, '2021-06-01'::date, 5.5);
select add_course_package('package 6'::text, 6, '2021-01-01'::date, '2021-02-01'::date, 6.5);
select add_course_package('package 7'::text, 7, '2021-02-02'::date, '2021-03-01'::date, 7.5);
select add_course_package('package 8'::text, 8, '2021-03-01'::date, '2021-04-01'::date, 8.5);
select add_course_package('package 9'::text, 9, '2021-04-02'::date, '2021-05-01'::date, 9.5);
select add_course_package('package 10'::text, 10, '2020-05-02'::date, '2021-06-01'::date, 10.5);

select utime('2020-11-01');
select buy_course_package(1,1);
select buy_course_package(2,1);
select utime('2021-01-01');
select buy_course_package(3,3);
select buy_course_package(4,4);
select buy_course_package(5,5);
select buy_course_package(6,6);
select utime('2021-02-15');
select buy_course_package(7,7);
select utime('2021-03-15');
select buy_course_package(8,8);
select utime('2021-04-15');
select buy_course_package(9,9);
select utime('2021-05-15');
select buy_course_package(10,10);

select utime('2020-11-01');
select register_session(1, 1, 1, 'credit card');
select register_session(2, 1, 1, 'credit card');
select register_session(3, 2, 2, 'credit card');
select register_session(4, 4, 1, 'redemption');
select register_session(1, 4, 1, 'redemption');
select cancel_registration(1, 4);
select register_session(1, 5, 1, 'redemption');
select register_session(1, 6, 1, 'credit card');
select cancel_registration(1, 6);
select register_session(5, 10, 1, 'credit card');
select register_session(6, 10, 1, 'redemption');
select utime('2021-02-10');
select cancel_registration(5, 10);
select cancel_registration(6, 10);
select register_session(6, 11, 1, 'credit card');
select register_session(7, 14, 1, 'credit card');
select register_session(8, 14, 1, 'redemption');
select register_session(3, 12, 1, 'credit card');
select register_session(3, 15, 1, 'credit card');
select register_session(5, 15, 1, 'redemption');
select cancel_registration(5, 15);
select register_session(6, 13, 1, 'redemption');
select register_session(7, 16, 1, 'redemption');
select register_session(3, 16, 1, 'credit card');
select register_session(7, 17, 1, 'credit card');
select utime('2020-09-01');
select register_session(10, 1, 2, 'redemption');
select register_session(10, 3, 1, 'redemption');
select register_session(10, 6, 1, 'redemption');
select register_session(6, 1, 1, 'redemption');
select utime('2020-10-01');
select cancel_registration(6, 1);
select utime('2020-10-01 00:00:01');
select register_session(6, 5, 1, 'redemption');
select cancel_registration(6, 5);
select utime('2020-10-01 00:00:02');
select register_session(6, 5, 1, 'redemption');
select cancel_registration(6, 5);
select utime('2020-10-01 00:00:03');
select register_session(6, 5, 1, 'redemption');
select cancel_registration(6, 5);
select utime('2020-10-01 00:00:04');
select register_session(6, 5, 1, 'redemption');
select cancel_registration(6, 5);
select utime(null);