/* 
The purpose of this script to calculate the Average Unit Cost for each product over the years and 
to understand how much has the cost increased from 2023 (beginning year of the portfolio) to 2025 in both dollars and 
percentage.
This helps in prioritizing the products which require immediate attention. 
*/
CREATE OR ALTER VIEW agg_productcostoveryears AS
WITH calc_unitcost_by_year AS (
SELECT  
	p.ProductKey,
	YEAR(o.OrderDate) AS SalesYear,
	CAST(SUM(o.COGS)/ NULLIF(SUM(o.Quantity), 0) AS DECIMAL(12,2)) AS UnitCost_2023,
	LEAD(CAST(SUM(o.COGS)/ NULLIF(SUM(o.Quantity), 0) AS DECIMAL(12,2)), 1) OVER(PARTITION BY p.ProductKey ORDER BY YEAR(o.OrderDate) ASC) AS UnitCost_2024,
	LEAD(CAST(SUM(o.COGS)/ NULLIF(SUM(o.Quantity), 0) AS DECIMAL(12,2)), 2) OVER(PARTITION BY p.ProductKey ORDER BY YEAR(o.OrderDate) ASC) AS UnitCost_2025
FROM fact_order_details AS o
LEFT JOIN dim_products AS p
ON o.ProductKey = p.ProductKey
GROUP BY 
p.ProductKey,
YEAR(o.OrderDate)
)
SELECT 
	ProductKey,
	UnitCost_2023,
	UnitCost_2024,
	UnitCost_2025,
	CAST(UnitCost_2025 - UnitCost_2023  AS DECIMAL(12,2)) AS Increase_in_dollars_from_2023_25,
	CAST(((UnitCost_2025 - UnitCost_2023)/ UnitCost_2023) * 100 AS DECIMAL(12,2))  AS Increase_Percent_2023_25
FROM calc_unitcost_by_year AS c
WHERE UnitCost_2024 IS NOT NULL AND UnitCost_2025 IS NOT NULL
