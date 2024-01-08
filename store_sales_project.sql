
--First look at the data
SELECT TOP (10) *
FROM STORE;

--Checking the data types in the columns
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'STORE';

--Changing the data type of sales column to numeric
ALTER TABLE STORE 
ALTER COLUMN SALES FLOAT;

--Calculating the total sum of sales
SELECT ROUND(SUM(SALES),0) AS 'SUM OF SALES'
FROM STORE;

--Calculating the average value of orders
SELECT ROUND(AVG(SALES),1) AS 'AVERAGE VALUE OF ORDERS'
FROM STORE;

--Looking for best 10 sales
SELECT TOP 10 *
FROM STORE
ORDER BY SALES DESC

--Looking for most sold products
SELECT TOP 10 [PRODUCT NAME], COUNT ([PRODUCT NAME]) AS 'Count of product sold'
FROM STORE 
GROUP BY [PRODUCT NAME]
ORDER BY 'Count of product sold' DESC

--Checking the frequency of each type of delivery
SELECT [SHIP MODE],COUNT([SHIP MODE]) AS 'Count of ship mode'
FROM STORE 
GROUP BY [SHIP MODE]
ORDER BY COUNT([SHIP MODE]) DESC

--Counting the number of customers in each segment
SELECT SEGMENT, COUNT(DISTINCT [CUSTOMER ID]) AS 'Number of customers'
FROM STORE 
GROUP BY SEGMENT ORDER BY 'Number of customers' DESC

--Calculating the total sales for each segment
SELECT SEGMENT, SUM(SALES) AS 'Sum of sales'
FROM STORE 
GROUP BY SEGMENT ORDER BY 'Sum of sales'DESC

--Counting the number of products sold in each category ?????????????
SELECT COUNT(*) AS 'Count of products sold', CATEGORY
FROM STORE
GROUP BY CATEGORY 
ORDER BY 'Count of products sold' DESC

--Counting the number of products sold in each category by segment ??????????
SELECT COUNT(*) AS 'Count of products sold', CATEGORY, SEGMENT
FROM STORE
GROUP BY CATEGORY,SEGMENT
ORDER BY SEGMENT, 'Count of products sold' DESC


--Top 20 Products by Total Sales
SELECT TOP 20 SUM(SALES) AS 'Total Sales', [PRODUCT NAME]
FROM STORE 
GROUP BY [PRODUCT NAME]
ORDER BY 'Total Sales' DESC

--Sales by Year and Month
SELECT YEAR([ORDER DATE]) AS 'Year',MONTH([ORDER DATE]) AS 'Month',SUM(SALES) AS 'Sales'
FROM STORE
GROUP BY YEAR([ORDER DATE]), MONTH([ORDER DATE])
ORDER BY 'Year','Month'

--Sales by Region
SELECT REGION, SUM(SALES) AS 'Sales'
FROM STORE 
GROUP BY REGION
ORDER BY 'Sales' DESC

--Yearly Sales and Percentage Change
SELECT YEAR([ORDER DATE]), ROUND(SUM(SALES),0) AS 'SUM SALES',
ROUND(1 - LAG(SUM(SALES),1) OVER (ORDER BY YEAR([ORDER DATE])) / SUM(SALES),2)*100 as 'Percentage change in sales compared to previous year' 
FROM STORE
GROUP BY YEAR([ORDER DATE])

--Customer Lifetime Value
SELECT [CUSTOMER ID], SUM(SALES) AS 'Total Sales', COUNT(DISTINCT [ORDER ID]) AS 'Total Orders',
		SUM(SALES)/COUNT(DISTINCT [ORDER ID]) AS 'Average Order Value'
FROM STORE
GROUP BY [CUSTOMER ID]
ORDER BY 'Total Sales' DESC;

--Customer Retention
WITH CustomerOrders AS (
    SELECT [CUSTOMER ID], YEAR([ORDER DATE]) AS OrderYear, COUNT(DISTINCT [ORDER ID]) AS NumOrders
    FROM STORE
    GROUP BY [CUSTOMER ID], YEAR([ORDER DATE])
),
YearlyCustomer AS (
    SELECT OrderYear, COUNT(DISTINCT [CUSTOMER ID]) AS TotalCustomers
    FROM CustomerOrders
    GROUP BY OrderYear
)
SELECT 
    Currentx.OrderYear, 
    Currentx.TotalCustomers AS CurrentYearCustomers, 
    Previous.TotalCustomers AS PreviousYearCustomers,
    ROUND((CAST(Currentx.TotalCustomers AS FLOAT) / Previous.TotalCustomers) * 100, 2) AS RetentionRate
FROM YearlyCustomer Currentx
LEFT JOIN YearlyCustomer AS Previous ON Currentx.OrderYear = Previous.OrderYear + 1;

--

