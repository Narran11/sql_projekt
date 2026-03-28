WITH product_prices AS (
	SELECT 
		date_part('year', date_from) AS category_year, 
		category_code AS code, 
		AVG(value) AS value_average 
	FROM czechia_price
	GROUP BY category_code,  category_year
	ORDER BY category_year ASC
)
, payroll_info AS (
	SELECT 
		cp.payroll_year, 
		AVG(cp.value) AS average_pay, 
		cp.industry_branch_code AS code, cpib."name" 
	FROM czechia_payroll AS cp 
	JOIN czechia_payroll_industry_branch AS cpib 
		ON cp.industry_branch_code = cpib.code 
	WHERE cp.value_type_code = '5958'
	AND cp.unit_code = '200'
	AND cp.calculation_code = '200'
	GROUP BY cp.payroll_year , cp.industry_branch_code, cpib."name" 
	ORDER BY cp.payroll_year ASC
)
, gdp_info AS (
	SELECT e."year" , e.gdp 
	FROM economies AS e 
	WHERE e.country = 'Czech Republic'
	ORDER BY e."year" ASC
)
, aggregated_info AS (
SELECT pp.category_year AS year, 
		pp.code AS product_code, 
		cpc."name" AS product_name, 
		pp.value_average AS avg_product_price, 
		cpc.price_unit, 
		cpc.price_value,
		pi.code AS industry_code,
		pi."name" AS industry_name ,
		pi.average_pay,
		gi.gdp 
	FROM product_prices AS pp
	JOIN czechia_price_category AS cpc 
		ON pp.code = cpc.code
	JOIN payroll_info AS pi
		ON pp.category_year = pi.payroll_year 
	JOIN gdp_info AS gi 
		ON pp.category_year = gi."year" 
	ORDER BY pp.category_year ASC
)
SELECT *
INTO t_narmin_ismiyeva_project_sql_primary_final
FROM aggregated_info

