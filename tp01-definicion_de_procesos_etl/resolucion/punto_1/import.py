"""
11088 - Bases de Datos Masivas
Nicolas Cavasin - Legajo 143501
TP01 - Definicion de procesos ETL
Punto 1) Migración de datos de archivo ".xls" a una DB PostgreSQL alojada en un docker.

# Esquema de la base de datos a migrar:
# Tabla 1: Medios(id, nombre, id_especialidad, id_tipo_medio, dirección, id_ciudad),
# Tabla 2: Especialidades(id, descripción)
# Tabla 3: Tipos_medio(id, descripción)
# Tabla 4: Ciudades(id, nombre, id_provincia)
# Tabla 5: Provincias(id, nombre)
"""

from sys import argv, exit
import pandas as pd
import psycopg2 as pg

# Datos necesarios para conectarse al pg del docker
connection_data = "dbname=medios user=postgres password=postgres host=127.0.0.1 port=5470"

def main():
    # Primero el nombre del programa y luego el nombre del dataset
    if (len(argv) != 2):
        print()
        print("Uso: import.py <dataset>")
        exit(1)
    
    # Almaceno el path al dataset
    ds_path = argv[1]
    print(f"Received path: {ds_path}")

    # Parseo su contenido y almaceno los datos resultantes
    dprovincias, dciudades, dtmedios, despecialides, lista_medios = parse(ds_path)

    # Creo las tablas 
    create_tables()
    
    # Cargo la DB
    with pg.connect(connection_data) as con:

        # Obtengo cursor para operar sobre las tablas
        with con.cursor() as cur:

            # Cargo las provincias
            for key, value in dprovincias.items():
                print(f"Insertando ciudad {key} con id {value}")
                cur.execute("""INSERT INTO provincias VALUES (%s, %s);""" , (value, key))
            con.commit()

            # Cargo las ciudades
            for key, value in dciudades.items():
                print(f"Insertando ciudad {key} con id {value[0]} pertenciente a la provincia id {value[1]}")
                cur.execute("""INSERT INTO ciudades VALUES (%s, %s, %s);""", (value[0], key, value[1]))
            con.commit()

            # Cargo los tipos de medios
            for key, value in dtmedios.items():
                print(f"Insertando medio {key} con id {value}")
                cur.execute("""INSERT INTO tipos_medio VALUES (%s, %s);""", (value, key))
            con.commit()

            # Cargo las especialidades
            for key, value in despecialides.items():
                print(f"Insertando especialidad {key} con id {value}")
                cur.execute("""INSERT INTO especialidades VALUES (%s, %s);""", (value, key))
            con.commit()

            # Cargo los medios
            for medio in lista_medios:
                print(f"Insertando medio: {medio}")
                cur.execute("""INSERT INTO medios VALUES (%s, %s, %s, %s, %s, %s);""", 
                                (medio["id"], medio["nombre"], medio["id_especialidad"], medio["id_tipo_medio"], medio["direccion"], medio["id_ciudad"]))
                con.commit()
        # With cierra automaticamente el cursor y la conexion al desindentar
    print()
    print("Se ha migrado el contenido con exito!")
    exit(0)

def tabla_tipos_medios(medios):

    # Diccionario que almacenara tipo e id del medio
    dict_medios = {}

    for medio in medios:
        if medio not in dict_medios:
            dict_medios[medio] = len(dict_medios)
    
    return dict_medios


def tabla_especialidad(especialidades):

    # Diccionario que almacenara tipo e id de especialidad
    dict_especialidades = {}
    
    for especialidad in especialidades:
        if especialidad not in dict_especialidades:
            dict_especialidades[especialidad] = len(dict_especialidades)

    return dict_especialidades


def tabla_provincia(provincias):

    # Diccionario que almacenara tipo e id de provincias
    dict_provincias = {}

    for provincia in provincias:
        if provincia not in dict_provincias:
            dict_provincias[provincia] = len(dict_provincias)
    
    return dict_provincias


def tabla_ciudad(ciudades, provincias, dprov):

    dict_ciudades = {}

    i = 0
    for ciudad in ciudades:
        if ciudad not in dict_ciudades:
            # Obtengo el id de la provincia usando el indice
            prov_id = dprov[provincias[i]]
            dict_ciudades[ciudad] = [len(dict_ciudades), prov_id]
        i += 1

    return dict_ciudades


def parse(path):

    # Leo el archivo
    xls_data = pd.read_excel(path)

    # Lo convierto un DataFrame, simil R, para manipularlo facilmente
    # NaNs son reemplazados por el string vacio ""
    xls_file = pd.DataFrame(xls_data).fillna("")   
    
    dtme = tabla_tipos_medios(xls_file.loc[:]["Tipo de medio"])

    desp = tabla_especialidad(xls_file.loc[:]["Especialidad"])

    dprov = tabla_provincia(xls_file.loc[:]["Provincia"])

    dciu = tabla_ciudad(xls_file.loc[:]["Ciudad"], xls_file.loc[:]["Provincia"], dprov)
  
    list_medios = []
    
    # Construyo la tabla principal
    for row in  xls_file.iterrows():
        medio = {
            "id" : row[1][0],
            "nombre" : row[1][1],
            "id_especialidad" : desp[row[1][5]],
            "id_tipo_medio" : dtme[row[1][4]],
            "direccion" : row[1][6],
            "id_ciudad" : dciu[row[1][3]][0]
        }
        list_medios.append(medio)
    return dprov, dciu, dtme, desp, list_medios


def create_tables():
    """
        Crea las tablas en la base de datos. 
        No se realiza ningun tipo de chequeo, como corresponde.
    """
    # Conexion a la db
    with pg.connect(connection_data) as con:
        cur = con.cursor()

        # Creo tabla provincias
        print("Creando tabla provincias")
        cur.execute("CREATE TABLE provincias(id_provincia INTEGER PRIMARY KEY" +
                                            ", nombre VARCHAR(255));")
        con.commit()

        # Creo tabla ciudades
        print("Creando tabla ciudades")
        cur.execute("CREATE TABLE ciudades (id_ciudad INTEGER PRIMARY KEY" +
                                            ", nombre VARCHAR(255)" +
                                            ", id_provincia INTEGER" +
                                            ", FOREIGN KEY (id_provincia) REFERENCES provincias(id_provincia));")
        con.commit()

        # Creo tabla tipo_medio
        print("Creando tabla tipos_medio")
        cur.execute("CREATE TABLE tipos_medio(id_tipo INTEGER PRIMARY KEY" +
                                            ", descripcion VARCHAR(255));")
        con.commit()

        # Creo tabla especialidades
        print("Creando tabla especialidades")
        cur.execute("CREATE TABLE especialidades(id_especialidad INTEGER PRIMARY KEY" +
                                                ", descripcion VARCHAR(255));")
        con.commit()

        # Creo tabla medios
        print("Creando tabla medios")
        cur.execute("CREATE TABLE medios(id_medio INTEGER PRIMARY KEY" +
                                        ", nombre VARCHAR(255) NOT NULL" + 
                                        ", id_especialidad INTEGER" + 
                                        ", id_tipo_medio INTEGER" +
                                        ", direccion VARCHAR(255)" +
                                        ", id_ciudad INTEGER" +
                                        ", FOREIGN KEY (id_especialidad) REFERENCES especialidades(id_especialidad)" +
                                        ", FOREIGN KEY (id_tipo_medio) REFERENCES tipos_medio(id_tipo)" +
                                        ", FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad));")
        con.commit()
    return

main()
