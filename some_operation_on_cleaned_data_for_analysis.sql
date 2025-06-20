-- 1. View all records from the layoffs_staging2 table
SELECT * 
FROM layoffs_staging2;

-- 2. Find the maximum values of total_laid_off and percentage_laid_off
SELECT MAX(total_laid_off), MAX(percentage_laid_off) 
FROM layoffs_staging2;

-- 3. Find companies that laid off 100% of their workforce, sorted by funds raised
SELECT * 
FROM layoffs_staging2 
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

-- 4. Total layoffs by company, sorted from highest to lowest
SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY company 
ORDER BY 2 DESC;

-- 5. View all layoff data for Amazon
SELECT * 
FROM layoffs_staging2 
WHERE company = 'amazon';

-- 6. Total layoffs by industry, sorted from highest to lowest
SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY industry 
ORDER BY 2 DESC;

-- 7. Find the earliest and latest layoff dates
SELECT MIN(`date`), MAX(`date`) 
FROM layoffs_staging2;

-- 8. Total layoffs by country, sorted from highest to lowest
SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY country 
ORDER BY 2 DESC;

-- 9. Total layoffs per year, sorted from highest to lowest
SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY YEAR(`date`) 
ORDER BY 2 DESC;

-- 10. Monthly layoffs for the year 2022
SELECT MONTH(`date`), SUM(total_laid_off) 
FROM layoffs_staging2 
WHERE YEAR(`date`) = 2022 
GROUP BY MONTH(`date`) 
ORDER BY 1;

-- 11. Total layoffs by funding stage for the year 2023
SELECT stage, SUM(total_laid_off) 
FROM layoffs_staging2 
WHERE YEAR(`date`) = 2023 
GROUP BY stage 
ORDER BY 2 DESC;

-- 12. Total layoffs by month (formatted as YYYY-MM)
SELECT SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) 
FROM layoffs_staging2 
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL 
GROUP BY month 
ORDER BY 1;

-- 13. Rolling total of layoffs by month (cumulative sum)
WITH Rolling_total AS (
    SELECT SUBSTRING(`date`, 1, 7) AS month, SUM(total_laid_off) AS T_L_O
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY month
    ORDER BY 1
)
SELECT month, T_L_O, SUM(T_L_O) OVER (ORDER BY month) AS rolling_total
FROM Rolling_total;

-- 14. Total layoffs by company and year, sorted from highest to lowest
SELECT company, YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY company, YEAR(`date`) 
ORDER BY 3 DESC;

-- 15. Top 5 companies with the most layoffs per year
WITH company_year (company, years, total_laid_off) AS (
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
),
company_year_ranking AS (
    SELECT *, 
           DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS denserank
    FROM company_year
    WHERE years IS NOT NULL
)
SELECT * 
FROM company_year_ranking 
WHERE denserank < 6;
