# HR-Analysis

## Table Of Content

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning](#data-cleaning)
 

- ### Project Overview

The HR Employee Distribution Dashboard aims to provide a comprehensive overview of the organization's workforce composition, enabling data-driven decision-making for workforce planning, diversity and inclusion strategies, and employee retention efforts.

### Data Sources
The Primary dataset used for this analysis is the "Human Resources.csv" file.

### Tools
- Excel - Data Inspection
- SQL- Data Cleaning and Analysis
- Power BI - Dashboard Report Creation


 ### Data Cleaning
The following Data cleaning was carried out on SQL ;
- Date Format: The Date format were modified to a proper sql date format
- Miising Values
  ``` SQL
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
   ```

### Analysis
1. What is the gender breakdown of the employees in the company?
2. What is the race/ ethnicity breakdown of employees in the company?
3. What is the age distribution of the employee in the company?
4. How many employees work at headquarters versus remote locations?
5. What is the average lenght of employment for employees who have been terminated?
6. How does the gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. What is the distribution of employees across location by City and State?
10. How has the company's employee count changed over time based on the hire and term dates?
11. What is the tenure distribution for each department?
