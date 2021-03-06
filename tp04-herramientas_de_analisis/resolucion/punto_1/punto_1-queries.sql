
--************************************ PUNTO 1A **********************************

--=============================================
--QUERY DE RECONOCIMIENTO
--=============================================
SELECT m.nombre AS "Nombre"
	, t.descripcion AS "Tipo de medio"
	, e.descripcion AS "Especialidad"
	, m.direccion AS "Direccion"
	, c.nombre AS "Ciudad"
	, p.nombre AS "Provincia"
FROM medios AS m
	INNER JOIN ciudades AS c
	ON c.id_ciudad = m.id_ciudad
		INNER JOIN provincias AS p
		ON p.id_provincia = c.id_provincia
			INNER JOIN especialidades AS e
			ON m.id_especialidad = e.id_especialidad
				INNER JOIN tipos_medio AS t
				ON t.id_tipo = m.id_tipo_medio
WHERE 
	t.descripcion LIKE '_iario'
	OR t.descripcion LIKE '_u_a'
	OR t.descripcion LIKE '_er%dico%' 
	OR t.descripcion LIKE '_evista'
	OR t.descripcion LIKE '_emanal'
	OR t.descripcion LIKE '_uplementos'
ORDER BY m.nombre ASC

--=============================================
--QUERY CON NORMALIZACION PARA REPORTE
--=============================================
SELECT 
	CASE 
			WHEN t.descripcion LIKE '_er%dico' THEN 'Periódico'
			WHEN t.descripcion LIKE '%emanal%' THEN 'Periódico Semanal'
			WHEN t.descripcion LIKE '%ens.' THEN 'Periódico Mensual'
			ELSE t.descripcion
			END "Tipo de Medio"
	, COUNT (*) AS "Cantidad"
FROM medios AS m
	INNER JOIN ciudades AS c
	ON c.id_ciudad = m.id_ciudad
		INNER JOIN provincias AS p
		ON p.id_provincia = c.id_provincia
			INNER JOIN especialidades AS e
			ON m.id_especialidad = e.id_especialidad
				INNER JOIN tipos_medio AS t
				ON t.id_tipo = m.id_tipo_medio
WHERE 
	t.descripcion LIKE '_iario'
	OR t.descripcion LIKE '_u_a'
	OR t.descripcion LIKE '_er%dico%' 
	OR t.descripcion LIKE '_evista'
	OR t.descripcion LIKE '_emanal'
	OR t.descripcion LIKE '_uplementos'
GROUP BY "Tipo de Medio"
ORDER BY "Cantidad" DESC

--*********************************** PUNTO 1B ***********************************

--=============================================
--QUERY DE RECONOCIMIENTO
--=============================================
SELECT m.nombre AS "Nombre"
	, t.descripcion AS "Tipo de medio"
	, e.descripcion AS "Especialidad"
	, m.direccion AS "Direccion"
	, c.nombre AS "Ciudad"
	, p.nombre AS "Provincia"
FROM medios AS m
	INNER JOIN ciudades AS c
	ON c.id_ciudad = m.id_ciudad
		INNER JOIN provincias AS p
		ON p.id_provincia = c.id_provincia
			INNER JOIN especialidades AS e
			ON m.id_especialidad = e.id_especialidad
				INNER JOIN tipos_medio AS t
				ON t.id_tipo = m.id_tipo_medio
WHERE 
	p.nombre LIKE '%rdoba' 
	AND (t.descripcion LIKE '_iario'
		OR t.descripcion LIKE '_u_a'
		OR t.descripcion LIKE '_er%dico%' 
		OR t.descripcion LIKE '_evista'
		OR t.descripcion LIKE '_emanal'
		OR t.descripcion LIKE '_uplementos')
ORDER BY m.nombre ASC


--=============================================
--QUERY CON NORMALIZACION PARA REPORTE
--=============================================
SELECT 
	CASE 
			WHEN t.descripcion LIKE '_er%dico' THEN 'Periódico'
			WHEN t.descripcion LIKE '%emanal%' THEN 'Periódico Semanal'
			WHEN t.descripcion LIKE '%ens.' THEN 'Periódico Mensual'
			ELSE t.descripcion
			END "Tipo de Medio"
	, COUNT (*) AS "Cantidad"
FROM medios AS m
	INNER JOIN ciudades AS c
	ON c.id_ciudad = m.id_ciudad
		INNER JOIN provincias AS p
		ON p.id_provincia = c.id_provincia
			INNER JOIN especialidades AS e
			ON m.id_especialidad = e.id_especialidad
				INNER JOIN tipos_medio AS t
				ON t.id_tipo = m.id_tipo_medio
WHERE 
	p.nombre LIKE '__rdoba'
	AND	(t.descripcion LIKE '_iario'
	OR t.descripcion LIKE '_u_a'
	OR t.descripcion LIKE '_er%dico%' 
	OR t.descripcion LIKE '_evista'
	OR t.descripcion LIKE '_emanal'
	OR t.descripcion LIKE '_uplementos')
GROUP BY "Tipo de Medio"
ORDER BY "Cantidad" DESC

--****************************** PUNTO 1C ****************************************

--=============================================
--QUERY CON NORMALIZACION PARA LISTADO
--=============================================
SELECT m.nombre AS "Nombre"
	, t.descripcion AS "Tipo de medio"
	, e.descripcion AS "Especialidad"
	, m.direccion AS "Direccion"
	, c.nombre AS "Ciudad"
	, p.nombre AS "Provincia"
FROM medios AS m
	INNER JOIN ciudades AS c
	ON c.id_ciudad = m.id_ciudad
		INNER JOIN provincias AS p
		ON p.id_provincia = c.id_provincia
			INNER JOIN especialidades AS e
			ON m.id_especialidad = e.id_especialidad
				INNER JOIN tipos_medio AS t
				ON t.id_tipo = m.id_tipo_medio
WHERE m.nombre LIKE 'M%'
ORDER BY m.nombre ASC

--=============================================
--QUERY CON CANTIDAD PARA GRAFICO
--=============================================
SELECT p.nombre AS "Provincia"
	, t.descripcion AS "Tipo de Medio"
	, COUNT (m.nombre) as "Cantidad"
FROM medios AS m
	INNER JOIN ciudades AS c
	ON c.id_ciudad = m.id_ciudad
		INNER JOIN provincias AS p
		ON p.id_provincia = c.id_provincia
			INNER JOIN especialidades AS e
			ON m.id_especialidad = e.id_especialidad
				INNER JOIN tipos_medio AS t
				ON t.id_tipo = m.id_tipo_medio
WHERE m.nombre LIKE 'M%'
GROUP BY p.nombre, t.descripcion
ORDER BY p.nombre





