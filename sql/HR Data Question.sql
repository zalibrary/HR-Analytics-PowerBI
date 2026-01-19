-- 1. What is the gender breakdown of employees in the company?
SELECT gender, count(*) AS count
FROM hr.`human resources`
WHERE age >=18 AND termdate IS NULL
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees?
SELECT race, count(*) AS count
FROM hr.`human resources`
WHERE age >=18 AND termdate IS NULL
GROUP BY race;

-- 3. What is the age distribution of employees in the company?
SELECT
	min(age) AS youngest,
    max(age) AS oldest
FROM hr.`human resources`
WHERE age >= 18 AND termdate is NULL

SELECT
	CASE
		WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
	END AS age_group, gender,
    count(*) AS count
FROM hr.`human resources`
WHERE age >= 18 AND termdate is NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employee work at heradquartes versus remote location?
SELECT location, count(*) AS count
FROM hr.`human resources`
WHERE age >= 18 AND termdate is NULL
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT
    ROUND(AVG(DATEDIFF(termdate, hire_date)) / 365) AS avg_length_employment
FROM hr.`human resources`
WHERE termdate IS NOT NULL
  AND termdate <= CURDATE()
  AND TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) >= 18;
  
-- 6. HOW does the gender distribution vary across department and job title?
SELECT department, gender, COUNT(*) AS count
FROM hr.`human resources`
WHERE age >= 18 AND termdate IS NULL
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, count(*) AS count
FROM hr.`human resources`
WHERE age >= 18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT 
	department,
	total_count, #total karyawan usia >= 18
    terminated_count, #Karyawab yg sudah resign
    terminated_count/total_count AS termination_rate #proporsi resign per department
FROM (
	SELECT department,
    count(*) AS total_count,
    SUM(
		CASE 
			WHEN termdate IS NOT NULL 
				AND termdate <=curdate() 
			THEN 1 
            ELSE 0 
		END
	) AS terminated_count
    FROM hr.`human resources`
    WHERE age >= 18
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

-- 9. what is the distribution of employees across locations by city and state?
SELECT location_state, count(*) AS count
 FROM hr.`human resources`
 WHERE age >= 18 AND termdate IS NULL
 GROUP BY location_state
 ORDER BY count DESC;
 
 -- 10. How has the company's employee count changed over time based on hire and time dates?
 SELECT
	year,
    hires, 									#jumlah karyawan masuk pertahun
    terminations,							#jumlah resign pertahun
    hires - terminations AS net_change,		#pertumbuhan bersih karyawan
    round((hires - terminations)/hires*100, 2) AS net_change_percent 	#pertumbuhan relatif (%)
FROM(
	SELECT
	YEAR(hire_date) AS year,
    count(*) AS hires,
    SUM(
		CASE 
			WHEN termdate IS NOT NULL 
				AND termdate <=curdate() 
			THEN 1 
            ELSE 0 
		END
	) AS terminations
    FROM hr.`human resources`
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT
	department,
    round(avg(datediff(termdate, hire_date)/365),0) AS avg_tenure
FROM hr.`human resources`
WHERE 
	termdate IS NOT NULL
	AND termdate <= curdate()
	AND age >= 18
GROUP BY department;
    
