CREATE TABLE IF NOT EXISTS provincias
(
    id_provincia SERIAL PRIMARY KEY,
    nombre_provincia VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS ciudades(
    id_ciudad SERIAL PRIMARY KEY,
    nombre_ciudad VARCHAR(255),
    id_provincia INTEGER,
    FOREIGN KEY (id_provincia) REFERENCES provincias(id_provincia)
);

CREATE TABLE IF NOT EXISTS tipos_medio(
    id_tipo SERIAL PRIMARY KEY,
    descripcion VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS especialidades(
    id_especialidad SERIAL PRIMARY KEY,
    descripcion VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS medios(
    id_medio INTEGER,
    nombre VARCHAR(255),
    id_especialidad INTEGER,
    id_tipo INTEGER,
    direccion VARCHAR(255),
    id_ciudad INTEGER,
    FOREIGN KEY (id_especialidad) REFERENCES especialidades(id_especialidad),
    FOREIGN KEY (id_tipo) REFERENCES tipos_medio(id_tipo),
    FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad)
);

