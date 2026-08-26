------------QUALITY CHECKS---------------------------------------------------
/*
Products Table
Upon checking , found that producs table has only 25 unique products(ProductName,ProductCategory, Price,Base Cost Combination)
while the total number of rows are 50 with duplicate productID for each product
Hence, DenseRank() function has been used to generate Unique ProductKey
*/
SELECT COUNT(*) FROM products --total rows
--------------------------------------------------------
SELECT DISTINCT 
	ProductName,
	ProductCategory,
	Price,
	Base_Cost
FROM products   --25 rows 
---------------------------------------------------------
SELECT 
	ProductName,
	ProductCategory,
	Price,
	Base_Cost,
	COUNT(ProductID) AS Num_duplicate_IDS
FROM products
GROUP BY 
	ProductName,
	ProductCategory,
	Price,
	Base_Cost
----------------------------------------------------------------------
--Orders Table
--all_orders - View combining  order details from individual source file Orders_2023, Orders_2024 & Orders_2025

--1.Checking if NULL Customer ID rows in Orders Table is specific to one source file (is a deliberate NULL rows) or is it genuinely missing data
SELECT DISTINCT YEAR(OrderDate)
FROM all_orders
WHERE CustomerID IS NULL   --found NULL CustomerID rows spanning across all the years and is not specific to a one source file (one year) 


--2.Checking the composing of rows of with NULL customerID to Total Revenue and the Total number of rows 
SELECT SUM(Revenue) FROM all_orders; --871330.40

GO 

SELECT SUM(Revenue) FROM all_orders WHERE CustomerID IS NULL; --7629.44

GO

SELECT 7629.44 / 871330.40 * 100; --less than 1% --0.87560815000 % 

--Sum of revenue of the rows with NULL CustomerID is less than 1% of the total revenue 
--Count of rows with NULL CustomerID is 24 and the total rows of orders table is 4456
--Hence the  Rows with NULL CustomerID can be excluded from analysis if needed considering the immateriality of it


--3. Checking NULL Revenue rows in Orders Table is specific to a  time period 
SELECT COUNT(*) FROM all_orders WHERE Revenue IS NULL; --41 Rows 

GO

SELECT  YEAR(OrderDate), MONTH(OrderDate) , COUNT(*)
FROM all_orders
WHERE Revenue IS NULL
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY  YEAR(OrderDate), MONTH(OrderDate);

---------------------------------------------------------------------
--Quality Checks for  COGS and Retail Price
--Checking if the Unit Cost (COGS) change from when it was updated in products catalog or does it differ from the static base cost in products table
SELECT 
DISTINCT 
	o.COGS,
	o.Quantity,
	CAST(o.COGS/ o.Quantity AS DECIMAL(12,2)) AS UnitCost,
	p.Base_Cost,
	CAST(o.Revenue/o.Quantity AS DECIMAL(12,2)) AS UnitPrice,
	p.Price,
	YEAR(o.OrderDate) AS OrderYear
FROM all_orders AS o
LEFT JOIN cleaned_products AS p
ON o.ProductID = p.ProductID
WHERE o.Revenue IS NOT NULL AND p.ProductID = 1006 --(eg: ProductKey - 20, ProductID - 1006)
ORDER BY YEAR(o.OrderDate)
--Found  that Unit Cost actually changes over the years while base cost in products table to be static and it hasn't been updated 
--Hence replacing Base cost with the Calculated Unit Cost for further analysis

GO

--Checking if the calculated price (selling price) is dynamic or stays the same as in product table's price
SELECT *
FROM (
	SELECT DISTINCT
		p.ProductKey,
		p.Price AS PriceFromProductsTable,
		CAST(o.Revenue/o.Quantity AS DECIMAL(12,2)) AS CalclulatedPrice
	FROM all_orders AS o
	LEFT JOIN cleaned_products AS p
	ON o.ProductID = p.ProductID
	WHERE o.Revenue IS NOT NULL)sq
WHERE PriceFromProductsTable != CalclulatedPrice  
/*Found the calculated price from orders table is always equal to the price in products table and it
hasn't changed since the price was updated in product catalog*/

GO

--Checking if the actual unit price recorded at the time of order is equal to the list Price in Products Catalog 
--or does it differ due to discounts 
SELECT * 
FROM all_orders AS o
LEFT JOIN cleaned_products AS  p
ON o.ProductID = p.ProductID
WHERE Revenue IS NOT NULL AND o.Revenue != o.Quantity * p.Price -- found calculated Unit Price and Price in Product Catalog to be equal

----------------------------------------------
SELECT *
FROM products;
SELECT * 
FROM cleaned_products;
SELECT *
FROM dim_products;
