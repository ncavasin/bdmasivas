# Conectando servicios en diferentes contenedores

1. Cuando se levanta un container por primera vez, al ejecutar ``docker-compose up``, se crea una red con el nombre del directorio en la que encuentra el archivo ``docker-compose.yaml`` y el sufijo *_default*.

   - Por ejemplo, si se ejecuta ``docker-compose up`` dentro del directorio *postgres/* se creará una red con el nombre **postgres_default**.

2. Entonces, si la idea es conectar el container de *pentaho* con el container de *postgres* basta con conectar *pentaho* a la red **postgres_default**.

3. Yo decidí hacerlo de manera persistente modificando el archivo ``docker-compose.yaml`` del container de *pentaho*, quedando así:
   
        version: '3'

        services:

        pentaho:
            image: dgraselli/pentaho-biserver:9.0
            ports:
            - "8080:8080"
            networks:
            - postgres_default

        pentaho_mysql:
            image: mysql:5.7
            ports:
            - '3306:3306'
            environment:
            MYSQL_ROOT_PASSWORD: bdm

        pentaho_phpmyadmin:
            depends_on:
            - pentaho_mysql
            image: phpmyadmin/phpmyadmin
            ports:
            - '6030:80'
            environment:
            PMA_HOST: pentaho_mysql
            
        networks:
        postgres_default:
            external: true

4. Luego de la modificación se reinicia el container *pentaho* y se ejecuta el comando ``docker network inspect postgres_default`` para verificar que estén todos los servicios conectados. Este es el output esperado:

        $ docker network inspect postgres_default
        [
            {
                "Name": "postgres_default",
                "Id": "29eefaf70f9a5142cc471a9a702bc7867dffc407e0246ed03e475b3138d39901",
                "Created": "2020-09-23T23:08:35.485666222-03:00",
                "Scope": "local",
                "Driver": "bridge",
                "EnableIPv6": false,
                "IPAM": {
                    "Driver": "default",
                    "Options": null,
                    "Config": [
                        {
                            "Subnet": "172.20.0.0/16",
                            "Gateway": "172.20.0.1"
                        }
                    ]
                },
                "Internal": false,
                "Attachable": true,
                "Ingress": false,
                "ConfigFrom": {
                    "Network": ""
                },
                "ConfigOnly": false,
                "Containers": {
                    "72fdba5319d008efe2ba73e90db5571a5a1f5481e3cf66847c2cc8e22e1248a2": {
                        "Name": "pgadmin_container",
                        "EndpointID": "8905bc31b00cb7efee522cea7c15045dba03d3f8034d9b0f1d1e5fca2876c447",
                        "MacAddress": "02:42:ac:14:00:04",
                        "IPv4Address": "172.20.0.4/16",
                        "IPv6Address": ""
                    },
                    "9bd79bd60a6ff383479a57eeae81f9acedaf6b25b84b172c82bae5f75d642d8c": {
                        "Name": "postgres_db_1",
                        "EndpointID": "c9e3070314ce55a43081ceca0f71c25f366ac53592c92e898c45491cfef62515",
                        "MacAddress": "02:42:ac:14:00:03",
                        "IPv4Address": "172.20.0.3/16",
                        "IPv6Address": ""
                    },
                    "a1e9ee62f7337b019a0ec136efaf9c1e7107daa04784d8cd659a9cf27573393f": {
                        "Name": "pentaho_pentaho_1",
                        "EndpointID": "69d1a1b0759573d202858ccccf38eea5f6b16307c9507c025a307337a333cb72",
                        "MacAddress": "02:42:ac:14:00:02",
                        "IPv4Address": "172.20.0.2/16",
                        "IPv6Address": ""
                    }
                },
                "Options": {},
                "Labels": {
                    "com.docker.compose.network": "default",
                    "com.docker.compose.project": "postgres",
                    "com.docker.compose.version": "1.27.3"
                }
            }
        ]

5. Si todo sale bien, ambos containers están ahora conectados.

6. **Importante:** recordar que ahora los containers se encuentran en la misma red y por lo tanto **cambian los sockets** y se utilizan los internos.
   - Por ejemplo: para conectarme a la DB Postgres desde el *pentaho* voy a usar el socket ``db:5432`` porque estos son los valores definidos en el ``docker-compose.yaml`` del container *postgres*.

### Referencias útiles:

Cómo rear [redes](https://dev.to/mozartted/docker-networking--how-to-connect-multiple-containers-7fl) para containers.

Stackoverflow: respuesta [#3](https://stackoverflow.com/questions/38088279/communication-between-multiple-docker-compose-projects).

Documentación oficial de [docker](https://docs.docker.com/compose/networking/) para networking entre containers creados con ``compose``.