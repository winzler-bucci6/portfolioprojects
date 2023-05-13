select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

select *
from PortfolioProject..CovidVaccinations
where continent is not null
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--The total cases vs Population
--shows percentage of population that got covid

select location,date,total_cases,population,(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location = 'Kenya' 
where continent is not null
order by 1,2

--Countries with highest infection rate compared to population

select location,population,max(total_cases)as HighestInfectionCount,max((total_cases/population))*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location='Kenya'
where continent is not null
group by location,population
order by PercentagePopulationInfected desc

--Countries with the highest Death count per Population

select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--Continents with highest Death count
select location,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

select continent,max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers
select date,sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

select sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2


--Total Population vs Vaccination

select dea.continent,dea.location,dea.population,vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

select dea.continent,dea.location,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by vac.location order by dea.location,dea.date) as totalVaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--use CTE

with PopvsVac (continent,location,date,population,new_vaccinations,totalVaccinations)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by vac.location order by dea.location,dea.date) as totalVaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)
select *,(totalVaccinations/population)*100
from PopvsVac

--Temporary table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Total_Vaccinations numeric
)

insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by vac.location order by dea.location,dea.date) as totalVaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null

select *,(Total_Vaccinations/population)*100
from #PercentPopulationVaccinated

--Creating View to store late for visualization

create View PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over(partition by vac.location order by dea.location,dea.date) as totalVaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3


select *
from PercentPopulationVaccinated


