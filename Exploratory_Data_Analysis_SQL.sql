/*Exploratory data analysis*/

SELECT * 
FROM layoffs_staging2;

SELECT 
company,
YEAR(`date`) AS date_layoff,
MAX(total_laid_off) AS max_layoffs,
SUM(percentage_laid_off) AS percent_layoffs
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY date_layoff,company
ORDER BY max_layoffs DESC;


SELECT company,
	   SUM(total_laid_off) as total_layoff
FROM layoffs_staging2
GROUP BY company
ORDER BY total_layoff DESC ;


SELECT industry,
	   YEAR(`date`) AS years_layoff,
	   SUM(total_laid_off) as total_layoff
FROM layoffs_staging2
GROUP BY industry ,YEAR(`date`)
ORDER BY total_layoff DESC ;

SELECT 
	   SUBSTRING(`date`,6,2) AS month_layoff,
	   SUM(total_laid_off) as total_layoff
FROM layoffs_staging2
WHERE SUBSTRING(`date`,6,2) IS NOT NULL
GROUP BY SUBSTRING(`date`,6,2)
ORDER BY  month_layoff ASC,total_layoff DESC ;


WITH rolling_total AS
(
SELECT  SUBSTRING(`date`,1,7) AS month_layoff,
SUM(total_laid_off) as total_layoff
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY month_layoff
)
SELECT month_layoff,total_layoff,
SUM(total_layoff) OVER(ORDER BY month_layoff) AS rolling_sm_total
FROM rolling_total;

-- rolling total query
WITH company_year(company,years,total_layoffs) AS
(
SELECT company, YEAR(`date`) as years,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
company_layoff_year_rank AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_layoffs DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_layoff_year_rank
WHERE ranking <= 5
ORDER BY years DESC;


-- rolling total query  
/* WITH company_year(company,years,total_layoffs,company_ranking) AS
(
SELECT company, YEAR(`date`) as years,SUM(total_laid_off) ,
DENSE_RANK() OVER(PARTITION BY YEAR(`date`) ORDER BY SUM(total_laid_off) DESC) AS ranking
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *
FROM company_year
WHERE company_ranking <= 5
ORDER BY years DESC; */

-- query to find which country has the highest layoff from 2020-2023
WITH company_year(country,years,total_percent_layoffs) AS
(
SELECT country, YEAR(`date`) as years, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`), country
),
company_layoff_year_rank AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_percent_layoffs DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_layoff_year_rank
WHERE total_percent_layoffs IS NOT NULL AND
	  ranking <= 5
ORDER BY years DESC,ranking ASC;


/*companies and their rescpective industries that had highest layoff*/
WITH stage_company(company,industry,stage,total_layoff) AS
(SELECT company,
        industry,
		stage,
		SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
GROUP BY stage,company,industry)
SELECT * 
FROM stage_company
WHERE total_layoff IS NOT NULL
ORDER BY total_layoff DESC;


SELECT company,
		stage,
        funds_raised_millions,
		SUM(total_laid_off) AS total_layoff
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY company,funds_raised_millions,stage
ORDER BY total_layoff DESC;
