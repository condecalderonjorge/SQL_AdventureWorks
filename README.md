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
- **dm.DimDate**(`DateKey` int, `Date`, `Year`, `Quarter`, `Month`, `MonthName`, `YearMonth`, `WeekOfYear`, `DayOfMonth`, `DayName`, `IsWeekend`)  
- **dm.DimCustomer**(`CustomerKey`, `CustomerAlternateKey`, `PersonType`, `FullName`, `EmailAddress`, `Phone`, `StoreName`, `TerritoryKey`)  
- **dm.DimProduct**(`ProductKey`, `ProductAlternateKey`, `ProductName`, `Subcategory`, `Category`, `Color`, `Size`, `StandardCost`, `ListPrice`)  
- **dm.DimTerritory**(`TerritoryKey`, `TerritoryAlternateKey`, `Name`, `CountryRegionCode`, `Group`)  
- **dm.FactSales**(`DateKey`, `CustomerKey`, `ProductKey`, `TerritoryKey`, `SalesOrderID`, `SalesOrderDetailID`, `OrderQty`, `UnitPriceUSD`, `LineTotalUSD`, `TaxAmtUSD`, `FreightUSD`, `DaysToShip`, `Channel`)

---

## 🔄 ETL 
