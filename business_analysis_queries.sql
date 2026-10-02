USE bank_db;

SELECT * 
FROM bank_churners 
LIMIT 10027;

SELECT COUNT(CLIENTNUM) AS Total_Clients
FROM bank_churners;

-- Which customer segments generate the highest Customer Lifetime Value (CLV)?
SELECT
Card_Category,
Income_Category,
ROUND(AVG(Total_Trans_Amt),2) AS Avg_Transaction_Amount,
ROUND(AVG(Total_Trans_Ct),2) AS Avg_Transaction_Count,
ROUND(AVG(Credit_Limit),2) AS Avg_Credit_Limit
FROM bank_churners
GROUP BY Card_Category, Income_Category
ORDER BY Avg_Transaction_Amount DESC;

-- Which customers are at risk of becoming inactive?
SELECT
    Customer_Status,
    ROUND(AVG(Months_Inactive_12_mon),2) AS Avg_Months_Inactive,
    ROUND(AVG(Contacts_Count_12_mon),2) AS Avg_Contacts,
    ROUND(AVG(Total_Revolving_Bal),2) AS Avg_Revolving_Balance,
    COUNT(*) AS Customer_Count
FROM bank_churners
GROUP BY Customer_Status
ORDER BY Avg_Months_Inactive DESC;

-- Query 1.1 – Average Transaction Amount by Card Category
SELECT
    Card_Category,
    ROUND(AVG(Total_Trans_Amt),2) AS Avg_Transaction_Amount
FROM bank_churners
GROUP BY Card_Category
ORDER BY Avg_Transaction_Amount DESC;

-- Query 1.2 – Average Transaction Amount by Income Category
SELECT
    Income_Category,
    ROUND(AVG(Total_Trans_Amt),2) AS Avg_Transaction_Amount
FROM bank_churners
GROUP BY Income_Category

-- Query 1.3 – Top 10 High-Value Customers
SELECT
    CLIENTNUM,
    Total_Trans_Amt,
    Total_Trans_Ct,
    Credit_Limit
FROM bank_churners
ORDER BY Total_Trans_Amt DESC
LIMIT 10;

-- Query 2.1 – Customers with Highest Inactive Months
SELECT
    CLIENTNUM,
    Months_Inactive_12_mon,
    Attrition_Flag
FROM bank_churners
ORDER BY Months_Inactive_12_mon DESC 
LIMIT 10;

-- Query 2.2 – Churn by Months Inactive
SELECT
    Months_Inactive_12_mon,
    COUNT(*) AS Customers
FROM bank_churners
GROUP BY Months_Inactive_12_mon
ORDER BY Months_Inactive_12_mon;

-- Query 2.3 – Churn by Contacts Count
SELECT
    Contacts_Count_12_mon,
    COUNT(*) AS Customers
FROM bank_churners
GROUP BY Contacts_Count_12_mon
ORDER BY Contacts_Count_12_mon;

-- Query 3.1 – Spending by Age Group
SELECT
    Age_Group,
    ROUND(AVG(Total_Trans_Amt),2) AS Avg_Spending
FROM bank_churners
GROUP BY Age_Group;

-- Query 3.2 – Spending by Gender
SELECT
    Gender,
    ROUND(AVG(Total_Trans_Amt),2) AS Avg_Spending
FROM bank_churners
GROUP BY Gender;

-- Query 3.3 – Spending by Education Level
SELECT
    Education_Level,
    ROUND(AVG(Total_Trans_Amt),2) AS Avg_Spending
FROM bank_churners
GROUP BY Education_Level
ORDER BY Avg_Spending DESC;

-- Query 3.4 – Spending by Card Category
SELECT
    Card_Category,
    ROUND(AVG(Total_Trans_Amt),2) AS Avg_Spending
FROM bank_churners
GROUP BY Card_Category
ORDER BY Avg_Spending DESC;

-- Query 4.1 – Revenue by Card Category
SELECT
    Card_Category,
    SUM(Total_Trans_Amt) AS Revenue
FROM bank_churners
GROUP BY Card_Category
ORDER BY Revenue DESC;
-- Query 4.2 – Revenue by Income Category
SELECT
    Income_Category,
    SUM(Total_Trans_Amt) AS Revenue
FROM bank_churners
GROUP BY Income_Category
ORDER BY Revenue DESC;
-- Query 4.3 – Revenue by Age Group
SELECT
    Age_Group,
    SUM(Total_Trans_Amt) AS Revenue
FROM bank_churners
GROUP BY Age_Group
ORDER BY Revenue DESC;

-- Query 5.1 – Relationship Count
SELECT
    Total_Relationship_Count,
    ROUND(AVG(Total_Trans_Ct),2) AS Avg_Transactions
FROM bank_churners
GROUP BY Total_Relationship_Count
ORDER BY Total_Relationship_Count;

-- Query 5.2 – Utilization Category
SELECT
    Utilization_Category,
    ROUND(AVG(Total_Trans_Amt),2) AS Avg_Spending
FROM bank_churners
GROUP BY Utilization_Category;

-- Query 5.3 – Months on Book
SELECT
    Months_on_book,
    ROUND(AVG(Total_Trans_Ct),2) AS Avg_Transactions
FROM bank_churners
GROUP BY Months_on_book
ORDER BY Months_on_book;

-- Query 5.4 – Active vs Attrited Transactions
SELECT
    Attrition_Flag,
    ROUND(AVG(Total_Trans_Ct),2) AS Avg_Transactions
FROM bank_churners
GROUP BY Attrition_Flag;

-- Query 6.1 – Churn Rate
SELECT
    ROUND(
        SUM(CASE 
            WHEN Attrition_Flag = 'Attrited Customer' THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*),
        2
    ) AS Churn_Rate
FROM bank_churners;

-- Query 6.2 – Active Customers
SELECT
COUNT(*) AS Active_Customers
FROM bank_churners
WHERE Attrition_Flag='Existing Customer';

-- Query 6.3 – Average Transaction Amount
SELECT
ROUND(AVG(Total_Trans_Amt),2) AS Avg_Transaction_Amount
FROM bank_churners;

-- Query 6.4 – Average Credit Limit
SELECT
ROUND(AVG(Credit_Limit),2) AS Avg_Credit_Limit
FROM bank_churners;

# Advance SQL Queries

# Query 1 — Customer Spending Rank
SELECT
    CLIENTNUM,
    Total_Trans_Amt,
    RANK() OVER (
        ORDER BY Total_Trans_Amt DESC
    ) AS Spending_Rank
FROM bank_churners
LIMIT 10;

-- Card Category Revenue Ranking
SELECT
    Card_Category,
    SUM(Total_Trans_Amt) AS Total_Revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(Total_Trans_Amt) DESC
    ) AS Revenue_Rank
FROM bank_churners
GROUP BY Card_Category;

-- Customer Risk Segmentation
WITH Customer_Risk AS (
    SELECT
        CLIENTNUM,
        Months_Inactive_12_mon,
        Total_Trans_Ct,
        Attrition_Flag,
        CASE
            WHEN Months_Inactive_12_mon >= 3
                 AND Total_Trans_Ct < 50
                THEN 'High Risk'
            WHEN Months_Inactive_12_mon >= 2
                THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS Risk_Level
    FROM bank_churners
)
SELECT
    Risk_Level,
    COUNT(*) AS Customer_Count
FROM Customer_Risk
GROUP BY Risk_Level
ORDER BY Customer_Count DESC;

-- Customers Spending Above Average
SELECT
    CLIENTNUM,
    Total_Trans_Amt,
    Total_Trans_Ct
FROM bank_churners
WHERE Total_Trans_Amt > (
    SELECT AVG(Total_Trans_Amt)
    FROM bank_churners
)
ORDER BY Total_Trans_Amt DESC LIMIT 20;

-- Active vs Attrited by Card Category
SELECT
    Card_Category,
    COUNT(*) AS Total_Customers,
    SUM(CASE
        WHEN Attrition_Flag = 'Existing Customer' THEN 1
        ELSE 0
    END) AS Active_Customers,
    SUM(CASE
        WHEN Attrition_Flag = 'Attrited Customer' THEN 1
        ELSE 0
    END) AS Attrited_Customers
FROM bank_churners
GROUP BY Card_Category;

-- Customer Value Segmentation
SELECT
    CLIENTNUM,
    Total_Trans_Amt,
    CASE
        WHEN Total_Trans_Amt >= 5000 THEN 'High Value'
        WHEN Total_Trans_Amt >= 3000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Value
FROM bank_churners
ORDER BY Total_Trans_Amt DESC LIMIT 20;

-- ⭐ One important improvement
SELECT
    Customer_Value,
    COUNT(*) AS Customer_Count,
    ROUND(AVG(Total_Trans_Amt), 2) AS Avg_Transaction_Amount
FROM (
    SELECT
        CLIENTNUM,
        Total_Trans_Amt,
        CASE
            WHEN Total_Trans_Amt >= 5000 THEN 'High Value'
            WHEN Total_Trans_Amt >= 3000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS Customer_Value
    FROM bank_churners
) AS Customer_Segments
GROUP BY Customer_Value
ORDER BY Avg_Transaction_Amount DESC;


# KPI Calculations
-- Churn Rate
SELECT
    ROUND(
        SUM(
            CASE
                WHEN Attrition_Flag = 'Attrited Customer' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Churn_Rate
FROM bank_churners;

-- Retention Rate
SELECT
    ROUND(
        SUM(
            CASE
                WHEN Attrition_Flag = 'Existing Customer' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Retention_Rate
FROM bank_churners;

-- Active Customer Rate
SELECT
    ROUND(
        SUM(
            CASE
                WHEN Attrition_Flag = 'Existing Customer' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Active_Customer_Rate
FROM bank_churners;

-- Average Transaction Amount
SELECT
    ROUND(AVG(Total_Trans_Amt), 2) AS Avg_Transaction_Amount
FROM bank_churners;

-- Average Utilization Ratio
SELECT
    ROUND(AVG(Avg_Utilization_Ratio), 2) AS Avg_Utilization_Ratio
FROM bank_churners;

-- Average Credit Limit
SELECT
    ROUND(AVG(Credit_Limit), 2) AS Avg_Credit_Limit
FROM bank_churners;

-- Total Customer Count
SELECT
    COUNT(*) AS Total_Customers
FROM bank_churners;
 
 -- Customer Lifetime Value Proxy
 SELECT
    CLIENTNUM,
    ROUND(
        Total_Trans_Amt / NULLIF(Months_on_book, 0),
        2
    ) AS Monthly_Value_Proxy
FROM bank_churners
ORDER BY Monthly_Value_Proxy DESC LIMIT 20;

## Customer Segmentation
-- Customer Value Segmentation
SELECT
    Customer_Value,
    COUNT(*) AS Customer_Count
FROM (
    SELECT
        CLIENTNUM,
        Total_Trans_Amt,
        CASE
            WHEN Total_Trans_Amt >= 5000 THEN 'High Value'
            WHEN Total_Trans_Amt >= 3000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS Customer_Value
    FROM bank_churners
) AS Segmented_Customers
GROUP BY Customer_Value
ORDER BY Customer_Count DESC;

-- Churn Risk Segmentation
SELECT
    Risk_Level,
    COUNT(*) AS Customer_Count
FROM (
    SELECT
        CLIENTNUM,
        CASE
            WHEN Months_Inactive_12_mon >= 3
                 AND Total_Trans_Ct < 50
                THEN 'High Risk'
            WHEN Months_Inactive_12_mon >= 2
                THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS Risk_Level
    FROM bank_churners
) AS Customer_Risk
GROUP BY Risk_Level
ORDER BY Customer_Count DESC;

-- Engagement Segmentation
SELECT
    Engagement_Level,
    COUNT(*) AS Customer_Count
FROM (
    SELECT
        CLIENTNUM,
        Total_Trans_Ct,
        Avg_Utilization_Ratio,
        CASE
            WHEN Total_Trans_Ct >= 80
                 AND Avg_Utilization_Ratio >= 0.5
                THEN 'Highly Engaged'
            WHEN Total_Trans_Ct >= 40
                THEN 'Moderately Engaged'
            ELSE 'Low Engagement'
        END AS Engagement_Level
    FROM bank_churners
) AS Customer_Engagement
GROUP BY Engagement_Level
ORDER BY Customer_Count DESC;