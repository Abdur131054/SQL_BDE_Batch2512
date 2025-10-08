-- DQL
/*
select column name 
from table 
where (optional) condition 
group by (optional/mandatory) non aggregated column names
having (optional) condition 
order by column name asc/desc 
*/

-- all columns ,all data
use foodie_fi;
select * from plans;

-- select plan name with price ,where price is not null

select plan_name,price
from foodie_fi.plans
where price is not null;

-- select which price value is null

select plan_name, price
from foodie_fi.plans
where price is null;

-- showing values greater then 9.90
select plan_name, price
from foodie_fi.plans
where price > 9.90;

-- showing all column and rows for subscriptions 
select * from 
foodie_fi.subscriptions;

select  distinct(plan_id), count(customer_id) as number_of_customers
from foodie_fi.subscriptions
group by plan_id;

select plan_id, count(customer_id) as count
from foodie_fi.subscriptions
where plan_id !=4
group by plan_id
having count<600
order by plan_id asc;

-- Joining

-- inner join
-- left join or left outer join
-- right join or right outer join 
-- full join or full outer join
-- self join

-- condition: There must be at least a common column between the tables

-- Inner join: Return only the rows thart match in both tables

-- Left Join: returns all rows from the left table and matching rows from right tables 
-- if there is no match ,null is returned for right table column

-- right join: return all rows from right table and matching rows from left tables,
-- if there is no match , null is returned for left table

-- full join: return all rows from 


-- Common Table Expression(CTE)
with plan_wise_count as
(select plan_id, count(distinct customer_id) as counts
from foodie_fi.subscriptions
where plan_id !=4
group by plan_id
having counts<600
order by plan_id asc)
select * from plan_wise_count;

-- right join
with plan_wise_count as
(select plan_id, count(distinct customer_id) as counts
from foodie_fi.subscriptions
where plan_id !=4
group by plan_id
having counts<600
order by plan_id asc)
select * from plan_wise_count right join plans
on plan_wise_count.plan_id=plans.plan_id;

-- left join

with plan_wise_count as
(select plan_id, count(distinct customer_id) as counts
from foodie_fi.subscriptions
where plan_id !=4
group by plan_id
having counts<600
order by plan_id asc)
select * from plan_wise_count left join plans
on plan_wise_count.plan_id=plans.plan_id;

with plan_wise_count as
(select plan_id, count(distinct customer_id) as counts
from foodie_fi.subscriptions
where plan_id !=4
group by plan_id
having counts<600
order by plan_id asc)
select 
	plans.plan_name,
	plan_wise_count.counts,
	plans.price
from plan_wise_count left join plans
on plan_wise_count.plan_id=plans.plan_id;

-- calculate revenue
with plan_wise_count as
(select plan_id, count(customer_id) as counts
from foodie_fi.subscriptions
where plan_id !=4
group by plan_id
having counts<600
order by plan_id asc)
select 
	plans.plan_name,
	plan_wise_count.counts,
	round((plans.price * plan_wise_count.counts),0)as revenue
from plan_wise_count left join plans
on plan_wise_count.plan_id=plans.plan_id;





