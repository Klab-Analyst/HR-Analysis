CREATE DATABASE project;
USE project;
select*from hr;
alter table hr
rename column ï»¿id to emp_id ;
describe hr;
alter table hr
modify column emp_id varchar(20);
select	birthdate from hr;
set sql_safe_updates = 0;
update hr
set birthdate = case
when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
else null
end;
alter table hr
modify column birthdate date;
select hire_date from hr;
update hr
set hire_date= case
when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
else null
end;
alter table hr
modify column hire_date date;

select termdate from hr;
update hr
set termdate =IF(termdate IS NOT NULL AND termdate !='',
 date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')),'0000-00-00')
 where true;
 
select termdate from hr;
set sql_mode = 'ALLOW_INVALID_DATES';

alter table hr
modify column termdate date;

ALTER TABLE hr
ADD column age int;
select * from hr;
update hr
set age = timestampdiff(YEAR, birthdate, CURDATE());
SELECT birthdate, age FROM hr;
select 
MIN(age) as youngest,
max(age) as oldest from hr;

SELECT count(*) from hr where age< 18;

select count(*) from hr;

-- 1. What is the gender breakdown of the employees in the company?
select gender, count(*) as count from hr where age >= 18 and termdate = '0000-00-00'
group by gender;

-- 2. What is the race/ ethnicity breakdown of employees in the company?
SELECT race, count(*) as count from hr where age >=18 and termdate = '0000-00-00'
group by race
order by count(*) DESC;
-- 3. What is the age distribution of the employee in the company?
select 
case 
when age >= 18 and age <=24 then '18-24'
when age >= 25 and age <=34 then '25-34'
when age >= 35 and age <=44 then '35-44'
when age >= 45 and age <=54 then '45-54'
when age >= 55 and age <=64 then '55-64'
else '65+'
End As age_group,
count(*) as count
from hr 
where age >= 18 and termdate = '0000-00-00'
group by age_group
order by age_group;

select 
case 
when age >= 18 and age <=24 then '18-24'
when age >= 25 and age <=34 then '25-34'
when age >= 35 and age <=44 then '35-44'
when age >= 45 and age <=54 then '45-54'
when age >= 55 and age <=64 then '55-64'
else '65+'
End As age_group, gender,
count(*) as count
from hr 
where age >= 18 and termdate = '0000-00-00'
group by age_group, gender
order by age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) AS count from hr where age >= 18 and termdate = '0000-00-00'
group by location;

-- 5. What is the average lenght of employment for employees who have been terminated?
SELECT
round(avg(datediff(termdate, hire_date))/365) as avg_length_emp from hr 
where termdate <= curdate() and termdate <> '0000-00-00' and age >=18;

-- 6. How does the gender distribution vary across departments and job titles?
select department, gender, count(*) as count from hr 
where age >= 18 and termdate = '0000-00-00' group by gender, department
order by department; 

-- 7. What is the distribution of job titles across the company? --
select jobtitle , count(*) as count from hr
where age >= 18 and termdate = '0000-00-00'
group by jobtitle
order by jobtitle desc; 

-- 8. Which department has the highest turnover rate? --  
select department,
total_count, terminated_count, terminated_count/total_count AS termination_rate
FROM ( select department, count(*) AS total_count,
sum(case when termdate <> '0000-00-00' and termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
FROM hr WHERE age >= 18 group by department) as subquery
order by termination_rate DESC;

-- 9. What is the distribution of employees across location by City and State?
SELECT location_state, COUNT(*) AS count from hr
where age >= 18 and termdate = '0000-00-00'
GROUP BY location_state order by count desc;

-- 10. How has the company's employee count changed over time based on the hire and term dates?
SELECT
year,
hires, 
terminations, 
hires - terminations AS net_change,
round((hires - terminations)/hires*100, 2) AS net_change_percent
FROM(
SELECT YEAR(hire_date) AS year,
count(*) AS hires,
sum(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
from hr where age >= 18
group by year(hire_date)
)as subquery
order by year ASC;

 -- 11. What is the tenure distribution for each department?
 select department, round(avg(datediff(termdate, hire_date)/365), 0) AS avg_tenure
 FROM hr
 where termdate <= curdate() and termdate <> '0000-00-00' AND age >= 18
 GROUP BY department;
    