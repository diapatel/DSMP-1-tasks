USE olympics;
SELECT *
FROM olympics;

-- Q1- Display the names of athletes who won a gold medal in the 2008 Olympics and 
-- whose height is greater than the average height of all athletes in the 2008 Olympics.
SELECT Name, Height FROM olympics 
WHERE Year = 2008 AND Medal='Gold' AND Height > (SELECT AVG(Height)
												FROM olympics 
												WHERE Year=2008);
                                                
---------------------------------------------------------------------------------------------------------------------

-- Q2 - Display the names of athletes who won a medal in the sport of basketball in the 2016 Olympics and 
-- whose weight is less than the average weight of all athletes who won a medal in the 2016 Olympics.   

SELECT Name FROM olympics WHERE Year=2016 AND 
Sport = 'basketball' AND Medal IS NOT NULL AND weight<(SELECT AVG(weight)
														FROM olympics
														WHERE Year=2016 AND Medal IS NOT NULL);  
                                                        
--------------------------------------------------------------------------------------------------------------------

-- Q3 - Display the names of all athletes who have won a medal in the sport of swimming in either the 2008 and 2016 Olympics.
SELECT Name
FROM olympics
WHERE Sport='Swimming' AND YEAR IN (2008,2016)  AND Medal='Gold';

----------------------------------------------------------------------------------------------------------------------------------

-- Q4 - Display the names of all countries that have won more than 50 medals in a single year.

SELECT DISTINCT(Country), Year, COUNT(*) AS "medal_count"
FROM olympics
WHERE Medal IS NOT NULL
GROUP BY Country, Year
HAVING COUNT(*)>50
ORDER BY Year, Country;
---------------------------------------------------------------------------------------------------------------------

-- Q5 - Display the names of all athletes who have won medals in more than one sport in the same year.
SELECT DISTINCT(ID)
FROM (SELECT ID, Name, COUNT(sport) AS "sport_count" , COUNT(medal) AS "medal_count"
	  FROM olympics
	  WHERE Medal IS NOT NULL
	  GROUP BY ID, Year, Sport) t
WHERE sport_count>1 AND medal_count>1
LIMIT 2000;

SET sql_mode = (SELECT(REPLACE(@@sql_mode, "ONLY_FULL_GROUP_BY","")));
----------------------------------------------------------------------------------------------------------

-- Q6 - What is the average weight difference between male and female athletes in the Olympics who have won a medal in the same event?

WITH result_cte AS (SELECT *
					FROM olympics
                    WHERE Medal IS NOT NULL)
				
SELECT AVG(A.weight - B.weight) FROM result_cte A
JOIN
result_cte B
ON A.Sport= B.Sport
	AND A.Sex != B.Sex;
    
    ----------------------------------------------------------------------------------------------------------------------------------
    
-- Q7 - How many patients have claimed more than the average claim amount for patients 
-- who are smokers and have at least one child, and belong to the southeast region?

USE practice;
SELECT COUNT(DISTINCT PatientID) AS "patient_count"
FROM insurance
WHERE claim > (SELECT AVG(claim)
				FROM insurance
                WHERE smoker='Yes' AND children>=1 AND region='southeast');
                
------------------------------------------------------------------------------------------------------------------------------

-- Q8 - How many patients have claimed more than the average claim amount for patients who are not smokers and 
-- have a BMI greater than the average BMI for patients who have at least one child?
   
SELECT COUNT(DISTINCT PatientID) as "patient_count"
FROM insurance
WHERE claim > (SELECT AVG(claim) FROM insurance WHERE Smoker='No'
				AND bmi > (SELECT AVG(bmi) FROM insurance WHERE children>=1));
                
----------------------------------------------------------------------------------------------------------------------------------

-- Q9 - How many patients have claimed more than the average claim amount for patients who have a BMI greater than the average BMI 
-- for patients who are diabetic, have at least one child, and are from the southwest region?
   
SELECT COUNT(DISTINCT PatientID) AS "patient_count"
FROM insurance
WHERE claim > (SELECT AVG(claim)
				FROM insurance
				WHERE bmi > (SELECT AVG(bmi)
							FROM insurance
                            WHERE diabetic='Yes' AND children>=1 AND region='southwest'));
                            
                            
--------------------------------------------------------------------------------------------------------------------------

-- Q10 - What is the difference in the average claim amount between patients who are smokers 
-- and patients who are non-smokers, and have the same BMI and number of children?

SELECT AVG(t1.claim - t2.claim)
FROM insurance t1
JOIN insurance t2
ON  t1.smoker != t2.smoker 
	AND t1. bmi = t2.bmi 
    AND t1.children= t2.childreN;