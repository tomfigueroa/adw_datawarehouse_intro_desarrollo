insert into
    adw_datawh.dim_fecha (
        fecha_key,
        fecha,
        anio,
        mes,
        dia,
        dia_semana,
        trimestre
    )
select
    to_days(fecha) as fecha_key,
    fecha,
    year(fecha) as anio,
    month(fecha) as mes,
    dayname(fecha) as dia,
    dayofweek(fecha) as dia_semana,
    quarter(fecha) as trimestre
from (
        select
            distinct OrderDate as fecha
        from
            adw.Sales_SalesOrderHeader
    ) AS fechas;