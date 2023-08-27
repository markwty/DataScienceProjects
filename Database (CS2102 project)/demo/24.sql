drop function if exists add_session2;
create or replace function add_session2(_course_offering_id integer, _sid integer, _date date, _start_hour integer, _eid integer, _rid integer)
returns void
as $$
declare
	_launch_date date;
	_course_id integer;
	_registration_deadline date;
	_min_date date;
	_max_date date;
	_seating_capacity integer;
begin
	select launch_date, course_id, registration_deadline into _launch_date, _course_id, _registration_deadline from Offerings where course_offering_id = _course_offering_id;
	if _registration_deadline < CNOW() then
		RAISE EXCEPTION 'Registration deadline has passed. Cannot add session.';
	end if;
	if not exists(select 1 from find_instructors(_course_id, _date, _start_hour) where eid = _eid) then
		RAISE EXCEPTION 'Invalid instructor';
	end if;
	insert into Sessions values(_course_id, _launch_date, _sid, _rid, _eid, _date, _start_hour, _start_hour + 1);
	select min(S.date) into _min_date from Sessions S where S.course_id = _course_id and S.launch_date = _launch_date;
	select max(S.date) into _max_date from Sessions S where S.course_id = _course_id and S.launch_date = _launch_date;
	select sum(R.seating_capacity) into _seating_capacity from Rooms R natural join Sessions S where S.course_id = _course_id and S.launch_date= _launch_date;
	update Offerings O set start_date = _min_date, end_date = _max_date, seating_capacity = _seating_capacity
	where O.course_id = _course_id and O.launch_date = _launch_date;
END;
$$language plpgsql;


\i schema.sql
select utime('2021-04-12');
select add_employee('Manager 1'::text, 'Blk 1'::text, '65999429'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 3100, 'Manager'::text, '["area 1","area 2"]'::json);
select add_employee('Full-time Instructor 1'::text, 'Blk 1'::text, '65999428'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 2100, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Part-time Instructor 1'::text, 'Blk 1'::text, '65999427'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, false, 5, 'Instructor'::text, '["area 2"]'::json);
select add_employee('Part-time Instructor 2'::text, 'Blk 2'::text, '86329055'::text, 
'2@cs2102.com'::text, '2020-10-01'::date, false, 10, 'Instructor'::text, '["area 1"]'::json);
select add_employee('Admin 1'::text, 'Blk 1'::text, '65999426'::text, 
'1@cs2102.com'::text, '2020-10-01'::date, true, 4100, 'Administrator'::text, '[]'::json);
select remove_employee(4, '2021-04-12');

select add_course('Course 1'::text, 'Description 1'::text, 'area 1'::text, 10);
select add_course('Course 2'::text, 'Description 2'::text, 'area 2'::text, 10);

insert into Rooms values(1, 'room 1', 10);
select add_course_offering(1,1,50,'2020-04-01'::date,'2021-04-15'::date,7,5,'[["2021-06-17",9,1]]'::json);
select add_course_offering(2,2,50,'2020-04-01'::date,'2021-04-15'::date,7,5,'[["2021-06-17",11,1]]'::json);

select add_session2(1, 2, '2021-06-18', 11, 2, 1);
select * from Offerings;--updated seating capacity and start and end date

select add_session2(1, 3, '2021-06-17', 14, 3, 1);--instructor does not specialise
select add_session2(1, 3, '2021-06-17', 11, 2, 1);--room is already in use
select add_session2(1, 3, '2021-06-17', 14, 4, 1);--departed

select utime('2021-04-16');
select add_session2(1, 3, '2021-06-17', 14, 2, 1);--registration deadline has passed




