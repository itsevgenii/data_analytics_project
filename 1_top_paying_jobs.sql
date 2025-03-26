/* 
question: What are the top paying data analyst jonb?
-Identify the top 10 highest-paying Data Analyst roles that are available remotely.
-Focus on job postings with specified salaries (remove nulls)
-Highlight the top paying opportunities for Data Analysts, offering insights on the highest-paying roles.
*/

SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    name AS company_name,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10

/*
question:
1. What are the top-paying jobs for my role?
2. What are the skills required for these top-paying jobs?
3. What are the most in demand skills for my role?
4. What are the top skills based on salary for my role?
5. What are the most optimal skills to learn?
a. Optimal: High Demand and High Paying
*/

-- CTE
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
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
-- SELECT * FROM job_postings_fact
-- SELECT * FROM company_dim