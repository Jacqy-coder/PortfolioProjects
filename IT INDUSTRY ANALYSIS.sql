SELECT *
FROM salaries

--The salary analysis by getting the average salary by job title

SELECT job_title, AVG(salary_in_usd) as avarage_salary, RANK() OVER (ORDER BY AVG(salary_in_usd) DESC) as rank
FROM salaries
GROUP BY job_title
ORDER BY AVG(salary_in_usd) DESC;


--Getting the remote work analysis

SELECT remote_ratio, AVG(salary_in_usd)
FROM salaries
GROUP BY remote_ratio;

-- calculating number of job postng that allow remote work by the job title
SELECT job_title, COUNT(*) as remote_jobs, RANK() OVER (ORDER BY COUNT(*) DESC) as rank
FROM salaries
WHERE remote_ratio > 0
GROUP BY job_title
ORDER BY COUNT(*) DESC;


--getting the company analysis
--avarage salary by company size

SELECT company_size, AVG(salary_in_usd) AS Average_Salary, RANK() OVER (ORDER BY AVG(salary_in_usd) DESC) as rank
FROM salaries
GROUP BY company_size
order by AVG(salary_in_usd) DESC;

--number of job_title by region

SELECT company_location, COUNT(*) as job_count, RANK() OVER (ORDER BY COUNT(*) DESC) as rank
FROM salaries
GROUP BY company_location
ORDER BY COUNT(*) DESC;

--Job title analysis

SELECT job_title, experience_level, COUNT(*) as job_count, RANK() OVER (ORDER BY COUNT(*) DESC) as rank
FROM salaries
GROUP BY job_title, experience_level
ORDER BY COUNT(*) DESC;

--most popular job titles 
SELECT TOP 10 remote_ratio, job_title, COUNT(*) as job_count
FROM salaries
GROUP BY remote_ratio, job_title
ORDER BY job_count DESC






