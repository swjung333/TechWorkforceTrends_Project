--- Create tech_layoffs table 
create table tech_layoffs (
	layoff_id serial primary key,
	company varchar(50),
	employees_laid_off int,
	date date,
	industry varchar(50),
	location varchar(50),
	country varchar(50),
	reason text,
	department varchar(50),
	percentage_workforce numeric,
	total_employees int,
	severance_weeks int,
	ai_related text,
	year int,
	month int,
	month_name varchar(50),
	quarter int
)

--- Create tech_hiring table
create table tech_hiring (
	job_id serial primary key,
	company varchar(50),
	role varchar(50),
	number_positions int,
	date_posted date,
	salary_min numeric,
	salary_max numeric,
	location varchar(50),
	country varchar(50),
	remote varchar(50),
	skills_required text,
	experience_years int,
	department varchar(50),
	year int,
	month int,
	salary_average numeric
)

--- Create career_transitions table
create table career_transitions (
	transition_id serial primary key,
	old_role varchar(50),
	new_role varchar(50),
	transferable_Skills text,
	skills_gap text,
	reskilling_time_months int,
	success_rate int,
	companies_offering text
)


--- Data exploration for empty (incl. NULL) and invalid data check

-- tech_layoffs table
select *
from tech_layoffs
where (company is null or trim(company) = '')
or employees_laid_off is null
or date is null
or (industry is null or trim(industry) = '')
or (location is null or trim(location) = '')
or (country is null or trim(country) = '')
or (reason is null or trim(reason) = '')
or (department is null or trim(department) = '')
or percentage_workforce is null
or total_employees is null
or severance_weeks is null
or (ai_related is null or trim(ai_related) = '')
or year is null
or month is null
or (month_name is null or lower(trim(month_name)) not in ('january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'))
or extract(month from date) != month
or extract(year from date) != year
or lower(trim(to_char(date, 'month'))) != lower(trim(month_name)) 
or quarter is null

select *
from tech_layoffs
where employees_laid_off < 0
or percentage_workforce not between 0 and 100
or total_employees < 0
or severance_weeks < 0
or year not between 2025 and 2026
or month not between 1 and 12
or quarter not between 1 and 4
or date not between '2025-01-01' and current_date

-- tech_hiring table
select *
from tech_hiring
where (company is null or trim(company) = '')
or (role is null or trim(role) = '')
or number_positions is null
or date_posted is null
or salary_min is null
or salary_max is null
or (location is null or trim(location) = '')
or (country is null or trim(country) = '')
or (remote is null or trim(remote) = '')
or (skills_required is null or trim(skills_required) = '')
or experience_years is null
or (department is null or trim(department) = '')
or year is null
or month is null
or extract(month from date_posted) != month
or extract(year from date_posted) != year
or salary_average is null

select *
from tech_hiring
where number_positions <= 0
or salary_min < 0
or salary_max < salary_min
or experience_years < 0
or year not between 2025 and 2026
or month not between 1 and 12
or salary_average not between salary_min and salary_max
or date_posted not between '2025-01-01' and current_date

-- career_transitions table
select *
from career_transitions
where (old_role is null or trim(old_role) = '')
or (new_role is null or trim(new_role) = '')
or (transferable_skills is null or trim(transferable_skills) = '')
or (skills_gap is null or trim(skills_gap) = '')
or reskilling_time_months is null
or success_rate is null
or (companies_offering is null or trim(companies_offering) = '')

select *
from career_transitions
where reskilling_time_months < 0
or success_rate not between 0 and 100

--- the layoff-repeat check
select company, date, employees_laid_off, reason
from tech_layoffs
where company in (
    select company 
    from tech_layoffs 
    group by company 
    having count(*) > 1
)
order by 1, 2

--- [Q1] The layoff percent: which companies are laying off the most people?
select 
    company, 
    sum(employees_laid_off) as total_layoffs, 
    max(total_employees) as total_employees,
    (sum(employees_laid_off) * 100.0 / nullif(max(total_employees), 0)) as layoff_percent
from tech_layoffs
group by 1
order by 2 desc
limit 10

--- [Q2] The reason: whats the common reason for layoffs
select 
    reason, 
    count(*) as frequency, 
    sum(employees_laid_off) as total_layoffs
from tech_layoffs
group by 1
order by 3 desc

--- [Q3] The monthly trend: is the situation getting better or worse?
select 
    date_trunc('month', date) as layoff_month,
    sum(employees_laid_off) as monthly_total
from tech_layoffs
group by 1
order by 1