# The-Daily-Grind-D2C-Coffee-Brand-Pricing-Analysis

Pricing analysis for a fictional coffee D2C brand (synthetic dataset)  using SQL &amp; Power BI to understand rising COGS and declining profit margins, and identify products which require pricing adjustment.

## Project Overview

   An end to end data analysis project examining the performance of The Daily Grind - D2C (Coffee & Coffeeware) business to understand how rising COGS has impacted profit margin over the years (2023-2025)  and to identify the products that require prompt attention to price modification.

## Source

   This analysis uses the 'Data Analysis Project November 2025 Youtube.zip' dataset, sourced from Github user Gaelim  (accessed in August 2026). The dataset is synthetic,built to resemble a real-world e-commerce business and the temporal scope of this dataset ranges from 2nd January 2023 until 30th November 2025.

## Tools used

1. SQL Server
2. PowerBI
3. MS Excel

## Data Cleaning/Quality Checks

1. Trim checks for Text and Alphanumeric columns
2. Checked for outliers in dates
3. Checked for outliers, negatives and zeros in numeric columns
4. NULL Checks
5. Deduplication  of Primary Keys (Creating unique id for products table)
6. Checked for consistency of datatypes of related columns across all source files in order to append them.

## Data Preparation

1. Dimension Date Table was created with continuous dates as Power BI Time Intelligence functions requires it.
2. Dynamic calculations used to replace NULL values in Revenue Column
3. Built business objects - Fact and Dimension - Through Views and CTAS

## Connection and Storage Mode

**Import Mode & PowerBI's in-memory Vertipaq** has been used considering the static & small amount of data and for faster performance.

## Data Modeling

**Star Schema** built using single direction filters flowing from lookup tables to fact tables with **1 to many cardinality**

## Business Context

1. Choosing the right terms for measures based on the dataset e.g. Choosing Total Revenue instead of Gross or Net , Choosing Gross Profit instead of Total Profit/ Net Profit.
2. Calculating measures from base value for non-additive measure like Profit Margin and Markup % rather than averaging each row margin/markup %.

## Findings Summary

<img width="1628" height="906" alt="image" src="https://github.com/user-attachments/assets/c4939521-8510-435b-bda8-32423a29e323" />

<img width="1618" height="917" alt="image" src="https://github.com/user-attachments/assets/420a73d6-67ab-435f-8579-e576b3bf4979" />

<img width="1617" height="918" alt="image" src="https://github.com/user-attachments/assets/aed1e945-0c44-402a-99a2-b982b93351c4" />

<img width="1621" height="920" alt="image" src="https://github.com/user-attachments/assets/0d15e717-c3ab-4439-a736-7b964b81f360" />

1. COGS rising ~5% CAGR uniformly across all products – likely structural (tariffs, contracts, freight), not commodity-specific.
2. COGS steps up every January – same timing across all products, reinforcing structural cause.
3. Prices flat since 2023 while COGS rises --> margin eroded from 56.64% (2023) --> 52.43% (2025).
4. The merchandise category has the lowest profit margin (36.21% as of 2025) while Accessories has the second lowest margin of 42.27%.

### Recommended Price Increases

<img width="1476" height="342" alt="image" src="https://github.com/user-attachments/assets/1d133773-a95c-443d-9cf1-f4bdb302399b" />

### Conclusion

Gradual price revision needed to offset rising COGS and restore margins toward 2023 levels – a steep one-time hike risks attrition given volatile green bean costs.

### Strategy

Value-based pricing • Competitive pricing • Basket & bundle pricing (↑ Average Order Value, simplifies choice, one-stop for cafes/restaurants)

## Credits

-Coffee bag icon used in dashboard by (surang)[<a href="https://www.flaticon.com/free-icons/coffee-bag" title="coffee bag icons">Coffee bag icons created by surang - Flaticon</a>]
-Dataset sourced from Github User (Gaelim)[https://github.com/Gaelim]
