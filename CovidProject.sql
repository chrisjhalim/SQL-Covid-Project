Select * from coviddeaths where continent IS NOT NULL order by 3,4;

-- SELECT * from covidvaccinations order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population 
from coviddeaths
order by location, date;

-- The likelihood a person dies if contracted with Covid-19

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as percentage_deaths
from coviddeaths
where location like '%States%'
order by 1,2;

-- Percentage of the US population that got Covid 
Select location, date, population, total_cases,(total_cases/population) * 100 as percentage_covid
from coviddeaths
where location like '%States%'
order by 1,2;

-- Countries with the highest population contracted Covid-19
Select location, population, MAX(total_cases) as max_infection_number, MAX((total_cases/population))*100 as max_infection_rates
from coviddeaths
where total_cases IS NOT NULL and population IS NOT NULL
group by location, population
order by max_infection_rates desc;

-- Countries with the highest Covid-19 deaths  
Select location, MAX(total_deaths) as death_count
from coviddeaths
where total_deaths IS NOT NULL and continent IS NOT NULL
group by location
order by death_count desc;

-- Continents with the highest Covid-19 deaths
Select continent, MAX(total_deaths) as death_count
from coviddeaths
where total_deaths IS NOT NULL and continent IS NOT NULL
group by continent
order by death_count desc;

-- Continents' death count by population
Select continent, MAX(total_deaths) as death_count
from coviddeaths
where total_deaths IS NOT NULL and continent IS NOT NULL
group by continent
order by death_count desc;

-- Global Covid Statistics (as of 7/23)
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases) * 100 as percentage_deaths
from coviddeaths
where continent IS NOT NULL and new_cases IS NOT NULL and new_deaths IS NOT NULL
order by 1,2;

-- CTE
With pop_vs_vac(Continent, location, date, population, new_vaccinations, rolling_vaccinated)
as 
(
-- Vaccinations Data
Select death.continent, death.location, death.date, death.population, vax.new_vaccinations, 
SUM(vax.new_vaccinations) OVER (Partition by death.location Order by death.location, death.date) as rolling_vaccinated
from coviddeaths death join covidvaccinations vax
ON death.location = vax.location AND death.date = vax.date
where death.continent IS NOT NULL
order by 2,3
	)
	
Select *, (rolling_vaccinated/population) * 100
from pop_vs_vac

-- Create View for Data Visualization in Tableau
Create View pop_vs_vac as
Select death.continent, death.location, death.date, death.population, vax.new_vaccinations, 
SUM(vax.new_vaccinations) OVER (Partition by death.location Order by death.location, death.date) as rolling_vaccinated
from coviddeaths death join covidvaccinations vax
ON death.location = vax.location AND death.date = vax.date
where death.continent IS NOT NULL


