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


 
