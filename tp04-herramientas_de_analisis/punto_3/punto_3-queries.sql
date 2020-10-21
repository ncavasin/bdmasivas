======================================================
			CANTIDAD X ESPECIALIDADES
======================================================

SELECT 
	e.descripcion AS "Descripcion"
	, COUNT (m.id_medio) AS "Cantidad"
FROM medios AS m
    INNER JOIN especialidades AS e
	ON e.id_especialidad = m.id_especialidad
GROUP BY 1
ORDER BY 1;





 
