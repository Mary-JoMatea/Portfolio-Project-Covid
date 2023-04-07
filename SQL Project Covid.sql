/*Covid-19 data exploration*/
/*Data from Jan 1st, 2020 to Apr 5th, 2023*/

/*Select * from coviddeaths;
select * from covidvaccinations;*/

select 
	location
	,date
	,total_cases
	,new_cases
	,total_deaths
	,population 
from coviddeaths
where continent is not null
order by 1,2;

/*Total cases vs Total deaths*/

select 
	location
	,date
	,total_cases
	,total_deaths
	,(total_deaths/total_cases)*100 as death_percentage
from coviddeaths
where continent is not null
--where location ilike 'South Africa'
order by 1,2;

/*Total cases vs Population*/

select 
	location
	,date
	,total_cases
	,population
	,(total_cases/population)*100 as infected_population_percentage
from coviddeaths
where continent is not null
--where location ilike 'South Africa'
order by 1,2;

/*Countries with highest infection rate vs population*/

select 
	location
	,population
	,max(total_cases) as highest_infection_count
	,max(total_cases/population)*100 as infected_population_percentage
from coviddeaths
where continent is not null
--where location ilike 'South Africa'
group by location, population
order by infected_population_percentage desc;

/*Countries with highest death count per population*/

select 
	location
	,max(total_deaths) as highest_death_count
from coviddeaths
where continent is not null
--where location ilike 'South Africa'
group by location
order by highest_death_count desc;

/*Continent*/

select 
	location
	,case when location ilike '%income'
			and location not ilike '%World%' 
		then 'not continent'
		  when location ilike '%world%' then 'world'
	else 'continent'
end as location_type
	,max(total_deaths) as total_death_count
from coviddeaths
where continent is null
--where location ilike 'South Africa'
group by location,
case when location ilike '%income'
			and location not ilike '%World%' 
		then 'not continent'
		  when location ilike '%world%' then 'world'
	else 'continent'
end 
order by total_death_count desc;

/* Global numbers*/

select 
	 sum(new_cases) as total_cases
	,sum(new_deaths) as total_deaths
	,sum(new_deaths)/sum(new_cases)*100 as death_percentage
from coviddeaths
where continent is not null;

/*Join Covid Deaths to Covid Vaccinations*/

select * 
from coviddeaths d
		join 
	covidvaccinations v
		on 
	d.location = v.location
and d.date = v.date;


select d.continent
	  ,d.location
	  ,d.date
	  ,d.population
	  ,v.new_vaccinations
from coviddeaths d
		join 
	covidvaccinations v
		on 
	d.location = v.location
and d.date = v.date
where d.continent is not null
order by 1,2,3;

/*Create Views*/

Create view total_death_count as select 
	location
	,case when location ilike '%income'
			and location not ilike '%World%' 
		then 'not continent'
		  when location ilike '%world%' then 'world'
	else 'continent'
end as location_type
	,max(total_deaths) as total_death_count
from coviddeaths
where continent is null
--where location ilike 'South Africa'
group by location,
case when location ilike '%income'
			and location not ilike '%World%' 
		then 'not continent'
		  when location ilike '%world%' then 'world'
	else 'continent'
end 
order by total_death_count desc;


create view infected_population_percentage as select 
	location
	,population
	,max(total_cases) as highest_infection_count
	,max(total_cases/population)*100 as infected_population_percentage
from coviddeaths
where continent is not null
--where location ilike 'South Africa'
group by location, population
order by infected_population_percentage desc;


create view death_percentage_by_date as select 
	location
	,date
	,total_cases
	,total_deaths
	,(total_deaths/total_cases)*100 as death_percentage
from coviddeaths
where continent is not null
--where location ilike 'South Africa'
order by 1,2;