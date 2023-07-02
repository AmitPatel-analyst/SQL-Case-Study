Date : 12-June-2023

-- SQL Challenge Questions:
--1. Find the longest ongoung project for each department.
--2. Find all employees who are not managers.
--3. Find all employees who have been hired after the start of a project in their department.
--4. Rank employees within each department based on their hire date ( earliest hire gets the highest rank).
--5. Find the duration between the hire date of each employee and the hire date of the next employee.

  Solution 1 :-
select   department_id,
        end_date - start_date as longestperiod_indays
from    projects;

  Solution 2 :-
select   *
from     employees
where   job_title not like '%Manager%';

  Solution 3 :-
select     e.id,e.name,e.hire_date,p.start_date as Project_start_date,e.job_title,
           e.department_id
from      employees as e
inner join departments as d
on       d.id= e.department_id
inner join  projects as p
on       p.department_id = d.id
where hire_date  > start_date;

  Solution 4 :-
select department_id , id as emp_id, name as emp_name, hire_date,
       rank() over(partition by department_id order by hire_date) as rank_employees
from   employees;

  Solution 5 :-
With cte as(
      select   row_number() over(partition by department_id order by hire_date) as rn ,
               department_id, hire_date , name,
               coalesce(hire_date - lag(hire_date) over(partition by department_id order by hire_date ), 0) as duration_indays
      from     employees
 )
select       department_id , duration_indays
from         cte
where        duration_indays > 0;
