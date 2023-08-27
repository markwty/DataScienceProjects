\i schema.sql
select add_course_package('package 1'::text, 1, '2020-06-01'::date, '2020-12-01'::date, 1.5);
select add_course_package('package 2'::text, 2, '2020-06-01'::date, '2021-12-01'::date, 2.5);
select add_course_package('package 3'::text, 3, '2021-01-01'::date, '2021-06-01'::date, 3.5);

select * from Course_packages;
