-- data cleaning project
 
 select * 
 from layoffs;
 -- 1 - remove duplicates
 -- 2 - standadize data
 -- 3- no null values
 -- 4 - remove any column 
 
 create table layoffs_staging 
 like layoffs;
 select * 
 from layoffs_staging;
 
 insert into layoffs_staging 
 select * 
 from layoffs;
 
 
  with cte_duplicates as (
   select * ,
 row_number() over(partition by company,location ,industry, total_laid_off,percentage_laid_off,stage,country, `date`,funds_raised_millions) as row_num
 from layoffs_staging
  )
  select *
  from cte_duplicates
  where row_num>1;
   
   create table layoffs_staging2
   (
   company text ,
location text ,
industry text ,
total_laid_off int ,
percentage_laid_off text ,
date text ,
stage text ,
country text ,
funds_raised_millions int,
row_num int
);
select * from layoffs_staging2;

insert into layoffs_staging2
(  select * ,
 row_number() over(partition by company,location ,industry, total_laid_off,percentage_laid_off,stage,country, `date`,funds_raised_millions) as row_num
 from layoffs_staging
  );
  
  delete
  from layoffs_staging2
  where row_num>1;
  
   select *
  from layoffs_staging2
  where row_num>1;
  
 -- standardizing of data
 
 select company , trim( company) from layoffs_staging2;
 
 update layoffs_staging2
 set company = trim(company);  -- all blank spaces are trimmed
 
 select  distinct industry 
 from layoffs_staging2
 order by industry;
  
 
  select  *
 from layoffs_staging2
 where industry like 'crypto%';
 
 
 update layoffs_staging2
 set industry = 'crypto'
where industry like 'crypto%';
 
    select  distinct country
 from layoffs_staging2
 order by 1;
 
  update layoffs_staging2
 set country = trim(trailing '.' from country)
where country like 'united states.';
 
 select `date`
 from layoffs_staging2;
 
  update layoffs_staging2
  set `date` = str_to_date(`date`, '%m/%d/%Y');
  
 select `date`
 from layoffs_staging2;
 
 Alter table layoffs_staging2
 modify column `date` date;
 
 select * 
 from layoffs_staging2
 where total_laid_off is null
 AND percentage_laid_off is null;
  
  select * 
  from layoffs_staging2
  where industry is null
  or industry='';
  
   select * 
  from layoffs_staging2
  where company='airbnb';
   
   update layoffs_staging2
   set industry ='travel'
   where company = 'airbnb';
   
   update layoffs_staging2
   set industry= null
   where industry='';
   
    select *
  from layoffs_staging2 t1
  join layoffs_staging2 t2 
  on t1.company = t2.company
  where (t1.industry is null or t1.industry ='')
  AND (t2.industry is not null or t1.industry !='');
  
  select t1.industry, t2.industry
  from layoffs_staging2 t1
  join layoffs_staging2 t2 
  on t1.company = t2.company
  where (t1.industry is null or t1.industry ='')
  AND (t2.industry is not null or t1.industry !='');
  
  update layoffs_staging2 t1
   join layoffs_staging2 t2 
  on t1.company = t2.company
  set t1.industry = t2.industry
   where t1.industry is null 
  AND t2.industry is not null 
  ;
   select *
   from layoffs_staging2;
   
   select * 
 from layoffs_staging2
 where total_laid_off is null
 AND percentage_laid_off is null;
 
DElete                   -- data is deleted bcz both total laid and percentage are null so these rows are unuseful
 from layoffs_staging2
 where total_laid_off is null
 AND percentage_laid_off is null;
 
 alter table layoffs_staging2         -- we donot need row_num 
 drop column row_num;
 
  select *
   from layoffs_staging2;
   
   
   
 
