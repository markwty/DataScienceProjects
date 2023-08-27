drop function if exists register_session2;
create or replace function register_session2(_cust_id integer, _course_offering_id integer, _sid integer, _payment_method text)
returns void
as $$
DECLARE
	_date date;
	_number integer;
	_package_id integer;
	_course_id integer;
	_launch_date date;
	_old_num_remaining_redemptions integer;
	
begin
	select O.course_id, O.launch_date into _course_id, _launch_date from Offerings O where O.course_offering_id = _course_offering_id;
	if (select count(*) from Registers where course_id=_course_id and launch_date=_launch_date and number
	=(select CC.number from Credit_cards CC where CC.cust_id=_cust_id))
	+(select count(*) from Redeems where course_id=_course_id and launch_date=_launch_date and number
	=(select CC.number from Credit_cards CC where CC.cust_id=_cust_id))
	-(select count(*) from Cancels where course_id=_course_id and launch_date=_launch_date and cust_id=_cust_id) > 0 then
		RAISE EXCEPTION 'For each course offered by the company, a customer can register for at most one of its sessions before its registration deadline.';
	end if;
	if not exists(select 1 from get_available_course_sessions2(_course_offering_id) CS where (CS.date, CS.start_time) = 
	(select S.date, S.start_time from Sessions S where S.sid=_sid and S.course_id=_course_id and S.launch_date=_launch_date)) then
		RAISE EXCEPTION 'Session not available for registration.';
	end if;
	if _payment_method = 'redemption' then
		_date = null;
		select B.date, B.number, B.package_id, B.num_remaining_redemptions into _date, _number, _package_id, _old_num_remaining_redemptions from Buys B, Credit_cards CC 
		where CC.cust_id = _cust_id and CC.number = B.number and B.num_remaining_redemptions > 0;
		if _date is null then
			RAISE EXCEPTION 'There is no active course package.';
		end if;
		insert into Redeems values(CNOW(), _date, _number, _package_id, _course_id, _launch_date, _sid);
		update Buys set num_remaining_redemptions = _old_num_remaining_redemptions-1 where number = _number and date = _date and package_id = _package_id;
	elsif _payment_method = 'credit card' then
		_number := null;
		select CC.number into _number from Credit_cards CC where CC.cust_id =_cust_id
		and CC.expiry_date >= CNOW()::date and CC.from_date <= CNOW()::date;
		if _number is null then
			RAISE EXCEPTION 'Credit card has expired or has not started yet.';
		end if;
		insert into Registers values(CNOW(), _number, _course_id, _launch_date, _sid);
	else
		RAISE EXCEPTION 'Incorrect payment method';
	end if;
end;
$$language plpgsql;

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
insert into Rooms values(2, 'room 2', 1);
select add_course_offering(1,1,11.5,'2020-04-01'::date,'2021-04-15'::date,2,3,'[["2021-06-17",9,1],["2021-06-28",9,1]]'::json);
select add_course_offering(2,1,11.5,'2020-04-02'::date,'2021-04-15'::date,8,3,'[["2021-06-18",9,2],["2021-06-18",11,1]]'::json);

select add_customer('Cus 1'::text, 'Blk 1'::text, '12345671'::text, 'c1@cs2102.com'::text, 1, '2021-01-20'::date, 'CVV_1'::text);
select add_customer('Cus 2'::text, 'Blk 2'::text, '12345672'::text, 'c2@cs2102.com'::text, 2, '2021-05-20'::date, 'CVV_2'::text);
select add_customer('Cus 3'::text, 'Blk 3'::text, '12345673'::text, 'c3@cs2102.com'::text, 3, '2021-05-20'::date, 'CVV_3'::text);
select add_customer('Cus 4'::text, 'Blk 4'::text, '12345674'::text, 'c4@cs2102.com'::text, 4, '2021-05-20'::date, 'CVV_4'::text);

select register_session(1, 1, 1, 'credit card');--credit card expired

select register_session(2, 1, 1, 'credit card');
select add_course_package('package 1'::text, 1, '2021-01-01'::date, '2021-06-01'::date, 1.5);
select buy_course_package(3, 1);
select register_session(3, 1, 2, 'redemption');
select * from Redeems;

select * from Registers;

select register_session2(4, 1, 1, 'credit card');--cannot register, target registration reached already

select register_session(4, 2, 1, 'credit card');
select register_session2(3, 2, 1, 'redemption');--cannot register, room fully occupied


