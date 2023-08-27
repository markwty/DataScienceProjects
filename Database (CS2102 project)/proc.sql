drop function if exists CNOW;
CREATE OR REPLACE FUNCTION CNOW()
RETURNS timestamp
AS $$
BEGIN
	if (select count(*) from _Time) = 0 then
		return NOW();
	end if;
	return (select coalesce(now, NOW()) from _Time); 
END;
$$language plpgsql;

drop function if exists utime;
CREATE OR REPLACE FUNCTION utime(_now timestamp)
RETURNS VOID
AS $$
BEGIN
	if (select count(*) from _Time) = 0 then
		insert into _Time values(1, _now);
	else
		update _Time set now = _now;
	end if;
END;
$$language plpgsql;

drop function if exists add_employee;
CREATE OR REPLACE FUNCTION add_employee(_name text, _address text, _phone text, _email text, _join_date date, _full_time bool, _salary_info numeric, _category text, _areas json)
RETURNS VOID
AS $$
DECLARE
	_eid integer;
BEGIN
	insert into Employees(name, address, phone, email, join_date) values(_name, _address, _phone, _email, _join_date);
	select eid from Employees into _eid where name = _name;--assume name is unique
	if _category='Manager' then
		if json_array_length(_areas)=0 then
			RAISE EXCEPTION 'Course areas cannot be empty for new manager';
		end if;
		if not _full_time then
			RAISE EXCEPTION 'All managers are full-time';
		end if;
		insert into Full_time_Emp values (_eid, _salary_info);
		insert into Managers values (_eid);
		for counter in 1..json_array_length(_areas) loop
			insert into Course_areas values((_areas ->> (counter - 1))::TEXT, _eid);
   		end loop;
	elsif _category='Instructor' then
		if json_array_length(_areas)=0 then
			RAISE EXCEPTION 'Each instructor specializes in a set of one or more course areas. Course areas cannot be empty.';
		end if;
		insert into Instructors values (_eid);
		for counter in 1..json_array_length(_areas) loop
			insert into Specializes values(_eid, (_areas ->> (counter - 1))::TEXT);
   		end loop;
		if _full_time then
			insert into Full_time_Emp values (_eid, _salary_info);
			insert into Full_time_instructors values (_eid);
		else
			insert into Part_time_Emp values (_eid, _salary_info);
			insert into Part_time_instructors values (_eid);
		end if;
	elsif _category='Administrator' then
		if json_array_length(_areas)>0 then
			RAISE EXCEPTION 'No course areas are associated with administrator.';
		end if;
		if not _full_time then
			RAISE EXCEPTION 'All administrators are full-time';
		end if;
		insert into Full_time_Emp values (_eid, _salary_info);
		insert into Administrators values (_eid);
	else
		RAISE EXCEPTION 'Invalid category. Category can either be Manager, Instructor or Administrator';
	end if;
END;
$$LANGUAGE plpgsql;


drop function if exists remove_employee;
CREATE OR REPLACE FUNCTION remove_employee(_eid integer, _depart_date date)
RETURNS VOID
AS $$
DECLARE
	success boolean;
BEGIN
	select not exists (select 1 from Offerings where eid = _eid and registration_deadline > _depart_date) into success;
	if not success then
		RAISE EXCEPTION 'Registration deadline has not passed';
	end if;
	select not exists (select 1 from Sessions where eid = _eid and date > _depart_date) into success;
	if not success then
		RAISE EXCEPTION 'Session date has not passed';
	end if;
	select not exists (select 1 from Course_areas where eid = _eid) into success;
	if not success then
		RAISE EXCEPTION 'Manager is currently managing some course area/s';
	else
		update Employees set depart_date = _depart_date where eid = _eid;
	end if;
END;
$$LANGUAGE plpgsql;


drop function if exists add_customer;
CREATE OR REPLACE FUNCTION add_customer(_name text, _address text, _phone text, _email text, _number integer, _expiry_date date, _CVV text)
RETURNS VOID
AS $$
DECLARE
	_cust_id integer;
BEGIN
	insert into Customers(name, address, phone, email) values(_name, _address, _phone, _email);
	select cust_id from Customers into _cust_id where name=_name;--assume name is unique
	insert into Credit_cards(number, expiry_date, CVV, from_date, cust_id)
values(_number, _expiry_date, _CVV, CNOW()::date, _cust_id);
END;
$$LANGUAGE plpgsql;


drop function if exists update_credit_card;
CREATE OR REPLACE FUNCTION update_credit_card(_cust_id integer, _number integer, _expiry_date date, _CVV text)
RETURNS VOID
AS $$
DECLARE
	exist boolean;
BEGIN
	select exists (select 1 from Credit_cards where cust_id=_cust_id) into exist;
	if not exist then
		RAISE EXCEPTION 'No existing credit card to update for customer';
	end if;
	update Credit_cards set number=_number, expiry_date=_expiry_date,
CVV=_CVV, from_date=CNOW()::date where cust_id=_cust_id;
END;
$$LANGUAGE plpgsql;


drop function if exists add_course;
CREATE OR REPLACE FUNCTION add_course(_title text, _description text, _name text, _duration integer)
RETURNS VOID
AS $$
BEGIN
	insert into Courses(title, description, name, duration) values(_title, _description, _name, _duration);
END;
$$LANGUAGE plpgsql;


drop function if exists find_instructors;
CREATE OR REPLACE FUNCTION find_instructors(_course_id integer, _date date, _start_hour integer)
RETURNS TABLE(eid integer, name text)
AS $$
BEGIN
	if not (((_start_hour>=9 and _start_hour<=11) or (_start_hour>=14 and
_start_hour<=17)) and extract(dow from _date) not in (6,0)) then
		RAISE EXCEPTION 'Invalid start hour/day';
	end if;
	return query select E.eid, E.name from Employees E join
	(select I.eid from Instructors I natural join Specializes S where S.name = (select C.name from Courses C where course_id = _course_id)
	except
	select S.eid from Sessions S where date = _date and abs(start_time-_start_hour)<2
	except
	select E.eid from Employees E where depart_date < _date or join_date > _date
	except
	select S.eid from Sessions S where date >= date_trunc('month', _date) and date < date_trunc('month', _date) + interval '1' month
	and S.eid in (select P.eid from Part_time_instructors P)
	group by S.eid having count(*) >= 30) A on E.eid=A.eid;
END;
$$LANGUAGE plpgsql;


drop function if exists get_available_instructors;
CREATE OR REPLACE FUNCTION get_available_instructors(_course_id integer, _start_date date, _end_date date)
RETURNS TABLE(eid integer, name text, hours bigint, date date, available_hours integer[])
AS $$
BEGIN
	return query select * from (select E.eid, E.name, (select count(*) from Sessions S where S.eid=E.eid and S.date >= date_trunc('month', i.date) and S.date < date_trunc('month', i.date) + interval '1' month)
	, i.date, array[9,10,11,14,15,16,17] as available_hours
	from Instructors natural join Employees E, generate_series(_start_date, _end_date, '1 day'::interval) i where (E.eid, i.date) not in (select S.eid, S.date from Sessions S)
	union
	select E.eid, E.name, (select count(*) from Sessions SS where SS.eid=E.eid and SS.date >= date_trunc('month', S.date) and SS.date < date_trunc('month', S.date) + interval '1' month)
	, S.date, (select array_agg(st) from (values (9),(10),(11),(14),(15),(16),(17)) as t(st) where true = all(select abs(start_time-st)>=2 from Sessions SS where SS.eid=E.eid and SS.date=S.date))
	as available_hours from Employees E natural join Sessions S where _start_date<=S.date and S.date<=_end_date group by E.eid, E.name, S.date) B
	where
	extract(dow from B.date) not in (6,0)
        and
	array_length(B.available_hours, 1) > 0
	and
	exists(select 1 from Specializes S where S.eid = B.eid and S.name = (select C.name from Courses C where C.course_id = _course_id))
	and
	(select count(*) from Sessions SS where SS.eid = B.eid and SS.date >= date_trunc('month', B.date) and SS.date < date_trunc('month', B.date) + interval '1' month
	and SS.eid in (select P.eid from Part_time_instructors P)) < 30
	and
	exists(select 1 from Employees E where (depart_date >= B.date or depart_date is null) and join_date <= B.date and B.eid=E.eid) 
	order by B.eid, B.date;
END;
$$LANGUAGE plpgsql;


drop function if exists find_rooms;
CREATE OR REPLACE FUNCTION find_rooms(_date date, _start_hour integer, _duration numeric)
RETURNS TABLE(rid integer)
AS $$
BEGIN
	return query select R.rid from Rooms R except
	select S.rid from Sessions S where date=_date and start_time < _start_hour + _duration and _start_hour < end_time;
END;
$$LANGUAGE plpgsql;


drop function if exists get_available_rooms;
CREATE OR REPLACE FUNCTION get_available_rooms(_start_date date, _end_date date)
RETURNS TABLE(rid integer, capacity integer, date date, available_hours integer[])
AS $$
BEGIN
	return query select * from (select R.rid, R.seating_capacity, i.date,
array[9,10,11,14,15,16,17] from Rooms R, generate_series(_start_date,
    _end_date, '1 day'::interval) i where (R.rid, i.date) not in (select S.rid, S.date from Sessions S)
	union
	select R.rid, R.seating_capacity, S.date, (select array_agg(st) from
(values (9),(10),(11),(14),(15),(16),(17)) as t(st)
	where true = all(select SS.start_time<>st from Sessions SS where SS.rid=R.rid and SS.date=S.date))
	from Rooms R natural join Sessions S where _start_date<=S.date and
S.date<=_end_date group by R.rid, R.seating_capacity, S.date) B
	where extract(dow from B.date) not in (6,0)
	order by B.rid, B.date;
END;
$$LANGUAGE plpgsql;


drop function if exists add_course_offering;
CREATE OR REPLACE FUNCTION add_course_offering(_offering_id integer, _course_id integer, _fees numeric, _launch_date date
, _registration_deadline date, _target_num_registrations integer, _eid integer, _sessions_information json)
RETURNS VOID
AS $$
DECLARE
	_date date;
	_start_offering_date date;
	_end_offering_date date;
	_start_time numeric;
	_rid integer;
	_seating_capacity integer;
	_total_seating_capacity integer;
	_new_information json;
	_iid integer;
BEGIN
	_start_offering_date := null;
	_end_offering_date := null;
	_total_seating_capacity := 0;
	if json_array_length(_sessions_information) = 0 then
		RAISE EXCEPTION 'There must be at least 1 session in each offering.';
	end if;
	for counter in 1..json_array_length(_sessions_information) loop
		_date := (_sessions_information -> (counter - 1) ->> 0)::DATE;
		_start_time := (_sessions_information -> (counter - 1) ->> 1)::INTEGER;
		for counter2 in 1..json_array_length(_sessions_information) loop
			if counter<>counter2 and _date=(_sessions_information -> (counter2 - 1) ->> 0)::DATE 
			and _start_time = (_sessions_information -> (counter2 - 1) ->> 1)::INTEGER then
			RAISE EXCEPTION 'No two sessions for the same course offering can be conducted on the same day and at the same time.';
			end if;
		end loop;
	end loop;
	for counter in 1..json_array_length(_sessions_information) loop
		_date := (_sessions_information -> (counter - 1) ->> 0)::DATE;
		if (_start_offering_date IS NULL or _start_offering_date > _date) then
			_start_offering_date := _date;
		end if;
		if (_end_offering_date IS NULL or _end_offering_date < _date) then
			_end_offering_date := _date;
		end if;
		_start_time := (_sessions_information -> (counter - 1) ->> 1)::INTEGER;
		_rid := (_sessions_information -> (counter - 1) ->> 2)::INTEGER;
		select seating_capacity into _seating_capacity from Rooms where rid=_rid;
		_total_seating_capacity := _total_seating_capacity + _seating_capacity;
   	end loop;
	insert into Offerings values(_offering_id, _course_id, _launch_date, _start_offering_date, _end_offering_date, 
	_registration_deadline, _target_num_registrations, _total_seating_capacity, _fees, _eid);

	select json_agg(value order by (select -count(*) from Sessions where
date=(value->>0)::date and abs((value->>1)::integer-start_time)<2)) into
_new_information from json_array_elements(_sessions_information);
	for counter in 1..json_array_length(_new_information) loop
		_date := (_new_information -> (counter - 1) ->> 0)::DATE;
		_start_time := (_new_information -> (counter - 1) ->> 1)::INTEGER;
		_rid := (_new_information -> (counter - 1) ->> 2)::INTEGER;
		select eid into _iid from find_instructors(_course_id, _date,
_start_time::integer) limit 1;
		if _iid IS NULL then
			RAISE EXCEPTION 'Cannot allocate instructors.';
		end if;
		insert into Sessions(course_id, launch_date, sid, rid, eid, date,
start_time, end_time) values(_course_id, _launch_date, 0, _rid, _iid, _date, _start_time, _start_time + 1);
   	end loop;
END;
$$LANGUAGE plpgsql;
--Valid assignment of instructors here entails not reshuffling the instructors
--already allocated from previous calls of the function.


drop function if exists add_course_package;
CREATE OR REPLACE FUNCTION add_course_package(_name text,
_num_free_registrations integer, _sale_start_date date, _sale_end_date date,
_price numeric)
RETURNS VOID
AS $$
BEGIN
	insert into Course_packages(sale_start_date, sale_end_date,
num_free_registrations, name, price) values(_sale_start_date, _sale_end_date,
_num_free_registrations, _name, _price);
END;
$$LANGUAGE plpgsql;


drop function if exists get_available_course_packages;
CREATE OR REPLACE FUNCTION get_available_course_packages()
RETURNS TABLE(name text, num_free_registrations integer, sale_end_date date,
price numeric)
AS $$
BEGIN
	return query select CP.name, CP.num_free_registrations, CP.sale_end_date, CP.price
from Course_packages CP where CP.sale_start_date <= CNOW()::date and CP.sale_end_date >= CNOW()::date;
END;
$$LANGUAGE plpgsql;


drop function if exists get_my_course_package;
create or replace function get_my_course_package(_cust_id integer)
returns json
as $$
DECLARE
	_json json;
begin
	select row_to_json(A) into _json from (select CP.name, B.date, CP.price,
CP.num_free_registrations, ((select CP.num_free_registrations - count(*) from Redeems R where
B.date = R.date and B.number = R.number and B.package_id = R.package_id) +
(select coalesce(sum(package_credit), 0) from Cancels C where C.cust_id=_cust_id and C.by_package=true and
(C.course_id, C.launch_date, C.sid) in (select R.course_id, R.launch_date, R.sid from Redeems R where
B.date = R.date and B.number = R.number and B.package_id = R.package_id))) as num_not_redeemed, 
(select json_agg(t) as Session_details from (select C.title, S.date, S.start_time from Redeems R natural join
Courses C inner join Sessions S on R.sid = S.sid and R.course_id = S.course_id and R.launch_date=S.launch_date
where B.date = R.date and B.number = R.number and B.package_id = R.package_id
except all
select CC.title, SS.date, SS.start_time from Cancels CA natural join
Courses CC inner join Sessions SS on CA.sid = SS.sid and CA.course_id = SS.course_id and CA.launch_date=SS.launch_date
where CA.by_package=true
order by date, start_time) as t) from Course_packages CP 
natural join Buys B natural join Credit_cards where cust_id = _cust_id
and (true=any(select S.date - CNOW()::date >=7 from Redeems R inner join Sessions S 
on R.sid = S.sid and R.course_id = S.course_id and R.launch_date = S.launch_date 
where B.date = R.date and B.number = R.number and B.package_id = R.package_id)
or 0 < (select CP.num_free_registrations - count(*) from Redeems R where
B.date = R.date and B.number = R.number and B.package_id = R.package_id) +
(select coalesce(sum(package_credit), 0) from Cancels C inner join Redeems R 
on C.course_id=R.course_id and C.launch_date=R.launch_date and C.sid=R.sid where
B.date = R.date and B.number = R.number and B.package_id = R.package_id))
) A limit 1;
	return _json;
end;
$$language plpgsql;
--it is sufficient to check the sessions since it is impossible to make a package inactive and apply for the same
--session by the registration deadline (10 days before first session date in offering)


drop function if exists buy_course_package;
CREATE OR REPLACE FUNCTION buy_course_package(_cust_id integer, _package_id integer)
RETURNS VOID
AS $$
DECLARE
	_number integer;
	_name text;
	_num_free_registrations integer;
	_package_is_available integer;
BEGIN
	_number := null;
	select number into _number from Credit_cards where cust_id = _cust_id
and expiry_date >= CNOW()::date and from_date <= CNOW()::date;
	if _number IS NULL then
		RAISE EXCEPTION 'Credit card has expired or has not started yet.';
	end if;
	select count(*) into _package_is_available from Course_packages where package_id=_package_id 
and sale_start_date<=CNOW()::date and sale_end_date>=CNOW()::date;
	if _package_is_available = 0 then
		RAISE EXCEPTION 'Package specified is not in sale.';
	end if;
	_name := get_my_course_package(_cust_id)::json->>'name';
	if _name IS NOT NULL then
		RAISE EXCEPTION 'Each customer can have at most one active or partially active package.';
	end if;
	select num_free_registrations into _num_free_registrations from
Course_packages where package_id=_package_id;
	insert into Buys values(CNOW()::date, _number, _package_id, _num_free_registrations);
END;
$$LANGUAGE plpgsql;


drop function if exists get_available_course_offerings;
create or replace function get_available_course_offerings()
returns table(title text, course_area text, start_date date, end_date date,
registration_deadline date, fees numeric, remaining_seats bigint)
as $$
begin
	return query select C.title, C.name, O.start_date, O.end_date,
O.registration_deadline, O.fees, O.target_number_registrations
- (select count(*) from Registers R where O.course_id=R.course_id and O.launch_date=R.launch_date)
- (select count(*) from Redeems R where O.course_id=R.course_id and O.launch_date=R.launch_date)
+ (select count(*) from Cancels C where O.course_id=C.course_id and O.launch_date=C.launch_date) from
Courses C natural join Offerings O where O.target_number_registrations
- (select count(*) from Registers R where O.course_id=R.course_id and O.launch_date=R.launch_date)
- (select count(*) from Redeems R where O.course_id=R.course_id and O.launch_date=R.launch_date)
+ (select count(*) from Cancels C where O.course_id=C.course_id and O.launch_date=C.launch_date) > 0
and O.registration_deadline >= CNOW()::date;
end;
$$language plpgsql;


drop function if exists get_available_course_sessions;
create or replace function get_available_course_sessions(_course_offering_id integer)
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
        order by cte.date, cte.start_time;
end;
$$language plpgsql;


drop function if exists register_session;
create or replace function register_session(_cust_id integer, _course_offering_id integer, _sid integer, _payment_method text)
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
	if not exists(select 1 from get_available_course_sessions(_course_offering_id) CS where (CS.date, CS.start_time) = 
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


drop function if exists get_my_registrations;
create or replace function get_my_registrations(cust_id_i integer)
returns table(course_name text, fees numeric, date date, start_time
integer, duration numeric, instructor text) as $$
declare
    curs cursor for (select r.course_id, r.launch_date, r.sid
from Registers r where r.number = (select
number from Credit_cards cc where cc.cust_id = cust_id_i)
union all select rr.course_id, rr.launch_date, rr.sid 
from Redeems rr where rr.number = (select
number from Credit_cards cc where cc.cust_id = cust_id_i)
except all select c.course_id, c.launch_date, c.sid
from Cancels c natural join Credit_cards v where v.number = (select
number from Credit_cards cc where cc.cust_id = cust_id_i)
);
    r record;
    _timestamp timestamp;
    _course_name text;
    _fees numeric;
    _start_time integer;
    _duration integer;
    _instructor text;
begin
    drop table if exists _result;
    create table _result (course_name text, fees numeric, date date,
    start_time integer, duration numeric, instructor text);
    open curs;
    loop
        fetch next from curs into r;
        exit when not found;
        _timestamp := (select S.date + S.end_time * interval '1' hour from Sessions S where 
        S.launch_date = r.launch_date and S.course_id = r.course_id and S.sid = r.sid);
        if CNOW() < _timestamp then
            _course_name := (select c1.title from Courses c1 where c1.course_id = r.course_id);
            _fees := (select o.fees from Offerings o where o.course_id =
            r.course_id and o.launch_date = r.launch_date);
            _start_time := (select s2.start_time from Sessions s2 where s2.sid
            = r.sid and s2.course_id = r.course_id and s2.launch_date = r.launch_date);
            _duration := 1;
            _instructor := (select e.name from Employees e where e.eid =
            (select s.eid from Sessions s where s.sid = r.sid and s.launch_date = r.launch_date
            and s.course_id = r.course_id));
            insert into _result(course_name, fees, date, start_time, duration, instructor)
            values(_course_name, _fees, _timestamp, _start_time, _duration, _instructor);
        end if;
    end loop;
    close curs;
    return query (select * from _result a order by (a.date, a.start_time));
    drop table if exists _result;
end;
$$ language plpgsql;


drop function if exists update_course_session;
create or replace function update_course_session(_cust_id integer, _offering_id integer, _session_id integer)
RETURNS VOID AS $$ 
DECLARE ccNum BIGINT;
	sessionStartTime TIMESTAMP;
	newSessionStartTime TIMESTAMP;
	numRegistered INTEGER;
	numRedeemed INTEGER;
	numCancelled INTEGER;
	totalRegistered INTEGER;
	seatingCapacity INTEGER;
	currentSid INTEGER;
	countRegister INTEGER;
BEGIN -- Check both Registers and Redeems entity since we are not sure if individual has a package

currentSid := null;
select sid into currentSid from
(select r.sid
from Registers r where r.number = (select
number from Credit_cards cc where cc.cust_id = _cust_id)
and (r.course_id, r.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
union all 
select rr.sid 
from Redeems rr where rr.number = (select
number from Credit_cards cc where cc.cust_id = _cust_id)
and (rr.course_id, rr.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
except all 
select c.sid
from Cancels c natural join Credit_cards v where v.number = (select
number from Credit_cards cc where cc.cust_id = _cust_id)
and (c.course_id, c.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
) A;

if currentSid is null then
  RAISE EXCEPTION 'There is no old session registered/redeemed that is not already cancelled.';
end if;

ccNum := (
  SELECT
    number
  FROM
    Credit_cards
  WHERE
    cust_id = _cust_id
);

sessionStartTime := (
  SELECT
    S.date + S.start_time * interval '1' hour
  FROM
    Sessions S
  WHERE
    (S.course_id, S.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
    AND S.sid = currentSid
);

countRegister := (
  select 
(select count(*) 
from Redeems rr where rr.number = ccNum
and (rr.course_id, rr.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id))
-
(select count(*)
from Cancels c natural join Credit_cards v where v.number = ccNum
and (c.course_id, c.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
and by_package = true)
);

numRegistered := (
  SELECT
    COUNT(*)
  FROM
    Registers r
  WHERE
    (r.course_id, r.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
    AND r.sid = _session_id
);

numRedeemed := (
  SELECT
    COUNT(*)
  FROM
    Redeems r
  WHERE
    (r.course_id, r.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
    AND r.sid = _session_id
);

numCancelled := (
  SELECT
    COUNT(*)
  FROM
    Cancels C
  WHERE
    (C.course_id, C.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
    AND C.sid = _session_id
);

-- Find the total number of participants **/
totalRegistered := numRegistered + numRedeemed - numCancelled;

seatingCapacity := (
  SELECT
    seating_capacity
  FROM
    Sessions s natural join Rooms R
  WHERE
    s.sid = _session_id
    AND (s.course_id, s.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
);

newSessionStartTime := (
  SELECT
    s.date + s.start_time * interval '1' hour
  FROM
    Sessions s
  WHERE
    (s.course_id, s.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
    AND s.sid = _session_id
);

IF (CNOW() < sessionStartTime
AND CNOW() < newSessionStartTime
AND seatingCapacity > totalRegistered) THEN
  IF countRegister <= 0 THEN
    UPDATE
      Registers r
    SET
      sid = _session_id
    WHERE
      NUMBER = ccNum
      AND (r.course_id, r.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
      AND r.sid = currentSid
      AND r.date = 
      (select max(RR.date) from Registers RR where NUMBER = ccNum
      AND (RR.course_id, RR.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
      AND RR.sid = currentSid);
  ELSE
    UPDATE
      Redeems r
    SET
      sid = _session_id
    WHERE
      NUMBER = ccNum
      AND (r.course_id, r.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
      AND r.sid = currentSid
      AND r.date = 
      (select max(RR.redeem_date) from Redeems RR where NUMBER = ccNum
      AND (RR.course_id, RR.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
      AND RR.sid = currentSid);
  END IF;
ELSE
  RAISE EXCEPTION 'Not enough seats or old/new session has already passed/ongoing.';
END IF;
END;
$$LANGUAGE plpgsql;


drop function if exists cancel_registration;
CREATE OR REPLACE FUNCTION cancel_registration(_cust_id integer, _offering_id integer)
RETURNS VOID
AS $$
DECLARE
	sessionDate DATE;
	sessionStartTime TIMESTAMP;
	registered INTEGER;
	redeemed INTEGER;
	refundAmtAllowed NUMERIC;
	ccNum BIGINT;
	sessionId INTEGER;
	cid INTEGER;
	launchDate DATE;
BEGIN

sessionId := null;
select sid into sessionId from
(select r.sid
from Registers r where r.number = (select
number from Credit_cards cc where cc.cust_id = _cust_id)
and (r.course_id, r.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
union all 
select rr.sid 
from Redeems rr where rr.number = (select
number from Credit_cards cc where cc.cust_id = _cust_id)
and (rr.course_id, rr.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
except all 
select c.sid
from Cancels c natural join Credit_cards v where v.number = (select
number from Credit_cards cc where cc.cust_id = _cust_id)
and (c.course_id, c.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
) A;

if sessionId is null then
  RAISE EXCEPTION 'There is no old session registered/redeemed that is not already cancelled.';
end if;

ccNum := (
  SELECT
    number
  FROM
    Credit_cards
  WHERE
    cust_id = _cust_id
);

-- Check the date of the original session registered 
sessionDate := (
  SELECT
    S.date
  FROM
    Sessions S
  WHERE
    (S.course_id, S.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
    AND S.sid = sessionId
);

sessionStartTime := (
  SELECT
    S.date + S.start_time * interval '1' hour
  FROM
    Sessions S
  WHERE
    (S.course_id, S.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
    AND S.sid = sessionId
);

-- Check if individual registered or redeemed for the session 
registered := (
  select 
(select count(*) 
from Redeems rr where rr.number = ccNum
and (rr.course_id, rr.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id))
-
(select count(*)
from Cancels c natural join Credit_cards v where v.number = ccNum
and (c.course_id, c.launch_date) = (select O.course_id, O.launch_date from Offerings O where course_offering_id = _offering_id)
and by_package = true)
);

-- Max refundable amt of 90% course fee 
refundAmtAllowed := 0.9 * (
  SELECT
    o.fees
  FROM
    Offerings o
  WHERE
    course_offering_id = _offering_id
);

launchDate := (
  SELECT
    launch_date
  FROM
    Offerings
  WHERE
    course_offering_id = _offering_id
);


cid := (
  SELECT
    course_id
  FROM
    Offerings
  WHERE
    course_offering_id = _offering_id
);

-- Offer 90% refund of course fee or package credit if cancellation took place a week before session date
IF CNOW()::date + 7 < sessionDate THEN IF registered <= 0 THEN
INSERT INTO
  Cancels(
    sid,
    launch_date,
    course_id,
    date,
    package_credit,
    refund_amt,
    cust_id,
    by_package
  )
VALUES
  (
    sessionId,
    launchDate,
    cid,
    CNOW(),
    0,
    refundAmtAllowed,
    _cust_id,
    false
  );

ELSE -- Update additional package credit redeemable
UPDATE
  Buys
SET
  num_remaining_redemptions = num_remaining_redemptions + 1
WHERE
  number = ccNum
  and date = (select max(B.date) from Buys B where B.number = ccNum);

INSERT INTO
  Cancels(
    sid,
    launch_date,
    course_id,
    date,
    package_credit,
    refund_amt,
    cust_id,
    by_package
  )
VALUES
  (
    sessionId,
    launchDate,
    cid,
    CNOW(),
    1,
    0,
    _cust_id,
    true
  );
END IF;
ELSIF CNOW() < sessionStartTime THEN
  IF registered <= 0 THEN
    INSERT INTO
      Cancels(
      sid,
      launch_date,
      course_id,
      date,
      package_credit,
      refund_amt,
      cust_id,
      by_package
    )
    VALUES(
      sessionId,
      launchDate,
      cid,
      CNOW(),
      0,
      0,
      _cust_id,
      false
    );  
  ELSE
    INSERT INTO
      Cancels(
      sid,
      launch_date,
      course_id,
      date,
      package_credit,
      refund_amt,
      cust_id,
      by_package
    )
    VALUES(
      sessionId,
      launchDate,
      cid,
      CNOW(),
      0,
      0,
      _cust_id,
      true
    );
  END IF;
ELSE
  RAISE EXCEPTION 'Session that has already passed cannot be cancelled.';
END IF;
END;
$$ LANGUAGE plpgsql;


drop function if exists update_instructor;
create or replace function update_instructor(_course_offering_id integer, _sid integer, _eid integer)
returns void
as $$
DECLARE
	_session_start_date date;
	_session_start_time integer;
	_course_id integer;
	_launch_date date;
	exist boolean;
begin
	select S.date, S.start_time, S.course_id, S.launch_date into _session_start_date, _session_start_time, _course_id, _launch_date from Sessions S, Offerings O where O.course_offering_id = _course_offering_id and O.course_id = S.course_id and O.launch_date = S.launch_date and S.sid = _sid;
	if _session_start_date > CNOW() then
		select exists (select 1 from find_instructors(_course_id, _session_start_date, _session_start_time) where eid = _eid) into exist;
		if exist then
			update Sessions set eid = _eid where course_id = _course_id and launch_date = _launch_date and sid = _sid;
		else
			RAISE EXCEPTION 'Replacing instructor does not fulfill requirements.';
		end if;
	else
		RAISE EXCEPTION 'Course session has either already started or is over.';
	end if;
end;
$$language plpgsql;


drop function if exists update_room;
create or replace function update_room(_course_offering_id integer, _sid integer, _rid integer)
returns void
as $$
declare
	_old_rid integer;
	_launch_date date;
	_course_id integer;
	_date date;
	_start_time integer;
	_seating_capacity integer;
	_num_registered integer;
begin
	select launch_date, course_id into _launch_date, _course_id from Offerings where course_offering_id = _course_offering_id;
	select date, start_time, rid into _date, _start_time, _old_rid from Sessions natural join Rooms
	where sid = _sid and launch_date = _launch_date and course_id = _course_id;
	if (select _date + _start_time * interval '1' hour) > CNOW() then
		if exists(select 1 from find_rooms(_date, _start_time, 1) where rid = _rid) then
			select (select count(*) from Registers R where course_id = _course_id and launch_date = _launch_date and sid = _sid)
			+ (select count(*) from Redeems R where course_id = _course_id and launch_date = _launch_date and sid = _sid)
			- (select count(*) from Cancels C where course_id = _course_id and launch_date = _launch_date and sid = _sid) into _num_registered;
			if _num_registered <= (select seating_capacity from Rooms where rid = _rid) then
				update Sessions set rid = _rid where course_id = _course_id and launch_date = _launch_date and sid = _sid;
				select sum(R.seating_capacity) into _seating_capacity from Rooms R natural join Sessions S where S.course_id = _course_id and S.launch_date= _launch_date;
				if (select target_number_registrations <= _seating_capacity from Offerings where course_offering_id = _course_offering_id) then
					update Offerings O set seating_capacity = _seating_capacity where O.course_id = _course_id and O.launch_date = _launch_date;
				else
					RAISE EXCEPTION 'Target number of registrations cannot fall below total seating capacity for an offering.';
				end if;
			else
				RAISE EXCEPTION 'New room unable to hold all currently registered participants.';
			end if;
		elsif _old_rid = _rid then
			RAISE EXCEPTION 'Room to be updated is the same as the old room.';
		else
			RAISE EXCEPTION 'Room is not available.';
		end if;
	else
		RAISE EXCEPTION 'Session is ongoing/ has passed.';
	end if;
END;
$$language plpgsql;


drop function if exists remove_session;
create or replace function remove_session(course_offering_id_i integer, sid_i integer)
returns void as $$
declare
success boolean;
_launch_date date;
_course_id integer;
_date date;
_start_time integer;
_min_date date;
_max_date date;
_seating_capacity integer;
begin
    select s1.course_id into _course_id from Sessions s1 inner join Offerings O
    on s1.course_id = O.course_id and s1.launch_date = O.launch_date where O.course_offering_id = course_offering_id_i;
    select s1.launch_date into _launch_date from Sessions s1 inner join Offerings O
    on s1.course_id = O.course_id and s1.launch_date = O.launch_date where O.course_offering_id = course_offering_id_i;

    _date := (select s1.date from Sessions s1
    where s1.course_id = _course_id and s1.launch_date = _launch_date and s1.sid = sid_i);
    _start_time := (select s1.start_time from Sessions s1
    where s1.course_id = _course_id and s1.launch_date = _launch_date and s1.sid = sid_i);
    if CNOW() < _date + _start_time * INTERVAL '1' hour then
        select exists (select * from Sessions s2 where s2.sid = sid_i and
        s2.course_id = _course_id and s2.launch_date = _launch_date) into success;
        if success then
            select (_course_id, _launch_date, sid_i) not in (select r.course_id, r.launch_date, r.sid from Registers r
union all select rr.course_id, rr.launch_date, rr.sid from Redeems rr
except all select c.course_id, c.launch_date, c.sid
from Cancels c) into success;
            if success then
                delete from Sessions s3 where s3.sid = sid_i and
                s3.course_id = _course_id and s3.launch_date = _launch_date;
		select min(S.date) into _min_date from Sessions S where S.course_id = _course_id and S.launch_date = _launch_date;
		select max(S.date) into _max_date from Sessions S where S.course_id = _course_id and S.launch_date = _launch_date;
		select sum(R.seating_capacity) into _seating_capacity from Rooms R natural join Sessions S where S.course_id = _course_id and S.launch_date= _launch_date;
		update Offerings O set start_date = _min_date, end_date = _max_date, seating_capacity = _seating_capacity
		where O.course_id = _course_id and O.launch_date = _launch_date;
            else
		RAISE EXCEPTION 'Someone is already registered in this course.';
	    end if;
         end if;
    else
	RAISE EXCEPTION 'Session has ended/ already started';
    end if;
end;
$$ language plpgsql;


drop function if exists add_session;
create or replace function add_session(_course_offering_id integer, _sid integer, _date date, _start_hour integer, _eid integer, _rid integer)
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
	select launch_date, course_id into _launch_date, _course_id, _registration_deadline from Offerings where course_offering_id = _course_offering_id;
	if _registration_deadline > CNOW() then
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


drop function if exists pay_salary;
create or replace function pay_salary()
returns table(eid integer, name text, status text, num_work_hours bigint, num_work_days integer, hourly_rate numeric, monthly_salary numeric, amount numeric) as $$
declare
	temprow record;
begin
	for temprow in
		(select EE.eid, EE.name, 'full-time' as status, null as num_work_hours, (extract(epoch from ((case when (EE.depart_date >= date_trunc('month', CNOW()) + interval '1' month or EE.depart_date is null) then (date_trunc('month', CNOW()) + interval '1' month) else EE.depart_date end) - greatest(EE.join_date, date_trunc('month', CNOW()))))/60/60/24)::integer as num_work_days, 
null as hourly_rate, F.monthly_salary, (extract(epoch from (((case when (EE.depart_date >= date_trunc('month', CNOW()) + interval '1' month or EE.depart_date is null) then (date_trunc('month', CNOW()) + interval '1' month) else EE.depart_date end) - greatest(EE.join_date, date_trunc('month', CNOW()))))/60/60/24)::integer / (extract(epoch from (date_trunc('month', CNOW()) + interval '1' month) - date_trunc('month', CNOW()))/60/60/24)::numeric * F.monthly_salary) as amount
from Employees EE natural join Full_time_Emp F where (EE.depart_date >= date_trunc('month', CNOW()) or EE.depart_date is null) and EE.join_date < date_trunc('month', CNOW()) + interval '1' month
		union
		select E.eid, E.name, 'part-time', (select count(*) from Sessions S where S.eid=E.eid and S.date >= date_trunc('month', CNOW()) and S.date < date_trunc('month', CNOW()) + interval '1' month),
null, P.hourly_rate, null, P.hourly_rate * (select count(*) from Sessions S where S.eid=E.eid and S.date >= date_trunc('month', CNOW()) and S.date < date_trunc('month', CNOW()) + interval '1' month)
from Employees E natural join Part_time_Emp P where (E.depart_date >= date_trunc('month', CNOW()) or E.depart_date is null) and E.join_date < date_trunc('month', CNOW()) + interval '1' month)
	loop
		insert into Pay_slips(eid, payment_date, num_work_hours, num_work_days, amount)
		values (temprow.eid, CNOW()::date, temprow.num_work_hours, temprow.num_work_days, temprow.amount);
	end loop;

	return query select EE.eid, EE.name, 'full-time' as status, null as num_work_hours, (extract(epoch from ((case when (EE.depart_date >= date_trunc('month', CNOW()) + interval '1' month or EE.depart_date is null) then (date_trunc('month', CNOW()) + interval '1' month) else EE.depart_date end) - greatest(EE.join_date, date_trunc('month', CNOW()))))/60/60/24)::integer as num_work_days, 
null as hourly_rate, F.monthly_salary, (extract(epoch from (((case when (EE.depart_date >= date_trunc('month', CNOW()) + interval '1' month or EE.depart_date is null) then (date_trunc('month', CNOW()) + interval '1' month) else EE.depart_date end) - greatest(EE.join_date, date_trunc('month', CNOW()))))/60/60/24)::integer / (extract(epoch from (date_trunc('month', CNOW()) + interval '1' month) - date_trunc('month', CNOW()))/60/60/24)::numeric * F.monthly_salary) as amount
from Employees EE natural join Full_time_Emp F where (EE.depart_date >= date_trunc('month', CNOW()) or EE.depart_date is null) and EE.join_date < date_trunc('month', CNOW()) + interval '1' month
		union
		select E.eid, E.name, 'part-time', (select count(*) from Sessions S where S.eid=E.eid and S.date >= date_trunc('month', CNOW()) and S.date < date_trunc('month', CNOW()) + interval '1' month),
null, P.hourly_rate, null, P.hourly_rate * (select count(*) from Sessions S where S.eid=E.eid and S.date >= date_trunc('month', CNOW()) and S.date < date_trunc('month', CNOW()) + interval '1' month)
from Employees E natural join Part_time_Emp P where (E.depart_date >= date_trunc('month', CNOW()) or E.depart_date is null) and E.join_date < date_trunc('month', CNOW()) + interval '1' month;
end;
$$ language plpgsql;


drop function if exists promote_courses;
create or replace function promote_courses()
returns table(cust_id integer, name text, course_area text, course_id integer, course_title text,
launch_date date, registration_deadline date, fee numeric)
as $$
begin
	return query with temp as (select CC.cust_id, CC.name, 
(select array_agg(a) from (select R.course_id, R.date from Credit_cards V natural join Registers R where V.cust_id=CC.cust_id 
union select RR.course_id, RR.redeem_date as date from Redeems RR natural join Buys B natural join Credit_cards VV where VV.cust_id=CC.cust_id
order by date desc limit 3) as t(a,b))
as arr from Customers CC where not exists
(select 1 from Registers R natural join Credit_cards C where R.date>= date_trunc('month', CNOW()) - interval '5' month and CC.cust_id=C.cust_id)
and not exists(select 1 from Redeems R natural join Buys B natural join Credit_cards C 
where R.redeem_date>= date_trunc('month', CNOW()) - interval '5' month and CC.cust_id=C.cust_id))
	select T.cust_id, T.name, C.name, C.course_id, C.title, O.launch_date, O.registration_deadline, O.fees
from temp T, (Courses C natural join Offerings O) 
where (C.name in (select CC.name from Courses CC where CC.course_id=any(T.arr)) or T.arr is null)
and O.target_number_registrations
- (select count(*) from Registers R where O.course_id=R.course_id and O.launch_date=R.launch_date)
- (select count(*) from Redeems R where O.course_id=R.course_id and O.launch_date=R.launch_date)
+ (select count(*) from Cancels C where O.course_id=C.course_id and O.launch_date=C.launch_date) > 0
and O.registration_deadline >= CNOW()::date
order by T.cust_id, O.registration_deadline;
END;
$$language plpgsql;
--and (T.cust_id, C.course_id) not in (select CC.cust_id, R.course_id from Credit_cards CC natural join Registers R)
--3 most recent course offerings may fall under the same course and this includes course offerings that are registered for but cancelled afterwards


drop function if exists top_packages;
create or replace function top_packages(_N integer)
returns table(package_id integer, number_of_free_sessions integer, price numeric, start_date date, end_date date, number_of_packages_sold integer)
as $$
begin
	if _N > (select count(*) from Course_packages P where P.sale_start_date >= date_trunc('year', CNOW()) and P.sale_start_date < date_trunc('year', CNOW()) + interval '1' year) then
		return query WITH cte3 AS
			(select P.package_id, P.num_free_registrations, P.price, P.sale_start_date, P.sale_end_date, (select count(*) from Buys B where B.package_id=P.package_id)::integer as number_of_packages_sold from Course_packages P
			where P.sale_start_date >= date_trunc('year', CNOW()) and P.sale_start_date < date_trunc('year', CNOW()) + interval '1' year)
		select cte3.package_id, cte3.num_free_registrations, cte3.price, cte3.sale_start_date, cte3.sale_end_date, cte3.number_of_packages_sold from cte3 order by number_of_packages_sold desc, price desc;
	else
		return query WITH cte AS
			(select P.package_id, P.num_free_registrations, P.price, P.sale_start_date, P.sale_end_date, (select count(*) from Buys B where B.package_id=P.package_id) as number_of_packages_sold from Course_packages P 
			where P.sale_start_date >= date_trunc('year', CNOW()) and P.sale_start_date < date_trunc('year', CNOW()) + interval '1' year
			order by number_of_packages_sold desc, price desc limit 1 offset _N-1),
			cte2 AS
			(select P.package_id, P.num_free_registrations, P.price, P.sale_start_date, P.sale_end_date, (select count(*) from Buys B where B.package_id=P.package_id)::integer as number_of_packages_sold from Course_packages P
                        where P.sale_start_date >= date_trunc('year', CNOW()) and P.sale_start_date < date_trunc('year', CNOW()) + interval '1' year)
		select cte2.package_id, cte2.num_free_registrations, cte2.price, cte2.sale_start_date, cte2.sale_end_date, cte2.number_of_packages_sold from cte2 where cte2.number_of_packages_sold>=(select cte.number_of_packages_sold from cte) order by number_of_packages_sold desc, price desc;
	end if;
end;
$$language plpgsql;


drop function if exists popular_courses;
create or replace function popular_courses()
returns table(course_id integer, title text, course_area text, num_offerings bigint, num_registrations bigint)
as $$
begin
	return query select C.course_id, C.title, C.name, count(*), 
((select count(*) from Registers R natural join Offerings OO where R.course_id = C.course_id and OO.start_date = 
(select max(OOO.start_date) from Offerings OOO where OOO.course_id = C.course_id 
and OOO.start_date >= date_trunc('year', CNOW()) and OOO.start_date < date_trunc('year', CNOW()) + interval '1' year))
+(select count(*) from Redeems R natural join Offerings OO where R.course_id = C.course_id and OO.start_date = 
(select max(OOO.start_date) from Offerings OOO where OOO.course_id = C.course_id 
and OOO.start_date >= date_trunc('year', CNOW()) and OOO.start_date < date_trunc('year', CNOW()) + interval '1' year))
-(select count(*) from Cancels CC natural join Offerings OO where CC.course_id = C.course_id and OO.start_date = 
(select max(OOO.start_date) from Offerings OOO where OOO.course_id = C.course_id 
and OOO.start_date >= date_trunc('year', CNOW()) and OOO.start_date < date_trunc('year', CNOW()) + interval '1' year)))
as num_registrations 
from Courses C natural join Offerings O
where O.start_date >= date_trunc('year', CNOW()) and O.start_date < date_trunc('year', CNOW()) + interval '1' year
and C.course_id not in (select OO.course_id from Offerings OO, Offerings OOO
where OO.start_date > OOO.start_date and OO.start_date >= date_trunc('year', CNOW()) and OO.start_date < date_trunc('year', CNOW()) + interval '1' year
and OOO.start_date >= date_trunc('year', CNOW()) and OOO.start_date < date_trunc('year', CNOW()) + interval '1' year and
(select count(*) from Registers R where OO.course_id = R.course_id and OO.launch_date = R.launch_date)
+ (select count(*) from Redeems R where OO.course_id=R.course_id and OO.launch_date=R.launch_date)
- (select count(*) from Cancels CC where OO.course_id=CC.course_id and OO.launch_date=CC.launch_date)
<= (select count(*) from Registers R where OOO.course_id = R.course_id and OOO.launch_date = R.launch_date)
+ (select count(*) from Redeems R where OOO.course_id=R.course_id and OOO.launch_date=R.launch_date)
- (select count(*) from Cancels CC where OOO.course_id=CC.course_id and OOO.launch_date=CC.launch_date))
group by C.course_id having count(*) > 1 order by num_registrations desc, C.course_id asc;
END;
$$language plpgsql;
--Assumes that there is only 1 latest offering i.e. 2 offerings cannot have the same start_date (implied by question?)


drop function if exists view_summary_report;
create or replace function view_summary_report(N integer)
returns table(month integer, year integer, total_salary numeric, total_packages_sales numeric, 
total_fees_credit_cards numeric, refunded_registration_fees numeric, total_redemptions bigint)
as $$
begin
	return query select extract(month from st_date)::integer as month, extract(year from st_date)::integer as year, 
(select coalesce(sum(amount), 0) from Pay_slips where extract(month from payment_date)=extract(month from st_date)::integer and extract(year from payment_date)=extract(year from st_date)::integer) as total_salary,
(select coalesce(sum(price), 0) from Course_packages natural join Buys where extract(month from date)=extract(month from st_date)::integer and extract(year from date)=extract(year from st_date)::integer) as total_packages_sales,
(select coalesce(sum(fees), 0) from Registers natural join Offerings where extract(month from date)=extract(month from st_date)::integer and extract(year from date)=extract(year from st_date)::integer) as total_fees_credit_cards,
(select coalesce(sum(refund_amt), 0) from Cancels where extract(month from date)=extract(month from st_date)::integer and extract(year from date)=extract(year from st_date)::integer) as refunded_registration_fees,
(select count(*) from Redeems where extract(month from redeem_date)=extract(month from st_date)::integer and extract(year from redeem_date)=extract(year from st_date)::integer) as total_redemptions
from generate_series(date_trunc('month', CNOW()) - (N-1) * interval '1' month, date_trunc('month', CNOW()), '1 month'::interval) as st_date;
END;
$$language plpgsql;
--total_fees_credit_cards is calculated without considering refunds
--i.e. $1 as fees from offerings, after refund before deadline $0.90 as refund_amt, total_fees_credit_cards is $1
--refunded_registration_fees only comprise of the 90% refunds.

drop function if exists view_manager_report;
create or replace function view_manager_report()
returns table(name text, num_course_areas bigint, num_course_offerings bigint, total_net_registration_fees numeric, title text[])
as $$
begin
	return query select E.name, (select count(*) from Course_areas A where A.eid=M.eid), 
(select count(*) from (Offerings natural join Courses C) inner join Course_areas A on C.name=A.name
where end_date >= date_trunc('year', CNOW()) and end_date < date_trunc('year', CNOW()) + interval '1' year and A.eid=M.eid),
(select coalesce(sum((select coalesce(sum(OO.fees), 0) from Registers R natural join Offerings OO where O.course_id=OO.course_id and O.launch_date=OO.launch_date)
- (select coalesce(sum(refund_amt), 0) from Cancels natural join Offerings OO where O.course_id=OO.course_id and O.launch_date=OO.launch_date)
+ (select coalesce(sum(floor(price/num_free_registrations)), 0) from Redeems R natural join Course_packages where O.course_id=R.course_id and O.launch_date=R.launch_date)), 0)
from (Offerings O natural join Courses C) inner join Course_areas A on C.name=A.name
where end_date >= date_trunc('year', CNOW()) and end_date < date_trunc('year', CNOW()) + interval '1' year and A.eid=M.eid),
(select coalesce(array_agg(distinct C.title), '{}') from (Offerings O natural join Courses C) inner join Course_areas A on C.name=A.name
where O.end_date >= date_trunc('year', CNOW()) and O.end_date < date_trunc('year', CNOW()) + interval '1' year and A.eid=M.eid
and (select coalesce(sum(OO.fees), 0) from Registers R natural join Offerings OO where O.course_id=OO.course_id and O.launch_date=OO.launch_date)
- (select coalesce(sum(refund_amt), 0) from Cancels natural join Offerings OO where O.course_id=OO.course_id and O.launch_date=OO.launch_date)
+ (select coalesce(sum(floor(price/num_free_registrations)), 0) from Redeems R natural join Course_packages where O.course_id=R.course_id and O.launch_date=R.launch_date)
>= all(select (select coalesce(sum(OO.fees), 0) from Registers R natural join Offerings OO where OOO.course_id=OO.course_id and OOO.launch_date=OO.launch_date)
- (select coalesce(sum(refund_amt), 0) from Cancels natural join Offerings OO where OOO.course_id=OO.course_id and OOO.launch_date=OO.launch_date)
+ (select coalesce(sum(floor(price/num_free_registrations)), 0) from Redeems R natural join Course_packages where OOO.course_id=R.course_id and OOO.launch_date=R.launch_date)
from (Offerings OOO natural join Courses CC) inner join Course_areas AA on CC.name=AA.name
where OOO.end_date >= date_trunc('year', CNOW()) and OOO.end_date < date_trunc('year', CNOW()) + interval '1' year and AA.eid=M.eid))
from Managers M natural join Employees E;
END;
$$language plpgsql;

