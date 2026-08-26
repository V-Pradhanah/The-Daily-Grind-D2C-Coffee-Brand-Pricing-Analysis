--..........................................EDA...................................................
SELECT * FROM fact_order_details;
--Checking the temporal scope of data
SELECT DISTINCT YEAR(OrderDate), MONTH(orderDate) FROM fact_order_details
ORDER BY YEAR(OrderDate), MONTH(orderDate);

SELECT MIN(OrderDate), MAX(orderDate) FROM fact_order_details;
--Dec 2025 data not recorded yet

SELECT MIN(CustomerJoinDate), MAX(CustomerJoinDate)
FROM dim_customers;  --Customer Join date only falls in 2023 with no new customer joined after 28 dec 2023
-- Likely a result of how the synthetic dataset was generated, not something expected in a real business


--Check if there is any month of mass customer acquisition  
SELECT DATETRUNC(MONTH,CustomerJoinDate), COUNT(DISTINCT CustomerID)
FROM dim_customers
GROUP BY DATETRUNC(MONTH,CustomerJoinDate)
ORDER BY DATETRUNC(MONTH,CustomerJoinDate); --from 15 to 21 customers each month


--------------------------------Important Metrics Overall Summary-----------------------------------------------------------
SELECT 
SUM(Revenue) AS Rev_Sum,  --871070.86
SUM(Profit) AS Profit_sum,
SUM(COGS) AS Cogs_Sum,
COUNT(DISTINCT OrderID) AS Total_Orders,
AVG(Profit) AS Avg_profit_Per_Order, --107.786719
CAST(AVG(CAST(Quantity AS FLOAT)) AS DECIMAL(12,2)) AS avg_quantity_sold_per_order
FROM fact_order_details;

--..........................................Important Product Metrics...................................................
SELECT 
p.ProductKey,
p.ProductName, 
AVG(Revenue) AS Avg_Revenue_per_product,
AVG(Profit) AS Avg_profit_per_product ,  --43 $ to 193$
SUM(Revenue) AS Sum_Revenue_per_product ,
SUM(Profit) AS Sum_Profit_per_product,
SUM(COGS) AS Sum_Cogs_per_product,
COUNT(DISTINCT OrderID) AS Total_Orders_per_product,
SUM(Quantity) AS Sum_Quantity_per_product
FROM fact_order_details AS o
LEFT JOIN dim_products AS p
ON o.ProductKey = p.ProductKey
GROUP BY p.ProductKey  , p.ProductName
ORDER BY Avg_profit_per_product DESC; 


--checking if there is any customer who brings in extraordinary income
SELECT CustomerID, COUNT(DISTINCT OrderID) AS Order_count, SUM(Revenue) AS Sum_Revenue
FROM fact_order_details
GROUP BY CustomerID
ORDER BY Sum_Revenue DESC;

--Checking Seasonal Demand
SELECT 
DATETRUNC(MONTH, OrderDate), COUNT(DISTINCT orderID) AS  NumOrdersPerMonth
FROM fact_order_details
GROUP BY DATETRUNC(MONTH, OrderDate)
ORDER BY NumOrdersPerMonth DESC;

--checking how much does unit cost rise year on year
SELECT DISTINCT ProductKey, YEAR(OrderDate),UnitCost
FROM fact_order_details;  --maybe 0.01 cent increase in unit cost within the same year across all products 
--real variation and increase in unit cost occurs every year



