# help docker

https://stackoverflow.com/a/70113454/14736127

setup docker:
```shell
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<YourStrong@Passw0rd>" \
   -p 1433:1433 --name sql1 --hostname sql1 \
   -d mcr.microsoft.com/mssql/server:2022-latest \
   --network host
```

add docker to network `host` to remove network isolation between docker and devbox

__sqlcmd__ <br>
docker exec -it os-mssql3 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa

docker exec -it os-mssql3 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P Oscar2439$7261 -C

-P : password
-C : trust self-signed certificate

## copy file over

```
docker cp <file> <docker-name>:<path>
```
example:
```shell
docker cp file1.sql os-compose1:/
```

## connect spring app to docker container

Make sure to create a db:
```shell
docker cp file1.sql os-compose1:/
docker exec -it os-compose1 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "lololol7261()()" -C -i file1.sql
```
Then change the connection string in application.yml to be this
```shell
url: jdbc:sqlserver://host.docker.internal:1433;databaseName=oscar;trustServerCertificate=true;
```

`host.docker.internal` is a special DNS name that resolves to an internal IP address for you docker.

So this will work:
```shell
docker-compose up -d
telnet host.docker.internal 1433
```

source: https://dev.to/natterstefan/docker-tip-how-to-get-host-s-ip-address-inside-a-docker-container-5anh


## copy all sql files into a docker container:

quick and dirty method:

```shell
cd sql/
ls | xargs -I % sh -c "docker cp % os-compose1:/sql-scripts"
```

sort files among docker files:
ls | sort -V

log in as root:
docker exec -u 0 -it zealous_chatelet /bin/sh
