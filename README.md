# SQL — AdventureWorks (Datamart, ETL & Queries)

**Autor:** Jorge Conde Calderón  
**DB base:** AdventureWorks (OLTP)  
**Stack:** SQL Server · T-SQL · ETL (views/stored procedures)

> 🚧 **Estado**: Under construction. Este repositorio se irá completando con los ETL y queries finales a medida que avance el proyecto.

---

## 🎯 Objetivo
Construir un **datamart ligero** sobre AdventureWorks con las dimensiones **Date, Customer, Product, Territory** y la **tabla de hechos de ventas (FactSales)**; incluir **ETL** reproducible y **consultas KPI** listas para BI (Power BI, etc.).

---

## 🚀 Puesta en marcha

### Requisitos
- **SQL Server** 2017/2019+ (o Azure SQL Database).
- **AdventureWorks** restaurada en la instancia (OLTP).


---

## 🧱 Modelo (resumen)
- **dbo.DW_Fact_Sales**(``SalesID BIGINT PRIMARY KEY``
	,``OrderDate DATE``
	,``OrderDateKey INT``
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
- **dbo.DW_Dim_Date**(`CustomerKey`, `CustomerAlternateKey`, `PersonType`, `FullName`, `EmailAddress`, `Phone`, `StoreName`, `TerritoryKey`)  
- **dbo.DW_Dim_ShipMethod**(`ProductKey`, `ProductAlternateKey`, `ProductName`, `Subcategory`, `Category`, `Color`, `Size`, `StandardCost`, `ListPrice`)  
- **dbo.DW_Dim_Product**(`TerritoryKey`, `TerritoryAlternateKey`, `Name`, `CountryRegionCode`, `Group`) 

---

## 🔄 ETL 
