insert into
    adw_datawh.dim_tienda (
        tienda_id,
        tienda_pais,
        tienda_estado,
        tienda_ciudad,
        tienda_nombre
    )
select
    Sales_SalesOrderHeader.CustomerID as tienda_id,
    # Esto en verdad, es el id de la tienda y se puede confirmar en la tabla Sales_Store
    MAX(Person_CountryRegion.Name) as tienda_pais,
    MAX(Person_StateProvince.Name) as tienda_estado,
    MAX(Person_Address.City) as tienda_ciudad,
    MAX(Sales_Store.Name) as tienda_nombre
from
    adw.Sales_SalesOrderHeader
    inner join adw.Person_Address on Sales_SalesOrderHeader.ShipToAddressID = Person_Address.AddressID
    inner join adw.Person_StateProvince on Person_Address.StateProvinceID = Person_StateProvince.StateProvinceID
    inner join adw.Person_CountryRegion on Person_StateProvince.CountryRegionCode = Person_CountryRegion.CountryRegionCode
    inner join adw.Sales_Customer on Sales_SalesOrderHeader.CustomerID = Sales_Customer.CustomerID
    inner join adw.Sales_Store on Sales_Customer.StoreID = Sales_Store.BusinessEntityID
group by
    Sales_SalesOrderHeader.CustomerID;