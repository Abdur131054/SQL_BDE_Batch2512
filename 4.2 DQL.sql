use foodie_fi;
select * from subscriptions;

-- Extract month from start_date

select 
	customer_id,
    plan_id,
    extract(month from start_date) as month
from subscriptions;

-- adding Where condition (discard plan_id 0,4)

select 
	customer_id,
    plan_id,
    extract(month from start_date) as month
from subscriptions
where plan_id!= 0 and plan_id!= 4;

-- using 'not in'
select 
	extract(month from start_date) as month,
    plan_id,
    customer_id
from subscriptions
where plan_id not in (0,4);

-- how many unique customer purchasing 

select 
	extract(month from start_date) as month,
    date_format(start_date,'%M') as months,
    plan_name,
    count(distinct customer_id) as customer_count
from 
	subscriptions
	left join plans
    on subscriptions.plan_id=plans.plan_id
where 
	subscriptions.plan_id between 1 and 3
group by 1,2,3
order by 1 asc, 3 asc;

select 
    date_format(start_date,'%M') as months,
    plan_name,
    count(distinct customer_id) as customer_count
from 
	subscriptions
	left join plans
    on subscriptions.plan_id=plans.plan_id
where 
	subscriptions.plan_id between 1 and 3
group by extract(month from start_date),1,2
order by extract(month from start_date) asc, 2 asc;

-- creating Data Mart

select
	customer_id,
    plan_name,
    start_date,
    date_format(start_date,'%M') as start_months,
    price,
    case
		when price>=1 then 'Yes'
        else 'No'
	end as revenued
from 
	subscriptions
    left join plans
    on subscriptions.plan_id=plans.plan_id;

-- Window Function 


select
	customer_id,
    plan_name,
    start_date,
    date_format(start_date,'%M') as start_months,
    price,
    row_number() over(partition by customer_id  order by start_date asc) as trans_no,
    case
		when price>=1 then 'Yes'
        else 'No'
	end as revenued
    
from 
	subscriptions
    left join plans
    on subscriptions.plan_id=plans.plan_id;


-- -----
select
	customer_id,
    plan_name,
    start_date,
    date_format(start_date,'%M') as start_months,
    price,
    row_number() over(partition by customer_id  order by start_date asc) as trans_no,
    case
		when price>=1 then 'Yes'
        else 'No'
	end as revenued,
    max(case when subscriptions.plan_id=4 then 1 else 0 end) 
		over(partition by customer_id) as churn
    
from 
	subscriptions
    left join plans
    on subscriptions.plan_id=plans.plan_id;

-- rfm(resency frequency Monetary)
-- Recency (R): How recently a customer made a purchase
-- Frequency (F): How often a customer purchases
-- Monetary (M): How much money the customer spends

-- frequency
select
	customer_id,
    plan_name,
    start_date,
    date_format(start_date,'%M') as start_months,
    price,
    row_number() over(partition by customer_id  order by start_date asc) as trans_no,
    case
		when price>=1 then 'Yes'
        else 'No'
	end as revenued,
    max(case when subscriptions.plan_id=4 then 1 else 0 end) over(partition by customer_id) as churn,
    count(case when subscriptions.plan_id between 1 and 3 then start_date else null end) over(partition by customer_id) as frequency
    
from 
	subscriptions
    left join plans
    on subscriptions.plan_id=plans.plan_id;

-- in subscription ,Recency: Days since last login, last activity, or last renewal
-- Loyality

select
	customer_id,
    plan_name,
    start_date,
    date_format(start_date,'%M') as start_months,
    price,
    row_number() over(partition by customer_id  order by start_date asc) as trans_no,
    case
		when price>=1 then 'Yes'
        else 'No'
	end as revenued,
    max(case when subscriptions.plan_id=4 then 1 else 0 end) over(partition by customer_id) as churn,
    count(case when subscriptions.plan_id between 1 and 3 then start_date else null end) over(partition by customer_id) as frequency,
    max(case when subscriptions.plan_id=3 then 1 else 0 end) over(partition by customer_id) as Annual_paid
from 
	subscriptions
    left join plans
    on subscriptions.plan_id=plans.plan_id;
    
    -- Monetary
    
select
	customer_id,
    plan_name,
    start_date,
    date_format(start_date,'%M') as start_months,
    price,
    row_number() over(partition by customer_id  order by start_date asc) as trans_no,
    case
		when price>=1 then 'Yes'
        else 'No'
	end as revenued,
    max(case when subscriptions.plan_id=4 then 1 else 0 end) over(partition by customer_id) as churn,
    count(case when subscriptions.plan_id between 1 and 3 then start_date else null end) over(partition by customer_id) as frequency,
    max(case when subscriptions.plan_id=3 then 1 else 0 end) over(partition by customer_id) as Annual_paid,
    sum(price) over(partition by customer_id) as Total_Revenue
from 
	subscriptions
    left join plans
    on subscriptions.plan_id=plans.plan_id;
    
-- creating DataMart with above code
create table foodie_fi_mart as
(select
	customer_id,
    plan_name,
    start_date,
    date_format(start_date,'%M') as start_months,
    price,
    row_number() over(partition by customer_id  order by start_date asc) as trans_no,
    case
		when price>=1 then 'Yes'
        else 'No'
	end as revenued,
    max(case when subscriptions.plan_id=4 then 1 else 0 end) over(partition by customer_id) as churn,
    count(case when subscriptions.plan_id between 1 and 3 then start_date else null end) over(partition by customer_id) as frequency,
    max(case when subscriptions.plan_id=3 then 1 else 0 end) over(partition by customer_id) as Annual_paid,
    sum(price) over(partition by customer_id) as Total_Revenue
from 
	subscriptions
    left join plans
    on subscriptions.plan_id=plans.plan_id)
