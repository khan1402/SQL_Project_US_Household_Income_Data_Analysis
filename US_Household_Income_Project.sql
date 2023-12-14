# US Household Income Data Cleaning & Analysis. The project work is consist of two parts. First part Data Cleaning of both datasets:

SELECT * FROM us_project.us_household_income_statistics;

SELECT * FROM us_project.us_household_income;

SELECT * FROM us_project.us_household_income_statistics;
ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

SELECT id, COUNT(id) 
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT *
FROM ( 
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_household_income) Duplicates
WHERE row_num > 1
;

DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM ( 
			SELECT row_id,
			id,
			ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
			FROM us_project.us_household_income) Duplicates
	WHERE row_num > 1)
;

# No duplicate id´s had been found in dataset us_household_income_statistics.

SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;

UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';

SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (AWater = 0 OR AWater = ''  OR Awater IS Null)
AND (ALand = 0 OR ALand = ''  OR ALand IS Null)
;

# Second part of the project US Household Income Exploratory Data Analysis:

SELECT * FROM us_project.us_household_income_statistics;

SELECT * FROM us_project.us_household_income;

#Finding top 10 states in US by Land and Water;

SELECT State_Name, SUM(ALand) AS Land, SUM(AWater) AS Water
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;

SELECT State_Name, SUM(ALand) AS Land, SUM(AWater) AS Water
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;

#Joining both datasets

SELECT * 
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;

SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;

# Avg income & Median level by States

SELECT u.State_Name, ROUND(AVG(Mean),1) AS AVG_Mean, ROUND(AVG(Median),1) AS AVG_Median
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2
;

#Avg income & Median level by Type of household

SELECT Type, COUNT(Type), ROUND(AVG(Mean),1) AS AVG_Mean, ROUND(AVG(Median),1) AS AVG_Median
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
ORDER BY 2
;

#Highest Avg income by Cities

SELECT  u.State_Name, City, ROUND(AVG(Mean),1) AS AVG_Mean, ROUND(AVG(Median),1) AS AVG_Median
FROM us_project.us_household_income u
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
Group By u.State_Name, City
ORDER BY 3 DESC
;

#THE END



























