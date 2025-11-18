# SQL — AdventureWorks (Datamart, ETL & Queries)

**Autor:** Jorge Conde Calderón  
**DB base:** AdventureWorks (OLTP)  
**Stack:** SQL Server · T-SQL · ETL (views/stored procedures)

> 🚧 **Estado**: Under construction. Este repositorio se irá completando con los ETL y queries finales a medida que avance el proyecto.

---

## 🎯 Objetivo
Construir un **datamart ligero** sobre AdventureWorks con las dimensiones **Date, Product, ShipingMethod** y la **tabla de hechos de ventas (FactSales)**; incluir **ETL** reproducible y **consultas KPI** listas para BI (Power BI, etc.).

---

## 🚀 Puesta en marcha

### Requisitos
- **SQL Server** 2017/2019+ (o Azure SQL Database).
- **AdventureWorks2017**.


---

## 🧱 Modelo (resumen)
- **dbo.DW_Fact_Sales**(``SalesID``
	,``OrderDate``
	,``OrderDateKey``
	,``ShipDate``
	,``ShipDateKey``
	,``DaysToShip``
	,``Status``
	,``OrderFlag``
	,``SalesOrderNumber``
	,``AccountNumber``
	,``CUstomerID``
	,``SalesPersonID``
	,``TerritoryID``
	,``BillToAdressID``
	,``ShipToAdressID``
	,``ShipMethodID``
	,``Currency``
	,``CurrencyName``
	,``SubTotalUSDDollar``
	,``SubTotal``
	,``TaxAmtUSDDollar``
	,``TaxAmt``
	,``FreighUSDDollar``
	,``Freigh``
	,``TotalDueUSDDollar``
	,``TotalDue``
	,``PercentageTax``
	,``FreightTax``
	,``OrderQty``
	,``ProductID``
	,``UnitPrice``
	,``LineTotal``
	,``PercentageOfTotal ``
- **dbo.DW_Dim_Date**(``Datekey``
	,``Date``
	,``Year``
	,``Month``
	,``Day``
	,``MonthName``
	,``Weekday``
	,``DayOfYear``
	,``WeekOfYear``
	,``Quarter``
	,``Trimeste``
	,``Semester``
	,``DatePY``
	,``DatePM`` 
- **dbo.DW_Dim_ShipMethod**(``ShipMethodID``
	,``ShipMethod``
	,``ShipBase``
	,``ShipRate``
- **dbo.DW_Dim_Product**(``ProductID``,
	``ProductName``,
	``ProductNumber``,
	``Color``,
	``StandartCost``,
	``ListPrice``,
  	``Profit``,
	``Size``,
	``SizeUnitMeasureCode``,
	``Weight``,
	``WeightUnitMeasureCode``,
	``ProductLine``,
	``Class``,
	``Style``,
	``SellStartDate``,
	``SellEndDate``,
	``ProductStatus``,
	``SubCategory``,
	``Category``,
	``Model``) 

---

## 🔄 ETL 

**dbo.DW_Fact_Sales**

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
