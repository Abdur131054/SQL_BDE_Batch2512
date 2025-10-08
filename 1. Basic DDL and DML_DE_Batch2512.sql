-- DDL (create, Alter ,Drop, truncate)

create database sql_bde; -- creating database
 
use sql_bde; -- selecting database 

-- creating table

create table employees(
id int primary key, 
first_name varchar(20) not null,
last_name varchar(20),
email varchar(40),
hire_date date,
department varchar(40)
);
-- Alter table 
alter table employees add column age numeric;
alter table employees drop column age;

drop table employees;

-- DML 

insert into employees(id,first_name,last_name,email,hire_date,department)
values
(1,'Abdur','Rahman','abdur.rahman@gmail.com','2023-12-01','IT'),
(2,'Ashikur','Rahman','ashikur.rahman@gmail.com','2023-12-02','HR'),
(3,'Siddik','','ashikur.rahman@gmail.com','2023-12-02','Accounts');
-- DDL (delete all rows from table)
truncate table employees;

-- update last name

update employees
set  last_name= 'Khan'
where id=3;

select * from employees;

-- deleting a row
delete from sql_bde.employees where id=3;

-- DDL
drop table sql_bde.employees;

drop database sql_bde;



