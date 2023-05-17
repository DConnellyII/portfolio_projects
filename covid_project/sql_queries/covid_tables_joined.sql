--Join deaths and vaccinations tables
SELECT *
FROM covid_deaths AS cd
JOIN covid_vaccinations AS cv
ON cd.location = cv.location
AND cd.date = cv.date;

--Total Population v. New Vaccinations
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
FROM covid_deaths AS cd
JOIN covid_vaccinations AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3;

--Count Vaccinations as they are added
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vaccinations
FROM covid_deaths AS cd
JOIN covid_vaccinations AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3;

--Use CTE for rolling_vaccinations
WITH pop_v_vac(continent, location, date, population, new_vaccinations, rolling_vaccinations) AS
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vaccinations
FROM covid_deaths AS cd
JOIN covid_vaccinations AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
)
SELECT *, (rolling_vaccinations*1.0/population)*100 AS rolling_vaccinations_percentage
FROM pop_v_vac;

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
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vaccinations
FROM covid_deaths AS cd
JOIN covid_vaccinations AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL;

SELECT *, (rolling_vaccinations*1.0/population)*100 AS rolling_vaccinations_percentage
FROM #PercentPopVaxxed;

--Crating View to store data for Visualizations
DROP TABLE IF EXISTS PercentPopVaxxed;

CREATE VIEW PercentPopVaxxed AS
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_vaccinations
FROM covid_deaths AS cd
JOIN covid_vaccinations AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL;