drop table if exists Employees, Pay_slips, Part_time_Emp, Full_time_Emp, Administrators, Managers, Instructors
, Part_time_instructors, Full_time_instructors, Courses, Course_areas, Offerings, Specializes, Rooms, Sessions
, Customers, Cancels, Credit_cards, Registers, Registers, Course_packages, Buys, Redeems, _Time cascade;

--date that the employee departed the company (the value is null if an employee is still employed by the company).
create table Employees(
	eid serial primary key,
	name text not null unique,
	phone text constraint employees_phone check(phone not similar to '%[^0-9]%' and phone<>''),
	address text,
	email text constraint employees_email check(email like '%_@__%.__%'),
	depart_date date default null,
	join_date date not null,
	constraint employees_join_depart_date check(join_date <= depart_date)
);

/*
Missing
Each part-time instructor must not teach more than 30 hours for each month.
salary amount for full-time = employee’s monthly salary * no. of work days for the month / no. of days in the month.
no. of work days for the month = (last work day - first work day + 1).
first work day = day of the employee’s joined date if the employee’s joined date is within the month of payment; otherwise, it is equal to 1.
last work day = day of the employee’s departed date if the employee’s departed date is within the month of payment; otherwise, it is equal to the no. of days in the month.
salary amount for part-time = employee’s hourly rate * the number of work hours for the month.
*/
create table Pay_slips(
	eid integer references Employees on delete cascade,
	payment_date date,
	num_work_hours integer,
	num_work_days integer,
	amount numeric not null,
	primary key(eid, payment_date)
);

create table Part_time_Emp(
	eid integer primary key,
	hourly_rate numeric not null,
	foreign key(eid) references Employees on delete cascade
);

create table Full_time_Emp(
	eid integer primary key,
	monthly_salary numeric not null,
	foreign key(eid) references Employees on delete cascade
);

create table Administrators(
	eid integer primary key,
	foreign key(eid) references Full_time_Emp on delete cascade
);

create table Managers(
	eid integer primary key,
	foreign key(eid) references Full_time_Emp on delete cascade
);

create table Instructors(
	eid integer primary key,
	foreign key(eid) references Employees on delete cascade
);

create table Part_time_instructors(
	eid integer primary key,
	foreign key(eid) references Instructors on delete cascade,
	foreign key(eid) references Part_time_Emp on delete cascade
);

create table Full_time_instructors(
	eid integer primary key,
	foreign key(eid) references Instructors on delete cascade,
	foreign key(eid) references Full_time_Emp on delete cascade
);

--Course_areas+Manages
create table Course_areas(
	name text primary key,
	eid integer not null references Managers
);

--unique course title
--duration(in terms of number of hours)
create table Courses(
	course_id serial primary key,
	duration integer not null,
	description text not null,
	title text unique not null,
	name text not null references Course_areas
);

--Offerings+Has+Handles
--The registration deadline for a course offering must be at least 10 days before its start date.
/*
Missing
seating capacity of a course offering is equal to the sum of the seating capacities of its sessions
A course offering is said to be available if the number of registrations received is no more than its seating capacity;
otherwise, we say that a course offering is fully booked.
Each course offering is managed by the manager of that course area.
*/
create table Offerings(
	course_offering_id serial unique,
	course_id integer,
	launch_date date,
	start_date date not null,
	end_date date not null,
	registration_deadline date not null,
	target_number_registrations integer not null,
	seating_capacity integer not null,
	fees numeric not null,
	eid integer not null references Administrators,
	primary key(course_id, launch_date),
	foreign key(course_id) references Courses on delete cascade,
	constraint offerings_launch_date_registration_deadline check(launch_date <= registration_deadline),
	constraint offerings_start_date_registration_deadline check(start_date - registration_deadline >= 10),
	constraint offerings_start_date_end_date check(start_date <= end_date)
);

/*
Missing
Cannot enforce total participation constraint with Instructors with regards to Specializes
(Each instructor specializes in a set of one or more course areas)
*/
create table Specializes(
	eid integer references Instructors,
	name text references Course_areas,
	primary key(eid, name)
);

create table Rooms(
	rid integer primary key,
	location text not null,
	seating_capacity integer not null
);

--Sessions+Consists+Conducts
--The earliest session can start at 9am and the latest session (for each day) must end by 6pm, and no sessions are conducted between 12pm to 2pm.
/*
Missing
A trigger is needed to enforce sid to start from 1 for each course offering instead of serial
Cannot enforce total participation constraint of Offerings with regards to Consists
an instructor who is assigned to teach a course session must be specialized in that course area
there must be at least one hour of break between any two course sessions that the instructor is teaching
*/
create table Sessions(
	course_id integer,
	launch_date date,
	sid serial,
	rid integer not null references Rooms,
	eid integer not null references Instructors,
	date date not null check(extract(dow from date) not in (6,0)),
	start_time integer not null constraint sessions_start_time check((start_time>=9 and start_time<=11) or (start_time>=14 and start_time<=17)),
	end_time integer not null,
	unique(course_id, date, start_time),
	unique(rid, date, start_time),
	unique(eid, date, start_time),
	primary key(course_id, launch_date, sid),
	foreign key(course_id, launch_date) references Offerings on delete cascade,
	constraint sessions_1_hour_duration check(end_time = start_time + 1)
);

create table Customers(
	cust_id serial primary key,
	address text,
	phone text constraint customers_phone check(phone not similar to '%[^0-9]%' and phone<>''),
	name text not null unique,
	email text constraint customers_email check(email like '%_@__%.__%')
);

/*
Missing
For a credit card payment, the company’s cancellation policy will refund 90% of the paid fees for a registered course
if the cancellation is made at least 7 days before the day of the registered session; otherwise, there will no refund
for a late cancellation. For a redeemed course session, the company’s cancellation policy will credit an extra course session
to the customer’s course package if the cancellation is made at least 7 days before the day of the registered session;
otherwise, there will no refund for a late cancellation.
*/
create table Cancels(
	date timestamp,
	cust_id integer references Customers,
	course_id integer,
	launch_date date,
	sid integer,
	refund_amt numeric,
	package_credit integer,
	by_package boolean,
	primary key(date, cust_id, course_id, launch_date, sid),
	foreign key(course_id, launch_date, sid) references Sessions
);

--Credit_cards+Owns
--from_date date default CURRENT_DATE
--constraint credit_cards_from_date_expiry_date check(from_date <= expiry_date)
--removed to allow adding of customers with expired credit card since the details can be updated later
/*
Missing
Cannot enforce total participation constraint of Customers with regards to Owns
*/
create table Credit_cards(
	number integer primary key,
	CVV text not null,
	expiry_date date not null,
	from_date date,
	cust_id integer not null references Customers
);

/*
Missing
For each course offered by the company, a customer can register for at most one of its sessions before its registration deadline.
*/
create table Registers(
	date timestamp,
	number integer references Credit_cards on update cascade,
	course_id integer,
	launch_date date,
	sid integer,
	primary key(date, number, course_id, launch_date, sid),
	foreign key(course_id, launch_date, sid) references Sessions on update cascade
);

/*
Missing
active - at least one unused session in the package
partially active - all the sessions in the package have been redeemed but there is at least one redeemed session that could be refunded if it is cancelled
inactive - otherwise
Each customer can have at most one active or partially active package.
*/
create table Course_packages(
	package_id serial primary key,
	sale_start_date date not null,
	sale_end_date date not null,
	num_free_registrations integer not null constraint course_packages_num_free_registrations check(num_free_registrations > 0),
	name text not null,
	price numeric check(price >= 0),
	constraint course_packages_sale_start_end_date check(sale_start_date<=sale_end_date)
);

--On update cascade to fit in with the update_credit_card function
--Can only buy up to 1 package a day
--date date default CURRENT_DATE
create table Buys(
	date date,
	number integer references Credit_cards on update cascade,
	package_id integer references Course_packages,
	num_remaining_redemptions integer,
	primary key(date, number, package_id)
);

--date in Redeems change to redeem_date
create table Redeems(
	redeem_date timestamp,
	date date,
	number integer,
	package_id integer,
	course_id integer,
	launch_date date,
	sid integer,
	primary key(redeem_date, date, number, package_id, course_id, launch_date, sid),
	foreign key(date, number, package_id) references Buys on update cascade,
	foreign key(course_id, launch_date, sid) references Sessions
);

create table _Time(
	uid integer primary key,
	now timestamp
);


drop trigger if exists sid_trigger on Sessions;
drop trigger if exists insert_payslip_once_trigger on Pay_slips; 

drop function if exists add_appropriate_sid;
CREATE OR REPLACE FUNCTION add_appropriate_sid()
RETURNS TRIGGER
AS $$
DECLARE
	id integer;
BEGIN
	if NEW.sid = 0 then
		id := null;
		select tag into id
		from (
			select generate_series (1, (select max(sid) from Sessions where course_id=NEW.course_id and launch_date=NEW.launch_date)) as tag
			except
    			select sid from Sessions where course_id=NEW.course_id and launch_date=NEW.launch_date
		) s
		order by tag
		limit 1;
		if id is null then
			NEW.sid := (select coalesce(max(sid), 0) + 1 from Sessions where course_id=NEW.course_id and launch_date=NEW.launch_date);
		else
			NEW.sid := id;
		end if;
	end if;
	return NEW; 
END;
$$LANGUAGE plpgsql;

create trigger sid_trigger
before insert on Sessions
for each row execute function add_appropriate_sid();


drop function if exists insert_payslip_once;
CREATE OR REPLACE FUNCTION insert_payslip_once()
RETURNS TRIGGER
AS $$
BEGIN
	if date_trunc('month', CNOW()::date) <>  date_trunc('month', CNOW()::date + interval '1' day) then
		return NEW;
	end if;
	RAISE NOTICE 'It is not the end of the month yet';
	return null; 
END;
$$LANGUAGE plpgsql;

create trigger insert_payslip_once_trigger
before insert on Pay_slips
for each row execute function insert_payslip_once();


drop function if exists target_less_than_seating_capacity;
CREATE OR REPLACE FUNCTION target_less_than_seating_capacity()
RETURNS TRIGGER
AS $$
BEGIN
	if NEW.target_number_registrations <= NEW.seating_capacity then
		return NEW;
	end if;
	RAISE NOTICE 'The seating capacity of the course offering must be at least equal to the course offering’s target number of registrations.';
	return null; 
END;
$$LANGUAGE plpgsql;
--cannot be implemented in table since remove_session allows seating capacity to fall below target number registration.

create trigger target_less_than_seating_capacity_trigger
before insert on Offerings
for each row execute function target_less_than_seating_capacity();