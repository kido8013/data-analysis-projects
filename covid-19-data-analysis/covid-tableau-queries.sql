/*

Queries used for Tableau Project

*/
--Global numbers generated to showcase total cases, total deaths, and the global death percentage. 

SELECT
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths as INT64)) AS total_deaths,
    SAFE_DIVIDE(SUM(CAST(new_deaths as INT64)), SUM(new_cases)) * 100 AS DeathPercentage
  FROM
    `shining-lamp-427900-r1.covid_analysis.covid_deaths`
  WHERE continent IS NOT NULL
ORDER BY
  total_cases,
  total_deaths;


-- 2. 

-- Table created to determine total death count per continent
-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT
    location,
    SUM(CAST(new_deaths AS INT64)) AS TotalDeathCount
  FROM
    `shining-lamp-427900-r1.covid_analysis.covid_deaths`
  WHERE continent IS NULL
   AND NOT location IN(
    'World', 'European Union', 'International'
  )
  GROUP BY 1
ORDER BY
  TotalDeathCount DESC;


-- 3.

--This query is designed to analyze COVID-19 infection data by location, calculating the highest infection counts and the percentage of the population infected for each location.

SELECT
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((SAFE_DIVIDE(total_cases, Population))) * 100 AS PercentPopulationInfected
  FROM
    `shining-lamp-427900-r1.covid_analysis.covid_deaths`
  GROUP BY 1, 2
ORDER BY
  PercentPopulationInfected DESC;


-- 4.

--Table created to analyze the percent population infected by location, created like query 3 however organized in a different way for analysis. 

SELECT
    location,
    population,
    date,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((SAFE_DIVIDE(total_cases, Population))) * 100 AS PercentPopulationInfected
  FROM
    `shining-lamp-427900-r1.covid_analysis.covid_deaths`
  GROUP BY 1, 2, 3
ORDER BY
  PercentPopulationInfected DESC;
