CREATE TABLE covid_vaccinations (
	iso_code VARCHAR,
	continent VARCHAR,
	location VARCHAR,
	date DATE,
	population NUMERIC,
	total_tests NUMERIC,
	new_tests NUMERIC,
	total_tests_per_thousand FLOAT,
	new_tests_per_thousand FLOAT,
	new_tests_smoothed NUMERIC,
	new_tests_smoothed_per_thousand FLOAT,
	positive_rate FLOAT,
	tests_per_case FLOAT,
	tests_units VARCHAR,
	total_vaccinations NUMERIC,
	people_vaccinated NUMERIC,
	people_fully_vaccinated NUMERIC,
	total_boosters NUMERIC,
	new_vaccinations NUMERIC,
	new_vaccinations_smoothed NUMERIC,
	total_vaccinations_per_hundred FLOAT,
	people_vaccinated_per_hundred FLOAT,
	people_fully_vaccinated_per_hundred FLOAT,
	total_boosters_per_hundred FLOAT,
	new_people_vaccinated_smoothed NUMERIC,
	new_people_vaccinated_smoothed_per_hundred FLOAT,
	stringency_index FLOAT,
	population_density FLOAT,
	median_age FLOAT,
	aged_65_older FLOAT,
	aged_70_older FLOAT,
	gdp_per_capita FLOAT,
	extreme_poverty FLOAT,
	cardiovasc_death_rate FLOAT,
	diabetes_prevalence FLOAT,
	female_smokers FLOAT,
	male_smokers FLOAT,
	handwashing_facilities FLOAT,
	hospital_beds_per_thousand FLOAT,
	life_expectancy FLOAT,
	human_development_index FLOAT,
	excess_mortality_cumulative_absolute FLOAT,
	excess_mortality_cumulative FLOAT,
	excess_mortality FLOAT,
	excess_mortality_cumulative_per_million FLOAT
	);