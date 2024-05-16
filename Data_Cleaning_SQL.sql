/* Data cleaning portfolio project in SQL*/
/* Create a copy of the original raw data to work with */

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;

/* THIS ABOVE PROCEDURE CREATE A COPY OF OUR ORIGINAL DATA.*/

/* Step 1.Let us delete duplicates,we will create row number since this tables doesn't have unique row id*/

SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions) AS unique_row_id
FROM layoffs_staging;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `unique_row_id` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,
`date`,stage,country,funds_raised_millions) AS unique_row_id
FROM layoffs_staging;

/* Delete duplicates rows where unique row number is greater then 1*/
DELETE 
FROM layoffs_staging2
WHERE unique_row_id > 1;

/* Step 2.To standardize the data. */

SELECT * 
FROM layoffs_staging2;

-- Removes white spaces in the company column
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Removes repeated names in the industry column

SELECT DISTINCT industry
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Change the date column to date data format

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y') AS date_new
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= str_to_date(`date`, '%m/%d/%Y');

SELECT * FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN  `date` DATE;


/* Step 3.To handle null and blank values. */

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL;

SELECT *
FROM layoffs_staging2 tb1
JOIN layoffs_staging2 tb2
		ON tb1.industry = tb2.industry AND 
		   tb1.location = tb2.location
WHERE (tb1.industry IS NULL OR tb1.industry = '')
	   AND tb2.industry IS NOT NULL ;

UPDATE layoffs_staging2
SET industry = null 
WHERE industry = '' ;

SELECT * FROM layoffs_staging2 
WHERE company= 'Airbnb'; 

UPDATE layoffs_staging2 tb1
JOIN layoffs_staging2 tb2
		ON tb1.company = tb2.company 
		AND tb1.location = tb2.location 
SET tb1.industry =  tb2.industry     
WHERE (tb1.industry IS NULL)
	    AND tb2.industry IS NOT NULL ;

/* Step 4.Deleting irrelevant rows and columns. */

-- Query to delete the column called unique_row_id
ALTER TABLE layoffs_staging2
DROP COLUMN unique_row_id;
 
 -- Query to delete the rows that are null and are irrelevant to the analysis
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;