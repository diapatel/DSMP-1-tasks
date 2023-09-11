USE practice;

SELECT * FROM insurance;

-- Q1 - Show records of 'male' patient from 'southwest' region.
SELECT *
FROM insurance
WHERE gender='male' AND region='southwest';

------------------------------------------------------------------------------------------------------------------------------

-- Q2- Show all records having bmi in range 30 to 45 both inclusive.
SELECT *
FROM insurance
WHERE bmi BETWEEN 30 AND 45;

--------------------------------------------------------------------------------------------------------------------------------

-- Q3  - Show minimum and maximum bloodpressure of diabetic patient who smokes. Make column names as MinBP and MaxBP respectively.

SELECT MIN(bloodpressure) AS "MinBP",  MAX(bloodpressure) AS "MaxBP"
FROM insurance
WHERE smoker='Yes';

---------------------------------------------------------------------------------------------------------------------------------

-- Q4 - Find no of unique patients who are not from southwest region.
SELECT COUNT(DISTINCT PatientID) AS "patient_count"
FROM insurance
WHERE region != 'southwest';

-------------------------------------------------------------------------------------------------------------------------

-- Q5- Total claim amount from male smoker.
SELECT ROUND(SUM(claim),2) AS "total_claim_amount"
FROM insurance
WHERE gender='Male' AND smoker='Yes';

---------------------------------------------------------------------------------------------------------------------------
-- Q6 - Select all records of south region.
SELECT *
FROM insurance
WHERE region LIKE "south%";

-----------------------------------------------------------------------------------------------------------------------------
-- Q7 - No of patient having normal blood pressure. Normal range[90-120]
SELECT COUNT(DISTINCT PatientID) AS "patient_count"
FROM insurance
WHERE bloodpressure BETWEEN 90 AND 120;

---------------------------------------------------------------------------------------------------------------------------
-- Q8 - No of pateint belo 17 years of age having normal blood pressure as per below formula -
-- BP normal range = 80+(age in years × 2) to 100 + (age in years × 2)
-- Note: Formula taken just for practice, don't take in real sense.

SELECT COUNT(DISTINCT PatientID)
FROM insurance
WHERE age < 17 AND 
	(bloodpressure BETWEEN 80 + (age * 2) AND 100+(age*2));
    
---------------------------------------------------------------------------------------------------------------------------------------

-- Q9 - 	What is the average claim amount for non-smoking female patients who are diabetic?
SELECT ROUND(AVG(claim),2) as "avg_claim"
FROM insurance
WHERE smoker='No' AND gender='Female' AND diabetic='Yes';

------------------------------------------------------------------------------------------------------------------------

-- Q10 - Write a SQL query to update the claim amount for the patient with PatientID = 1234 to 5000.

UPDATE insurance
SET claim=5000
WHERE PatientID = 1234;

-------------------------------------------------------------------------------------------------------------------

-- Q11 - Write a SQL query to delete all records for patients who are smokers and have no children.
DELETE FROM insurance
WHERE smoker='Yes' AND children=0;
