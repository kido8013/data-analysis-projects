# COVID-19 Analysis

# Overview
This project involves analyzing COVID-19 data to understand the impact of the pandemic across different regions and to provide insights into infection rates, death rates, and vaccination rates. The goal is to derive meaningful patterns and trends to better understand the progression of the pandemic and the effectiveness of vaccination campaigns.

## Table of Contents
- [Data Source](#data-source)
- [Data Queries](#data-queries)
- [Visualizations](#visualizations)
- [Analysis](#analysis)
- [Findings](#findings)

## Data Source
The data used in this analysis comes from the COVID-19 dataset provided by Our World in Data, which includes historical data on COVID-19 cases, deaths, and vaccinations.

# Data Queries

## Exploring the Dataset
```
SELECT *
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
ORDER BY 3, 4;
```
```
SELECT *
FROM `shining-lamp-427900-r1.covid_analysis.covid_vaccinations`
ORDER BY 3, 4;
```

## Total Cases vs Total Deaths and Death Percentage
```
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
ORDER BY 1, 2;
Death Percentage in the United States
```

```
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
WHERE location LIKE 'United States'
ORDER BY 1, 2;
```

## Total Cases vs Population in the United States
```
SELECT location, date, Population, total_cases, (total_cases/Population)*100 AS CovidPopulation
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
WHERE location LIKE 'United States'
ORDER BY 1, 2;
```

## Countries with Highest Infection Rate Compared to Population
```
SELECT location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/Population))*100 AS CovidPopulation
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
GROUP BY Location, Population
ORDER BY CovidPopulation DESC;
Countries with Highest Death Count per Population
```

```
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;
Continents with Highest Death Count
```

```
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;
```

## Global Numbers for Total Cases, Total Deaths, and Death Percentage
```
SELECT 
  date, 
  SUM(new_cases) AS total_cases, 
  SUM(CAST(new_deaths AS INT64)) AS total_deaths, 
  SAFE_DIVIDE(SUM(CAST(new_deaths AS INT64)), SUM(new_cases))*100 AS DeathPercentage
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths`
WHERE continent IS NOT NULL
AND total_cases IS NOT NULL
GROUP BY 1
ORDER BY date, total_cases;
Total Population vs Vaccination
```

```
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.Date) AS RollingPopulationVaccinated
FROM `shining-lamp-427900-r1.covid_analysis.covid_deaths` dea
JOIN `shining-lamp-427900-r1.covid_analysis.covid_vaccinations` vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND vac.new_vaccinations IS NOT NULL
ORDER BY 2, 3;
```

## Cumulative Number of Vaccinations Administered Over Time
```
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
```

## Creating a Table for Percent Population Vaccinated
```
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
```

## Creating a View for Percent Population Vaccinated
```
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
```

# Visualizations
Visualizations were created using Tableau to showcase global and regional COVID-19 statistics. The dashboards include total cases, total deaths, infection rates, and vaccination rates, providing a comprehensive view of the pandemic's impact.

For full dashboard access on Tableau, please use the direct link: [COVID-19 Analysis Dashboard.](https://public.tableau.com/views/COVIDdataanalysis_17219813310870/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

# Analysis
The primary objective of this analysis is to understand the spread and impact of COVID-19 across different regions and to evaluate the effectiveness of vaccination campaigns. Key metrics include infection rates, death rates, and vaccination rates, analyzed across various dimensions such as time, location, and population.

# Findings
Key findings from the analysis include:

The United States has a significant percentage of deaths relative to total cases.
Some countries have very high infection rates compared to their populations.
Vaccination campaigns have led to a notable increase in the percentage of vaccinated populations over time.
Recommendations
To mitigate the impact of future pandemics, the following recommendations are made:

Enhanced Data Collection and Reporting: Improve the accuracy and timeliness of data collection to better monitor and respond to outbreaks.
Targeted Vaccination Campaigns: Focus vaccination efforts on regions with high infection rates and low vaccination coverage to maximize impact.
Public Awareness and Education: Increase public awareness about the importance of vaccinations and preventive measures to reduce the spread of infections.
Global Collaboration: Strengthen international collaboration and resource sharing to ensure equitable access to vaccines and medical supplies.
Conclusion
The analysis provides valuable insights into the progression and impact of the COVID-19 pandemic. By implementing the recommended strategies, it is possible to improve pandemic preparedness and response, ultimately reducing the global burden of infectious diseases.

# Source
The datasets for the COVID-19 information were retrieved from Our World in Data.
