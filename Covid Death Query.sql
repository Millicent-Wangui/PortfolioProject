# SELECTING THE DATA WE NEED
SELECT location,date,total_cases, new_cases, total_deaths,population
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
ORDER BY 1,2;

#Likelyhood of dying of covid if you contract the disease worldwide
SELECT location,date,total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
ORDER BY 1,2;

#Looking at total cases vs population - what % of population got covid
SELECT location,date,population, total_cases, (total_cases/population) * 100 AS PopulationPercentage
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
ORDER BY 1,2;

# Looking at countries  highest infection rate compared to population
SELECT location, population,MAX(total_cases) AS HighestInfectionRate, MAX((total_cases/population)) * 100 AS InfectionPercentage
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
GROUP BY location,population
ORDER BY InfectionPercentage DESC;

#showing countries with the highest death count
SELECT location,MAX(total_deaths) AS HighestDeathRate
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
GROUP BY location
ORDER BY HighestDeathRate DESC;

# BREAKING BY CONTINENT INSTEAD OF LOCATION
SELECT continent,MAX(total_deaths) AS HighestDeathRate
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
GROUP BY continent
ORDER BY HighestDeathRate DESC;

#SHOWING THE CONTINENTS WITH THE HIGHEST DEATH COUNTS
SELECT continent, MAX(total_deaths) AS TotalContinentDeaths
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotalContinentDeaths DESC;

#GLOBAL NUMBERS - total cases and deaths globally per day
SELECT date,  SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths) / SUM(new_cases)) * 100 AS GlobalDeathPercentage
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
GROUP BY date
ORDER BY 1,2 ;


#GLOBAL NUMBERS - total cases and deaths globally to date
SELECT   SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths) / SUM(new_cases)) * 100 AS GlobalDeathPercentage
FROM `portfolio-database-352318.CovidData.CovidDeaths`
WHERE continent is not NULL
#GROUP BY date
ORDER BY 1,2 
