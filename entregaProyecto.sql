-- Active: 1697237543541@@127.0.0.1@3306@adw

with territorio_y_ventas as (
    select 
    distinct Person_CountryRegion.CountryRegionCode as Cod_ISO,
    Person_CountryRegion.Name as pais,
    Person_StateProvince.TerritoryID as TerritoryID,
    Sales_SalesTerritory.Name as Lugar_ventas,
    Person_StateProvince.Name as Provincia

    from Person_CountryRegion
        join Person_StateProvince using(CountryRegionCode)
        join Sales_SalesTerritory on Sales_SalesTerritory.TerritoryID =Person_StateProvince.TerritoryID

),

-- ventas por producto
Ventas_por_producto as (
    select 
        distinct ProductID,
        Production_Product.Name as producto,
        sum(LineTotal) as Ingresos_prod,
        Production_ProductCategory.Name as categoria,
        Production_ProductSubcategory.Name as subcategoria
        from Sales_SalesOrderDetail
        join Production_Product using (ProductID)
        join Production_ProductSubcategory using (ProductSubcategoryID) 
        join Production_ProductCategory using (ProductCategoryID) 
        group by producto

),

-- Ventas y monedas
ventas_y_monedas as (
    select 
        distinct SalesOrderID,
        TotalDue,
        SubTotal,
        OrderDate,
        FromCurrencyCode,
        ToCurrencyCode
    from Sales_SalesOrderHeader
    join Sales_CurrencyRate using (CurrencyRateID)
),

-- Conssulta1 
ventas_por_territorio as (
    select
        distinct SalesOrderID,
        TotalDue,
        OrderDate,
        City,
        AddressID,
        Person_StateProvince.Name as Provincia,
        Person_CountryRegion.Name as Pais

    from Sales_SalesOrderHeader
        join Person_Address on Person_Address.AddressID = Sales_SalesOrderHeader.BillToAddressID
        join Person_StateProvince using (StateProvinceID)
        join Person_CountryRegion using (CountryRegionCode)
),


ventas_por_producto_y_territorio as (
    select
    distinct ProductID,
    OrderQty,
    TotalDue,
    OrderDate,
    Production_Product.Name as producto,
    Production_ProductCategory.Name as categoria,
    Production_ProductSubcategory.Name as subcategoria,
    City,
    Provincia,
    Pais
    from ventas_por_territorio
    join Sales_SalesOrderDetail using(SalesOrderID)
    join Production_Product using (ProductID)
    join Production_ProductSubcategory using (ProductSubcategoryID) 
    join Production_ProductCategory using (ProductCategoryID)     
),

-- Consulta2

Utilidad_por_producto as (
  
    select 
        distinct ProductID,
        Production_Product.Name as producto,
        sum(LineTotal) as Ingresos_prod,
        sum(LineTotal-StandardCost*OrderQty) as utilidades,
        Production_ProductCategory.Name as categoria,
        Production_ProductSubcategory.Name as subcategoria
        from Sales_SalesOrderDetail
        join Production_Product using (ProductID)
        join Production_ProductSubcategory using (ProductSubcategoryID) 
        join Production_ProductCategory using (ProductCategoryID) 
        group by ProductID
),

venta_por_meses as (
select
    MONTH(Sales_SalesOrderHeader.OrderDate) as mes,
    YEAR(Sales_SalesOrderHeader.OrderDate) as anio,
#     COUNT(Sales_SalesOrderHeader.SalesOrderID) as cantidad_ventas, Esto sería el pedido en el que van un grupo de ventas
#     Con LineTotal, podría sacar las ventas totales por mes y anio, pero no por producto
    sum(OrderQty) as cantidad_producto_vendido,
    sum(LineTotal) as total_ventas

from `Sales_SalesOrderHeader`
inner join Sales_Customer using (CustomerID)
inner join Sales_SalesOrderDetail using (SalesOrderID)
group by mes, anio
),

-- Consulta3
datos_por_estacion as (
select
    sum(CASE WHEN mes in (12, 1, 2) and anio = 2011 THEN total_ventas else 0 end) as  invierno_total_ventas2011,
    sum(CASE WHEN mes in (12, 1, 2) and anio = 2011 THEN cantidad_producto_vendido else 0 end) as  invierno_Cantidad_Productos2011,
    sum(CASE WHEN mes in (3, 4, 5) and anio = 2011 THEN total_ventas else 0 end) as  Primavera2011,
    sum(CASE WHEN mes in (3, 4, 5) and anio = 2011 THEN cantidad_producto_vendido else 0 end) as  primavera_Cantidad_Productos2011,
    sum(CASE WHEN mes in (6, 7, 8) and anio = 2011 THEN total_ventas else 0 end) as  Verano2011,
    sum(CASE WHEN mes in (6, 7, 8) and anio = 2011 THEN cantidad_producto_vendido else 0 end) as  verano_Cantidad_Productos2011,
    sum(CASE WHEN mes in (9, 10, 11) and anio = 2011 THEN total_ventas else 0 end) as  Otoño2011,
    sum(CASE WHEN mes in (9, 10, 11) and anio = 2011 THEN cantidad_producto_vendido else 0 end) as  otoño_Cantidad_Productos2011,
    sum(CASE WHEN mes in (12, 1, 2) and anio = 2012 THEN total_ventas else 0 end) as  Invierno2012,
    sum(CASE WHEN mes in (12, 1, 2) and anio = 2012 THEN cantidad_producto_vendido else 0 end) as  invierno_Cantidad_Productos2012,
    sum(CASE WHEN mes in (3, 4, 5) and anio = 2012 THEN total_ventas else 0 end) as  Primavera2012,
    sum(CASE WHEN mes in (3, 4, 5) and anio = 2012 THEN cantidad_producto_vendido else 0 end) as  primavera_Cantidad_Productos2012,
    sum(CASE WHEN mes in (6, 7, 8) and anio = 2012 THEN total_ventas else 0 end) as  Verano2012,
    sum(CASE WHEN mes in (6, 7, 8) and anio = 2012 THEN cantidad_producto_vendido else 0 end) as  verano_Cantidad_Productos2012,
    sum(CASE WHEN mes in (9, 10, 11) and anio = 2012 THEN total_ventas else 0 end) as  Otoño2012,
    sum(CASE WHEN mes in (9, 10, 11) and anio = 2012 THEN cantidad_producto_vendido else 0 end) as  otoño_Cantidad_Productos2012,
    sum(CASE WHEN mes in (12, 1, 2) and anio = 2013 THEN total_ventas else 0 end) as  Invierno2013,
    sum(CASE WHEN mes in (12, 1, 2) and anio = 2013 THEN cantidad_producto_vendido else 0 end) as  invierno_Cantidad_Productos2013,
    sum(CASE WHEN mes in (3, 4, 5) and anio = 2013 THEN total_ventas else 0 end) as  Primavera2013,
    sum(CASE WHEN mes in (3, 4, 5) and anio = 2013 THEN cantidad_producto_vendido else 0 end) as  primavera_Cantidad_Productos2013,
    sum(CASE WHEN mes in (6, 7, 8) and anio = 2013 THEN total_ventas else 0 end) as  Verano2013,
    sum(CASE WHEN mes in (6, 7, 8) and anio = 2013 THEN cantidad_producto_vendido else 0 end) as  verano_Cantidad_Productos2013,
    sum(CASE WHEN mes in (9, 10, 11) and anio = 2013 THEN total_ventas else 0 end) as  Otoño2013,
    sum(CASE WHEN mes in (9, 10, 11) and anio = 2013 THEN cantidad_producto_vendido else 0 end) as  otoño_Cantidad_Productos2013,
    sum(CASE WHEN mes in (12, 1, 2) and anio = 2014 THEN total_ventas else 0 end) as  Invierno2014,
    sum(CASE WHEN mes in (12, 1, 2) and anio = 2014 THEN cantidad_producto_vendido else 0 end) as  invierno_Cantidad_Productos2014,
    sum(CASE WHEN mes in (3, 4, 5) and anio = 2014 THEN total_ventas else 0 end) as  Primavera2014,
    sum(CASE WHEN mes in (3, 4, 5) and anio = 2014 THEN cantidad_producto_vendido else 0 end) as  primavera_Cantidad_Productos2014,
    sum(CASE WHEN mes in (6, 7, 8) and anio = 2014 THEN total_ventas else 0 end) as  Verano2014,
    sum(CASE WHEN mes in (6, 7, 8) and anio = 2014 THEN cantidad_producto_vendido else 0 end) as  verano_Cantidad_Productos2014
FROM
    venta_por_meses
)

select *
from
datos_por_estacion

limit 20;