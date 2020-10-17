SELECT ra.id_estudiante
, ra.id_plan
, ra.id_sede
, ra.id_ciudad
, ra.id_sexo
, ra.id_cohortes
, ra.cantidad_cursadas
, ra.cantidad_aprobadas
, cur_input.prom AS promedio
FROM rendimiento_academico AS ra
LEFT JOIN 
	(SELECT id_estudiante, AVG(calificacion) as prom
	FROM cursadas_2003_etl
	WHERE condicion LIKE 'P' OR (condicion LIKE 'R' AND calificacion >= 4)
	GROUP BY id_estudiante
	ORDER BY id_estudiante) AS cur_input
ON ra.id_estudiante = cur_input.id_estudiante
