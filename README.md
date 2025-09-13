# Chicago Data Analysis - SQL Data Engineering Project

## Project Overview
This project demonstrates advanced SQL techniques for analyzing Chicago datasets to identify insights for improving education quality and reducing crime. The analysis uses three key datasets:

1. **Chicago Crime Data** - Reported incidents of crime from 2001 to present
2. **Chicago Public Schools** - School performance data for 2011-2012
3. **Chicago Socioeconomic Data** - Socioeconomic indicators by community area (2008-2012)

## Database Setup

### Connection Details
Any MySQL 8 server works (the course used the IBM Skills Network MySQL lab). The Python helper reads its connection from environment variables:

| Variable | Default |
|---|---|
| `MYSQL_HOST` | `localhost` |
| `MYSQL_USER` | `root` |
| `MYSQL_PASSWORD` | *(none: set it)* |
| `MYSQL_DATABASE` | `Mysql_learners` |

### Setup Steps
1. Connect to your MySQL server
2. Create database: `CREATE DATABASE Mysql_learners;`
3. Load the three SQL dump files in this order:
   - `chicago_crime.sql`
   - `chicago_public_schools.sql`
   - `chicago_socioeconomic_data.sql`

## File Structure
```
├── chicago_crime.sql                    # Crime data dump file
├── chicago_public_schools.sql          # Schools data dump file
├── chicago_socioeconomic_data.sql      # Socioeconomic data dump file
├── chicago_data_analysis_solutions.sql # Complete solution queries
├── project.overview.md                 # Project requirements
├── project.instructions.md             # Detailed instructions
└── README.md                          # This file
```

## Problem Solutions

The `chicago_data_analysis_solutions.sql` file contains solutions to all 10 problems:

### Problem 1: Total Crimes
```sql
SELECT COUNT(*) AS total_crimes FROM chicago_crime;
```

### Problem 2: First 10 Crime Records
```sql
SELECT * FROM chicago_crime LIMIT 10;
```

### Problem 3: Crimes with Arrests
```sql
SELECT COUNT(*) AS crimes_with_arrest 
FROM chicago_crime 
WHERE UPPER(ARREST) = 'TRUE';
```

### Problem 4: Crime Types at Gas Stations
```sql
SELECT DISTINCT PRIMARY_TYPE 
FROM chicago_crime 
WHERE UPPER(LOCATION_DESCRIPTION) LIKE '%GAS STATION%';
```

### Problem 5: Community Areas Starting with 'B'
```sql
SELECT COMMUNITY_AREA_NAME 
FROM chicago_socioeconomic_data 
WHERE UPPER(COMMUNITY_AREA_NAME) LIKE 'B%';
```

### Problem 6: Healthy Schools in Areas 10-15
```sql
SELECT NAME_OF_SCHOOL, `Community_Area_Name`, `Community_Area_Number`
FROM chicago_public_schools
WHERE `Community_Area_Number` BETWEEN 10 AND 15
  AND UPPER(HEALTHY_SCHOOL_CERTIFIED) = 'YES';
```

### Problem 7: Average Safety Score
```sql
SELECT AVG(CAST(SAFETY_SCORE AS DECIMAL(3,1))) AS average_safety_score
FROM chicago_public_schools
WHERE SAFETY_SCORE IS NOT NULL AND SAFETY_SCORE != '';
```

### Problem 8: Top 5 Areas by College Enrollment
```sql
SELECT `Community_Area_Number`, `Community_Area_Name`, 
       AVG(CAST(`College_Enrollment` AS UNSIGNED)) AS avg_college_enrollment
FROM chicago_public_schools
WHERE `College_Enrollment` IS NOT NULL AND `College_Enrollment` REGEXP '^[0-9]+$'
GROUP BY `Community_Area_Number`, `Community_Area_Name`
ORDER BY avg_college_enrollment DESC
LIMIT 5;
```

### Problem 9: Community Area with Least Safety Score (Subquery)
```sql
SELECT `Community_Area_Number`, `Community_Area_Name`, 
       MIN(CAST(SAFETY_SCORE AS DECIMAL(3,1))) AS min_safety_score
FROM chicago_public_schools
WHERE SAFETY_SCORE IS NOT NULL 
  AND CAST(SAFETY_SCORE AS DECIMAL(3,1)) = (
    SELECT MIN(CAST(s.SAFETY_SCORE AS DECIMAL(3,1)))
    FROM chicago_public_schools s
    WHERE s.SAFETY_SCORE IS NOT NULL AND s.SAFETY_SCORE REGEXP '^[0-9]+$'
  )
GROUP BY `Community_Area_Number`, `Community_Area_Name`;
```

### Problem 10: Per Capita Income for Safety Score = 1 (No JOIN)
```sql
SELECT PER_CAPITA_INCOME, COMMUNITY_AREA_NAME
FROM chicago_socioeconomic_data
WHERE COMMUNITY_AREA_NUMBER = (
    SELECT DISTINCT `Community_Area_Number`
    FROM chicago_public_schools
    WHERE CAST(SAFETY_SCORE AS DECIMAL(3,1)) = 1
    LIMIT 1
);
```

## Key SQL Techniques Demonstrated

1. **Aggregate Functions**: COUNT, AVG, MIN, MAX
2. **String Functions**: UPPER, LIKE, REGEXP
3. **Data Type Conversion**: CAST operations
4. **Subqueries**: Both scalar and correlated subqueries
5. **Grouping and Ordering**: GROUP BY, ORDER BY, LIMIT
6. **Filtering**: WHERE clauses with multiple conditions
7. **Data Quality**: Handling NULL values and data validation

## Data Quality Considerations

The solutions include data quality checks to handle:
- NULL values in safety scores
- Non-numeric data in numeric fields
- Empty strings vs NULL values
- String formatting variations (case sensitivity)

## Execution Instructions

1. **Setup**: Load all three dump files into the database
2. **Verification**: Run the data quality check queries first
3. **Execution**: Run problems 1-10 in order
4. **Validation**: Use the bonus analysis queries to verify results

## Expected Outcomes

This analysis will provide insights into:
- Crime patterns and arrest rates in Chicago
- School safety and performance metrics
- Socioeconomic factors affecting education
- Community area comparisons for policy decisions

## Technical Skills Demonstrated

- **Database Design**: Understanding of relational data structures
- **SQL Proficiency**: Advanced query writing and optimization
- **Data Analysis**: Statistical analysis and aggregations
- **Problem Solving**: Complex multi-table queries and subqueries
- **Data Quality**: Handling real-world data inconsistencies
- **Documentation**: Clear, commented, and maintainable code
