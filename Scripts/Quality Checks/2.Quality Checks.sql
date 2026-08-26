----......................................2.Quality Checks..................................................................
--Checking if there is any long gap or pause in business for weeks or days was recorded in dataset
SELECT DATETRUNC(MONTH, OrderDate), COUNT(DISTINCT OrderDate)
FROM fact_order_details
GROUP BY DATETRUNC(MONTH, OrderDate)
ORDER BY DATETRUNC(MONTH, OrderDate);  --from 24 to 31 days a month 

--Checking if there is any customerID in order details table that is not recorded in customer table
--Expection: No Result
SELECT CustomerID
FROM all_orders
WHERE CustomerID NOT IN (SELECT CustomerID FROM dim_customers);  -- 0

SELECT CustomerID
FROM all_orders
WHERE CustomerID IS NULL; --24 NULL CustomerID


--checking if there is any data lag in the last month in the dataset --Nov 2025
SELECT 
DISTINCT DAY(OrderDate)
FROM fact_order_details
WHERE YEAR(OrderDate) = 2025 AND MONTH(OrderDate) = 11 ;

--Is Revenue equal to product of quantity and price
SELECT * 
FROM all_orders AS o
LEFT JOIN products AS p
ON o.ProductID = p.ProductID
WHERE o.Revenue IS NOT NULL  AND o.Revenue != o.Quantity * p.Price;
