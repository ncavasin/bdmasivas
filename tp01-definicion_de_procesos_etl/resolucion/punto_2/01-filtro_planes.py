# Parseo simple para eliminar el asqueroso formato del archivo .txt lleno de espacios
# El resultado se guarda en un csv llamado "etl_planes_filtrado.csv"

# Leo el archivo original
with open("01-02-planes.txt", "r") as txtfile:
    lines = txtfile.readlines()

# Creo el archivo parseado
with open("etl_planes_filtrado.csv", "w") as out:
    # Escribo los headers
    out.writelines("codigo_plan;nombre_carrera\n")
    for line in lines:
    	# Elimino espacios en los extremos
        line = line.strip()
        # Elimino los espacios internos y obtengo una lista de valores
        res = line.rsplit("            ")
        # Elimino nuevamente espacios en los extremos
        res[0] = res[0].strip()
        # Escribo la linea en formato .csv
        out.writelines(f"{res[0]};{res[1]}\n")
    
# Fin
