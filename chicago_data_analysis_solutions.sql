-- Chicago Data Analysis - SQL Solutions
-- Data Engineering Test Project
-- Database: Mysql_learners
-- Tables: chicago_crime, chicago_public_schools, chicago_socioeconomic_data

-- ========================================
-- DATABASE SETUP INSTRUCTIONS
-- ========================================
-- 1. Connect to your MySQL server (credentials are not stored in this repo)
-- 2. Create database: CREATE DATABASE Mysql_learners;
-- 3. Load the three SQL dump files:
--    - chicago_crime.sql
--    - chicago_public_schools.sql  
--    - chicago_socioeconomic_data.sql

-- ========================================
-- PROBLEM SOLUTIONS
-- ========================================

-- Problem 1: Find the total number of crimes recorded in the CRIME table
-- Expected: Count all records in chicago_crime table
SELECT COUNT(*) AS total_crimes
FROM chicago_crime;

-- Problem 2: Retrieve first 10 rows from the CRIME table
-- Expected: Show first 10 records with all columns
SELECT *
FROM chicago_crime
LIMIT 10;

-- Problem 3: How many crimes involve an arrest?
-- Expected: Count crimes where ARREST = 'true' or 'TRUE'
SELECT COUNT(*) AS crimes_with_arrest
FROM chicago_crime
WHERE UPPER(ARREST) = 'TRUE';

-- Alternative query (in case arrest field has different values):
SELECT COUNT(*) AS crimes_with_arrest
FROM chicago_crime
WHERE ARREST IS NOT NULL 
  AND ARREST != '' 
  AND ARREST != 'false' 
  AND ARREST != 'FALSE';

-- Problem 4: Which unique types of crimes have been recorded at GAS STATION locations?
-- Expected: List distinct PRIMARY_TYPE where LOCATION_DESCRIPTION contains 'GAS STATION'
SELECT DISTINCT PRIMARY_TYPE
FROM chicago_crime
WHERE UPPER(LOCATION_DESCRIPTION) LIKE '%GAS STATION%'
ORDER BY PRIMARY_TYPE;

-- Problem 5: In the CENUS_DATA table list all Community Areas whose names start with the letter 'B'
-- Note: Based on the table structure, this should be chicago_socioeconomic_data table
-- Expected: Show COMMUNITY_AREA_NAME starting with 'B'
SELECT COMMUNITY_AREA_NAME
FROM chicago_socioeconomic_data
WHERE UPPER(COMMUNITY_AREA_NAME) LIKE 'B%'
ORDER BY COMMUNITY_AREA_NAME;

-- Problem 6: Which schools in Community Areas 10 to 15 are healthy school certified?
-- Expected: Show schools where COMMUNITY_AREA_NUMBER between 10-15 and HEALTHY_SCHOOL_CERTIFIED = 'Yes'
SELECT NAME_OF_SCHOOL, `Community_Area_Name`, `Community_Area_Number`
FROM chicago_public_schools
WHERE `Community_Area_Number` BETWEEN 10 AND 15
  AND UPPER(HEALTHY_SCHOOL_CERTIFIED) = 'YES'
ORDER BY `Community_Area_Number`, NAME_OF_SCHOOL;

-- Problem 7: What is the average school Safety Score?
-- Expected: Calculate average of SAFETY_SCORE (convert to numeric if needed)
SELECT AVG(CAST(SAFETY_SCORE AS DECIMAL(3,1))) AS average_safety_score
FROM chicago_public_schools
WHERE SAFETY_SCORE IS NOT NULL 
  AND SAFETY_SCORE != '' 
  AND SAFETY_SCORE != '';

-- Alternative query to handle non-numeric safety scores:
SELECT AVG(CASE 
    WHEN SAFETY_SCORE REGEXP '^[0-9]+$' THEN CAST(SAFETY_SCORE AS DECIMAL(3,1))
    ELSE NULL 
END) AS average_safety_score
FROM chicago_public_schools;

-- Problem 8: List the top 5 Community Areas by average College Enrollment [number of students]
-- Expected: Show top 5 areas by average COLLEGE_ENROLLMENT
SELECT `Community_Area_Number`, `Community_Area_Name`, 
       AVG(CAST(`College_Enrollment` AS UNSIGNED)) AS avg_college_enrollment
FROM chicago_public_schools
WHERE `College_Enrollment` IS NOT NULL 
  AND `College_Enrollment` != '' 
  AND `College_Enrollment` REGEXP '^[0-9]+$'
GROUP BY `Community_Area_Number`, `Community_Area_Name`
ORDER BY avg_college_enrollment DESC
LIMIT 5;

-- Problem 9: Use a sub-query to determine which Community Area has the least value for school Safety Score?
-- Expected: Find the community area with minimum safety score using subquery
SELECT `Community_Area_Number`, `Community_Area_Name`, 
       MIN(CAST(SAFETY_SCORE AS DECIMAL(3,1))) AS min_safety_score
FROM chicago_public_schools
WHERE SAFETY_SCORE IS NOT NULL 
  AND SAFETY_SCORE != '' 
  AND SAFETY_SCORE REGEXP '^[0-9]+$'
  AND CAST(SAFETY_SCORE AS DECIMAL(3,1)) = (
    SELECT MIN(CAST(s.SAFETY_SCORE AS DECIMAL(3,1)))
    FROM chicago_public_schools s
    WHERE s.SAFETY_SCORE IS NOT NULL 
      AND s.SAFETY_SCORE != '' 
      AND s.SAFETY_SCORE REGEXP '^[0-9]+$'
  )
GROUP BY `Community_Area_Number`, `Community_Area_Name`;

-- Problem 10: [Without using an explicit JOIN operator] Find the Per Capita Income of the Community Area which has a school Safety Score of 1
-- Expected: Use subquery to find per capita income where safety score = 1
SELECT PER_CAPITA_INCOME, COMMUNITY_AREA_NAME
FROM chicago_socioeconomic_data
WHERE COMMUNITY_AREA_NUMBER = (
    SELECT DISTINCT `Community_Area_Number`
    FROM chicago_public_schools
    WHERE CAST(SAFETY_SCORE AS DECIMAL(3,1)) = 1
    LIMIT 1
);

-- ========================================
-- ADDITIONAL ANALYSIS QUERIES
-- ========================================

-- Bonus: Verify table structures and data counts
SELECT 'chicago_crime' AS table_name, COUNT(*) AS record_count FROM chicago_crime
UNION ALL
SELECT 'chicago_public_schools' AS table_name, COUNT(*) AS record_count FROM chicago_public_schools
UNION ALL
SELECT 'chicago_socioeconomic_data' AS table_name, COUNT(*) AS record_count FROM chicago_socioeconomic_data;

-- Bonus: Sample data from each table
SELECT 'Sample from chicago_crime:' AS info;
SELECT * FROM chicago_crime LIMIT 3;

SELECT 'Sample from chicago_public_schools:' AS info;
SELECT School_ID, NAME_OF_SCHOOL, `Community_Area_Number`, SAFETY_SCORE FROM chicago_public_schools LIMIT 3;

SELECT 'Sample from chicago_socioeconomic_data:' AS info;
SELECT COMMUNITY_AREA_NUMBER, COMMUNITY_AREA_NAME, PER_CAPITA_INCOME FROM chicago_socioeconomic_data LIMIT 3;

-- ========================================
-- DATA QUALITY CHECKS
-- ========================================

-- Check for null safety scores
SELECT COUNT(*) AS null_safety_scores
FROM chicago_public_schools
WHERE SAFETY_SCORE IS NULL OR SAFETY_SCORE = '';

-- Check for non-numeric safety scores
SELECT SAFETY_SCORE, COUNT(*) AS count
FROM chicago_public_schools
WHERE SAFETY_SCORE IS NOT NULL AND SAFETY_SCORE != ''
GROUP BY SAFETY_SCORE
ORDER BY SAFETY_SCORE;

-- Check community area numbers in schools table
SELECT `Community_Area_Number`, COUNT(*) AS school_count
FROM chicago_public_schools
WHERE `Community_Area_Number` IS NOT NULL
GROUP BY `Community_Area_Number`
ORDER BY CAST(`Community_Area_Number` AS UNSIGNED);

-- ========================================
-- NOTES FOR EXECUTION
-- ========================================
/*
1. Run these queries in the order they appear
2. Some queries may need adjustment based on actual data format
3. The column names with spaces use backticks (`) for proper escaping
4. Safety scores might be stored as strings, hence the CAST operations
5. Community area numbers are compared as strings but ordered numerically
6. Always check data quality before running final queries
*/
