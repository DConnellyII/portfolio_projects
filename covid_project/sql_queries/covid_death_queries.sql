--Total Cases v. Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths*1.0/total_cases)*100 AS death_percentage
FROM covid_deaths
--WHERE location ilike '%states%'
ORDER BY 1,2;

--Total Cases v. Population
SELECT location, date, population, total_cases, (total_cases*1.0/population)*100 AS population_cases_percentage
FROM covid_deaths
--WHERE location ilike '%states%'
ORDER BY 1,2;

--Highest Cases compared to Population
SELECT location, population, MAX(total_cases) AS highest_cases_count, (total_cases*1.0/population)*100 AS population_cases_percentage
FROM covid_deaths
--WHERE location ilike '%states%'
GROUP BY population, location
ORDER BY 1,2;

--Highest Death Rates compared to Population
SELECT location, MAX(total_deaths) AS total_death_count
FROM covid_deaths
--WHERE location ilike '%states%'
GROUP BY location
ORDER BY total_death_count DESC;

--Highest Death Rates compared by Location
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM covid_deaths
WHERE continent IS NULL AND location NOT LIKE '%income'
GROUP BY location
ORDER BY total_death_count DESC;

--Highest Death Rates compared by Continent
SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

--Global Death Rate Percentage by Day
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases*1.0)*100 AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL AND new_cases >0
GROUP BY date
ORDER BY 1,2;

--Global Death Rate Percentage
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases*1.0)*100 AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL AND new_cases >0
ORDER BY 1,2;