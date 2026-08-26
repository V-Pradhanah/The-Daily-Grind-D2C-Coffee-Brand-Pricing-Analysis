--Combining order details from all the years in portfolio 2023-25 in a view to be used across multiple queries
CREATE OR ALTER VIEW all_orders AS
SELECT 
	OrderID,
	CustomerID,
	ProductID,
	OrderDate,
	Quantity,
	Revenue,
	COGS
FROM Orders_2023
UNION ALL
SELECT 
	OrderID,
	CustomerID,
	ProductID,
	OrderDate,
	Quantity,
	Revenue,
	COGS
FROM Orders_2024
UNION ALL
SELECT 
	OrderID,
	CustomerID,
	ProductID,
	OrderDate,
	Quantity,
	Revenue,
	COGS
FROM Orders_2025;

GO

--Creating table 'cleaned_products' with surrogate key(ProductKey) for products (found ProductID to be duplicated)
SELECT 
	DENSE_RANK() OVER(ORDER BY ProductName, ProductCategory, Price, Base_Cost) AS ProductKey,
	ProductID,
	ProductName,
	ProductCategory,
	Price,
	Base_Cost
--Inserting the existing columns from products table along with surrogate key to a permenant table using CTAS
INTO dbo.cleaned_products
FROM dbo.products;

GO

--Creating a view with deduplicated product records to ensure 1 to many cardinality relationship in Data Modeling
CREATE OR ALTER VIEW dim_products AS
SELECT DISTINCT
ProductKey,
ProductName,
ProductCategory,
Price,
Base_Cost
FROM cleaned_products;





