# Udemy > Docker & YAML In A Nutshell > Section 2: "Introduction of Docker"

## 4. Get a database and run
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
```

## 3. Cleanup: docker prune
```
docker image ls
    lists images
docker image prune
    removes all images that 'arent being used' (clarification needed)
docker image prune -a
    removes all images
TODO: 
    download DBeaver 
    open it
    click connect
        host: localhost
        port 5432
        username postgres
        password mysecretpassword

```
## Assignment 1: Run a docker application with input parameter
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

## 2 Hello world from Docker
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
