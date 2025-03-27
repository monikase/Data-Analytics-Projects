/* 1.1 Extract the data on products from the Product table where there exists a product subcategory.
- Columns needed: ProductId, Name, ProductNumber, size, color, ProductSubcategoryId, Subcategory name.
- Order results by SubCategory name. */

SELECT
p.ProductID,
p.Name,
p.ProductNumber,
p.Size,
p.Color,
p.ProductSubcategoryID,
p_subcategory.Name AS SubCategory
FROM `tc-da-1.adwentureworks_db.product` AS p
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS p_subcategory
ON p.ProductSubcategoryID = p_subcategory.ProductSubcategoryID
ORDER BY SubCategory

/* 1.2
- Find and add the product category name.
- Afterwards order the results by Category name.*/

SELECT
p.ProductID,
p.Name,
p.ProductNumber,
p.Size,
p.Color,
p.ProductSubcategoryID,
p_subcategory.Name AS SubCategory,
p_category.name AS Category
FROM `tc-da-1.adwentureworks_db.product` AS p
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS p_subcategory
ON p.ProductSubcategoryID = p_subcategory.ProductSubcategoryID
JOIN `tc-da-1.adwentureworks_db.productcategory` AS p_category
ON p_subcategory.ProductCategoryID = p_category.ProductCategoryID
ORDER BY Category

/* 1.3
- Select the most expensive (price listed over 2000) bikes that are still actively sold (does not have a sales end date)
- Order the results from most to least expensive bike. */

SELECT
p.ProductID,
p.Name,
p.ProductNumber,
p.Size,
p.Color,
p.ProductSubcategoryID,
p_subcategory.Name AS SubCategory,
p_category.Name AS Category
FROM `tc-da-1.adwentureworks_db.product` AS p
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS p_subcategory
ON p.ProductSubcategoryID = p_subcategory.ProductSubcategoryID
JOIN `tc-da-1.adwentureworks_db.productcategory` AS p_category
ON p_subcategory.ProductCategoryID = p_category.ProductCategoryID
WHERE p_category.Name = 'Bikes' AND p.SellEndDate IS NULL AND p.ListPrice > 2000
ORDER BY p.ListPrice DESC
