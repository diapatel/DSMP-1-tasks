-- Q1 - What are the top 5 patients who claimed the highest insurance amounts?

SELECT *,
DENSE_RANK() OVER(ORDER BY claim DESC) AS "rank_num"
FROM insurance
LIMIT 5;

----------------------------------------------------------------------------------------------------------

-- q2 - What is the average insurance claimed by patients based on the number of children they have?
SELECT children, avg_claim
FROM (SELECT *,
	ROUND(AVG(claim) OVER(PARTITION BY children), 2) AS "avg_claim",
	ROW_NUMBER() OVER(PARTITION BY children) AS "row_num"
	FROM insurance)t
WHERE `row_num`= 1;

---------------------------------------------------------------------------------------------------------------------------------

-- Q3 -  What is the highest and lowest claimed amount by patients in each region?
SELECT region, min_claim, max_claim
FROM (SELECT *,
	MIN(claim) OVER(PARTITION BY region) AS "min_claim", 
	MAX(claim) OVER(PARTITION BY region) AS "max_claim",
	ROW_NUMBER() OVER(PARTITION BY region) AS "row_num"
	FROM insurance
	WHERE region IS NOT NULL) t
WHERE row_num=1;

--------------------------------------------------------------------------------------------------------------------------------

-- Q4 - What is the difference between the claimed amount of first patient and the claim amount of every other patient?

SELECT *, 
claim - FIRST_VALUE(claim) OVER() AS "difference"
FROM insurance;

-----------------------------------------------------------------------------------------------------------------------------

-- Q5 -  For each patient, calculate the difference between their claimed amount 
-- and the average claimed amount of patients with the same number of children.

SELECT *,
claim - AVG(claim) OVER(PARTITION BY children) AS "claim_diff"
FROM insurance;

----------------------------------------------------------------------------------------------------------------------

-- Q7 - Show the patient with the highest BMI in each region and their respective overall rank.
SELECT region, PatientID, overall_rank
FROM (SELECT *,
	DENSE_RANK() OVER(PARTITION BY region ORDER BY bmi DESC) AS "rank_num",
	RANK() OVER(ORDER BY bmi DESC) as "overall_rank"
	FROM insurance
	WHERE region IS NOT NULL) t
WHERE rank_num=1;

-----------------------------------------------------------------------------------------------------------------

-- Q8 - Calculate the difference between the claimed amount of each patient 
-- and the claimed amount of the patient who has the highest BMI in their region.
SELECT *,
ROUND(claim - FIRST_VALUE(claim) OVER(PARTITION BY region ORDER BY bmi DESC), 2) AS "claim_of_highest_bmi"
FROM insurance;

---------------------------------------------------------------------------------------------------------------------------

-- Q10 - For each patient, calculate the difference in claim amount between the patient and the patient with the highest claim amount
--  among patients with smoker status, within the same region. Return the result in descending order difference.

SELECT *,
	round(MAX(claim) OVER(PARTITION BY smoker, region) - claim, 2) AS "claim_diff"
FROM insurance
ORDER BY claim_diff DESC;

------------------------------------------------------------------------------------------------------------------------------

-- Q10 - : For each patient, find the maximum BMI value among their next three records (ordered by age).
SELECT *,
MAX(bmi) OVER(ORDER BY age 
				ROWS BETWEEN 1 FOLLOWING AND 3 FOLLOWING) AS "required_bmi"
FROM insurance;

---------------------------------------------------------------------------------------------------------------

-- Q11 -  For each patient, find the rolling average of the last 2 claims.
SELECT PatientID,
		AVG(claim) OVER(ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) AS "rolling_Avg"
FROM insurance;

------------------------------------------------------------------------------------------------------------------------

-- Q12 -  Find the first claimed insurance value for male and female patients, within each region order the data by patient age in ascending order, 
-- and only include patients who are non-diabetic and have a bmi value between 25 and 30.
SELECT region, gender, required_claim
FROM (SELECT *,
		FIRST_VALUE(claim) OVER(PARTITION BY region, gender ORDER BY age) AS "required_claim",
		ROW_NUMBER() OVER(PARTITION BY region, gender ORDER BY age) as "row_num"
		FROM insurance
		WHERE diabetic='No' AND (bmi BETWEEN 25 AND 30)
		ORDER BY region) t
WHERE `row_num` = 1;