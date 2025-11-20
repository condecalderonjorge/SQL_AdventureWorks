# AdventureWorks (DataWarehouse, ETL & Queries)

**Autor:** Jorge Conde Calderón  
**DB base:** AdventureWorks2017  
**Stack:** SQL Server · PowerBI · ETL (views/stored procedures)

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
