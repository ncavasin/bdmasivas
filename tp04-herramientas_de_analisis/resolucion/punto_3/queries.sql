
--======================================================= 
--1				ESTUDIANTES X SEXO 
--=======================================================

SELECT 
    CASE 
        WHEN g.sexo = 'M' THEN 'Masculinos'
        WHEN g.sexo = 'F' THEN 'Femeninos'
    END
	, COUNT (ra.id_estudiante) AS "Cantidad estudiantes"
FROM rendimiento_academico ra
	INNER JOIN sexos g
	ON g.id_sexo = ra.id_sexo
GROUP BY g.sexo

--======================================================
--2			TOP 10 PEOR PROMEDIO X CARRERA
--======================================================
SELECT 
    p.nombre_carrera AS "Carrera"
	, AVG (ra.promedio) AS "Promedio general"
FROM rendimiento_academico ra
	INNER JOIN planes AS p
	ON p.id_plan = ra.id_plan
GROUP BY p.nombre_carrera
ORDER BY "Promedio general" ASC
LIMIT 10

--======================================================
--3			TOP 10 CIUDADES QUE VAN A LUJAN
--======================================================
SELECT 
    COUNT (ra.id_estudiante) AS "Cantidad"
	, c.nombre_ciudad AS "Ciudad"
FROM rendimiento_academico AS ra
	INNER JOIN ciudades c
	ON  c.id_ciudad = ra.id_ciudad
		INNER JOIN sedes s
		ON s.id_sede = ra.id_sede
WHERE s.sede LIKE 'SEDE LUJAN' AND c.nombre_ciudad NOT LIKE 'LUJAN'
GROUP BY c.nombre_ciudad
ORDER BY "Cantidad" DESC
LIMIT 10

--======================================================
--4			APROBADAS VS CURSADAS X SEDE
--======================================================
SELECT
    s.sede AS "Sede"
	, SUM (ra.cantidad_cursadas) AS "Cursadas" 
	, SUM (ra.cantidad_aprobadas) AS "Aprobadas"
FROM rendimiento_academico AS ra
	INNER JOIN sedes as s
	ON s.id_sede = ra.id_sede
GROUP BY s.sede
ORDER BY "Cursadas" DESC

--======================================================
--5				ESTUDIANTES X CARRERA
--======================================================
SELECT 
    p.nombre_carrera AS "Carrera"
	, COUNT (ra.id_estudiante) AS "Cantidad estudiantes"
FROM rendimiento_academico ra
	INNER JOIN planes p
	ON p.id_plan = ra.id_plan
GROUP BY p.nombre_carrera
ORDER BY p.nombre_carrera
 
