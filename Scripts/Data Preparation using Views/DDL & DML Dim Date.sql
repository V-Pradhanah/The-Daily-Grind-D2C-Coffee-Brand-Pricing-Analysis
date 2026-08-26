-------------------------------------------------------------------------------------------------------------------
--Creating Dimension Date table  as time intelligence functions in PowerBI require continuous dates for analysis like change over time and cumulative analysis
--It also enables us to flag and identify the time period where there is no sales or no order placed
------------------------------------------------------------------------------------------------------------------
--Dropping the table to avoid creating duplicate dim_date table
IF OBJECT_ID('dim_date' , 'U') IS NOT NULL
DROP TABLE dim_date;

GO
--Creating table dim_date .........................................................................
CREATE TABLE dim_date (
	CalendarDate DATE PRIMARY KEY,
	DayNum INT NOT NULL,
	MonthNum INT NOT NULL,
	YearNum INT NOT NULL,
	QuarterNum INT NOT NULL,
	QuarterName NVARCHAR(20) NOT NULL,
	MonthName NVARCHAR(50) NOT NULL,
	WeekDayNum INT  NOT NULL,
	WeekDayName  NVARCHAR(50) NOT NULL,
	StartofWeek DATE NOT NULL,
	StartofMonth DATE NOT NULL,
	StartofYear DATE NOT NULL,
	WeekofYear INT NOT NULL,
	IsWeekend VARCHAR(20) NOT NULL
);

GO
--Truncating the table to avoid  inserting duplicates 
TRUNCATE TABLE dim_date;
GO 
--Using Recursive CTE to generate date from 2023-01-01 until 2025-12-31
WITH date_table_cte AS(
	SELECT CAST('2023-01-01' AS DATE) AS CalendarDate
	UNION ALL
	SELECT DATEADD(DAY, 1, CalendarDate)
	FROM date_table_cte
	WHERE CalendarDate < '2025-12-31'
)
--Inserting the values generated from recursive cte to table dim_date
INSERT INTO   dim_date
(
	CalendarDate ,
	DayNum ,
	MonthNum ,
	YearNum ,
	QuarterNum ,
	QuarterName ,
	MonthName ,
	WeekDayNum ,
	WeekDayName  ,
	StartofWeek ,
	StartofMonth ,
	StartofYear ,
	WeekofYear,
	IsWeekend
)
SELECT 
	CalendarDate ,
	DAY(CalendarDate) AS DayNum,
	MONTH(CalendarDate) AS MonthNum,
	YEAR(CalendarDate) AS YearNum,
	DATEPART(QUARTER, CalendarDate) AS QuarterNum,
	CONCAT('Q' , DATENAME(QUARTER, CalendarDate)) AS QuarterName,
	DATENAME(MONTH, CalendarDate) AS MonthName,
	DATEPART(WEEKDAY, CalendarDate) AS WeekDayNum,
	DATENAME(WEEKDAY, CalendarDate) AS WeekDayName,
	CAST(DATEADD(WEEK, DATEDIFF(WEEK, -1, CalendarDate), -1) AS DATE) AS StartofWeek,
	DATETRUNC(MONTH, CalendarDate) AS StartofMonth,
	DATETRUNC(YEAR, CalendarDate) AS StartofYear,
	DATEPART(WEEK, CalendarDate) AS WeekofYear,
	CASE WHEN DATENAME(WEEKDAY, CalendarDate) IN ('Sunday', 'Saturday') THEN 'Yes' ELSE 'No' END AS IsWeekend
FROM date_table_cte
OPTION (MAXRECURSION  1500)







