-- CREATE DATABASE International_debts;

-- USE International_debts;

-- 1.  What are the total number of countries in the list?
SELECT  COUNT( DISTINCT country_name) as 'Total no of countries' FROM international_debt;

-- 1.1 List total number of countries
SELECT DISTINCT  row_number() over() as `Serial no`, country_name
FROM international_debt
GROUP BY country_name
ORDER BY country_name; 

-- 2.  What is the total amount of debt that is owed by the countries listed in the dataset?

SELECT distinct country_name , sum(debt) OVER(partition	by country_name) as `Total debt`
from international_debt
order by `Total debt` DESC;

-- 3. Which country owns the maximum amount of debt and what does that amount look like?

select distinct country_name , sum(debt) as `Total debt`
from international_debt
group by country_name
order by `Total debt` DESC
LIMIT 1;

-- 4. Finding out the distinct debt indicators
SELECT DISTINCT indicator_name, indicator_code 
FROM international_debt;

-- 5. What is the debt of each country in the international_debt table?
select country_name , sum(debt) as 'Total amount' 
from international_debt
group by country_name;

-- 6. Average amount of debt across indicators
SELECT DISTINCT indicator_name,indicator_code, ROUND(AVG(DEBT),2) as 'Average_debt'
FROM international_debt 
GROUP BY indicator_name,indicator_code
ORDER BY 'Average_debt';

-- 7. The highest amount of principal repayments
SELECT * 
FROM international_debt 
WHERE indicator_name like '%principal repayments%'
ORDER BY debt DESC
limit 1;

-- 8. The most common debt indicator
SELECT indicator_name, indicator_count
FROM(
SELECT indicator_name, count(*) as indicator_count, rank() OVER(order by count(*) DESC )as rankinc
FROM international_debt
GROUP BY indicator_name 
) AS ranked
WHERE rankinc = 1;

-- 9. Which country has the lowest debt?
SELECT Country_name
FROM (
SELECT distinct Country_name, sum(debt), rank() over(order by sum(debt)) as rankbydebt
FROM international_debt
GROUP BY country_name) AS ranklow
WHERE rankbydebt = 1  ;

-- 10. What are the indicator names for the international debt of each country?
SELECT DISTINCT country_name, indicator_name,indicator_code, COUNT(*) OVER(PARTITION BY country_name) as Indicators_count
FROM  international_debt;

-- 11.  Which country has the highest debt based on 'Principal repayments on external debt, long-term (AMT, current US$)' indicator?
SELECT country_name,indicator_name,indicator_code,debt1 FROM(
SELECT country_name,indicator_name,indicator_code,debt1,rank() over( order by debt1 DESC) as ranked FROM (
SELECT country_name,indicator_name,indicator_code, MAX(debt) as debt1 
FROM international_debt
GROUP BY country_name,indicator_name,indicator_code)as tag1) as tag
WHERE indicator_code = 'DT.AMT.DLXF.CD'  and ranked = 1 
ORDER BY debt1 DESC ;

-- 12.  Which country has the highest debt based on each specific indicator?
SELECT country_name, T1.indicator_name, indicator_code, T1.debt 
FROM international_debt AS T1
JOIN
(SELECT indicator_name, MAX(debt) AS max_debt
FROM international_debt
GROUP BY indicator_name) AS T2 
ON T1.indicator_name = T2.indicator_name
AND T1.debt = T2.max_debt;

-- 13. How many records are there in the international_debt table?
SELECT COUNT(*) Records FROM international_debt;

-- 14. What are the country names and indicator codes for all records?
SELECT country_name, COUNT(indicator_code) as indicator_codes
FROM International_debt
GROUP BY country_name;

-- 15. How many different indicator names are there in the table?
SELECT COUNT( DISTINCT indicator_name) as 'no_of_Indicator_names' FROM international_debt;

-- 16.  What is the average debt across all countries?
SELECT country_name, AVG(debt) 
FROM international_debt
GROUP BY country_name;

-- 17. How many countries have a debt greater than Average amount?
SELECT COUNT( DISTINCT country_name) AS country_count
FROM international_debt
WHERE debt > (SELECT sum(debt)/count(distinct country_name) FROM international_debt);

--  18. list countries have a debt greater than Average amount
SELECT DISTINCT country_name FROM international_debt
WHERE debt > (SELECT SUM(debt)/count(distinct country_name) FROM international_debt );

-- 19. What is the debt for a specific 'IND' country and 'PPG, commercial banks (DIS, current US$)' indicator?
SELECT * FROM international_debt
WHERE country_code ='IND' AND indicator_name = 'PPG, commercial banks (DIS, current US$)'; 

-- 20. What is the total debt for each indicator across all countries?
SELECT indicator_name,sum(debt) as total_debt
FROM international_debt
GROUP BY indicator_name;
