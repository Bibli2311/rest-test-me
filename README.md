# example using mssql docker image in a spring project:

1. Build the docker image:
```shell
docker compose up -d
```

Then copy a .sql file inside the container:
```shell
docker cp file1.sql os-compose1:/
# the docker container name can vary
```

Then load the script using `sqlcmd`

```shell
docker exec -it os-compose1 /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "lololol7261()()" -C -i file1.sql
```

-it : run command interactively
-S : server
U : user
sa : Service account (root user of database)
-P : password (password is in parenthesis since the password has parenthesis)
-C : trust self-signed certificate
-i : input sql file

By passing -i then we can load the `file1.sql` file into the datbase with `sqlcmd`

2. Configure Spring to use the docker container

This has been set to this:
```yml
datasource:
   url: jdbc:sqlserver://host.docker.internal:1433;databaseName=oscar;trustServerCertificate=true;
```

`host.docker.internal` is a special DNS name that resolves to an internal IP address for you docker.

