\i schema.sql
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

select * from Customers;
select * from Credit_cards;

select update_credit_card(1, 11, '2021-01-01'::date, 'CVV_11'::text);
select * from Credit_cards;