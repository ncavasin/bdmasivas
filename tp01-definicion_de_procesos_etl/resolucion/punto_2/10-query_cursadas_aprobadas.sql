SELECT cursadas_2003_etl.id_estudiante, cant AS cursadas, COUNT(*) as aprobadas
FROM "public".cursadas_2003_etl 
INNER JOIN (
		SELECT cursadas_2003_etl.id_estudiante, COUNT (*) AS  cant
		FROM "public".cursadas_2003_etl
		GROUP BY id_estudiante) AS cursadas
ON cursadas_2003_etl.id_estudiante = cursadas.id_estudiante
WHERE condicion LIKE 'P' OR (condicion LIKE 'R' and calificacion >= 4)
GROUP BY cursadas_2003_etl.id_estudiante, cant
ORDER BY cursadas_2003_etl.id_estudiante ASC