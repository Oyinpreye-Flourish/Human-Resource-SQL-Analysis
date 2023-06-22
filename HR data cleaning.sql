CREATE DATABASE hr_project;
SELECT * FROM hr;

# changed id column name and data type
ALTER TABLE hr
CHANGE COLUMN id emp_id VARCHAR(20);

DESCRIBE hr;

SELECT birthdate FROM hr;

SET sql_safe_updates = 0;

# changed birthdate date format to the standard format
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
    END;
  
  #changed data type for birthdate column to date
  ALTER TABLE hr
  MODIFY COLUMN birthdate DATE;
  # changed hire_date date format to the standard format
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(STR_TO_DATE(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
    END;
    
#changed data type for hire_date column to date
  ALTER TABLE hr
  MODIFY COLUMN hire_date DATE;
  
  #changed termdate format from datetime to show just date
  SET sql_mode = 'ALLOW_INVALID_DATES';

  UPDATE hr
  SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

#changed column data type to date 
ALTER TABLE hr 
MODIFY COLUMN termdate DATE;

#add age column 
ALTER TABLE hr
ADD COLUMN age INT;

#find age to fill age column
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());
#finding incorrect age value
SELECT 
min(age) AS Youngest,
max(age) AS Oldest
FROM hr;

SELECT count(*) FROM hr
WHERE age < 18;

SELECT * FROM hr;