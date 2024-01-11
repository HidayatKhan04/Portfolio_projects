Select * 
from [Covid Project]..CovidDeaths$
order by 3,4

----Select * 
--from [Covid Project]..CovidVaccinations$
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths,population 
from [Covid Project]..CovidDeaths$
order by 1,2

--Total cases vs total death

Select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from [Covid Project]..CovidDeaths$
order by 1,2


--- Total cases vs Population
Select Location, date, total_cases, new_cases, total_deaths,  (total_cases/population)*100 as Infectedpop_Percentage
from [Covid Project]..CovidDeaths$
---where location like '%India%'
order by 1,2

---highest infection against popultion
Select Location, Max(total_cases) as highest, population,  Max((total_cases/population))*100 as Infectedpop_Percentage
from [Covid Project]..CovidDeaths$
where continent is not null
group by location,population
order by 4 desc

---- higest deaths reported
Select Location, Max(cast(total_deaths as int)) as Deaths, population
from [Covid Project]..CovidDeaths$
where continent is not null
group by location,population
order by 2 desc

Select Location , Max(population)
from [Covid Project]..CovidDeaths$
where continent is not null
group by location
order by 2 desc

-- GLOBAL NUMBERS
-- 1
Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Covid Project]..CovidDeaths$
where continent is not null 
--Group By date
order by 1


Select location, sum(cast(new_deaths as int)) as TotalDeathCount
From [Covid Project]..CovidDeaths$
where continent is null
and location not in ('World' , 'European Union' , 'International')
Group by location
order by TotalDeathCount desc

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid Project]..CovidDeaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [Covid Project]..CovidDeaths$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc





--------------------------------------------------
Select * from [Covid Project]..CovidVaccinations$

Select * from [Covid Project]..CovidDeaths$ dt
join [Covid Project]..CovidVaccinations$ vc
on dt.location=vc.location
and dt.date=vc.date

---- Total population vs vaccination
Select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations
From [Covid Project]..CovidDeaths$ dt
join [Covid Project]..CovidVaccinations$ vc
on dt.location=vc.location
and dt.date=vc.date
where dt.continent is not null
order by 2,3



---- toatal Vaccinated by day  
Select dt.continent, dt.location, dt.date, dt.population, vc.new_vaccinations,
 SUM(Cast(vc.new_vaccinations as int )) OVER (Partition by dt.Location Order by dt.location, dt.Date) as PeopleVaccinated
From [Covid Project]..CovidDeaths$ dt
join [Covid Project]..CovidVaccinations$ vc
on dt.location=vc.location
and dt.date=vc.date
where dt.continent is not null
order by 2,3

