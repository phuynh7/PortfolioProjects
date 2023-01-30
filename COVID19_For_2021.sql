/*
Covid 19 Data Exploration with the Data of 2021

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations 	
--order by 3,4
	
select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths	
order by 1,2

--Looking at Total cases vs Total Deaths (based in 2021)

select Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths	
--where location like '%states%'
order by 1,2

select continent, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths	
where continent is not null
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage got Covid
select Location, date,population, total_cases, (total_cases/population) * 100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths	
where location like '%states%'
order by 1,2

--Looking at Coutries with Highest infection rate compared to Population
select Location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population)) * 100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths	
group by Location, Population
order by PercentPopulationInfected desc

--Show countries with highest death count per population
select Location, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths	
where continent is not null
group by Location
order by TotalDeathCount desc

-- Show Continent with highest death count
select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths	
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global numbers
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths	
--where location like '%states%'
where continent is not null
group by date
order by 1,2

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths	
--where location like '%states%'
where continent is not null
order by 1,2

-- Looking at total Pop vs Vaccations (People Vaccinated = each new vaccine will be added up)

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population) * 100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null	
order by 2,3

-- USE CTE

With PopvsVac (continet, location, date, population, New_Vaccinations, PeopleVaccinated)
as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population) * 100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null	
--order by 2,3
)
Select *, (PeopleVaccinated/population) * 100
from PopvsVac

--Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population) * 100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null	
--order by 2,3
Select *, (PeopleVaccinated/population) * 100
from #PercentPopulationVaccinated


-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population) * 100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date	
where dea.continent is not null	

Select * from
PercentPopulationVaccinated

Create View HighestDeathCount as 
select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths	
where continent is not null
group by continent
--order by TotalDeathCount desc

Create View ContientCasevsDeath as 
select continent, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths	
where continent is not null
--order by 1,2
