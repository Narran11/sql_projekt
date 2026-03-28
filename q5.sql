WITH price_pay_difference AS (
	SELECT 
		YEAR,
		avg(average_pay) AS pay_current_year,
		100* (avg(average_pay) - LAG(avg(tnipspf.average_pay)) OVER (ORDER BY year))/avg(average_pay) AS pay_difference_prct,
		avg(tnipspf.avg_product_price) AS price_current_year,
		100* (avg(tnipspf.avg_product_price) - LAG(avg(tnipspf.avg_product_price)) OVER (ORDER BY year))/avg(tnipspf.avg_product_price) AS price_difference_prct
	FROM t_narmin_ismiyeva_project_sql_primary_final AS tnipspf 
	GROUP BY "year"  
)
, gdp_difference AS (
	SELECT 
		YEAR,
		gdp,
		100* (gdp - LAG(gdp) OVER (ORDER BY year))/gdp AS gdp_difference_prct
	FROM t_narmin_ismiyeva_project_sql_primary_final AS tnipspf 
	GROUP BY "year" , gdp 
)
, final_numbers AS (
SELECT 
	ppd.YEAR AS year, 
	COALESCE(gdpd.gdp_difference_prct, '0') AS gdp_difference_final,
	COALESCE(ppd.pay_difference_prct , '0') AS pay_difference_final,
	COALESCE(ppd.price_difference_prct, '0') AS price_difference_final
FROM price_pay_difference AS ppd
JOIN gdp_difference AS gdpd
ON ppd."year" = gdpd."year" 
) 
SELECT year,
	gdp_difference_final,
	pay_difference_final,
	price_difference_final,
	CASE
		WHEN gdp_difference_final - LAG(gdp_difference_final) OVER (Order BY year) >= 5 THEN 'significant increase'
		WHEN gdp_difference_final - LAG(gdp_difference_final) OVER (Order BY year) >= 2 THEN 'increase'
		WHEN gdp_difference_final - LAG(gdp_difference_final) OVER (Order BY year) > 0 THEN 'minor increase'
		WHEN gdp_difference_final - LAG(gdp_difference_final) OVER (Order BY year) = 0 THEN 'no change'
		WHEN gdp_difference_final - LAG(gdp_difference_final) OVER (Order BY year) >= -2 THEN 'minor decrease'
		WHEN gdp_difference_final - LAG(gdp_difference_final) OVER (Order BY year) >= -5 THEN 'decrease'
		ELSE 'significant decrease'
	END AS GDP_YOY_growth_rate,
	CASE 
		WHEN pay_difference_final - LAG(pay_difference_final) OVER (ORDER BY year) >= 5 THEN 'significant increase' 
		WHEN pay_difference_final - LAG(pay_difference_final) OVER (ORDER BY year) >= 2 THEN 'increase' 
		WHEN pay_difference_final - LAG(pay_difference_final) OVER (ORDER BY year) > 0 THEN 'minor increase' 
		WHEN pay_difference_final - LAG(pay_difference_final) OVER (ORDER BY year) = 0 THEN 'no change'
		WHEN pay_difference_final - LAG(pay_difference_final) OVER (ORDER BY year) >= -2 THEN 'minor decrease'
		WHEN pay_difference_final - LAG(pay_difference_final) OVER (ORDER BY year) >= -5 THEN 'decrease'
		ELSE 'significant decrease'
	END AS PAY_YOY_growth_rate,
	CASE
		WHEN price_difference_final - LAG (price_difference_final) OVER (ORDER BY year) >= 5 THEN 'significant increase'
		WHEN price_difference_final - LAG (price_difference_final) OVER (ORDER BY year) >= 2 THEN 'increase'
		WHEN price_difference_final - LAG (price_difference_final) OVER (ORDER BY year) > 0 THEN 'minor increase'
		WHEN price_difference_final - LAG (price_difference_final) OVER (ORDER BY year) = 0 THEN 'no change'
		WHEN price_difference_final - LAG (price_difference_final) OVER (ORDER BY year) >= -2 THEN 'minor decrease'
		WHEN price_difference_final - LAG (price_difference_final) OVER (ORDER BY year) >= -5 THEN 'decrease'
		ELSE 'significant decrease'
	END AS PRICE_YOY_growth_rate
FROM final_numbers AS fn
ORDER BY "year" 
OFFSET 1 ROWS



	
