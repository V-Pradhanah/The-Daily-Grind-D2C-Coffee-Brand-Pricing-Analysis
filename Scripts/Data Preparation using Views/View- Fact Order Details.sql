---Creating fact order details table with required metrics and calculated values by joining dimension 
---customers, products and date table
CREATE OR ALTER VIEW fact_order_details AS
SELECT 
	o.OrderID,
	o.CustomerID,
	p.ProductKey,
	o.OrderDate,
	--Replacing NULL Revenue rows with the product of Quantity and Price
	CASE WHEN o.Revenue IS NULL THEN p.Price * o.Quantity
		 ELSE o.Revenue 
	END AS Revenue,
	o.COGS,
	o.Quantity,
	p.Price AS UnitPrice,
	--Calculating Unit Cost from COGS and Quantity
	CAST(o.COGS / o.Quantity AS DECIMAL(12,2)) AS UnitCost,
	--Calculating profit from Revenue and COGS
	CASE WHEN o.Revenue IS NULL THEN p.Price * o.Quantity
		 ELSE o.Revenue 
	END - o.COGS AS Profit,
	p.Price - CAST(o.COGS/o.Quantity AS DECIMAL(12,2)) AS ProfitPerUnit
FROM all_orders AS o
LEFT JOIN dim_customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN cleaned_products AS p
ON o.ProductID = p.ProductID
LEFT JOIN dim_date AS d
ON o.OrderDate = d.CalendarDate
WHERE o.CustomerID IS NOT NULL  --excluding rows with NULL customerID considering the immateriality of it to the total revenue


