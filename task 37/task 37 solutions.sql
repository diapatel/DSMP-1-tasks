USE northwind;

-- Q1 - Rank Employee in terms of revenue generation. Show employee id, first name, revenue, and rank
SELECT t3.EmployeeID,
	FirstName,
	UnitPrice * Quantity AS "revenue",
	RANK() OVER(ORDER BY UnitPrice * Quantity DESC) AS "employee_rank"
FROM order_details t1
JOIN orders t2
ON t1.OrderID = t2.OrderID
JOIN employees t3
ON t2.EmployeeID = t3.EmployeeID
GROUP BY t2.EmployeeID
ORDER BY `employee_rank`;

-------------------------------------------------------------------------------------------------------------------

-- Q2 - : Show All products cumulative sum of units sold each month.
SELECT MONTH(OrderDate) AS "order_month", 
	ProductID, 
	SUM(Quantity) AS "monthly_orders",
    SUM(SUM(Quantity)) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS "cumulative_sum"
FROM order_details t1
JOIN orders t2
ON t1.OrderID = t2.OrderID
GROUP BY MONTH(OrderDate), ProductID;

------------------------------------------------------------------------------------------------------------------------------

-- Q3 - Show Percentage of total revenue by each suppliers
SELECT *, ROUND((`revenue` / SUM(`revenue`)  OVER()) * 100,2) AS "revenue_percentage"
FROM (SELECT SupplierID, CompanyName, SUM(UnitPrice * Quantity) AS "revenue"
FROM orders t1
JOIN order_details t2
ON t1.OrderID = t2.OrderID
JOIN suppliers t3
ON t1.ShipVia = t3.SupplierID
GROUP BY SupplierID
ORDER BY SupplierID) t;

------------------------------------------------------------------------------------------------------------------------------

-- Q4 - Show Percentage of total orders by each suppliers
SELECT *, order_count/ SUM(order_count) OVER() *100 AS "percent_orders"
FROM (SELECT ShipVia, 
			CompanyName,
			COUNT(OrderID) AS "order_count"
	FROM orders t1
	JOIN suppliers t2
	ON t1.ShipVia = t2.SupplierID
	GROUP BY ShipVia
	ORDER BY ShipVia) t;
    
    -----------------------------------------------------------------------------------------------------------------
    
-- Q5 - Show All Products Year Wise report of totalQuantity sold, percentage change from last year.
SELECT  YEAR(OrderDate) AS "year",
		ProductID, 
        SUM(Quantity) AS "units_sold",
		LAG(SUM(Quantity)) OVER(ORDER BY YEAR(OrderDate),ProductID)AS "previous_year_sales",
		ROUND(((SUM(Quantity) - LAG(SUM(Quantity)) OVER(ORDER BY YEAR(OrderDate),ProductID)) / LAG(SUM(Quantity)) OVER(ORDER BY YEAR(OrderDate),ProductID)) *100, 2) AS "percent_change"
FROM order_details t1
JOIN orders t2
ON t1.OrderID = t2.OrderID
GROUP BY YEAR(OrderDate), ProductID
ORDER BY YEAR(OrderDate), ProductID;

----------------------------------------------------------------------------------------------------------------------------------------
-- Q6 - For each condition, what is the average satisfaction level of drugs that are "On Label" vs "Off Label"?
USE practice;

SELECT `Condition`, Indication, ROUND(AVG(Satisfaction),2) AS "avg_satisfaction_level"
FROM drugs
GROUP BY `Condition`, Indication;

-----------------------------------------------------------------------------------------------------------------------

-- Q7 - What is the cumulative distribution of EaseOfUse ratings for each drug type (RX, OTC, RX/OTC)? Show the results in descending order by drug type and cumulative distribution. 
-- (Use the built-in method and the manual method by calculating on your own. For the manual method,
--  use the "ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW" and see if you get the same results as the built-in method.)
SELECT Type, 
	ROUND(SUM(SUM(EaseOfUse)) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS "cumulative_sum"
FROM drugs
WHERE Type IN ('RX', 'OTC', 'RX/OTC')
GROUP BY Type;

---------------------------------------------------------------------------------------------------------------------------

-- Q8 -  What is the running average of the price of drugs for each medical condition? 
-- Show the results in ascending order by medical condition and drug name.
SELECT `Condition`, 
		ROUND(AVG(Price) OVER(PARTITION BY `Condition` 
					ORDER BY Drug
				ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS "running_sum"
FROM drugs
GROUP BY `Condition`;

----------------------------------------------------------------------------------------------------------------------------

-- Q9 - What is the percentage change in the number of reviews for each drug between the previous row and the current row? 
-- Show the results in descending order by percentage change.
SELECT Drug, 
	COUNT(Reviews) AS "review_count",
    LAG(COUNT(reviews)) OVER() AS "previous_count",
    ROUND((COUNT(reviews) -  LAG(COUNT(reviews)) OVER()) /  LAG(COUNT(reviews)) OVER(), 2) AS "percent_change"
FROM drugs
GROUP BY Drug
ORDER BY percent_change DESC;

---------------------------------------------------------------------------------------------------------------------

-- Q10 - What is the percentage of total satisfaction level for each drug type (RX, OTC, RX/OTC)? 
-- Show the results in descending order by drug type and percentage of total satisfaction.

SELECT Type,
	ROUND(sum_satisfaction / SUM(sum_satisfaction) OVER() * 100, 2) AS "percent_satisfaction"
FROM (SELECT Type,
		ROUND(SUM(`Satisfaction`), 2) AS "sum_satisfaction"
FROM drugs
WHERE Type IN ('RX', 'OTC', 'RX/OTC')
GROUP BY Type) t;

-------------------------------------------------------------------------------------------------------------------------

-- Q10 - What is the cumulative sum of effective ratings for each medical condition and drug form combination? 
-- Show the results in ascending order by medical condition, drug form and the name of the drug.

SELECT `Condition`, Form, 
		ROUND(SUM(SUM(Effective)) OVER(PARTITION BY `Condition`, Form ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS "cumulative_sum"
FROM drugs
GROUP BY `Condition`, Form
ORDER BY `Condition`, Form, Drug ;

----------------------------------------------------------------------------------------------------------------------------

-- Q11 -  What is the rank of the average ease of use for each drug type (RX, OTC, RX/OTC)? 
-- Show the results in descending order by rank and drug type.

SELECT Type, ROUND(AVG(EaseOfUse), 2) AS "avg_ease_of_use",
	RANK() OVER(ORDER BY AVG(EaseOfUse) DESC) AS "rank_of_ease"
FROM drugs
WHERE Type IN ('RX', 'OTC', 'RX/OTC')
GROUP BY Type
ORDER BY rank_of_ease DESC, Type DESC;

-----------------------------------------------------------------------------------------------------------------------------

-- Q12 - For each condition, what is the average effectiveness of the top 3 most reviewed drugs?
SELECT *
FROM (SELECT `Condition`,
		RANK() OVER(PARTITION BY `condition` ORDER BY SUM(reviews) DESC) AS "drug_Rank",
        Drug,
        ROUND(AVG(effective),2) AS "avg_effective"
FROM drugs
GROUP BY `Condition`, Drug
ORDER BY `Condition`) t
WHERE drug_rank < 4;
