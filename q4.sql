WITH prct_difference AS (
	SELECT 
		YEAR,
		avg(average_pay) AS pay_current_year,
		100* (avg(average_pay) - LAG(avg(tnipspf.average_pay)) OVER (ORDER BY year))/avg(average_pay) AS pay_difference_prct,
		avg(tnipspf.avg_product_price) AS price_current_year,
		100* (avg(tnipspf.avg_product_price) - LAG(avg(tnipspf.avg_product_price)) OVER (ORDER BY year))/avg(tnipspf.avg_product_price) AS price_difference_prct
	FROM t_narmin_ismiyeva_project_sql_primary_final AS tnipspf 
	GROUP BY "year"  
)
, price_pay_difference AS (
SELECT
	YEAR, 
	price_difference_prct,
	pay_difference_prct,
	CAST(price_difference_prct AS int) - CAST(pay_difference_prct AS int) AS price_pay_difference_prct
FROM prct_difference
)
SELECT 
	YEAR,
	price_pay_difference_prct,
	CASE 
		WHEN price_pay_difference_prct > 10 THEN 'yes'
		ELSE 'no'
	END AS trend
FROM price_pay_difference

	
