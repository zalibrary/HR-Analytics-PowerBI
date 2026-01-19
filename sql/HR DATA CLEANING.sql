SELECT * FROM hr.`human resources`;

ALTER TABLE hr.`human resources`
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

SELECT birthdate FROM  hr.`human resources`;

SET sql_safe_updates = 0

UPDATE  hr.`human resources`
SET birthdate = CASE
	WHEN birthdate like '%/%' THEN DATE_FORMAT(str_to_date(birthdate, '%m/%d/%Y'),'%Y-%m-%d')
    WHEN birthdate like '%-%' THEN DATE_FORMAT(str_to_date(birthdate, '%m-%d-%Y'),'%Y-%m-%d')
    ELSE NULL
END;

SELECT hire_date FROM  hr.`human resources`;

UPDATE  hr.`human resources`
SET hire_date = CASE
	WHEN hire_date like '%/%' THEN DATE_FORMAT(str_to_date(hire_date, '%m/%d/%Y'),'%Y-%m-%d')
    WHEN hire_date like '%-%' THEN DATE_FORMAT(str_to_date(hire_date, '%m-%d-%Y'),'%Y-%m-%d')
    ELSE NULL
END;

SELECT termdate FROM  hr.`human resources`;

UPDATE hr.`human resources`
SET termdate = DATE(STR_TO_DATE(termdate,'%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate!='';

ALTER TABLE hr.`human resources`
MODIFY COLUMN termdate DATE;

ALTER TABLE hr.`human resources` ADD column age INT;

UPDATE hr.`human resources`
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT birthdate, age FROM hr.`human resources`

SELECT
	MIN(age) AS youngest,
    MAX(age) AS oldest
FROM hr.`human resources`;

SELECT count(*) FROM hr.`human resources` WHERE age < 18;