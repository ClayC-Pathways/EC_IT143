/*****************************************************************************************************************
NAME:    EC_IT143_W3.4_clay.sql
PURPOSE: Answer selected AdventureWorks questions for EC IT143 Week 3.4

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     09/20/2025  Clay          Created full W3.4 SQL script with 8 questions and answers

RUNTIME: 
Approx. 5-10 minutes depending on query execution

NOTES: 
This script answers 8 business user and metadata questions using the AdventureWorks 2022 OLTP database.
All queries have been corrected for column names, joins, and table names in AdventureWorks 2022.
******************************************************************************************************************/

-- Q1 (Aloysius) - Business User Question, Marginal complexity
-- What are the names and list prices of the ten most expensive products in the Production.Product table?
SELECT TOP 10 Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- Q2 (Emmanuel) - Business User Question, Marginal complexity
-- Who are the first 30 employees hired in the company (earliest hire dates)?
SELECT TOP 30 BusinessEntityID, JobTitle, HireDate
FROM HumanResources.Employee
ORDER BY HireDate ASC;

-- Q3 (Desire) - Business User Question, Moderate complexity
-- How many orders were placed by customers from California in the last year?
SELECT c.CustomerID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.Name = 'California'
  AND YEAR(soh.OrderDate) = YEAR(GETDATE()) - 1
GROUP BY c.CustomerID;

-- Q4 (Aloysius) - Business User Question, Moderate complexity
-- Show the top five salespeople by total sales revenue for the year 2012
SELECT TOP 5 sp.BusinessEntityID, e.JobTitle, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesPerson sp
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
WHERE YEAR(soh.OrderDate) = 2012
GROUP BY sp.BusinessEntityID, e.JobTitle
ORDER BY TotalSales DESC;

-- Q5 (Desire) - Business User Question, Increased complexity
-- Find the average unit price of bikes sold to Canadian customers
SELECT AVG(sod.UnitPrice) AS AvgUnitPrice
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'CA'
  AND sod.ProductID IN (
      SELECT ProductID
      FROM Production.Product
      WHERE Name LIKE '%Bike%'
  );

-- Q6 (Aloysius) - Business User Question, Increased complexity
-- Report mountain bike sales for Q3 2013 by color, quantity sold, and total revenue
SELECT p.Color, MONTH(soh.OrderDate) AS OrderMonth, SUM(sod.OrderQty) AS QuantitySold,
       SUM(sod.LineTotal) AS TotalRevenue
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.Name LIKE '%Mountain Bike%'
  AND soh.OrderDate BETWEEN '2013-07-01' AND '2013-09-30'
GROUP BY p.Color, MONTH(soh.OrderDate)
ORDER BY OrderMonth, TotalRevenue DESC;

-- Q7 (Clay) - Metadata Question
-- Which tables in AdventureWorks contain a column named ProductID or ProductSubcategoryID?
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('ProductID', 'ProductSubcategoryID')
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- Q8 (Clay) - Metadata Question
-- List all columns in the Sales.SalesOrderDetail table, including data type and maximum length
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
  AND TABLE_NAME = 'SalesOrderDetail';
