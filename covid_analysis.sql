select * from covid_project.coviddeaths c 
where continent is not null
order by 3,4

select * from covid_project.covidvacinnnations c2
order by 3,4

# lets select some useful data

select location, date, total_cases, new_cases, total_deaths, population
from covid_project.coviddeaths c
order by 1,2

#Looking at Total cases vs Total deaths
#shows a likelihood of dying by covid in India

select location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
from covid_project.coviddeaths c
where location = "India" and continent is not null
order by 1,2;


#Looking at total cases vs population
#shows infected population percent based on population

select location, date, population, total_cases, (total_cases / population)*100 as InfectedPopulation
from covid_project.coviddeaths c
where location = "India" and (total_cases / population)*100 is not null 
order by 1,2;

#Looking for 1st case and highest number of cases on a date in india 

select c.location, c.total_cases, c.date
from covid_project.coviddeaths c
where c.location = "india" and c.total_cases = 1


select c.location, c.total_cases, c.date
from covid_project.coviddeaths c
where c.location = "india"
order by c.total_cases desc

#Looking at the countries with Highest Infection Rate compared to Population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases / population))*100 as InfectedPopulation
from covid_project.coviddeaths c
group by location, population
order by InfectedPopulation desc;


#Quering the Highest Death Count Per Population

select location, MAX(total_deaths) as TotalDeathCount
from covid_project.coviddeaths c
where continent is not null
group by location
order by TotalDeathCount desc;



# Showing continents with the highest death count per population 

select continent , MAX(total_deaths) as TotalDeathCount
from covid_project.coviddeaths c
where continent is not null
group by continent
order by TotalDeathCount desc;


# Global Numbers

select date, SUM(new_cases), SUM(new_deaths), SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from covid_project.coviddeaths c
where continent is not null
group by date
order by 1,2;

select SUM(new_cases), SUM(new_deaths), SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
from covid_project.coviddeaths c
where continent is not null
order by 1,2;

#JOINING Tables - Coviddeaths & Covidvaccinations

select *
from covid_project.coviddeaths c
join covid_project.covidvacinnnations v 
on c.location = v.location and c.date = v.date and c.population = v.population 


#Looking at Total Population vs Vaccinations

select c.continent, c.location, c.date, v.population, v.new_vaccinations 
from covid_project.coviddeaths c
join covid_project.covidvacinnnations v 
on c.location = v.location and c.date = v.date 
where c.continent is not null
order by 2,3


#Using "Partition by" Over SUM of new_vaccinations based on location

select c.continent, c.location, c.date, v.population, v.new_vaccinations, SUM(v.new_vaccinations) over (partition by c.location order by c.location, c.date) as TotalPeopleVaccinated
from covid_project.coviddeaths c
join covid_project.covidvacinnnations v 
on c.location = v.location and c.date = v.date 
where c.continent is not null
order by 2,3

#Looking at How Many People Got Vaccinated each day Over Country's Total Population 
#Using CTE

with VacvsPop (Continent, Location, Date, Population, New_vaccinations, TotalPeopleVaccinated)
as
(
select c.continent, c.location, c.date, v.population, v.new_vaccinations, SUM(v.new_vaccinations) over (partition by c.location order by c.location, c.date) as TotalPeopleVaccinated
from covid_project.coviddeaths c
join covid_project.covidvacinnnations v 
on c.location = v.location and c.date = v.date 
where c.continent is not null
order by 2,3
)
select *, (TotalPeopleVaccinated/Population)*100 as PopulationVaccinated
from VacvsPop;

