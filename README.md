# TechWorkforceTrends_Project (pgAdmin 4 + Power BI)
Analysis of global tech layoffs and hiring trends (2025-2026) with PostgreSQL and Power BI


## Project Overview

This project analyzes the state of the tech workforce in 2025–2026 by examining layoff patterns, hiring trends, and career transition opportunities. Using SQL and Power BI, the objective is to transform raw workforce data into an interactive, 3 page Power BI dashboard that answers 8 key analytical questions. These questions range from identifying which companies and industries are cutting the most jobs to guiding laid-off workers toward the most financially rewarding and achievable career transitions.

---

## Dataset and Structure

The dataset was sourced from **Kaggle** *([link to be added](https://www.kaggle.com/datasets/ahsanneural/tech-layoffs-and-hiring-trends-2025-2026?select=tech_layoffs_2025_2026.csv))*, which originally contained **11 CSV files** including **dataset_summary_statistics** (excluded this file from the attachment). Out of these, **3 CSV files** were selected and used to build the database for this project:

| Table | Description |
|---|---|
| `tech_layoffs.csv` | Records of tech company layoff events including company, industry, location, department, reason, and workforce impact |
| `tech_hiring.csv` | Active job postings across tech companies including role, salary range, required skills, and location |
| `career_transitions.csv` | Career transition pathways including old/new roles, transferable skills, reskilling time, and success rates |

These 3 CSV files were imported into **PostgreSQL via pgAdmin 4** and structured into their respective relational tables.

---

## Project Workflow

### 1️⃣ Data Preparation in PostgreSQL (pgAdmin 4)

After importing the 3 CSV files into PostgreSQL, 3 created tables as follows:

- `tech_layoffs` — containing 17 columns covering company identity, layoff scale, timing, department, and workforce metadata
- `tech_hiring` — containing 16 columns covering job postings, salary ranges, and required skills
- `career_transitions` — containing 8 columns covering role transition pathways and success metrics

Since none of the original CSV files contained a primary key column, an artificial serial primary key column was manually added to each table upon creation to ensure proper relational database structure:

- `layoff_id` — serial primary key added to `tech_layoffs`
- `job_id` — serial primary key added to `tech_hiring`
- `transition_id` — serial primary key added to `career_transitions`

#### Data Validation & Quality Checks

Before any analysis, a thorough **data quality check** was performed across all three tables to ensure no NULL values, empty strings, or logically invalid data would interfere with results. Checks included:

- NULL and empty string detection across all columns
- Range validation (e.g. negative employee counts, percentages outside 0–100, invalid dates)
- Date consistency checks (cross-validating `year`, `month`, `month_name`, `quarter` against the actual `date` column)
- Salary logic validation (e.g. `salary_max` must not be less than `salary_min`)

#### Exploratory Data Analysis (EDA)

Two additional exploratory checks were conducted before moving to analytical questions:

- **Layoff-Repeat Check** — identified companies that appeared more than once in the dataset, indicating multiple rounds of layoffs in the same company
- **Companies That Went Out of Business Check** — flagged any company where `employees_laid_off = total_employees`, meaning a complete workforce shutdown

#### SQL View Creation

To support cleaner analysis, a SQL view was created:
```
create view categorized_career_transitions as
select *,
	case when lower(new_role) like '%ai%' or lower(new_role) like '%ml%' then 'ai related role'
	else 'others'
	end as role_category
from career_transitions
```

This view categorizes every career transition role as either AI-related or non-AI('others'), enabling direct comparisons across the two groups in both SQL and Power BI.

---

### 2️⃣ Analytical Questions & SQL Queries

8 analytical questions were defined to guide the investigation, each answered with a dedicated SQL query:

**[Q1] The Layoff Percent: Which companies are laying off the most people?**
Aggregates total layoffs and calculates each company's layoff percentage relative to its total workforce, ordered by percentage descending.

**[Q2] The Reason: What is the most common reason for layoffs?**
Groups layoff events by reason and ranks them by total employees affected, revealing the critical reasons behind workforce reductions.

**[Q3] The Monthly Trend: Is the situation getting better or worse?**
Tracks total monthly layoffs from January 2025 to February 2026, using `date_trunc` and `to_char` to generate month-year labels and track layoff progression over time.

**[Q4] Which locations are impacted the most?**
Aggregates layoffs by location, counting distinct companies and total employees affected per region.

**[Q5] Which industries are laying off the most people?**
Ranks industries by total layoffs alongside average layoff size and event frequency, revealing both scale and pattern.

**[Q6] Which skills are the most effective to transition into AI-related roles compared to other ones?**
Utilizes the `categorized_career_transitions` view to identify transferable skills and success rates for both AI and non-AI role transitions.

**[Q7] Which career transitions offer the most money?**
Joins `categorized_career_transitions` with `tech_hiring` on role name to calculate the average market salary per transition role.

**[Q8] Which departments were impacted by layoffs the most?**
Groups layoff data by department, counting affected companies and summing total layoffs to identify which departments were most severely impacted by average workforce cut percentage.

---

