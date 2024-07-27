--Look at both tables to determine what the dataset provides for analysis. 

SELECT *
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
ORDER BY 3, 4


SELECT *
FROM `shining-lamp-427900-r1.covid_analysis.covid_vaccinations`
ORDER BY 3, 4


-- Looking at Total Cases vs Total Deaths and percentage of deaths caused by cases

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
ORDER BY 1,2

-- Looking at Death Percentage in United States

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
WHERE location like 'United States'
ORDER BY 1,2

-- Looking at Total Cases vs Population

SELECT location, date, Population, total_cases, (total_cases/Population)*100 AS CovidPopulation
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
WHERE location like 'United States'
ORDER BY 1,2

-- Looking at countries w/ highest infection rate compared to population

SELECT location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 AS CovidPopulation
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
GROUP BY Location, Population
ORDER BY CovidPopulation DESC

-- Showing countries w/ highest death count per population

SELECT location, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC

-- Show continents w/ highest death count
 
SELECT continent, MAX(cast(total_deaths AS INT)) AS TotalDeathCount
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Showing global numbers for total counts
 
SELECT 
  date, 
  SUM(new_cases) as total_cases, 
  SUM(cast(new_deaths AS INT64)) as total_deaths, 
  SAFE_DIVIDE(SUM(cast(new_deaths AS INT64)), SUM(New_cases))*100 AS DeathPercentage
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
WHERE continent IS NOT NULL
AND total_cases IS NOT NULL
GROUP BY 1
ORDER BY date, total_cases

--Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPopulationVaccinated,
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths` dea
JOIN `shining-lamp-427900-r1.covid_analysis.covid_vaccinations` vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations IS NOT NULL
ORDER BY 2, 3

-- Using CTE to display the cumulative number of vaccinations administered over time for each location, along with the percentage of the population that has been vaccinated.

WITH PopulationvsVac AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT64)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPopulationVaccinated
    FROM
        `shining-lamp-427900-r1.covid_analysis.covid_deaths` AS dea
        INNER JOIN `shining-lamp-427900-r1.covid_analysis.covid_vaccinations` AS vac ON dea.location = vac.location
         AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
     AND vac.new_vaccinations IS NOT NULL
)
SELECT
    *,
    (RollingPopulationVaccinated/Population)*100 AS PercentVaccinated
  FROM
    `PopulationvsVac`;

-- Using create table to show identical information to previous query.  
 
CREATE TABLE `shining-lamp-427900-r1.covid_analysis.PercentPopulationVaccinated` AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS INT64)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPopulationVaccinated,
    (SUM(CAST(vac.new_vaccinations AS INT64)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)/dea.population)*100 AS PercentVaccinated
  FROM
    `shining-lamp-427900-r1.covid_analysis.covid_deaths` AS dea
    INNER JOIN `shining-lamp-427900-r1.covid_analysis.covid_vaccinations` AS vac ON dea.location = vac.location
     AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL
   AND vac.new_vaccinations IS NOT NULL;

-- CREATE VIEW

CREATE VIEW shining-lamp-427900-r1.covid_analysis.PercentPopulationVaccinatedView AS
 SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS INT64)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPopulationVaccinated
    FROM
        `shining-lamp-427900-r1.covid_analysis.covid_deaths` AS dea
        INNER JOIN `shining-lamp-427900-r1.covid_analysis.covid_vaccinations` AS vac ON dea.location = vac.location
         AND dea.date = vac.date
  WHERE dea.continent IS NOT NULL;
