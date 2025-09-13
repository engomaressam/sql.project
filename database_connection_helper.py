#!/usr/bin/env python3
"""
Chicago Data Analysis - Database Connection Helper
Alternative approach for connecting to MySQL database and executing queries
"""

import mysql.connector
from mysql.connector import Error
import pandas as pd
import sys
import os

class ChicagoDataAnalyzer:
    def __init__(self, host, username, password, database):
        self.host = host
        self.username = username
        self.password = password
        self.database = database
        self.connection = None
        self.cursor = None
    
    def connect(self):
        """Establish connection to MySQL database"""
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                user=self.username,
                password=self.password,
                database=self.database,
                charset='utf8mb4',
                collation='utf8mb4_unicode_ci'
            )
            if self.connection.is_connected():
                self.cursor = self.connection.cursor()
                print(f"Successfully connected to MySQL database '{self.database}'")
                return True
        except Error as e:
            print(f"Error connecting to MySQL: {e}")
            return False
    
    def disconnect(self):
        """Close database connection"""
        if self.cursor:
            self.cursor.close()
        if self.connection and self.connection.is_connected():
            self.connection.close()
            print("MySQL connection closed")
    
    def execute_query(self, query, fetch_results=True):
        """Execute SQL query and return results"""
        try:
            self.cursor.execute(query)
            if fetch_results:
                results = self.cursor.fetchall()
                columns = [desc[0] for desc in self.cursor.description] if self.cursor.description else []
                return results, columns
            else:
                self.connection.commit()
                return True
        except Error as e:
            print(f"Error executing query: {e}")
            return None
    
    def load_sql_file(self, file_path):
        """Load and execute SQL file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                sql_content = file.read()
            
            # Split by semicolon and execute each statement
            statements = [stmt.strip() for stmt in sql_content.split(';') if stmt.strip()]
            
            for statement in statements:
                if statement.upper().startswith(('CREATE', 'INSERT', 'DROP', 'ALTER')):
                    self.execute_query(statement, fetch_results=False)
                    print(f"Executed: {statement[:50]}...")
            
            return True
        except FileNotFoundError:
            print(f"SQL file not found: {file_path}")
            return False
        except Error as e:
            print(f"Error loading SQL file: {e}")
            return False
    
    def run_problem_solutions(self):
        """Execute all problem solutions"""
        problems = {
            "Problem 1": "SELECT COUNT(*) AS total_crimes FROM chicago_crime;",
            "Problem 2": "SELECT * FROM chicago_crime LIMIT 10;",
            "Problem 3": "SELECT COUNT(*) AS crimes_with_arrest FROM chicago_crime WHERE UPPER(ARREST) = 'TRUE';",
            "Problem 4": "SELECT DISTINCT PRIMARY_TYPE FROM chicago_crime WHERE UPPER(LOCATION_DESCRIPTION) LIKE '%GAS STATION%' ORDER BY PRIMARY_TYPE;",
            "Problem 5": "SELECT COMMUNITY_AREA_NAME FROM chicago_socioeconomic_data WHERE UPPER(COMMUNITY_AREA_NAME) LIKE 'B%' ORDER BY COMMUNITY_AREA_NAME;",
            "Problem 6": "SELECT NAME_OF_SCHOOL, `Community_Area_Name`, `Community_Area_Number` FROM chicago_public_schools WHERE `Community_Area_Number` BETWEEN 10 AND 15 AND UPPER(HEALTHY_SCHOOL_CERTIFIED) = 'YES' ORDER BY `Community_Area_Number`, NAME_OF_SCHOOL;",
            "Problem 7": "SELECT AVG(CAST(SAFETY_SCORE AS DECIMAL(3,1))) AS average_safety_score FROM chicago_public_schools WHERE SAFETY_SCORE IS NOT NULL AND SAFETY_SCORE != '' AND SAFETY_SCORE REGEXP '^[0-9]+$';",
            "Problem 8": "SELECT `Community_Area_Number`, `Community_Area_Name`, AVG(CAST(`College_Enrollment` AS UNSIGNED)) AS avg_college_enrollment FROM chicago_public_schools WHERE `College_Enrollment` IS NOT NULL AND `College_Enrollment` != '' AND `College_Enrollment` REGEXP '^[0-9]+$' GROUP BY `Community_Area_Number`, `Community_Area_Name` ORDER BY avg_college_enrollment DESC LIMIT 5;",
            "Problem 9": "SELECT `Community_Area_Number`, `Community_Area_Name`, MIN(CAST(SAFETY_SCORE AS DECIMAL(3,1))) AS min_safety_score FROM chicago_public_schools WHERE SAFETY_SCORE IS NOT NULL AND SAFETY_SCORE != '' AND SAFETY_SCORE REGEXP '^[0-9]+$' AND CAST(SAFETY_SCORE AS DECIMAL(3,1)) = (SELECT MIN(CAST(s.SAFETY_SCORE AS DECIMAL(3,1))) FROM chicago_public_schools s WHERE s.SAFETY_SCORE IS NOT NULL AND s.SAFETY_SCORE != '' AND s.SAFETY_SCORE REGEXP '^[0-9]+$') GROUP BY `Community_Area_Number`, `Community_Area_Name`;",
            "Problem 10": "SELECT PER_CAPITA_INCOME, COMMUNITY_AREA_NAME FROM chicago_socioeconomic_data WHERE COMMUNITY_AREA_NUMBER = (SELECT DISTINCT `Community_Area_Number` FROM chicago_public_schools WHERE CAST(SAFETY_SCORE AS DECIMAL(3,1)) = 1 LIMIT 1);"
        }
        
        results = {}
        for problem_name, query in problems.items():
            print(f"\n{'='*60}")
            print(f"EXECUTING {problem_name}")
            print(f"{'='*60}")
            print(f"Query: {query}")
            print("-" * 60)
            
            result = self.execute_query(query)
            if result:
                results_data, columns = result
                results[problem_name] = results_data
                
                # Display results
                if results_data:
                    if len(results_data) <= 10:  # Show all results for small datasets
                        for row in results_data:
                            print(row)
                    else:  # Show first 10 rows for large datasets
                        print("First 10 rows:")
                        for row in results_data[:10]:
                            print(row)
                        print(f"... and {len(results_data) - 10} more rows")
                else:
                    print("No results returned")
            else:
                print("Query failed to execute")
        
        return results
    
    def check_table_counts(self):
        """Check record counts in all tables"""
        tables = ['chicago_crime', 'chicago_public_schools', 'chicago_socioeconomic_data']
        print("\nTable Record Counts:")
        print("-" * 30)
        
        for table in tables:
            query = f"SELECT COUNT(*) FROM {table};"
            result = self.execute_query(query)
            if result:
                count = result[0][0][0]
                print(f"{table}: {count:,} records")

def main():
    # Database connection parameters (set them in the environment; never hard-code them)
    HOST = os.environ.get("MYSQL_HOST", "localhost")
    USERNAME = os.environ.get("MYSQL_USER", "root")
    PASSWORD = os.environ.get("MYSQL_PASSWORD", "")
    DATABASE = os.environ.get("MYSQL_DATABASE", "Mysql_learners")
    
    # Initialize analyzer
    analyzer = ChicagoDataAnalyzer(HOST, USERNAME, PASSWORD, DATABASE)
    
    try:
        # Connect to database
        if not analyzer.connect():
            print("Failed to connect to database. Exiting.")
            return
        
        # Check if tables exist and get counts
        analyzer.check_table_counts()
        
        # Run problem solutions
        print("\n" + "="*80)
        print("CHICAGO DATA ANALYSIS - PROBLEM SOLUTIONS")
        print("="*80)
        
        results = analyzer.run_problem_solutions()
        
        print("\n" + "="*80)
        print("ANALYSIS COMPLETE")
        print("="*80)
        
    except KeyboardInterrupt:
        print("\nAnalysis interrupted by user")
    except Exception as e:
        print(f"Unexpected error: {e}")
    finally:
        analyzer.disconnect()

if __name__ == "__main__":
    main()
