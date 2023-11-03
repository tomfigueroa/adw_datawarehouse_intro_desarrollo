insert into
    adw_datawh.dim_producto (
        producto_id,
        producto_categoria,
        producto_subcategoria,
        producto_color,
        producto_tamanio,
        producto_peso
    )
select
    Production_Product.ProductID as producto_id,
    MAX(
        Production_ProductCategory.Name
    ) as producto_categoria,
    MAX(
        Production_ProductSubcategory.Name
    ) as producto_subcategoria,
    IFNULL(
        MAX(Production_Product.Color),
        'Desconocido'
    ) as producto_color,
    IFNULL(
        MAX(Production_Product.Size),
        'Desconocido'
    ) as producto_tamanio,
    IFNULL(
        MAX(Production_Product.Weight),
        -1
    ) as producto_peso
from adw.Production_Product
    inner join adw.Production_ProductSubcategory on Production_Product.ProductSubcategoryID = Production_ProductSubcategory.ProductSubcategoryID
    inner join adw.Production_ProductCategory on Production_ProductSubcategory.ProductCategoryID = Production_ProductCategory.ProductCategoryID
group by ProductID;