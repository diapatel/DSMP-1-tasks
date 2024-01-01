USE practice;

SELECT * FROM insurance;

-----------------------------------------------------------------------------------------------------------------------------
-- Q1
SELECT *
FROM insurance
WHERE gender='male' AND region='southwest';

------------------------------------------------------------------------------------------
-- Q2
SELECT *
FROM insurance
WHERE bmi BETWEEN 30 AND 45;

---------------------------------------------------------------------------------------------------
-- Q3
SELECT MIN(bloodpressure) AS "MinBP", MAX(bloodpressure) AS "MaxBP"
FROM insurance
WHERE smoker='Yes';

---------------------------------------------------------------------------------------------------------------
-- Q4
SELECT COUNT(*)
FROM insurance
WHERE region != 'southwest';

------------------------------------------------------------------------------------------------------------------------
-- Q5
SELECT SUM(amount)
FROM insurance
WHERE gender='male';

--------------------------------------------------------------------------------------------------------------------------------
-- Q6 -
SELECT *
FROM insurance
WHERE region LIKE "south%";

--------------------------------------------------------------------------------------------------------------------------
-- Q7 
SELECT COUNT(*)
FROM insurance
WHERE bloodpressure BETWEEN 90 AND 120;

------------------------------------------------------------------------------------------------------------------------
-- Q8 - 
SELECT COUNT(*)
FROM insurance
WHERE age < 17
	AND (bloodpressure BETWEEN 80+(age*2) AND 100+(age*2));
    
-----------------------------------------------------------------------------------------------------------------------
-- Q9
SELECT AVG(claim)
FROM insurance 
WHERE smoker='No' AND gender='female' AND diabetic='Yes';

------------------------------------------------------------------------------------------------------------
-- Q10
UPDATE insurance
SET claim = 5000
WHERE PatientID = 1234;

---------------------------------------------------------------------------------------------------------------
-- Q10
DELETE FROM insurance
WHERE smoker='Yes' AND children-0;

