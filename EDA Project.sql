-- Exploratory Data Analysis(EDA)

select *
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select year(`date`),sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select substring(`date`,6,2) as `month`, sum(total_laid_off)
from layoffs_staging2
group by `month`
;

select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
;

-- rolling total
with Rolling_Total as
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off,
sum(total_off) over(order by `month`) as rolling_total
from Rolling_Total;

-- Main EDA Queries
with company_year (company,years,total_laid_off)as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
),
company_year_rank as 
(
select *,
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <= 5
;





