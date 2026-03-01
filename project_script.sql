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
	remote_status varchar(50),
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

--- Create industry_layoffs table
create table industry_layoffs (
	industry varchar(50) primary key,
	total_layoffs int,
	number_companies int,
	avg_workforce_percentage numeric,
	avg_severance_weeks numeric
)

--- Create us_state table
create table us_state (
	state varchar(10) primary key,
	total_layoffs int,
	number_companies int,
	percentage_of_usa numeric
)

--- Create ai_impact table
create table ai_impact (
	ai_related varchar(10) primary key,
	total_layoffs int,
	number_companies int,
	percentage numeric
)

--- Create department_layoffs table
create table department_layoffs (
	department varchar(50) primary key,
	total_affected int,
	number_events int
)

--- Create global_layoffs table
create table global_layoffs (
	country varchar(50) primary key,
	total_layoffs int,
	number_companies int,
	percentage_of_total numeric
)

--- Create severance tables
create table severance (
	severance_weeks int primary key,
	number_companies int,
	total_employees int
)

--- Create layoffs_trend table
create table layoffs_trend (
	trend_id serial primary key,
	year int,
	month_name varchar(10),
	quarter int,
	total_layoffs int,
	number_events int
)

