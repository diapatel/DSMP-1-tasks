USE country;

-- Q1 - Find out top 10 countries' which have maximum A and D values.	
SELECT t1.Country, A, D FROM (SELECT Country, A FROM ab ORDER BY A DESC LIMIT 10) t1
LEFT JOIN 
(SELECT Country, D FROM cd ORDER BY D DESC LIMIT 10) t2
ON t1.Country = t2.Country

UNION

SELECT t2.Country, A, D FROM (SELECT Country, A FROM ab ORDER BY A DESC LIMIT 10) t1
RIGHT JOIN 
(SELECT Country, D FROM cd ORDER BY D DESC LIMIT 10) t2
ON t1.Country = t2.Country

ORDER BY A DESC, D DESC;

----------------------------------------------------------------------------------------------------------------------------

-- Q2 -  Find out highest CL value for 2020 for every region. Also sort the result in descending order.

SELECT * FROM(SELECT Region, t1.Country, CL,
DENSE_RANK() OVER(PARTITION BY Region ORDER BY CL DESC) AS "cl_rank"
FROM cl t1
JOIN ab t2
ON t1.Country = t2.Country) t
WHERE cl_rank= 1;

--------------------------------------------------------------------------------------------------------------------------
-- Q3 - Find top-5 most sold products.
USE sales;
SELECT t1.ProductID, name, ROUND((Quantity * Price), 2) AS "total_amount"
FROM sales t1
JOIN products t2
ON t1.ProductID = t2.ProductID
GROUP BY t1.ProductID
ORDER BY total_amount DESC
LIMIT 10;

SET sql_mode = (SELECT (REPLACE(@@sql_mode, "ONLY_FULL_GROUP_BY","")));

--------------------------------------------------------------------------------------------------------------

-- q4 - Find sales man who sold most no of products.\
SELECT SalesPersonID, 
	CONCAT(FirstName, " ", MiddleInitial, " ",LastName) AS "Salesperson_name", 
    COUNT(ProductID) AS "product_count"
FROM sales t1
JOIN employees t2
ON t1.SalesPersonID =  t2.EmployeeID
GROUP BY SalesPersonID
ORDER BY product_count DESC
LIMIT 1;

----------------------------------------------------------------------------------------------------------

-- Q5 - Sales man name who has most no of unique customer.
SELECT t1.SalesPersonID, 
	CONCAT(FirstName, " ", MiddleInitial, " ",LastName) AS "Salesperson_name", 
	COUNT(DISTINCT(CustomerID)) AS "customer_count"
FROM sales t1
JOIN employees t2
ON t1.SalesPersonID =  t2.EmployeeID
GROUP BY SalesPersonID
ORDER BY customer_count DESC 
LIMIT 1;

--------------------------------------------------------------------------------------------------------------------------------

-- Q6 - Sales man who has generated most revenue. Show top 5.
SELECT SalesPersonID, 
	CONCAT(FirstName, " ", MiddleInitial, " ",LastName) AS "Salesperson_name",
	ROUND((SUM(Quantity * Price)),2)  AS "revenue"
FROM sales t1
JOIN products t2
ON t1.ProductID = t2.ProductID
JOIN employees t3
ON t1.SalesPersonID = t3.EmployeeID
GROUP BY SalesPersonID
ORDER BY revenue DESC
LIMIT 1;

------------------------------------------------------------------------------------------------------------
-- Q7- List all customers who have made more than 10 purchases.
SELECT T1.CustomerID, 
	CONCAT(FirstName, " ", MiddleInitial, " ",LastName) AS "customer_name",
	COUNT(DISTINCT(SalesID)) AS "purchase_count"
FROM sales t1
JOIN customers t2
ON t1.CustomerID = t2.CustomerID
GROUP BY T1.CustomerID
HAVING purchase_count> 5
ORDER BY purchase_count DESC;

---------------------------------------------------------------------------------------------------------------
-- Q8 - List all salespeople who have made sales to more than 5 customers.
SELECT SalesPersonID, 
	CONCAT(FirstName, " ", MiddleInitial, " ",LastName) AS "Salesperson_name",
	COUNT(DISTINCT(CustomerID))  AS "customer_count" 
FROM sales t1
JOIN employees t2
ON t1.SalesPersonID = t2.EmployeeID
GROUP BY SalesPersonID
HAVING customer_count > 5;

----------------------------------------------------------------------------------------------------------

-- Q9 - List all pairs of customers who have made purchases with the same salesperson
SELECT t1.SalesPersonID, t1.CustomerID, t2.CustomerID
FROM sales t1
JOIN sales t2
ON (t1.SalesPersonID = t2.SalesPersonID) 
	AND (t1.CustomerID != t2.CustomerID)
ORDER BY t1.SalesPersonID;