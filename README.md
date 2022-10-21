# Udemy > Docker & YAML In A Nutshell > Section 2: "Introduction of Docker"

I ended up bailing on this class (the pieces don't quite fit together)

## Notes

### Docker Cheatsheet
```
containers
    list containers
        docker container ls
    stop a container
        docker stop some-postgress
        or
        docker container stop some-postgress
    remove a container
        docker rm some-postgres
        or
        docker container rm some-postgres
```
### Postgres Cheatsheet
```
lists databases
    \l
lists the version of postgres
    select version();
```
## Course Content

### 5. Keep data outside of the continer
```
docker run -d -p 5432:5432 \
    -name some-postgres \
    -e POSTGRES_PASSWORD=mysecretpassword \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v ~/git/hello_docker/pg_data:/var/lib/postgresql/data \
    postgres
```
### Assignment 2 create two different versions of postgres DB in docker (versions 14 and 15)
```
check the one from the previous lesson 
    docker exec -it some-postgres bash
    psql -U postgres
    select version();
    (the image has version 15)
will maybe be something like this (need to specify version # though)
    docker run -p 5432:5432 --name postgres-13 -e POSTGRES_PASSWORD=mysecretpassword -d postgres
    docker run -p 5431:5431 --name postgres-14 -e POSTGRES_PASSWORD=mysecretpassword -d postgres
get version numbers
    https://www.postgresql.org/support/versioning/
    14.5 and 15.0
try this docker-compose.yml
    the contents
        version: '3'
        services:
        pg9:
            image: postgres:14.5
            ports:
            - 5961:5432
            environment:
            POSTGRES_DB: project-x

        pg10:
            image: postgres:15.0
            ports:
            - 5105:5432
            environment:
            POSTGRES_DB: project-y
    get it running...
        docker-compose up -d
    verify that they are running...
        docker-compose ps
    drop into psql
        docker-compose exec -u postgres pg9 bash
        and
        docker-compose exec -u postgres pg10 bash        
        not working
let's try another way...
    docker run --name my-postgres-15 \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=my-password \
    -e POSTGRES_USER=myself \
    -e POSTGRES_DB=my-db-15 \
    -v my-postgres-db:/var/lib/postgresql/data \
    postgres:15.0
    docker run --name my-postgres-14 \
    -p 5431:5432 \
    -e POSTGRES_PASSWORD=my-password \
    -e POSTGRES_USER=myself \
    -e POSTGRES_DB=my-db-14 \
    -v my-postgres-db:/var/lib/postgresql/data \
    postgres:14.5
the answer from the instructor (modified)...
    docker run -p 5432:5432 --name p14 -e POSTGRES_PASSWORD=mysecretpassword -d postgres:14.5
    and 
    docker run -p 5431:5432 --name p15 -e POSTGRES_PASSWORD=mysecretpassword -d postgres:15.0


```
### 4. Get a database and run
```
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
    that is gloriously simple
enter the container via the command line 
    docker exec -it some-postgres bash
get some deets
    psql -U postgres
        returns some deets
more info
    https://www.udemy.com/course/docker-yaml-in-a-nutshell/learn/lecture/34128386#overview
    https://hub.docker.com/_/postgres
additional tinkering
    docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d -p 5432:5432 postgres
    https://stackoverflow.com/questions/37694987/connecting-to-postgresql-in-a-docker-container-from-outside
    can't create a database (probably a login thing)
next day more tinkering
    get the running version
        select version();
    connect visualStudio postgres extention to the container's postgres...
        connection deets...
            host localhost
            port 5432
            username postgres
            password mysecretpassword  
    ...also need to tell the docker to listen on port 5432...
        (1) stop and  delete
            commands...
                docker container stop some-postgress
                docker container rm some-postgres
        (2) command...
            docker run -p 5432:5432 --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
        (3) connect via postgres visualStudio extension
            it works!
```
### 3. Cleanup: docker prune
```
docker image ls
    lists images
docker image prune
    removes all images that 'arent being used' (clarification needed)
docker image prune -a
    removes all images
```
### Assignment 1: Run a docker application with input parameter
```
requirement
    either 
    BUILD the image with host username as input or 
    RUN the image with host username as input

my submission
    docker run --name hello_assignment_1 --rm alpine echo 'Tell the computer program your name OR ELSE!!!' && read USER && echo "Yup, your name is '$USER'... or at least that's what you told me."
        that works but instructor had a different take on it...
            instructor example 1 (a Dockerfile)
                the file
                    FROM alpine
                    ENTRYPOINT ["echo"]
                the instructions
                    Build it as:
                        docker build . -t input_when_run
                    Run it as:
                        docker run --rm input_when_run "$USER"
            instructor example 2
                the file
                    FROM alpine
                    ARG USERNAME
                    ENV USERNAME ${USERNAME}
                    CMD echo ${USERNAME}
                the instructions
                    Build it as:
                        docker build . --build-arg USERNAME="$USER" -t docker_image_with_username
                    Run it as:
                        docker run --rm docker_image_with_username

additional tinkering
this Dockerfile
    FROM alpine
    ARG USERNAME
    ENV USERNAME ${USERNAME}
    CMD echo "Yup, your name is '${USERNAME}'... or at least that's what you told me."
and this command
    docker build . --build-arg USERNAME="Dorito-San" -t docker_image_with_username && docker run --rm docker_image_with_username
```

### 2 Hello world from Docker
```
docker pull alpine
    quick

docker run -it --name my_alpine alpine /bin/sh
    no bueno, but this works...

docker run -it --name my_alpine alpine
    echo 'hello world'
        nice!
    exit
    delete container 'my_alpine' via gui

docker run --name hello_alpine --rm alpine echo 'hello world'
    does everything above (including deleting the container) but in one command

created Dockerfile
    contents
        FROM alpine
        CMD echo "hello world"
    then build it
        docker build . -t hello_docker
    then run it
        docker run hello_docker
            returns 'hello world'
            (manually delete container (name is randomized))
    run it again with a name?
        docker run --name hello_again hello_docker
            (manually delete continaer (name is 'hello_again'))
    lastly, run it again "run and delete" style
        docker run --name hello_again_again --rm hello_docker
```
