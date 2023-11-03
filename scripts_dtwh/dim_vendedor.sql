insert into
    adw_datawh.dim_vendedor (
        vendedor_id,
        vendedor_nombre,
        vendedor_edad,
        vendedor_sexo
    )
select
    Sales_SalesOrderHeader.SalesPersonID as vendedor_id,
    MAX(Person_Person.FirstName) AS vendedor_nombre,
    DATE_FORMAT(
        FROM_DAYS(
            DATEDIFF(
                NOW(),
                MAX(
                    HumanResources_Employee.BirthDate
                )
            )
        ),
        '%Y'
    ) + 0 AS vendedor_edad,
    MAX(
        HumanResources_Employee.Gender
    ) AS vendedor_sexo
from
    adw.Sales_SalesOrderHeader
    inner join adw.Person_Person on Sales_SalesOrderHeader.SalesPersonID = Person_Person.BusinessEntityID
    inner join adw.HumanResources_Employee on Sales_SalesOrderHeader.SalesPersonID = HumanResources_Employee.BusinessEntityID
group by
    Sales_SalesOrderHeader.SalesPersonID;

;