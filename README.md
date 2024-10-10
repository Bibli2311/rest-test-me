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
   url: jdbc:sqlserver://host.docker.internal:1433;databaseName=master;trustServerCertificate=true;
```

`master` database is used here since it looks like it is the default database.


`host.docker.internal` is a special DNS name that resolves to an internal IP address for you docker.


## fill out the db with data

all relevant sql files are located in the `sql/` folder.
This must be done by yourself (locate the sql migration files from the backend project)

First start the docker from the docker-compose.yml file 
```shell
docker compose up -d
```
__copy all sql files into the container__ <br>

first create a folder for the scripts:
```shell
docker exec -u 0 -it os-compose1 /bin/sh
mkdir sql-scripts
```

`docker exec -u 0` command runs a command as root in the docker container.
This is needed bacause folders are owned by the root user.
Therefore, we need to be root to create the folder

Then copy all the sql files into the container:

```shell
cd sql/
ls | xargs -I % sh -c "docker cp % os-compose1:/sql-scripts"
```

This will run `docker cp <file> os-compose1:/sql-scripts` for every file inside the `./sql` folder

__copy over the bash script__ <br>
```shell
docker cp loop-through-scripts.sh os-compose1:/
```
Then run the sql files in the container:

```shell
docker exec -u 0 -it os-compose1 /bin/sh
./loop-through-scripts.sh
```

__commit changes so that you don't have to do this again__ <br>
```shell
# find the docker id:
MY_DOCKER=$(docker ps -a  | grep os-compose1 | awk '{print $1}')
docker commit $MY_DOCKER dsta-sql-db
```



