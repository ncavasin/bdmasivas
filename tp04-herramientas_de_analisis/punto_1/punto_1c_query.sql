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
WHERE m.nombre LIKE 'm%' OR m.nombre LIKE 'M%'
ORDER BY m.nombre ASC



