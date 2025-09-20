/*****************************************************************************************************************
NAME:    EC_IT143_W3.4_clay.sql
PURPOSE: Answer selected AdventureWorks questions for EC IT143 Week 3.4

MODIFICATION LOG:
Ver     Date        Author      Description
-----   ----------  ----------- -------------------------------------------------------------------------------
1.0     09/20/2025  Clay       Initial version with queries for all 8 questions (humanized formatting)

NOTES:
- This script addresses 8 business and metadata questions using the AdventureWorks 2022 OLTP database.
- Queries have been reviewed for column names, joins, and filters.
- Execution time may vary depending on server load and dataset size.
- Estimated runtime: a few minutes per query on a standard SQL Server setup.
******************************************************************************************************************/

-- Q1 (Aloysius) - Business question: List the 10 most expensive products
SELECT TOP 10 Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- Q2 (Emmanuel) - Business question: First 30 employees hired
SELECT TOP 30 BusinessEntityID, JobTitle, HireDate
FROM HumanResources.Employee
ORDER BY HireDate ASC;

-- Q3 (Desire) - Business question: Orders from California customers in the last year
SELECT cst.CustomerID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader AS soh
JOIN Sales.Customer AS cst 
    ON soh.CustomerID = cst.CustomerID
JOIN Person.BusinessEntityAddress AS bea 
    ON cst.CustomerID = bea.BusinessEntityID
JOIN Person.Address AS addr 
    ON bea.AddressID = addr.AddressID
JOIN Person.StateProvince AS sp 
    ON addr.StateProvinceID = sp.StateProvinceID
WHERE sp.Name = 'California'  -- filter for CA
  AND YEAR(soh.OrderDate) = YEAR(GETDATE()) - 1
GROUP BY cst.CustomerID;

-- Q4 (Aloysius) - Business question: Top 5 salespeople by total sales revenue in 2012
SELECT TOP 5 sp.BusinessEntityID, emp.JobTitle, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesPerson AS sp
JOIN Sales.SalesOrderHeader AS soh 
    ON sp.BusinessEntityID = soh.SalesPersonID
JOIN HumanResources.Employee AS emp 
    ON sp.BusinessEntityID = emp.BusinessEntityID
WHERE YEAR(soh.OrderDate) = 2012
GROUP BY sp.BusinessEntityID, emp.JobTitle
ORDER BY TotalSales DESC;

-- Q5 (Desire) - Business question: Average unit price of bikes sold to Canadian customers
SELECT AVG(sod.UnitPrice) AS AvgUnitPrice
FROM Sales.SalesOrderDetail AS sod
JOIN Sales.SalesOrderHeader AS soh 
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.Customer AS cst 
    ON soh.CustomerID = cst.CustomerID
JOIN Person.BusinessEntityAddress AS bea 
    ON cst.CustomerID = bea.BusinessEntityID
JOIN Person.Address AS addr 
    ON bea.AddressID = addr.AddressID
JOIN Person.StateProvince AS sp 
    ON addr.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode = 'CA'  -- Canadian customers
  AND sod.ProductID IN (
      SELECT ProductID
      FROM Production.Product
      WHERE Name LIKE '%Bike%'  -- only bikes
  );

-- Q6 (Aloysius) - Business question: Mountain bike sales by color for Q3 2013
SELECT p.Color, MONTH(soh.OrderDate) AS OrderMonth, 
       SUM(sod.OrderQty) AS QuantitySold, 
       SUM(sod.LineTotal) AS TotalRevenue
FROM Production.Product AS p
JOIN Sales.SalesOrderDetail AS sod 
    ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader AS soh 
    ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.Name LIKE '%Mountain Bike%'  -- only mountain bikes
  AND soh.OrderDate BETWEEN '2013-07-01' AND '2013-09-30'
GROUP BY p.Color, MONTH(soh.OrderDate)
ORDER BY OrderMonth, TotalRevenue DESC;

-- Q7 (Clay) - Metadata question: Tables containing ProductID or ProductSubcategoryID
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('ProductID', 'ProductSubcategoryID')
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- Q8 (Clay) - Metadata question: List all columns in Sales.SalesOrderDetail
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Sales'
  AND TABLE_NAME = 'SalesOrderDetail';
