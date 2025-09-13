Review and familiarize yourself with the datasets
To complete the assignment problems you will be using three datasets that are available on the city of Chicago's Data Portal:

Socioeconomic Indicators in Chicago

Chicago Public Schools

Chicago Crime Data

1. Socioeconomic Indicators in Chicago
This dataset contains a selection of six socioeconomic indicators of public health significance and a "hardship index," for each Chicago community area, for the years 2008 – 2012.

A detailed description of this dataset and the original dataset can be obtained from the Chicago Data Portal at:

https://data.cityofchicago.org/Health-Human-Services/Census-Data-Selected-socioeconomic-indicators-in-C/kn9c-c2s2

2. Chicago Public Schools
This dataset shows all school level performance data used to create CPS School Report Cards for the 2011-2012 school year.

A detailed description of this dataset and the original dataset can be obtained from the Chicago Data Portal at:

https://data.cityofchicago.org/Education/Chicago-Public-Schools-Progress-Report-Cards-2011-/9xs2-f89t

3. Chicago Crime Data
This dataset reflects reported incidents of crime (with the exception of murders where data exists for each victim) that occurred in the City of Chicago from 2001 to present, minus the most recent seven days.

A detailed description of this dataset and the original dataset can be obtained from the Chicago Data Portal at:

https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2

This dataset is quite large - over 1.5GB in size with over 6.5 million rows. For the purposes of this assignment we will use a much smaller subset of this dataset.

Database Used in this Lab
Mysql_learners database has been used in this lab.

Here you will be creating and inserting data into the below mentioned 3 tables

1.chicago_public_schools
2.chicago_socioeconomic_data
3.chicago_crime

Here you will be using 3 dump files for this purpose.

chicago_public_schools

chicago_crime

chicago_socioeconomic_data

Create a database
Click on Skills Network Toolbox. In Database section, click MySQL.
To start the MySQL click Start.

image


Once MySQL has started, click on phpMyAdmin button to open phpMyAdmin in the same window.
image


You will see the phpMyAdmin GUI tool.
image


In the tree-view, click New to create a new empty database. Then enter Mysql_Learners as the name of the database and click Create.

The encoding will be left as utf8mb4_0900_ai_ci. UTF-8 is the most commonly used character encoding for content or data.

image

Load the dump files one by one into the database Mysql_learners by clicking the Import tab and choose the file. Click on Go button.

image

image

The tables are created and the data is loaded successfully. Repeat the same operation with the other 2 dump files to create and load the tables.

You will see a screen as below

image

Problems
Now write and execute SQL queries to solve assignment problems


Problem 1
Find the total number of crimes recorded in the CRIME table.


Problem 2
Retrieve first 10 rows from the CRIME table.


Problem 3
How many crimes involve an arrest?


Problem 4
Which unique types of crimes have been recorded at GAS STATION locations?

Click here for a hint

Problem 5
In the CENUS_DATA table list all Community Areas whose names start with the letter 'B'.


Problem 6
Which schools in Community Areas 10 to 15 are healthy school certified?


Problem 7
What is the average school Safety Score?


Problem 8
List the top 5 Community Areas by average College Enrollment [number of students]


Problem 9
Use a sub-query to determine which Community Area has the least value for school Safety Score?


Problem 10
[Without using an explicit JOIN operator] Find the Per Capita Income of the Community Area which has a school Safety Score of 1.
