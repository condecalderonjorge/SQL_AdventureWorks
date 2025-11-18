-- 1. Consulta SQL 
-- 2. Crear una vista (View)
-- 3. En la base de datos de destino, vamos a crear la TABLA que almacenará los datos
-- 4. Ejecutaremos la vista en origen para migrar los datos a la base de datos de destino 
-- 1 Tabla de Hechos y Varias de Dimensiones


-- TABLA DE HECHOS / FACT TABLE
-- Ventas
--DROP VIEW DW_Fact_Sales

CREATE OR ALTER VIEW DW_Fact_Sales
AS 
SELECT CONCAT(SOH.SalesOrderID , SOD.SalesOrderDetailID) AS SalesID
	   ,CAST(SOH.OrderDate AS DATE) AS OrderDate
		,CAST(CONCAT(
			YEAR(OrderDate)
			,IIF( LEN(MONTH(OrderDate)) = 1 
					,CAST(CONCAT( 0, MONTH(OrderDate)) AS VARCHAR)
					,CAST( MONTH(OrderDate) AS VARCHAR))
			,IIF( LEN(DAY(OrderDate)) = 1 
					,CAST(CONCAT( 0, DAY(OrderDate)) AS VARCHAR)
					,CAST( DAY(OrderDate) AS VARCHAR))
				) AS INT) AS OrderDateKey
	   --,CONVERT(DATE, SOH.OrderDate) AS OrderDate
	   ,CONVERT(DATE, SOH.ShipDate) AS ShipDate
		 ,CAST(CONCAT(
			YEAR(ShipDate)
			,IIF( LEN(MONTH(ShipDate)) = 1 
					,CAST(CONCAT( 0, MONTH(ShipDate)) AS VARCHAR)
					,CAST( MONTH(ShipDate) AS VARCHAR))
			,IIF( LEN(DAY(ShipDate)) = 1 
					,CAST(CONCAT( 0, DAY(ShipDate)) AS VARCHAR)
					,CAST( DAY(ShipDate) AS VARCHAR))
				) AS INT)  AS ShipDateKey
	   ,DATEDIFF(DAY, SOH.OrderDate, SOH.ShipDate) AS DaysToShip
	   ,CASE
		    WHEN SOH.Status = 1 THEN 'In Progress'
			WHEN SOH.Status = 2 THEN 'Approved'
			WHEN SOH.Status = 3 THEN 'Backordered'
			WHEN SOH.Status = 4 THEN 'Rejected'
			WHEN SOH.Status = 5 THEN 'Shipped'
			WHEN SOH.Status = 6 THEN 'Cancelled'
			ELSE 'CHECK'
		END AS Status
	   ,IIF( SOH.OnlineOrderFlag = 1, 'Online Order', 'Sales Person Order') AS OrderFlag
	   ,SOH.SalesOrderNumber
	   ,SOH.AccountNumber
	   ,SOH.CustomerID
	   ,ISNULL(SOH.SalesPersonID, 0) AS SalesPersonID 
	   ,SOH.TerritoryID
	   ,SOH.BillToAddressID
	   ,SOH.ShipToAddressID
	   ,SOH.ShipMethodID
	   ,ISNULL(CR.ToCurrencyCode, 'USD') AS Currency
	   ,ISNULL(C.Name, 'USA Dollar') AS CurrencyName
	   ,ISNULL( SOH.SubTotal * CR.EndOfDayRate,SOH.SubTotal)  AS SubTotalUSDDollar
	   ,SOH.SubTotal
	   ,ISNULL( soh.TaxAmt * CR.EndOfDayRate,soh.TaxAmt)  AS TaxAmtUSDDollar
	   ,soh.TaxAmt
	   ,ISNULL( SOH.Freight * CR.EndOfDayRate,SOH.Freight)  AS FreightUSDDollar
	   ,soh.Freight
	   ,ISNULL( SOH.TotalDue * CR.EndOfDayRate,SOH.TotalDue)  AS TotalDueUSDDollar
	   ,SOH.TotalDue
	   ,ROUND( SOH.TaxAmt / SOH.TotalDue, 2)  AS PercentageTax
	   ,ROUND( SOH.Freight / SOH.TotalDue, 2)  AS FreightTax
	   ,SOD.OrderQty 
	   ,SOD.ProductID
	   ,SOD.UnitPrice
	   ,SOD.LineTotal
	   ,ROUND(SOD.LineTotal / SOH.TotalDue, 2) as PercentageOfTotal
FROM Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail AS SOD
	ON SOH.SalesOrderID = SOD.SalesOrderID
LEFT JOIN Sales.CurrencyRate AS CR
	ON CR.CurrencyRateID = SOH.CurrencyRateID
LEFT JOIN Sales.Currency AS C
	ON C.CurrencyCode = CR.ToCurrencyCode


SELECT * 
FROM DW_Fact_Sales

-- DROP TABLE [datawarehouse].dbo.DW_Fact_Sales

CREATE TABLE [datawarehouse].dbo.DW_Fact_Sales (
	SalesID BIGINT PRIMARY KEY
	,OrderDate DATE
	,OrderDateKey INT
	,ShipDate DATE
	,ShipDateKey INT
	,DaysToShip INT
	,Status VARCHAR(255)
	,OrderFlag VARCHAR(255)
	,SalesOrderNumber VARCHAR(255)
	,AccountNumber VARCHAR(255)
	,CUstomerID INT
	,SalesPersonID INT
	,TerritoryID INT
	,BillToAdressID INT
	,ShipToAdressID INT
	,ShipMethodID INT
	,Currency VARCHAR(255)
	,CurrencyName VARCHAR(255)
	,SubTotalUSDDollar NUMERIC(38,4)
	,SubTotal NUMERIC(38,4)
	,TaxAmtUSDDollar NUMERIC(38,4)
	,TaxAmt NUMERIC(38,4)
	,FreighUSDDollar NUMERIC(38,4)
	,Freigh NUMERIC(38,4)
	,TotalDueUSDDollar NUMERIC(38,4)
	,TotalDue NUMERIC(38,4)
	,PercentageTax NUMERIC(38,2)
	,FreightTax NUMERIC(38,2)
	,OrderQty INT
	,ProductID INT
	,UnitPrice NUMERIC(38,4)
	,LineTotal NUMERIC(38,4)
	,PercentageOfTotal NUMERIC(38,4)
)

INSERT INTO  [datawarehouse].dbo.DW_Fact_Sales
SELECT * 
FROM DW_Fact_Sales


 SELECT * FROM [datawarehouse].dbo.DW_Fact_Sales

 ;
 -- DIM DATES
 CREATE OR ALTER VIEW DW_Dim_Date
 AS
 SELECT DISTINCT
		 CAST(CONCAT(
			YEAR(OrderDate)
			,IIF( LEN(MONTH(OrderDate)) = 1 
					,CAST(CONCAT( 0, MONTH(OrderDate)) AS VARCHAR)
					,CAST( MONTH(OrderDate) AS VARCHAR))
			,IIF( LEN(DAY(OrderDate)) = 1 
					,CAST(CONCAT( 0, DAY(OrderDate)) AS VARCHAR)
					,CAST( DAY(OrderDate) AS VARCHAR))
				) AS INT) AS Datekey
		,CAST(OrderDate AS DATE) AS [Date]
		,YEAR(OrderDate) AS [Year]
		,MOnth(OrderDate) As [Month]
		,DAY(OrderDate) AS [Day]
		,DATENAME(MONTH, OrderDate) AS MonthName
		,DATENAME(WEEKDAY, OrderDate) As [Weekday]
		,DATEPART(DAYOFYEAR, OrderDate) As [DayOfYear]
		,DATEPART(WEEK, OrderDate) As [WeekOfYear]
		,DATEPART(QUARTER, OrderDate) AS [Quarter]
		,CASE
			WHEN MONTH(OrderDate) BETWEEN 1 AND 4 THEN 1
			WHEN MONTH(ORDERDATE) BETWEEN 4 AND 8 THEN 2
			WHEN MONTH(ORDERDATE) BETWEEN 8 AND 12 THEN 3
			ELSE NULL
		END AS Trimeste
		,CASE
			WHEN DATEPART(QUARTER, OrderDate) IN (1,2) THEN 1
			WHEN DATEPART(QUARTER, OrderDate) IN (3,4) THEN 2
			ELSE NULL
		 END AS Semester
	    ,CAST( DATEADD(YEAR, -1, OrderDate) AS date) AS DatePY
		,CAST( DATEADD(MONTH, -1, OrderDate) AS date) AS DatePM
 FROM Sales.SalesOrderHeader

 SELECT * 
 FROM DW_Dim_Date

 CREATE TABLE [datawarehouse].dbo.DW_Dim_Date (
	[Datekey] INT
	,[Date] Date
	,[Year] INT
	,[Month] INT
	,[Day] INT
	,[MonthName] VARCHAR(100)
	,[Weekday] VARCHAR(100)
	,[DayOfYear] INT
	,[WeekOfYear] INT
	,[Quarter] INT
	,[Trimeste] INT
	,[Semester] INT
	,[DatePY] DATE
	,[DatePM] DATE
 )

INSERT INTO [datawarehouse].dbo.DW_Dim_Date
SELECT * 
FROM DW_Dim_Date


 SELECT* FROM [datawarehouse].dbo.DW_Dim_Date
 ;


 -- DIM SHIP METHOD

 CREATE OR ALTER VIEW VWShipMethod
 AS
 SELECT ShipMethodID
	   ,Name AS ShipMethod
	   ,ShipBase
	   ,ShipRate
 FROM Purchasing.ShipMethod


 SELECT * FROM VWShipMethod

 CREATE TABLE [datawarehouse].dbo.DW_Dim_ShipMethod(
	ShipMethodID INT PRIMARY KEY
	,ShipMethod VARCHAR(100)
	,ShipBase NUMERIC(4,2)
	,ShipRate NUMERIC(3,2)
 )

 INSERT INTO [datawarehouse].dbo.DW_Dim_ShipMethod
 SELECT * FROM VWShipMethod

 SELECT * FROM [datawarehouse].dbo.DW_Dim_ShipMethod


 ;

 -- DIM PRODUCT

 SELECT * FROM Production.Product
 SELECT * FROM Production.ProductSubcategory
 SELECT * FROM Production.ProductCategory
 SELECT * FROM Production.ProductModel

 CREATE OR ALTER VIEW DW_Dim_Product
 AS
  SELECT PP.ProductID
	    ,PP.Name AS ProductName
		,PP.ProductNumber
		,IIF(PP.Color IS NULL, 'No Color', PP.Color) AS Color
		,PP.StandardCost
		,PP.ListPrice
		,PP.ListPrice - PP.StandardCost AS Profit
		,ISNULL(PP.Size, 'NSZ') AS Size
		,ISNULL(PP.SizeUnitMeasureCode, 'NSZ') AS SizeUnitMeasureCode
		,ISNULL(PP.Weight, 0) AS [Weight]
		,ISNULL(PP.WeightUnitMeasureCode, 'NoWe') AS WeightUnitMeasureCode
		,CASE
			WHEN PP.ProductLine = 'R' THEN 'Road'
			WHEN PP.ProductLine = 'M' THEN 'Mountain'
			WHEN PP.ProductLine = 'T' THEN 'Touring'
			WHEN PP.ProductLine = 'S' THEN 'Standar'
			WHEN PP.ProductLine IS NULL THEN 'No Line'
			ELSE 'TO CHECK'
		 END AS ProductLine
		--R = Road, M = Mountain, T = Touring, S = Standard
		,CASE
			WHEN PP.Class = 'H' THEN 'High'
			WHEN PP.Class = 'M' THEN 'Medium'
			WHEN PP.Class = 'L' THEN 'Low'
			WHEN PP.Class IS NULL THEN 'No Class'
			ELSE 'TO CHECK'
		 END AS Class
		--H = High, M = Medium, L = Low
		,CASE
			WHEN PP.Style = 'W' THEN 'Womens'
			WHEN PP.Style = 'M' THEN 'Mens'
			WHEN PP.Style = 'U' THEN 'Universal'
			WHEN PP.Style IS NULL THEN 'No Style'
			ELSE 'TO CHECK'
		 END AS Style
		--W = Womens, M = Mens, U = Universal
		,CAST(PP.SellStartDate AS date) AS SellStartDate
		,CAST(PP.SellEndDate AS date) AS SellEndDate
		,IIF(PP.SellEndDate IS NULL, 'Active' ,'Not Active') AS ProductStatus
		,IIF(SC.Name IS NULL, 'No SubCat',  SC.Name) AS SubCategory 
		,IIF(PC.Name IS NULL , 'No Cat', PC.NAME) AS Category
		,IIF(MO.Name IS NULL, 'No Model', MO.Name) AS Model
  FROM Production.Product AS PP
  LEFT JOIN Production.ProductSubcategory AS SC
	ON SC.ProductSubcategoryID = PP.ProductSubcategoryID
  LEFT JOIN  Production.ProductCategory AS PC
	ON PC.ProductCategoryID = SC.ProductCategoryID
  LEFT JOIN  Production.ProductModel AS MO
	ON MO.ProductModelID = PP.ProductModelID


SELECT * FROM DW_Dim_Product


CREATE TABLE [datawarehouse].dbo.DW_Dim_Product (
	ProductID INT,
	ProductName VARCHAR(255),
	ProductNumber VARCHAR(100),
	Color VARCHAR(100),
	StandartCost NUMERIC(38,2),
	ListPrice NUMERIC(38,2),
	Profit NUMERIC(38,2),
	Size VARCHAR(100),
	SizeUnitMeasureCode VARCHAR(100),
	[Weight] NUMERIC(38,2),
	WeightUnitMeasureCode VARCHAR(100),
	ProductLine VARCHAR(100),
	Class VARCHAR(100),
	Style VARCHAR(100),
	SellStartDate DATE,
	SellEndDate DATE,
	ProductStatus VARCHAR(100),
	SubCategory VARCHAR(100),
	Category VARCHAR(100),
	Model VARCHAR(100)
)


INSERT INTO [datawarehouse].dbo.DW_Dim_Product 
SELECT * FROM DW_Dim_Product


SELECT * FROM [datawarehouse].dbo.DW_Dim_Product 
