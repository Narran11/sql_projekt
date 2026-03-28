WITH first_year AS (
	SELECT  
		YEAR AS first_year, 
		tnipspf.product_code , 
		tnipspf.product_name ,
		tnipspf.avg_product_price , 
		tnipspf.price_unit , 
		tnipspf.price_value , 
		avg(tnipspf.average_pay)
	FROM t_narmin_ismiyeva_project_sql_primary_final AS tnipspf 
	WHERE YEAR = '2006'
	AND (tnipspf.product_name LIKE '%Chléb%' OR product_name LIKE '%Mléko%') 
	GROUP BY YEAR, product_code, product_name, avg_product_price, price_unit, price_value  
)
, last_year AS (
	SELECT 
		YEAR AS last_year, 
		tnipspf.product_code , 
		tnipspf.product_name ,
		tnipspf.avg_product_price , 
		tnipspf.price_unit , 
		tnipspf.price_value , 
		avg(tnipspf.average_pay)
	FROM t_narmin_ismiyeva_project_sql_primary_final AS tnipspf 
	WHERE YEAR = '2018'
	AND (tnipspf.product_name LIKE '%Chléb%' OR product_name LIKE '%Mléko%') 
	GROUP BY YEAR, product_code, product_name, avg_product_price, price_unit, price_value  
)
SELECT 
	f.product_name ,
	f.price_unit,
	f.price_value,
CAST(f.avg AS int) / CAST(f.avg_product_price AS int) AS unit_number_2006,
CAST(l.avg AS int)/ CAST(l.avg_product_price AS int) AS unit_number_2018
FROM first_year AS f
JOIN last_year AS l
ON f.product_code = l.product_code  
