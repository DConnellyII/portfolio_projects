--Total Cases v. Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths*1.0/total_cases)*100 AS death_percentage
FROM covid_deaths
--WHERE location ILIKE '%states%'
ORDER BY 1,2;

---------------------------------------------------------------------------------------

--Total Cases v. Population
SELECT location, date, population, total_cases, (total_cases*1.0/population)*100 AS population_cases_percentage
FROM covid_deaths
--WHERE location ILIKE '%states%'
ORDER BY 1,2;

---------------------------------------------------------------------------------------

--Highest Cases compared to Population
SELECT location, population, MAX(total_cases) AS highest_cases_count, (total_cases*1.0/population)*100 AS population_cases_percentage
FROM covid_deaths
--WHERE location ILIKE '%states%'
GROUP BY population, location
ORDER BY 1,2;

---------------------------------------------------------------------------------------

--Highest Death Rates compared to Population
SELECT location, MAX(total_deaths) AS total_death_count
FROM covid_deaths
--WHERE location ILIKE '%states%'
GROUP BY location
ORDER BY total_death_count DESC;

---------------------------------------------------------------------------------------

--Highest Death Rates compared by Location
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM covid_deaths
WHERE continent IS NULL AND location NOT ILIKE '%income'
GROUP BY location
ORDER BY total_death_count DESC;

---------------------------------------------------------------------------------------

--Highest Death Rates compared by Continent
SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

---------------------------------------------------------------------------------------

--Global Death Rate Percentage by Day
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases*1.0)*100 AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL AND new_cases >0
GROUP BY date
ORDER BY 1,2;

---------------------------------------------------------------------------------------

--Global Death Rate Percentage
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases*1.0)*100 AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL AND new_cases >0
ORDER BY 1,2;

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------

--Join deaths and vaccinations tables
SELECT *
FROM covid_deaths AS d
JOIN covid_vaccinations AS v
ON d.location = v.location
AND d.date = v.date;

---------------------------------------------------------------------------------------

--Total Population v. New Vaccinations
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
FROM covid_deaths AS d
JOIN covid_vaccinations AS v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 2,3;

---------------------------------------------------------------------------------------

--Count Vaccinations as they are added
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations AS INT)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rolling_vaccinations
FROM covid_deaths AS d
JOIN covid_vaccinations AS v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 2,3;

---------------------------------------------------------------------------------------

--Use CTE for rolling_vaccinations
WITH pop_v_vac(continent, location, date, population, new_vaccinations, rolling_vaccinations) AS
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations AS INT)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rolling_vaccinations
FROM covid_deaths AS d
JOIN covid_vaccinations AS v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL
)
SELECT *, (rolling_vaccinations*1.0/population)*100 AS rolling_vaccinations_percentage
FROM pop_v_vac;

---------------------------------------------------------------------------------------

--Use Temp Table for rolling_vaccinations
DROP TABLE IF EXISTS PercentPopVaxxed;

CREATE TABLE #PercentPopVaxxed
(
continent VARCHAR,
location VARCHAR,
date DATE,
population, NUMERIC,
new_vaccinations NUMERIC
rolling_vaccinations NUMERIC,
);

INSERT INTO #PercentPopVaxxed
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations AS INT)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rolling_vaccinations
FROM covid_deaths AS d
JOIN covid_vaccinations AS v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL;

SELECT *, (rolling_vaccinations*1.0/population)*100 AS rolling_vaccinations_percentage
FROM #PercentPopVaxxed;

---------------------------------------------------------------------------------------

--Crating View to store data for Visualizations
DROP TABLE IF EXISTS PercentPopVaxxed;

CREATE VIEW PercentPopVaxxed AS
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM(CAST(v.new_vaccinations AS INT)) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rolling_vaccinations
FROM covid_deaths AS d
JOIN covid_vaccinations AS v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL;