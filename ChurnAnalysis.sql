/* ============================================================
   1. WHICH CUSTOMER DEMOGRAPHICS ARE MOST ASSOCIATED WITH CHURN?
   ============================================================ */

-- Analyze churn rate by gender
SELECT GENDER, 
       SUM(CASE WHEN CHURN = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS CHURN_RATE
FROM TELCOCUSTOMERCHURN
GROUP BY GENDER;
-- Finding: Churn rate is roughly equal across genders, suggesting no strong gender association.

-- Analyze churn rate by senior citizen status
SELECT SENIORCITIZEN,  
       ROUND(SUM(CASE WHEN CHURN = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS CHURN_RATE
FROM TELCOCUSTOMERCHURN
GROUP BY SENIORCITIZEN;
-- Finding: Strong relationship between being a senior citizen and churn likelihood.

-- Analyze churn rate by partner status
SELECT PARTNER, 
       SUM(CASE WHEN CHURN = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS CHURN_RATE
FROM TELCOCUSTOMERCHURN
GROUP BY PARTNER;
-- Finding: Customers without a partner have a higher tendency to churn.


/* ============================================================
   2. IS THERE A CORRELATION BETWEEN TENURE AND CHURN?
   ============================================================ */

SELECT AVG(TENURE) AS AVG_TENURE, CHURN
FROM TELCOCUSTOMERCHURN
GROUP BY CHURN;
-- Finding: Longer tenure is associated with lower churn, but a statistical test (e.g., t-test in Python) is needed for confirmation.


/* ============================================================
   3. DO CERTAIN PAYMENT METHODS HAVE HIGHER CHURN RATES?
   ============================================================ */

-- Count customers by payment method and churn status
SELECT COUNT(PAYMENTMETHOD) AS METHOD_COUNT, PAYMENTMETHOD, CHURN
FROM TELCOCUSTOMERCHURN
GROUP BY PAYMENTMETHOD, CHURN;

-- Calculate percentage churn within each payment method
SELECT PAYMENTMETHOD,
       CHURN,
       COUNT(*) AS COUNT_PER_GROUP,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY PAYMENTMETHOD), 2) AS PERCENTAGE
FROM TELCOCUSTOMERCHURN
GROUP BY PAYMENTMETHOD, CHURN;
-- Finding: Electronic check has the highest churn rate (~45%).

-- Categorize customers as 'long term' or 'short term' based on tenure
SELECT CHURN,
       CASE 
           WHEN TENURE >= 12 THEN 'LONG TERM'
           WHEN TENURE <= 12 THEN 'SHORT TERM'
       END AS PERIOD,
       COUNT(*) AS COUNT_P
FROM TELCOCUSTOMERCHURN
GROUP BY CHURN, PERIOD;


/* ============================================================
   4. WHICH ISSUE TYPES ARE MOST COMMON AMONG CHURNED CUSTOMERS?
   ============================================================ */

SELECT COUNT(S.ISSUETYPE) AS ISSUE_COUNT, ISSUETYPE
FROM SUPPORTTICKETS AS S
JOIN TELCOCUSTOMERCHURN AS C
  ON S.CUSTOMERID = C.CUSTOMERID
WHERE C.CHURN = 'Yes'
GROUP BY S.ISSUETYPE;
-- Finding: Most common issues among churned customers are related to contracts and internet services.


/* ============================================================
   5. DOES RESOLUTION TIME IMPACT CHURN?
   ============================================================ */

SELECT C.CHURN,  
       ROUND(AVG(S.RESOLUTIONTIME), 2) AS AVG_RESOLUTION_TIME, 
       ROUND(MAX(S.RESOLUTIONTIME), 2) AS MAX_RESOLUTION_TIME,
       ROUND(MIN(S.RESOLUTIONTIME), 2) AS MIN_RESOLUTION_TIME
FROM SUPPORTTICKETS AS S
JOIN TELCOCUSTOMERCHURN AS C
  ON S.CUSTOMERID = C.CUSTOMERID 
GROUP BY C.CHURN;
-- Finding: No significant relationship between churn and resolution time.


/* ============================================================
   6. PARETO EFFECT: CHURN RATE FOR TOP 20% CUSTOMERS BY SPENDING
   ============================================================ */

WITH RANKED_CUSTOMERS AS (
    SELECT CUSTOMERID,
           CHURN,
           TOTALCHARGES,
           NTILE(5) OVER (ORDER BY TOTALCHARGES DESC) AS SPENDING_QUARTILE
    FROM TELCOCUSTOMERCHURN
)
SELECT SUM(CASE WHEN CHURN = 'Yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS CHURN_RATE
FROM RANKED_CUSTOMERS
WHERE SPENDING_QUARTILE = 1;
-- Finding: Churn rate for highest-paying customers is ~14%, suggesting they should be a key focus in retention strategies.
