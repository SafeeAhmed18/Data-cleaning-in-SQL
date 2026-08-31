-- Data Cleaning 

 select * from layoffs; 
 
 -- 1. remove duplicates
 -- 2. Standardize the data
 -- 3. Null values and blank values if it is possible
 -- 4. Remove Any new Columns
 
-- create new table

 create table layoffs_staging
 like layoffs;
 
 insert layoffs_staging
 select *
 from layoffs;
 
select * from layoffs_staging;

-- stage 1 -> delete duplicates 

-- Use windows function for add a new column row_num for find a duplicates
select *,
row_number() over(partition by company, location, industry,
total_laid_off, percentage_laid_off,`date`,
stage, country, funds_raised_millions) as row_num
from layoffs_staging  ;

-- create CTE for find duplicates
with duplicates_cte as
(
select *,
row_number() over(partition by company, location, industry,
total_laid_off, percentage_laid_off,`date`,
stage, country, funds_raised_millions) as row_num
from layoffs_staging  
) 
select *
from duplicates_cte
where row_num  > 1; 

-- create new table for new colum(row_num)
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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
insert into layoffs_staging2
select *,
row_number() over(partition by company, location, industry,
total_laid_off, percentage_laid_off,`date`,
stage, country, funds_raised_millions) as row_num
from layoffs_staging ;

-- delete duplicate here
delete 
from layoffs_staging2
where row_num > 1; 

select *
from layoffs_staging2;
 
-- stage2 -> standardizing data
 
select company, trim(company)
from layoffs_staging2;

-- update the company allignment
update layoffs_staging2
set company = trim(company);

select distinct(industry)
from layoffs_staging2
order by 1;

-- update the same industry if they have different name
select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct industry
from layoffs_staging2
order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%'; -- united States. => united States

-- Change the date format from text to date format.
update layoffs_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y');

select `date`
from layoffs_staging2;

-- change the date format in table 
alter table layoffs_staging2
modify column `date` date;

-- stage3 -> Remove Null values and blank values

-- remove the null and blank space in industry column
select *
from layoffs_staging2 where industry is null
;

-- change the blank space to null values
update layoffs_staging2
set industry = null
where industry = '';

select *
from layoffs_staging2;

-- check the null values in table
select *
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company 
where t1.industry is null
and t2.industry is not null
;
-- update the null values to industry name
update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company 
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

-- remove the null values in total_laid_off and percentage_laid_off
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- stage4 -> Remove any new columns 
alter table layoffs_staging2
drop column row_num;

select * 
from layoffs_staging2;




























































































































































































































 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 