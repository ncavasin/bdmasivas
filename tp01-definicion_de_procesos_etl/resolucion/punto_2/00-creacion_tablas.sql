CREATE TABLE IF NOT EXISTS cohortes
(
    id_cohortes SERIAL PRIMARY KEY,
    cohorte integer
);

CREATE TABLE IF NOT EXISTS  sexos
(
    id_sexo SERIAL PRIMARY KEY,
    sexo char(1)
);

CREATE TABLE IF NOT EXISTS  sedes
(
    id_sede SERIAL PRIMARY KEY,
    sede varchar(255)
);

CREATE TABLE IF NOT EXISTS  ciudades
(
    id_ciudad SERIAL PRIMARY KEY,
    codigo_postal integer,
    nombre_ciudad varchar(255),
    provincia varchar(255)
);

CREATE TABLE IF NOT EXISTS  planes
(
    id_plan SERIAL PRIMARY KEY,
    codigo_plan integer,
    codigo_carrera integer,
    nombre_carrera varchar(255)
);

CREATE TABLE IF NOT EXISTS  rendimiento_academico
(
    id_estudiante integer NOT NULL PRIMARY KEY,
    id_plan integer,
    id_sede integer,
    id_ciudad integer,
    id_sexo integer,
    id_cohortes integer,
    cantidad_cursadas integer,
    cantidad_aprobadas integer,
    promedio double precision,
    CONSTRAINT fk_ciudad FOREIGN KEY (id_ciudad) REFERENCES public.ciudades (id_ciudad),
    CONSTRAINT fk_cohortes FOREIGN KEY (id_cohortes) REFERENCES public.cohortes (id_cohortes),
    CONSTRAINT fk_plan FOREIGN KEY (id_plan) REFERENCES public.planes (id_plan),
    CONSTRAINT fk_sede FOREIGN KEY (id_sede) REFERENCES public.sedes (id_sede),
    CONSTRAINT fk_sexo FOREIGN KEY (id_sexo) REFERENCES public.sexos (id_sexo)
)



