# Global_layoffs_SQL_project
## Introduction:
The global layoff project is aimed to analyze the layoffs happened since 2020 to 2023, globally andit also helps to organize essential information related to layoffs, facilitate decision-making, and ensure compliance with legal and ethical standards.

## Project details:
The purpose of this project is to clean the data in SQL and to perform Exploratory data analysis (EDA) on the cleaned data.The layoff database includes all the information such as company name,industry,location,total percentage of layoffs and date of layoffs which helps us to analyze the data effectively and efficiently.The following steps are used in analysing the dataset.
- Data Collection: Dataset for this project is downloaded from internet.
- Data cleaning:Here data cleaning is divided into 4 steps.
  * Step 1.Since there is no unique id(primary key) for the dataset,we will create our own id using 'row_number()' function in sql which will give a unique id 
  for each row,this helps us to identify duplicate rows and delete those duplicate values.
  * Step 2.To standardize the data,which means removing white spaces ,deleting repeated values,changing the date format of date data type.
  * Step 3.To remove null and blank values.
  * Step 4.To delete rows and columns that are irrelevant for analysis.
- Data Analysis:Perform exploratory data analysis on the cleaned data using joins,ctes,subqueries,aggregate functions and window functions.

## Conclusion:
The Global Layoff project in MySQL is a comprehensive solution for managing employee layoffs on a global scale. By centralizing data, automating processes, ensuring compliance, and providing valuable insights, the project helps organizations navigate challenging workforce transitions with efficiency, transparency, and accountability.  



 
