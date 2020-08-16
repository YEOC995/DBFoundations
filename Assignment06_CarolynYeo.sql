--*************************************************************************--
-- Title: Assignment06
-- Author: Carolyn Yeo
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2020-08-16, Carolyn Yeo, Created File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_CarolynYeo')
	 Begin 
	  Alter Database [Assignment06DB_CarolynYeo] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_CarolynYeo;
	 End
	Create Database Assignment06DB_CarolynYeo;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_CarolynYeo;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Union
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From Categories;
go
Select * From Products;
go
Select * From Employees;
go
Select * From Inventories;
go

/********************************* Questions and Answers *********************************/
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5 pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!

--table 1:
--(1) SELECT CategoryID, CategoryName FROM dbo.Categories;

SELECT 
	CategoryID, 
	CategoryName 
FROM dbo.Categories;

GO

--(2) CREATE VIEW vCategories WITH SCHEMABINDING AS SELECT CategoryID, CategoryName FROM dbo.Categories;

CREATE
VIEW vCategories 
WITH SCHEMABINDING 
	AS SELECT CategoryID, CategoryName FROM dbo.Categories;
GO

--Table 2:
--(1) SELECT ProductID, ProductName, CategoryID, UnitPrice FROM dbo.Products;

SELECT 
	ProductID, 
	ProductName, 
	CategoryID, 
	UnitPrice 
FROM dbo.Products;

GO

--(2) CREATE VIEW vProducts WITH SCHEMABINDING AS SELECT ProductID, ProductName, CategoryID, UnitPrice FROM dbo.Products;

CREATE 
VIEW vProducts 
WITH SCHEMABINDING 
	AS SELECT ProductID, ProductName, CategoryID, UnitPrice FROM dbo.Products;
GO

--Table 3:
--(1) SELECT EmployeeID, EmployeeFirstName, EmployeeLastName, MenagerIE FROM Employees;

SELECT 
	EmployeeID, 
	EmployeeFirstName, 
	EmployeeLastName, 
	ManagerID 
FROM dbo.Employees;

GO

--(2) CREATE VIEW vEmployees WITH SCHEMABINDING AS SELECT EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID FROM dbo.Employees;

CREATE 
VIEW vEmployees 
WITH SCHEMABINDING 
	AS SELECT EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID FROM dbo.Employees;
GO

--Table 4:
--(1) SELECT InventoryID, InventoryDate, EmployeeID, ProductID, [Count] FROM dbo.Inventories;

SELECT 
	InventoryID, 
	InventoryDate, 
	EmployeeID, 
	ProductID, 
	[Count] 
FROM dbo.Inventories;

GO

--(2) CREATE VIEW vInventories WITH SCHEMABINDING AS SELECT InventoryID, InventoryDate, EmployeeID, ProductID, [Count] FROM dbo.Inventories;

CREATE 
VIEW vInventories 
WITH SCHEMABINDING 
	AS SELECT InventoryID, InventoryDate, EmployeeID, ProductID, [Count] FROM dbo.Inventories;
GO


-- Question 2 (5 pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?

--use grant and deny settings on tables and views:
--Table and view 1:
--(1) DENY SELECT ON Categories TO PUBLIC;
--(2) GRANT SELECT ON vCategories TO PUBLIC;

DENY SELECT ON Categories TO PUBLIC;
GRANT SELECT ON vCategories TO PUBLIC;

--Table and view 2:
--(1) DENY SELECT ON Products TO PUBLIC;
--(2) GRANT SELECT ON vProducts TO PUBLIC;

DENY SELECT ON Products TO PUBLIC;
GRANT SELECT ON vProducts TO PUBLIC;

--Table and view 3:
--(1) DENY SELECT ON Employees TO PUBLIC;
--(2) GRANT SELECT ON vEmployees TO PUBLIC;

DENY SELECT ON Employees TO PUBLIC;
GRANT SELECT ON vEmployees TO PUBLIC;

--Table and view 4:
--(1) DENY SELECT ON Inventories TO PUBLIC;
--(2) GRANT SELECT ON vInventories TO PUBLIC;

DENY SELECT ON Inventories TO PUBLIC;
GRANT SELECT ON vInventories TO PUBLIC;

-- Question 3 (10 pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,UnitPrice
-- Beverages,Chai,18.00
-- Beverages,Chang,19.00
-- Beverages,Chartreuse verte,18.00

--SELECT Statement:
--(1) SELECT CategoryName, ProductName, UnitPrice FROM dbo.Products;

--(2)SELECT CategoryName, ProductName, UnitPrice FROM dbo.Products AS P JOIN Categories AS C ON P.CategoryID=C.CategoryID;

--(3) SELECT TOP 100000000 CategoryName, ProductName, UnitPrice FROM dbo.Products AS P INNER JOIN Categories AS C ON P.CategoryID=C.CategoryID ORDER BY CategoryName, ProductName;

SELECT TOP 100000000 
	CategoryName, 
	ProductName, 
	UnitPrice 
	
FROM dbo.Products AS P 
INNER JOIN Categories AS C ON P.CategoryID=C.CategoryID 
ORDER BY CategoryName, ProductName;

GO

--Insert SELECT statement into view:
--(1) CREATE VIEW vProductsByCategories WITH SCHEMABINDING AS SELECT TOP 100000000 CategoryName, ProductName, UnitPrice FROM dbo.Products AS P 
--    INNER JOIN dbo.Categories AS C ON P.CategoryID=C.CategoryID ORDER BY CategoryName, ProductName;

CREATE 
VIEW vProductsByCategories 

WITH SCHEMABINDING 
AS 
	SELECT TOP 100000000 
	C.CategoryName, 
	P.ProductName, 
	P.UnitPrice 
FROM dbo.Products AS P 
INNER JOIN dbo.Categories AS C ON P.CategoryID=C.CategoryID 
ORDER BY CategoryName, ProductName;

GO

--another option would to use ORDER by in the SELECT statement


-- Question 4 (10 pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

-- Here is an example of some rows selected from the view:
--ProductName,InventoryDate,Count
--Alice Mutton,2017-01-01,15
--Alice Mutton,2017-02-01,78
--Alice Mutton,2017-03-01,83

--SELECT statement:
--(1) SELECT ProductName, InventoryDate, [Count], FROM dbo.Inventories;

--(2) SELECT ProductName, InventoryDate, [Count], FROM dbo.Inventories AS I JOIN dbo.Products AS P ON I.ProductID = P.ProductID;

--(3) SELECT TOP 100000000 ProductName, InventoryDate, [Count], FROM dbo.Inventories AS I INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID ORDER BY ProductName, InventoryDate,[Count];

SELECT TOP 100000000 
	ProductName, 
	InventoryDate, 
	[Count]

FROM dbo.Inventories AS I 
INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID 
ORDER BY ProductName, InventoryDate,[Count];

GO

--Insert into view:
--(1) CREATE VIEW vInventoriesByProductsByDates WITH SCHEMABINDING AS SELECT TOP 100000000 ProductName, InventoryDate, [Count], FROM dbo.Inventories AS I 
--   INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID ORDER BY ProductName, InventoryDate,[Count];

CREATE 
VIEW vInventoriesByProductsByDates 
WITH SCHEMABINDING 
AS 
	SELECT TOP 100000000 
		ProductName, 
		InventoryDate, 
		[Count]
	FROM dbo.Inventories AS I 

INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID 
ORDER BY ProductName, InventoryDate,[Count];
GO

--another option would to use ORDER by in the SELECT statement


-- Question 5 (10 pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

-- Here is an example of some rows selected from the view:
-- InventoryDate,EmployeeName
-- 2017-01-01,Steven Buchanan
-- 2017-02-01,Robert King
-- 2017-03-01,Anne Dodsworth


--SELECT Statement:
--(1) SELECT InventoryDate, [EmployeeName] = E.EmployeeFirstName +' '+ E.EmployeeLastName FROM dbo.Employees AS E;

--(2) SELECT InventoryDate, [EmployeeName] = E.EmployeeFirstName +' '+ E.EmployeeLastName FROM dbo.Employees AS E JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID;

--(3) SELECT TOP 100000000 InventoryDate, [EmployeeName] = E.EmployeeFirstName +' '+ E.EmployeeLastName FROM dbo.Employees AS E INNER JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID ORDER BY InventoryDate;

--(4) SELECT TOP 100000000 InventoryDate, [EmployeeName] = E.EmployeeFirstName +' '+ E.EmployeeLastName FROM dbo.Employees AS E INNER JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID 
--	GROUP BY InventoryDate, E.EmployeeFirstName + ''+ E.EmployeeLastName ORDER BY InventoryDate;

SELECT TOP 100000000 
	InventoryDate, 
	[EmployeeName] = E.EmployeeFirstName + ' '+ E.EmployeeLastName 
FROM dbo.Employees AS E 
	
INNER JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID 
GROUP BY 
	InventoryDate, 
	E.EmployeeFirstName +' '+ E.EmployeeLastName
	
ORDER BY InventoryDate;

GO

--Insert into View:
--(1) CREATE VIEW vInventoriesByEmployeesByDates WITH Schema Binding AS SELECT TOP 100000000 InventoryDate, [EmployeeName] = E.EmployeeFirstName +' '+ E.EmployeeLastName FROM dbo.Employees AS E 
--INNER JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID GROUP BY InventoryDate, E.EmployeeFirstName +' '+ E.EmployeeLastName ORDER BY InventoryDate;

CREATE 
VIEW vInventoriesByEmployeesByDates 
WITH SCHEMABINDING 
AS 
	SELECT TOP 100000000 
		InventoryDate, 
		[EmployeeName] = E.EmployeeFirstName +' '+ E.EmployeeLastName 
	FROM dbo.Employees AS E 

INNER JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID 
GROUP BY 
	InventoryDate, 
	E.EmployeeFirstName +' '+ E.EmployeeLastName 

ORDER BY InventoryDate;

GO


-- Question 6 (10 pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- Beverages,Chai,2017-01-01,72
-- Beverages,Chai,2017-02-01,52
-- Beverages,Chai,2017-03-01,54

/*
SELECT Statement:
(1) SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count] FROM dbo.Inventories as I;

(2) SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count] FROM dbo.Inventories AS I INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID;

(3) SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count] FROM dbo.Inventories AS I INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID, 
	INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID;

(4) SELECT TOP 100000000 C.CategoryName, P.productname, I.InventoryDate, I.[Count] FROM dbo.Inventories AS I INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID, 
	INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID ORDER BY CategoryName, ProductName, InventoryDate, [Count];
*/

SELECT TOP 100000000 
	C.CategoryName, 
	P.productname, 
	I.InventoryDate, 
	I.[Count] 
FROM dbo.Inventories AS I 

INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID 
INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 

ORDER BY CategoryName, ProductName, InventoryDate, [Count];

GO

/*CREATE view with SELECT statement:
(1) CREATE VIEW vInventoriesByProductsByCategories WITH SCHEMABINDING AS SELECT TOP 100000000 C.CategoryName, P.productname, I.InventoryDate, I.[Count] FROM dbo.Inventories AS I 
INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID 
INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 
ORDER BY CategoryName, ProductName, InventoryDate, [Count];

*/

CREATE 
VIEW vInventoriesByProductsByCategories 
WITH SCHEMABINDING 
AS SELECT TOP 100000000 
	C.CategoryName, 
	P.productname, 
	I.InventoryDate, 
	I.[Count] 
FROM dbo.Inventories AS I

INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID 
INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 

ORDER BY CategoryName, ProductName, InventoryDate, [Count];
GO



-- Question 7 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chartreuse verte,2017-01-01,61,Steven Buchanan

/*
SELECT statement:
(1) SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName +' ' + E.EmployeeLastName FROM dbo.Inventories as I;

(2)SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName FROM dbo.Inventories AS I 
INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID;

(3) SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName FROM dbo.Inventories AS I 
INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID, JOIN dbo.Products AS P ON I.ProductID = P.ProductID;

(4)SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName FROM dbo.Inventories AS I 
INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID;

(5) SELECT TOP 100000000 C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName FROM dbo.Inventories AS I 
INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID, INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 
ORDER BY InventoryDate, CategoryName, ProductName, [EmployeeName];

*/

SELECT TOP 100000000 
	C.CategoryName, 
	P.ProductName, 
	I.InventoryDate, 
	I.[Count], 
	[EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName 
FROM dbo.Inventories AS I 

INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID
INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID
INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 

ORDER BY InventoryDate, CategoryName, ProductName, [EmployeeName];

GO

/*
Insert into view:
(1) CREATE VIEW vInventoriesByProductsByEmployees WITH SCHEMABINDING AS SELECT TOP 100000000 C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName 
FROM dbo.Inventories AS I INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID, INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 
ORDER BY InventoryDate, CategoryName, ProductName, [EmployeeName];

*/

CREATE 
VIEW vInventoriesByProductsByEmployees 
WITH SCHEMABINDING 
AS SELECT TOP 100000000 
	C.CategoryName, 
	P.ProductName, 
	I.InventoryDate, 
	I.[Count], 
	[EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName 
FROM dbo.Inventories AS I 

INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID 
INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID
INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 

ORDER BY InventoryDate, CategoryName, ProductName, [EmployeeName];

GO


-- Question 8 (10 pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count,EmployeeName
-- Beverages,Chai,2017-01-01,72,Steven Buchanan
-- Beverages,Chang,2017-01-01,46,Steven Buchanan
-- Beverages,Chai,2017-02-01,52,Robert King

--add where clause in statement from question 7 and rename view

/*
SELECT statement:
(1) SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName +' ' + E.EmployeeLastName FROM dbo.Inventories as I;

(2)SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName FROM dbo.Inventories AS I 
INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID;

(3) SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName FROM dbo.Inventories AS I 
INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID, INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID;

(4)SELECT C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName FROM dbo.Inventories AS I 
INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID;

(5) SELECT TOP 100000000 C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName FROM dbo.Inventories AS I 
INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID, INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 
ORDER BY InventoryDate, CategoryName, ProductName, [EmployeeName];

(6) SELECT TOP 100000000 C.CategoryName, P.productname, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName FROM dbo.Inventories AS I 
INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID, INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 
 WHERE ProductName = 'Chai' OR 'Chang' ORDER BY InventoryDate, CategoryName, ProductName, [EmployeeName];
 */

SELECT TOP 100000000 
	C.CategoryName, 
	P.ProductName, 
	I.InventoryDate, 
	I.[Count], 
	[EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName 
FROM dbo.Inventories AS I 

INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID
INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID 
INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 

 WHERE ProductName = 'Chai' OR ProductName = 'Chang'

 ORDER BY InventoryDate, CategoryName, ProductName, [EmployeeName];

 GO


/*
Insert into view:
(1) CREATE VIEW vInventoriesForChaiAndChangByEmployees WITH SCHEMABINDING AS SELECT TOP 100000000 C.CategoryName, P.ProductName, I.InventoryDate, I.[Count], [EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName 
FROM dbo.Inventories AS I INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID, INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 
WHERE ProductName = 'Chai' OR ProductName ='Chang' ORDER BY InventoryDate, CategoryName, ProductName, [EmployeeName];
*/

CREATE 
VIEW vInventoriesForChaiAndChangByEmployees 
WITH SCHEMABINDING 
AS SELECT TOP 100000000 
	C.CategoryName, 
	P.ProductName, 
	I.InventoryDate, 
	I.[Count], 
	[EmployeeName] = E.EmployeeFirstName + ' ' + E.EmployeeLastName 
FROM dbo.Inventories AS I 

INNER JOIN dbo.Employees AS E ON I.EmployeeID = E.EmployeeID 
INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID
INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID 

WHERE ProductName = 'Chai' OR ProductName ='Chang' 

ORDER BY InventoryDate, CategoryName, ProductName, [EmployeeName];

GO

-- Question 9 (10 pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

-- Here is an example of some rows selected from the view:
-- Manager,Employee
-- Andrew Fuller,Andrew Fuller
-- Andrew Fuller,Janet Leverling
-- Andrew Fuller,Laura Callahan

/*
This requires the self-join clause from assignment 5.

SELECT Statement:
(1) SELECT M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] FROM Employees AS E;

(2) SELECT M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] FROM Employees AS E
	INNER JOIN Employees M ON E.MangerID=M.EmployeeID;

(3) SELECT M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] FROM Employees AS E
	INNER JOIN Employees M ON E.MangerID=M.EmployeeID ORDER BY [Manager], [Employee];
*/
SELECT 
M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], 
E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] 
FROM dbo.Employees AS E

INNER JOIN dbo.Employees M ON E.ManagerID=M.EmployeeID 

ORDER BY [Manager], [Employee];

GO


/*
Insert into view.

CREATE VIEW vEmployeesByManager WITH SCHEMABINDING AS SELECT TOP 10000000 M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] FROM dbo.Employees AS E
	INNER JOIN dbo.Employees M ON E.MangerID=M.EmployeeID ORDER BY [Manager], [Employee];
*/

CREATE 
VIEW vEmployeesByManager 
WITH SCHEMABINDING 
AS SELECT TOP 10000000 
	M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], 
	E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] 
FROM dbo.Employees AS E
	
INNER JOIN dbo.Employees M ON E.ManagerID=M.EmployeeID 

ORDER BY [Manager], [Employee];

GO


-- Question 10 (10 pts): How can you create one view to show all the data from all four 
-- BASIC Views?

-- Here is an example of some rows selected from the view:
-- CategoryID,CategoryName,ProductID,ProductName,UnitPrice,InventoryID,InventoryDate,Count,EmployeeID,Employee,Manager
-- 1,Beverages,1,Chai,18.00,1,2017-01-01,72,5,Steven Buchanan,Andrew Fuller
-- 1,Beverages,1,Chai,18.00,78,2017-02-01,52,7,Robert King,Steven Buchanan
-- 1,Beverages,1,Chai,18.00,155,2017-03-01,54,9,Anne Dodsworth,Steven Buchanan


/*
SELECT STATEMENT:
(1) SELECT C.CategoryID, C.CategoryName, P.ProductID, P.ProductName, P.UnitPrice, I.InventoryID, I.InventoryDate, I.Count, M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], 
E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] FROM Employees AS E;

(2) SELECT C.CategoryID, C.CategoryName, P.ProductID, P.ProductName, P.UnitPrice, I.InventoryID, I.InventoryDate, I.Count, M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], 
E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] FROM dbo.Employees AS E INNER JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID;

(3) SELECT C.CategoryID, C.CategoryName, P.ProductID, P.ProductName, P.UnitPrice, I.InventoryID, I.InventoryDate, I.Count, M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], 
E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] FROM dbo.Employees AS E INNER JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID JOIN dbo.Products AS P ON I.ProductID = P.ProductID;

(4) SELECT C.CategoryID, C.CategoryName, P.ProductID, P.ProductName, P.UnitPrice, I.InventoryID, I.InventoryDate, I.Count, M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], 
E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] FROM dbo.Employees AS E INNER JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID
INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID;

(5) SELECT TOP 100000000 C.CategoryID, C.CategoryName, P.ProductID, P.ProductName, P.UnitPrice, I.InventoryID, I.InventoryDate, I.Count, M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], 
E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] FROM dbo.Employees AS E INNER JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID
JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID INNER JOIN E M ON E.ManagerID=M.EmployeeID ORDER BY CategoryID, CategoryName, ProductID, ProductName;

*/

SELECT TOP 10000000
	C.CategoryID, 
	C.CategoryName, 
	P.ProductID, 
	P.ProductName, 
	P.UnitPrice, 
	I.InventoryID, 
	I.InventoryDate, 
	I.[Count], 
	E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee],
	M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager]
FROM dbo.Employees AS E 

INNER JOIN dbo.Inventories  AS I ON E.EmployeeID = I.EmployeeID 
INNER JOIN dbo.Products     AS P ON I.ProductID = P.ProductID
INNER JOIN dbo.Categories   AS C ON P.CategoryID = C.CategoryID
INNER JOIN dbo.Employees M ON M.EmployeeID=E.ManagerID

ORDER BY CategoryID, CategoryName, ProductID, ProductName;

GO

/*
Insert select statement into view:

(1) CREATE VIEW vInventoriesByProductsByCategoriesByEmployees WITH SCHEMABINDING AS SELECT TOP 100000000 C.CategoryID, C.CategoryName, P.ProductID, P.ProductName, P.UnitPrice, I.InventoryID, I.InventoryDate, I.Count, M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager], 
E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee] FROM dbo.Employees AS E INNER JOIN dbo.Inventories AS I ON E.EmployeeID = I.EmployeeID INNER JOIN dbo.Products AS P ON I.ProductID = P.ProductID
INNER JOIN dbo.Categories AS C ON P.CategoryID = C.CategoryID INNER JOIN E M ON E.ManagerID=M.EmployeeID ORDER BY CategoryID, CategoryName, ProductID, ProductName;


*/

CREATE 
VIEW vInventoriesByProductsByCategoriesByEmployees 
WITH SCHEMABINDING 
AS SELECT TOP 100000000
	C.CategoryID, 
	C.CategoryName, 
	P.ProductID, 
	P.ProductName, 
	P.UnitPrice, 
	I.InventoryID, 
	I.InventoryDate, 
	I.[Count], 
	E.EmployeeFirstName+' '+E.EmployeeLastName AS [Employee],
	M.EmployeeFirstName+' '+M.EmployeeLastName AS [Manager]
FROM dbo.Employees AS E 

INNER JOIN dbo.Inventories  AS I ON E.EmployeeID = I.EmployeeID 
INNER JOIN dbo.Products     AS P ON I.ProductID = P.ProductID
INNER JOIN dbo.Categories   AS C ON P.CategoryID = C.CategoryID
INNER JOIN dbo.Employees M ON M.EmployeeID=E.ManagerID

ORDER BY CategoryID, CategoryName, ProductID, ProductName;

GO



-- Test your Views (NOTE: You must change the names to match yours as needed!)
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByDates]
Select * From [dbo].[vInventoriesByEmployeesByDates]
Select * From [dbo].[vInventoriesByProductsByCategories]
Select * From [dbo].[vInventoriesByProductsByEmployees]
Select * From [dbo].[vInventoriesForChaiAndChangByEmployees]
Select * From [dbo].[vEmployeesByManager]
Select * From [dbo].[vInventoriesByProductsByCategoriesByEmployees]
/***************************************************************************************/