SELECT *
FROM 
(
	SELECT 
		tnipspf.industry_code, 
		tnipspf.industry_name ,
		YEAR,
		average_pay AS pay_current_year,
		LAG(tnipspf.average_pay) OVER (PARTITION BY tnipspf.industry_name ORDER BY year) AS pay_previous_year,
		average_pay - LAG(tnipspf.average_pay) OVER (PARTITION BY tnipspf.industry_name ORDER BY year) AS difference,
		CASE 
			WHEN average_pay - LAG(tnipspf.average_pay) OVER (PARTITION BY tnipspf.industry_name ORDER BY year) > 0 THEN 'increases'
			WHEN average_pay - LAG(tnipspf.average_pay) OVER (PARTITION BY tnipspf.industry_name ORDER BY year) < 0 THEN 'decreases'
			ELSE 'same'
		END AS trend
	FROM t_narmin_ismiyeva_project_sql_primary_final AS tnipspf 
) AS analysis
WHERE analysis.trend = 'decreases'
ORDER BY industry_code ASC, industry_name ASC, YEAR asc