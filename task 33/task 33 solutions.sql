USE practice;

SELECT * FROM sleep_efficiency;

--------------------------------------------------------------------------------------------------------------
-- Q1 
SELECT AVG(`Sleep duration`)
FROM sleep_efficiency
WHERE `Sleep duration` >= 7.5 AND Gender="male"
LIMIT 15;

--------------------------------------------------------------------------------------------------
-- Q2 
SELECT Gender, ROUND(AVG((`Deep sleep percentage`/100)*`Sleep duration`),2)  AS "Deep Sleep Time"
FROM sleep_efficiency
GROUP BY Gender;

------------------------------------------------------------------------------------------------------
-- Q3
SELECT age, `Light sleep percentage`, `Deep sleep percentage`
FROM sleep_efficiency 
WHERE `Deep sleep percentage` BETWEEN 25 AND 45
ORDER BY `Light sleep percentage`
LIMIT 10,20;

----------------------------------------------------------------------------------------------------------
-- Q4
SELECT `Exercise frequency`, `Smoking status`,
	ROUND(AVG((`Deep sleep percentage` /100) * `Sleep duration`), 2) AS "Avg deep sleep time",
    ROUND(AVG((`Light sleep percentage` /100) * `Sleep duration`), 2) AS "Avg Light sleep time",
    ROUND(AVG((`REM sleep percentage` /100) * `Sleep duration`), 2) AS "Avg REM sleep time"
FROM sleep_efficiency
GROUP BY `Smoking status` , `Exercise frequency`
ORDER BY `Exercise frequency`;

-----------------------------------------------------------------------------------------------------
-- Q5
SELECT Awakenings, 
	ROUND(AVG(`Deep sleep percentage`/100 * `Sleep duration`), 2) AS "Deep sleep time",
    ROUND(AVG(`Alcohol consumption`), 2) AS "average alcohol consumption",
    ROUND(AVG(`Caffeine consumption`),2 ) AS "average caffeine consumption"
FROM sleep_efficiency
WHERE `Exercise frequency` = 3
GROUP BY Awakenings
ORDER BY Awakenings;

----------------------------------------------------------------------------------------------------------------------
-- Q7
SELECT * FROM undergrad;
SELECT State, 
	COUNT(*) AS "number of occurrences", 
	ROUND(AVG(Value), 2) as "Average value"
FROM undergrad
WHERE Year in (2013, 2017, 2021) AND Type = "Public In-State" 
GROUP BY State
HAVING COUNT(*) BETWEEN 6 AND 10
ORDER BY AVG(Value) 
LIMIT 10;

---------------------------------------------------------------------------------------------------------
-- Q8
SELECT State, ROUND(AVG(Value), 2) AS "Average expense"
FROM undergrad
WHERE Type LIKE "Public%"
GROUP BY State
ORDER BY AVG(Value)
LIMIT 1;

---------------------------------------------------------------------------------------------------------------
-- Q9
SELECT State,
	Type,
	ROUND(AVG(Value)) AS "Average expense"
FROM undergrad
WHERE Type LIKE "Private%"
GROUP BY State, Type
ORDER BY AVG(Value) DESC
LIMIT 1,1;