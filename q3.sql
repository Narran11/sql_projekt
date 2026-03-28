WITH first_year AS (
	SELECT 
		YEAR AS first_year, 
		tnipspf.product_code , 
		tnipspf.product_name ,
		tnipspf.avg_product_price , 
		tnipspf.price_unit , 
		tnipspf.price_value 
	FROM t_narmin_ismiyeva_project_sql_primary_final AS tnipspf 
	WHERE YEAR = '2006'
	GROUP BY YEAR, product_code, product_name, avg_product_price, price_unit, price_value  
)
, last_year AS (
	SELECT 
		YEAR AS last_year, 
		tnipspf.product_code , 
		tnipspf.product_name ,
		tnipspf.avg_product_price , 
		tnipspf.price_unit , 
		tnipspf.price_value 
	FROM t_narmin_ismiyeva_project_sql_primary_final AS tnipspf 
	WHERE YEAR = '2018'
	GROUP BY YEAR, product_code, product_name, avg_product_price, price_unit, price_value  
),
yoy_change AS (
	SELECT 
		f.product_code ,
		f.product_name ,
		f.price_unit,
		f.price_value,
		(l.avg_product_price - f.avg_product_price) / l.avg_product_price * 100 AS prc_increase_yoy
	FROM first_year AS f
	JOIN last_year AS l
	ON f.product_code = l.product_code  
	ORDER BY prc_increase_yoy ASC
)
SELECT *
FROM yoy_change 
WHERE prc_increase_yoy > 0
ORDER BY prc_increase_yoy 
LIMIT 1 
