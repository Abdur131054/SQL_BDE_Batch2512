-- DQL

-- SELECT = column name ( course_id), count(course_id)
-- FROM = table (course_info)
-- WHERE = row-based filtering (course_duration > 100)
-- GROUP BY = non aggregated column name
--		 if there are agrregated functions in select
-- 		Aggregated Function= Sum(), Avg(), Min(), Max(),Count()

-- HAVING = filter after grouping
-- ORDER BY = column name asc desc

-- selecting course title which course duration is greater then 100 units
select course_title,course_duration
from course_info
where course_duration>100;

-- segmenting course upon duration
select
	case when course_duration>100 and course_duration<150
		then '100-149'
		when course_duration>=150 and course_duration<200
		then '150-199'
		else '200+' end as course_segment,
	course_title,
    course_duration
from course_info
where course_duration>100;

-- extracting count by course segment
select
	case when course_duration>100 and course_duration<150
		then '100-149'
		when course_duration>=150 and course_duration<200
		then '150-199'
		else '200+' end as course_segment,
	count(course_title) as course_count
from course_info
where course_duration>100
group by course_segment;

-- extracting course count greater then 25
select
	case when course_duration>100 and course_duration<150
		then '100-149'
		when course_duration>=150 and course_duration<200
		then '150-199'
		else '200+' end as course_segment,
	count(course_title) as course_count
from course_info
where course_duration>100
group by course_segment
having course_count>25;

select * from customer_engagement.course_ratings;
-- count student base
select count(student_id)
from student_info;

select date_registered, student_id
from student_info;

-- extract monthwise registration
select extract(month from date_registered) as month, student_id
from student_info;

select extract(month from date_registered) as month, count(student_id)
from student_info
group by month;

-- extracting those month in which student greater then 4000
select extract(month from date_registered) as month, count(student_id) as student
from student_info
group by month
having student>4000;

-- want to see the result by student count in desc order
select extract(month from date_registered) as month, count(student_id) as student
from student_info
group by month
having student>4000
order by student desc;

-- 
select * from customer_engagement.student_learning;

select student_id,
course_id,
round(sum(minutes_watched)) as total_spent,
count(distinct date_watched) as total_days
from customer_engagement.student_learning
group by student_id, course_id
order by student_id;




    