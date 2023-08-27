drop function if exists get_available_course_sessions2;
create or replace function get_available_course_sessions2(_course_offering_id integer)
returns table(date date, start_time integer, name text, remaining_seats int) 
as $$
declare
	_remaining_seats_in_offering integer;
begin
	select O.target_number_registrations
- (select count(*) from Registers R where O.course_id=R.course_id and O.launch_date=R.launch_date)
- (select count(*) from Redeems R where O.course_id=R.course_id and O.launch_date=R.launch_date)
+ (select count(*) from Cancels C where O.course_id=C.course_id and O.launch_date=C.launch_date) into _remaining_seats_in_offering
	from Offerings O where O.course_offering_id=_course_offering_id;

	return query with cte as
	(select S.date, S.start_time, S.eid, 
	((select count(*) from Registers R where R.sid=S.sid and R.course_id=S.course_id and R.launch_date=S.launch_date)
	+ (select count(*) from Redeems R where R.sid=S.sid and R.course_id=S.course_id and R.launch_date=S.launch_date)
	- (select count(*) from Cancels C where C.sid=S.sid and C.course_id=S.course_id and C.launch_date=S.launch_date)
	)::integer as number_of_registrations, R.seating_capacity
	from Sessions S natural join Rooms R, Offerings O where O.course_offering_id = _course_offering_id 
	and S.launch_date = O.launch_date and S.course_id = O.course_id)
	select cte.date, cte.start_time, E.name, least(cte.seating_capacity - cte.number_of_registrations, _remaining_seats_in_offering) as remaining_seats 
	from cte natural join Employees E 
	where least(cte.seating_capacity - cte.number_of_registrations, _remaining_seats_in_offering) > 0
	and cnow() <= (select registration_deadline from Offerings where course_offering_id=_course_offering_id)
        order by cte.date, cte.start_time;
end;
$$language plpgsql;
--2 problems haven't resolved: registration deadline and must be > 0 for available

\i schema.sql
select utime('2021-04-12');
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1", "area 2"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);

insert into Rooms values(1, 'room 1', 10);
select add_course_offering(1,1,11.5,'2020-10-01'::date,'2020-10-01'::date,2,3,'[["2021-04-12",9,1]]'::json);
select add_course_offering(2,1,11.5,'2020-04-01'::date,'2021-04-15'::date,2,3,'[["2021-06-17",9,1],["2021-06-28",9,1]]'::json);
select add_course_offering(3,1,11.5,'2020-04-02'::date,'2021-04-15'::date,15,3,'[["2021-06-18",9,1],["2021-06-18",11,1]]'::json);

select get_available_course_sessions2(1);
select utime('2020-10-01');
select get_available_course_sessions2(1);
select utime('2021-04-12');
select get_available_course_sessions(2);--seat limited by target number for registration
select get_available_course_sessions(3);--seats limited by room

select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-05-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);

select register_session(1, 2, 1, 'credit card');
select get_available_course_sessions(2);

select add_course_package('package 1'::text, 1, '2021-01-01'::date, '2021-06-01'::date, 2.5);
select buy_course_package(2, 1);
select register_session(2, 2, 1, 'redemption');
select get_available_course_sessions2(2);

select cancel_registration(2, 2);
select get_available_course_sessions(2);


