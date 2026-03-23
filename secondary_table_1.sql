CREATE TABLE t_narmin_ismiyeva_project_sql_secondary_final AS
SELECT e.year , e.country , e.gdp , e.gini, e.population
FROM economies AS e
JOIN countries AS c 
ON e.country = c.country 
WHERE c.continent = 'Europe'
AND e."year" > 2005
AND e."year" < 2019 --stejne obdobi jako prvni tabulka--
ORDER BY country ASC, year