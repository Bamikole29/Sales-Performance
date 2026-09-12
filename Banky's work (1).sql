USE sales_project;
SHOW TABLES;
SELECT * FROM products LIMIT 5;
SELECT * FROM `sales table` LIMIT 5;
SELECT * FROM `sales team` LIMIT 5;
SELECT * FROM `store location` LIMIT 5;

SELECT * FROM products;
SELECT * FROM `sales table`;
SELECT * FROM `sales team`;
SELECT * FROM `store location`;

-- EMPTY CELLS

SELECT COUNT(*)
FROM `sales table`
WHERE `sales Date` IS NULL;

SELECT *
FROM `sales table`
WHERE `Sales Date` IS NULL
   OR `Sales Date` = '';
   
SELECT *
FROM `sales table`
WHERE `unit price` IS NULL
   OR `unit price` = '';
   
   SELECT *
FROM `products`
WHERE `product name` IS NULL
   OR `product name` = '';
 
 SELECT *
FROM `sales table`
WHERE `unit cost` IS NULL
   OR `unit cost` = '';
   
   SELECT *
FROM `sales table`
WHERE `Currency` IS NULL
OR `Currency` = '';
   
   SHOW CREATE TABLE `sales table`;
   
   SET SQL_SAFE_UPDATES = 0;
   
    
  
    
    UPDATE `sales table`
    SET `Currency` = 'USD'
    WHERE `Currency` IS NULL
    OR `Currency` = ' ';
    
   -- COUNTING OF DUPLICATE VALUES
   
   SELECT COUNT(*) AS Duplicate_Count
FROM `sales table`
GROUP BY `sales date`
HAVING COUNT(*) > 1;

 
   


SELECT
    SUM(CASE WHEN `Sales Date` IS NULL THEN 1 ELSE 0 END) AS Missing_Sales_Date,
    SUM(CASE WHEN `Sales Channel` IS NULL THEN 1 ELSE 0 END) AS Missing_Sales_Channel,
    SUM(CASE WHEN Currency IS NULL THEN 1 ELSE 0 END) AS Missing_Currency,
    SUM(CASE WHEN Salesteamindex IS NULL THEN 1 ELSE 0 END) AS Missing_SalesTeam,
    SUM(CASE WHEN Storeindex IS NULL THEN 1 ELSE 0 END) AS Missing_Store,
    SUM(CASE WHEN Productindex IS NULL THEN 1 ELSE 0 END) AS Missing_Product,
    SUM(CASE WHEN `Order qty` IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN `unit price` IS NULL THEN 1 ELSE 0 END) AS Missing_Unit_Price,
    SUM(CASE WHEN `unit cost` IS NULL THEN 1 ELSE 0 END) AS Missing_Unit_Cost
FROM `sales table`;

-- INVALID VALUES

SELECT *
FROM `sales table`
WHERE `Order qty` < 0
OR `unit price` < 0
OR `unit cost` < 0;

-- CHECKING FOR ZERO VALUES

SELECT *
FROM `sales table`
WHERE `Order qty` = 0
OR `unit price` = 0
OR `unit cost` = 0;


SELECT DISTINCT `Sales Channel`
FROM `sales table`; 

-- CHECKING FOR NEGATIVE VALUES

SELECT *
FROM `sales table`
WHERE `Order qty` < 0
OR `unit price` < 0
OR `unit cost` < 0;


-- REVENUE

SELECT *,
(`Order qty` * `unit price`) AS Revenue,
((`Order qty` * `unit price`) -
(`Order qty` * `unit cost`)) AS Profit
FROM `sales table`;

SELECT *
FROM `sales table`
WHERE Currency IS NULL
OR Currency = ' ';

SELECT DISTINCT Currency
FROM `sales table`;

UPDATE `sales table`
SET Currency = 'USD'
WHERE Currency IS NULL;

SELECT DISTINCT Currency
FROM `sales table`;

SELECT Currency, COUNT(*)
FROM `sales table`
GROUP BY Currency;

UPDATE `sales table`
SET Currency = 'USD'
WHERE Currency IS NULL;

UPDATE `sales table`
SET Currency = 'USD'
WHERE Currency IS NULL
OR Currency = '   '
OR Currency = ' '
OR TRIM(Currency) = '  '
OR Currency = 'NULL';

SELECT DISTINCT Currency
FROM `sales table`
GROUP BY Currency;


//* The sales dataset was assessed for missing values
duplicate records, invalid values, and inconsistent categorical entries.
No significant data quality issues were identified except for the blank cell that was identified
and was addressed accordingly. */

/* Addition of Revenue Column*/

ALTER TABLE `sales table`
ADD COLUMN Revenue DOUBLE,
ADD COLUMN Profit DOUBLE;

/* I Populate the Column*/

UPDATE `sales table`
SET Revenue = `Order qty` * `unit price`,
Profit = (`Order qty` * `unit price`) - (`Order qty` * `unit cost`);

/* Verification of the Populated result*/

SELECT
`ï»¿Order Number`,
`Order qty`,
`unit price`,
`unit cost`,
Revenue,
Profit
FROM `sales table`
LIMIT 10;

 /* Correction made to a mispelled heading
in one of the column in sales table */

ALTER TABLE `sales table`
RENAME COLUMN `ï»¿Order Number` TO `Order Number`; 

SHOW TABLES;

/* Creation of Master Dataset
involving the combination of all the columns*/

SELECT
s. `Order Number`,
s. `Sales Date`,
s. `Sales Channel`,
s. Currency,
s. `Order qty`,
s. `unit price`,
s. `unit cost`,
s.Revenue,
s.Profit,
p. `Product Name`,
p. `Product Category`,
st. `Sales Team`,
st. Region,
sl. name AS Store_Name,
sl. state,
sl.population,
sl.households,
sl.median_income
FROM `sales table` s
LEFT JOIN products p
ON s.Salesteamindex = st. `Index`
LEFT JOIN `sales team` st
ON s.Salesteamindex = st. `Index`
LEFT JOIN `store location` sl
ON s.Storeindex = sl.id
LIMIT 10;

SHOW COLUMNS FROM `store location`;

ALTER TABLE `store location`
RENAME COLUMN `ï»¿id` TO `sl.id`; 

SELECT
s. `Order Number`,
s. `Sales Date`,
s. `Sales Channel`,
s. Currency,
s. `Order qty`,
s. `unit price`,
s. `unit cost`,
s.Revenue,
s.Profit,
p. `Product Name`,
p. `Product Category`,
st. `Sales Team`,
st. Region,
sl. name AS Store_Name,
sl. state,
sl.population,
sl.households,
sl.median_income
FROM `sales table` s
LEFT JOIN products p
ON s.Salesteamindex = st. `Index`
LEFT JOIN `sales team` st
ON s.Salesteamindex = st. `Index`
LEFT JOIN `store location` sl
ON s.Storeindex = sl.`sl.id
LIMIT 10;


DESCRIBE products;

DESCRIBE `store location`;

DESCRIBE Storeindex;

DESCRIBE `sales team`;
ALTER TABLE `sales team`
RENAME COLUMN `ï»¿Index` TO `sales Index`;

ALTER TABLE `products`
RENAME COLUMN `Index` TO `product Index`;

DESCRIBE `store location`;
DESCRIBE `sales table`;




CREATE TABLE master_sales AS
SELECT
    s.`Order Number`,
    s.`Sales Date`,
    s.`Sales Channel`,
    s.Currency,
    s.`Order qty`,
    s.`unit price`,
    s.`unit cost`,
    s.Revenue,
    s.Profit,

    p.`Product Name`,
    p.`Product Category`,

    st.`Sales Team`,
    st.Region,

    sl.name AS Store_Name,
    sl.county,
    sl.state_code,
    sl.state,
    sl.type,
    sl.latitude,
    sl.longitude,
    sl.area_code,
    sl.population,
    sl.households,
    sl.median_income,
    sl.land_area,
    sl.water_area,
    sl.time_zone

FROM `sales table` s

LEFT JOIN products p
ON s.Productindex = p.`product Index`

LEFT JOIN `sales team` st
ON s.Salesteamindex = st.`sales Index`

LEFT JOIN `store location` sl
ON s.Storeindex = sl.`sl.id`;

DESCRIBE `sales table`;
DESCRIBE `sales team
DESCRIBE `products`;


/* SOLUTION TO QUESTION 1
THE PRODUCTS THAT GENERATE THE
HIGHEST REVENUE AND PROFITS */

SELECT
`product name`,
SUM(Revenue) AS Total_Revenue,
SUM(Profit) AS Total_Profit
FROM master_sales
GROUP BY `product name`
ORDER BY Total_Revenue DESC;

/* THE PRODUCTS THAT GEENERATE
THE HIGHEST REVENUE AND PROFIT
IS ARE THE CLOCKS */


/* WHICH STORES HAVE THE BEST SALES PERFORMANCE */

SELECT
store_name,
SUM(Revenue) AS Total_Revenue,
SUM(Profit) AS Total_Profit
FROM master_sales
GROUP BY store_name
ORDER BY Total_Revenue DESC;

/* THE STORE WITH THE HIGHEST SALES IS
SPRINGFIELD WITH TOTAL REVENUE OF 
358751.0900000001 AND TOTAL PROFIT OF
102499.92999999998 */

/* WHICH SALES TEAMS OR REGIONS
PERFORM BEST? */

SELECT
`sales team`,
Region,
SUM(Revenue) AS Total_Revenue,
SUM(Profit) AS Total_Profit
FROM master_sales
GROUP BY `sales team`, Region
ORDER BY Total_Revenue DESC;

/* THE BEST SALES TEAM IS THE NICHOLAS
CUNNINGHSM'S TEAM IN THE SOUTH, WITH TOTAL_REVENUE 
OF 1856248.0500000017 AND TOTAL_PROFIT OF 530356.3400000005 */

/* WHAT IS THE CONTRIBUTION OF EACH SALES CHANNEL? */

SELECT
`sales channel`,
SUM(Revenue) AS Total_Revenue,
SUM(Profit) AS Total_Profit
FROM master_sales
GROUP BY `sales channel`
ORDER BY Total_Revenue DESC;

/* THE CONTRIBUTION OF EACH OF THE
SALES CHANNEL ARE DESCRIBED BELOW
Online	11245807.409999972	3213088.819999999
In-Store	11135610.970000042	3181603.6400000094
Distributor	11019157.570000008	3148329.570000005
Wholesale	10964450.020000037	3132699.449999992 */


/* WHICH PRODUCT CATEGORIES ARE OVERPERFORMING
OR UNDERPERFORMING? */

SELECT
`product category`,
SUM(Revenue) AS Total_Revenue,
SUM(Profit) AS Total_Profit
FROM master_sales
GROUP BY `product category`
ORDER BY Total_Revenue DESC;

/* DECORATIVE PRODUCTS ARE OVERPERFORMING
WHILE THE SPORTS ARE THE UNDERPERFORMING PRODUCTS. */

/* WHAT ARE THE REVENUE AND PROFIT ON MONTHLY BASIS */

 SELECT
 YEAR(`sales date`) AS sales_year,
 MONTH(`sales date`) AS sales_month,
 SUM(Revenue) AS Total_Revenue,
 SUM(Profit) AS Total_Profit
 FROM master_sales
 GROUP BY YEAR(`sales date`), MONTH(`sales date`)
 ORDER BY sales_year, sales_month;
 
 /* REVENUE AND PROFIT BY MONTH = 44365025.969999984	12675721.479999842
 RESPECTIVELY */
 
 
 
 ALTER TABLE master_sales
ADD COLUMN Quarter VARCHAR(2);


UPDATE master_sales
SET Quarter =
CASE
    WHEN MONTH(STR_TO_DATE(`Sales Date`, '%m/%d/%Y')) BETWEEN 1 AND 3 THEN 'Q1'
    WHEN MONTH(STR_TO_DATE(`Sales Date`, '%m/%d/%Y')) BETWEEN 4 AND 6 THEN 'Q2'
    WHEN MONTH(STR_TO_DATE(`Sales Date`, '%m/%d/%Y')) BETWEEN 7 AND 9 THEN 'Q3'
    WHEN MONTH(STR_TO_DATE(`Sales Date`, '%m/%d/%Y')) BETWEEN 10 AND 12 THEN 'Q4'
END;


SELECT * FROM master_sales;