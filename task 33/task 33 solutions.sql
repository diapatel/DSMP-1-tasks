SELECT * FROM sleep_efficiency;

-- Q1 - Find out the average sleep duration of top 15 male candidates who's sleep duration are equal to 7.5 or greater than 7.5.
SELECT ROUND(AVG(`Sleep duration`),2)
FROM sleep_efficiency
WHERE Gender='Male' AND `Sleep Duration` >= 7.5
ORDER BY `Sleep duration` DESC 
LIMIT 15;

--------------------------------------------------------------------------------------------------------------------

-- Q2 - Show avg deep sleep time for both gender. Round result at 2 decimal places.
SELECT round(AVG((`Deep sleep percentage`/100) *`Sleep duration`),2 ) AS "avg_Deep_sleep_duration"
FROM sleep_efficiency
GROUP BY Gender;

----------------------------------------------------------------------------------------------------------------

-- Q3 - Find out the lowest 10th to 30th light sleep percentage records where deep sleep percentage values are between 25 to 45. 
-- Display age, light sleep percentage and deep sleep percentage columns only.
SELECT Age, `Light sleep percentage`, `Deep sleep percentage`
FROM sleep_efficiency
WHERE `Deep sleep percentage` BETWEEN 25 AND 45
ORDER BY `Light sleep percentage`
LIMIT 10,30;

----------------------------------------------------------------------------------------------------------------------

-- Q4 -  Group by on exercise frequency and smoking status and show average deep sleep time, average light sleep time and avg rem sleep time.
SELECT `Smoking status`,
	`Exercise frequency`,
	ROUND(AVG((`Deep sleep percentage`/100) *`Sleep duration`),2) AS "avg_deep_sleep_duration",
	ROUND(AVG((`Light sleep percentage`/100) *`Sleep duration`),2) AS "avg_light_sleep_duration",
	ROUND(AVG((`Rem sleep percentage`/100) *`Sleep duration`),2) AS "avg_rem_sleep_duration"
from sleep_efficiency
GROUP BY `Exercise frequency`, `Smoking status`
order by `Exercise frequency`;

------------------------------------------------------------------------------------------------------

-- Q5 - Group By on Awekning and show AVG Caffeine consumption, AVG Deep sleep time and AVG Alcohol consumption only for people who do exercise atleast 3 days a week. 
-- Show result in descending order awekenings
SELECT Awakenings, 
	ROUND(AVG(`Caffeine Consumption`),2) AS "avg_caffeine_consumption", 
	ROUND(AVG((`Deep sleep percentage`/100) *`Sleep duration`),2) AS "avg_deep_sleep_duration",
    ROUND(AVG(`Alcohol Consumption`),2) AS "avg_alcohol_consumption"
FROM sleep_efficiency
WHERE `Exercise frequency` >=3
GROUP BY Awakenings
ORDER BY Awakenings;

---------------------------------------------------------------------------------------------------------------------------------

-- q6 - Display top 10 lowest "value" State names of which the Year either belong to 2013 or 2017 or 2021 and type is 'Public In-State'. 
-- Also the number of occurance should be between 6 to 10. 
-- Display the average value upto 2 decimal places, state names and the occurance of the states.
SELECT State, SUM(Value) AS "value"
FROM undergrad
WHERE Year IN (2013,2017,2021) AND Type='Public In-State'
GROUP BY State
ORDER BY SUM(Value)
LIMIT 5 ;

----------------------------------------------------------------------------------------------------------------------------------

-- Q7 - Best state in terms of low education cost (Tution Fees) in 'Public' type university
SELECT State, round(AVG(Value),2) AS "tuition fees"
FROM undergrad
WHERE Type LIKE "Public%" AND Expense LIKE "%Tuition"
GROUP BY State
ORDER BY `tuition fees`
LIMIT 1;

----------------------------------------------------------------------------------------------------------------------

-- Q9 - Second Costliest state for Private education in year 2021. Consider, Tution and Room fee both.

SELECT State, ROUND(AVG(Value),2) AS "Avg_cost"
FROM undergrad
WHERE Year=2021 AND Type LIKE "%Private"
GROUP BY State
LIMIT 1,1;