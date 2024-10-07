# example using mssql docker image in a spring project:

__explaining sqlcmd command__ <br>

```bash
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "lololol7261()()" -C -i file1.sql
```

-it : run command interactively <br>
-S : server  <br>
U : user <br>
sa : Service account (root user of database) <br>
-P : password (password is in parenthesis since the password has parenthesis) <br>
-C : trust self-signed certificate <br>
-i : input sql file <br>

By passing -i then we can load the `file1.sql` file into the datbase with `sqlcmd`

__Configure Spring to use the docker container__ <br>

This has been set to this:
```yml
datasource:
   url: jdbc:sqlserver://host.docker.internal:1433;databaseName=oscar;trustServerCertificate=true;
```

`host.docker.internal` is a special DNS name that resolves to an internal IP address for you docker.


## fill out the db with data

all relevant sql files are located in the `sql/` folder.
This must be done by yourself (locate the sql migration files from the backend project)

First start the docker container from the `Dockerfile`
```shell
docker build -t os/mssql-git .
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=lololol7261()()" -p 1433:1433 -d os/mssql-git
```

__check the docker name__ <br>
```shell
docker ps -a | grep git | awk -F " " '{print $NF}'
```

__copy all sql files into the container__ <br>

first create a folder for the scripts:
```shell
docker exec -u 0 -it <docker-name> /bin/sh
mkdir sql-scripts
```

`docker exec -u 0` command runs a command as root in the docker container.
This is needed bacause folders are owned by the root user.
Therefore, we need to be root to create the folder

Then copy all the sql files into the container:

```shell
cd sql/
ls | xargs -I % sh -c "docker cp % <docker-name>:/sql-scripts"
```

This will run `docker cp <file> <docker-name>:/sql-scripts` for every file inside the `./sql` folder

__copy over the bash script__ <br>
```shell
docker cp loop-through-scripts.sh <docker-name>:/
```
Then run the sql files in the container:

```shell
docker exec -u 0 -it <docker-name> /bin/sh
./loop-through-scripts.sh
```


