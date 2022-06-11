# JOINING VACINATION AND COVID DEATH TABLE
SELECT *
FROM CovidData.CovidVacinations AS Vacination
JOIN CovidData.CovidDeaths AS Death
  ON Vacination.location = Death.location
  AND Vacination.date = Death.date;

# Looking at total number of people in the world that are vaccinated
Select Death.continent, Death.location,Death.date, Death.population, Vacination.new_vaccinations
FROM CovidData.CovidVacinations AS Vacination
JOIN CovidData.CovidDeaths AS Death
  ON Vacination.location = Death.location
  AND Vacination.date = Death.date
WHERE Death.continent is not NULL
ORDER BY 2,3;

# To use the new vaccinations per day so that the number of vaccinations add up per day
Select Death.continent, Death.location,Death.date, Death.population, Vacination.new_vaccinations, SUM(Vacination.new_vaccinations)OVER(PARTITION BY Death.location ORDER BY Death.location, Death.date) AS total_vaccination 
# partitioning by location so that it only adds up the vaccinations from the same location then we order by location and date so that it sums up the vaccination of a new day to a previous day in a particular location.
--(total_vaccination/population) * 100 # this is meant to find the % of vaccinated people but it won't work because we can't use a newly created table . So we need to create a temp table 
FROM CovidData.CovidVacinations AS Vacination
JOIN CovidData.CovidDeaths AS Death
  ON Vacination.location = Death.location
  AND Vacination.date = Death.date
WHERE Death.continent is not NULL
ORDER BY 2,3;



-- TO CREATE A CTE - common table expression - CONSTRUCT COMPLEX QUERIES IN A MORE READABLE MANNER AND STARTS WITH KEYWORD WITH
WITH VaccinatedPopulation AS(
SELECT Death.continent, Death.location,Death.date, Death.population, Vacination.new_vaccinations, SUM(Vacination.new_vaccinations)OVER(PARTITION BY Death.location ORDER BY Death.location, Death.date) AS total_vaccination 

FROM CovidData.CovidVacinations AS Vacination
JOIN CovidData.CovidDeaths AS Death
  ON Vacination.location = Death.location
  AND Vacination.date = Death.date
WHERE Death.continent is not NULL
)
Select *, (total_vaccination/population ) *100 AS PercentageVaccinated  --to find the  % of people vaccinated
FROM VaccinatedPopulation;


--CREATING VIEWS TO STORE DATA FOR LATER VISUALIZATIONS
--VIEW FOR % OF PEOPLE THAT CONTRACTED COVID
CREATE VIEW CovidData.PercentageContractingCovid AS
SELECT location,date,population, total_cases, (total_cases/population) * 100 AS PopulationPercentage
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL;

--VIEW FOR COUNTRY WITH HIGHEST INFECTION RATE
CREATE VIEW CovidData.HighestInfectionRate AS
SELECT location, population,MAX(total_cases) AS HighestInfectionRate, MAX((total_cases/population)) * 100 AS InfectionPercentage
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
GROUP BY location,population;

--VIEW FOR TOTAL CASES AND DEATHS GLOBALLY
#GLOBAL NUMBERS - total cases and deaths globally per day
CREATE VIEW CovidData.GlobalCasesAndDeaths AS
SELECT date,  SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths) / SUM(new_cases)) * 100 AS GlobalDeathPercentage
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
GROUP BY date;

--VIEW OF COUNTRIES WITH THE HIGHEST DEATH RATE
CREATE VIEW CovidData.HighestDeathRate AS
SELECT location,MAX(total_deaths) AS HighestDeathRate
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
GROUP BY location
ORDER BY HighestDeathRate DESC;


--VIEW FOR VACCINATED PEOPLE
CREATE VIEW CovidData.TotalVaccinatedPopulation AS
SELECT Death.continent, Death.location,Death.date, Death.population, Vacination.new_vaccinations, SUM(Vacination.new_vaccinations)OVER(PARTITION BY Death.location ORDER BY Death.location, Death.date) AS total_vaccination 

FROM CovidData.CovidVacinations AS Vacination
JOIN CovidData.CovidDeaths AS Death
  ON Vacination.location = Death.location
  AND Vacination.date = Death.date
WHERE Death.continent is not NULL;
SELECT *
FROM CovidData.TotalVaccinatedPopulation;
