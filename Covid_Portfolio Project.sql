Select * 
From [Portfolio Project]..CovidDeaths
order by 3,4

--Select * 
--From [Portfolio Project]..CovidVaccinations
--order by 3,4

--select data that we are going to be used

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
order by 1,2

--Looking at total cases vs Total Deaths

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where location like '%Kenya%'
order by 1,2

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where location like '%Africa%'
and continent is not null
order by 1,2

--Looking at Total Cases Vs Population
--Total population that got covid
Select Location, date, total_cases,Population, (total_cases/population)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where location like '%Africa%'
and continent is not null
order by 1,2

Select Location, date, total_cases,Population, (total_cases/population)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where continent is not null
and location like '%Kenya%'
order by 1,2

--Countries with highest infection rate

Select Location,Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by Location,Population
order by PercentagePopulationInfected desc

--Coutries with the highest death count per population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by Location,Population
order by TotalDeathCount desc

--Break things down by continent

Select Continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Continents with highest death rate per population

Select Continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Global number

Select date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
--Where location like '%Africa%'
Where continent is not null
Group by date
order by 1,2

--Total population vs vacination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
on dea.location=vac.location
and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--use cte

with popvsVac (continent, location, Date, population,New_vaccination, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated

From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3 

)
select *, (RollingPeopleVaccinated/population)*100
from popvsVac

--temp table
DROP Table if exists #PercentagePopulationVaccinated 
Create Table #PercentagePopulationVaccinated

(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccinated

From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3 


select *, (RollingPeopleVaccinated/population)*100
from #PercentagePopulationVaccinated

--creating view to store data for later visualizations

Create View PercentagePopulationVaccinated as 


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
	dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3 