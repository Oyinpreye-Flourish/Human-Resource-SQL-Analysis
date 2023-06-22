-- QUESTIONS

-- 1. WHAT IS THE GENDER BREAKDOWN OF EMPLOYEES IN THE COMPANY ?
SELECT gender, count(*) AS gender_count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;

-- 2. WHAT IS THE RACE/ETHNICITY BREAKDOWN OF EMPLOYEE IN THE COMPANY ?
SELECT race, count(*) AS race_count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY race_count DESC;

-- 3. WHAT IS THE AGE DISTRIBUTION OF EMPLOYEE IN THE COMPANY ?
SELECT min(age) AS youngest,
	   max(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

# Create an age group
SELECT
	CASE
		WHEN age >=18 AND age <=24 THEN '18-24'
		WHEN age >=25 AND age <=34 THEN '25-34'
		WHEN age >=35 AND age <=44 THEN '35-44'
		WHEN age >=45 AND age <=54 THEN '45-54'
		WHEN age >=55 AND age <=64 THEN '55-64'
        ELSE '65+'
	END AS age_group,
    count(*) AS age_count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

# Distribution of age by gender
SELECT
	CASE
		WHEN age >=18 AND age <=24 THEN '18-24'
		WHEN age >=25 AND age <=34 THEN '25-34'
		WHEN age >=35 AND age <=44 THEN '35-44'
		WHEN age >=45 AND age <=54 THEN '45-54'
		WHEN age >=55 AND age <=64 THEN '55-64'
        ELSE '65+'
	END AS age_group, gender,
    count(*) AS age_count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. HOW MANY EMPLOYEES WORK AT HEADQUARTERS VERSUS REMOTE LOCATIONS ?
SELECT location, count(*) AS location_count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location ;

-- 5. WHAT IS THE AVERAGE LENGTH OF EMPLOYMENT FOR EMPLOYEES WHO HAVE BEEN TERMINATED ?
SELECT
# difference between termdate and hire date
	round(avg(datediff(termdate, hire_date))/365,0)AS avg_length_employment
    FROM hr
	WHERE termdate <= curdate()AND termdate <> '0000-00-00' AND age>=18;

-- 6. HOW DOES THE GENDER DISTRIBUTION VARY ACROSS DEPARTMRNTS AND JOB TITLES ?
SELECT department, gender, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7. WHAT IS THE DISTRIBUTION OF JOB TITLES ACROSS THE COMPANY ?
SELECT jobtitle, count(*) AS jobtitle_count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. WHCH DEPARTMENT HAS THE HIGHEST TURNOVER RATE ?

SELECT department,
	total_count, 
    terminated_count,
    terminated_count/total_count AS  termination_rate
FROM (
	SELECT department,
    count(*) AS total_count,
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age >=18
    GROUP BY department
    ) AS subquery
ORDER BY termination_rate DESC;
-- 9. WHAT IS THE DISTRIBUTION OF EMPLOYEES ACROSS LOCATIONS BY CITY AND STATE ?

SELECT location_state, count(*) AS employee_count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY employee_count DESC;

-- 10. HOW HAS THE COMPANY'S EMPLOYEE COUNT CHANGED OVER TIME BASED ON HIRE AND TERM DATES ?
SELECT
	year,
    hires,
    terminations,
    hires-terminations AS net_change,
    round((hires-terminations)/hires*100,2) AS net_change_percent
FROM (
	SELECT
		YEAR(hire_date) AS year,
        count(*) AS hires,
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
        FROM hr
        WHERE age >= 18
        GROUP BY YEAR(hire_date)
        ) AS subquery
ORDER BY year ASC;

-- 11. WHAT IS THE TENURE DISTRIBUTION FOR EACH DEPARTMRNT ?

SELECT department, round(avg(datediff(termdate, hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >=18
GROUP BY department;