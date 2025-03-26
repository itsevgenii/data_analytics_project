# 🔍 Introduction

In an increasingly competitive job market, simply being a "Data Analyst" isn't enough — having the right skills makes all the difference. This project dives into a dataset of real job postings to answer one big question:

What skills should a Data Analyst focus on to earn more and stay in demand?
By using SQL to explore job postings data, this analysis uncovers:

The highest-paying Data Analyst roles
The most in-demand skills across the market
The skills with the best return (i.e., high pay and high demand)

### Background

This project explores job market data to help Data Analysts identify the most lucrative and in-demand skills in today’s market. By analyzing real job postings, this project uncovers the highest-paying roles, the most sought-after skills, and which skills strike the perfect balance between demand and salary.

### Tools I used

- **SQL**: The backbone of my analysis;
- **PostgreSQL** and **PgAdmin4**: my database and server where I store the data;
- **VSC**: used to write and execute queries and to interact with the database;
- **Gi**t and **GitHub**: for version control and sharing my SQL scripts and analyses, providing project tracking and collaboration.

## 📈 The Analyses

1. **Top Paying Jobs for Data Analysts**
   - Identified the top 10 highest-paying remote Data Analyst roles
   - Filtered out postings with null salaries
   - Used company name and posting date for context

```sql
WITH top_paying_jobs AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

2. **Top Skills Required for High-Paying Jobs**

   - Extracted required skills for the top 10 highest-paying roles
   - Highlighted the skill sets linked to high compensation

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = 'TRUE'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 10
```

3. **Most In-Demand Skills**

   - Counted the number of postings mentioning each skill
   - Ranked by demand across all remote Data Analyst roles

4. **Skills with Highest Average Salaries**

   - Calculated the average salary associated with each skill
   - Focused on remote jobs with valid salary data

5. **Optimal Skills: High Demand & High Salary**
   - Combined demand and salary metrics to highlight the most valuable skills
   - Filtered out low-demand skills using a threshold (more than 10 postings)

```sql
WITH skills_demand AS(
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = 'TRUE' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
-- ORDER BY
--     demand_count DESC
-- LIMIT 10
), average_salary AS (
    SELECT
    skills_job_dim.skill_id,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = 'TRUE'
GROUP BY
    skills_job_dim.skill_id
-- ORDER BY
    -- demand_count DESC
    -- avg_salary DESC
-- LIMIT 25
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN
    average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25


--rewriting the query to make it more concise

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(salary_year_avg),0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = 'TRUE' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

## What I learned

- Setting up server and database using PgAdmin4, connecting to my database from VSC using SQLTools extension and advanced SQL.
