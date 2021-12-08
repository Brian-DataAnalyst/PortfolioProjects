SELECT * 
FROM PortfolioProject..Covid_Deaths$
WHERE continent is not null
ORDER BY 3,4

--SELECT * 
--FROM PortfolioProject..Covid_Vaccinations$
--ORDER BY 3,4

--SELECT location,date,total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..Covid_Deaths$
--ORDER BY 1,2;

--Looking at total deaths vs total cases
--Shows likelihood of dying if you contract COVID in your country (Using United States as example)


SELECT location,date,total_cases, total_deaths, (total_deaths/total_cases) *100 AS death_percentage
FROM PortfolioProject..Covid_Deaths$
WHERE location like '%states%'
ORDER BY 1,2;

--Looking at Total cases vs population
--Shows percentage of POP got COVID


--SELECT location,date,total_cases, population, (total_cases/population) *100 AS Infection_percentage
--FROM PortfolioProject..Covid_Deaths$
----WHERE location like '%states%'
--ORDER BY 1,2;

--Looking at countries with highest infection_rate compared to population
SELECT location, MAX(total_cases) AS Highest_Infection_Count, population, MAX((total_cases/population)) *100 AS Infection_percentage
FROM PortfolioProject..Covid_Deaths$
--WHERE location like '%states%'
GROUP BY location, population
ORDER BY Infection_percentage DESC

--Looking at countries with highest death_rate compared to population
SELECT location, MAX(cast(total_deaths as int)) AS total_death_count
FROM PortfolioProject..Covid_Deaths$
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count DESC

--Breakdown by continent
SELECT continent, MAX(cast(total_deaths as int)) AS total_death_count
FROM PortfolioProject..Covid_Deaths$
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count DESC

--Showing the continents with the highest death count


--Global Numbers
SELECT date, sum(new_cases) AS total_new_cases, sum(cast(new_deaths as int)) AS total_new_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS Death_Percentage
FROM PortfolioProject..Covid_Deaths$
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2


--Looking at total population vs vaccination
WITH PopsvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
As(




--Currently causing error with overflow converting to data type int...
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_Deaths$ dea
Join PortfolioProject..Covid_Vaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..Covid_Deaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..Covid_Deaths$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..Covid_Deaths$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--Table 4
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..Covid_Deaths$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc



Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

Create View Percent_Population_Vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..Covid_Deaths$ dea
Join PortfolioProject..Covid_Vaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
