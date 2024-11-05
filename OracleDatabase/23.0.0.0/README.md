# Docker Build Files Oracle Database 19.0.0.0

## General information

This folder contains the Docker build as well compose files for Oracle Database 19.4.0.0. The Oracle binaries are not included and must be copied separately into the software directory. The following binary packages are required to create a base installation of 19.4.0.0.

* *LINUX.X64_193000_db_home.zip* Oracle Database 19c (19.4.0.0)

Optionally, the following latest patch set updates can be used.

* n/a 

The exact download URLs are listed in the various **.download* files in the software folder.

## Building Oracle Database Docker Image

The *Dockerfile* is setup to use multistage build. The software can either be local in the *software* folder or downloaded during build from a local HTTP server. Both methods will create a space optimized Docker image.

Building the Docker images with local software packages:

```bash
docker build -t oracle/database:19.4.0.0 .
```

Building the Docker images with software packages from a local HTTP server. Where *orarepo_ip* is the name / IP address of the HTTP server:

```bash
export orarepo_ip=192.168.1.5
docker build --add-host=orarepo:${orarepo_ip} -t  oracle/database:19.4.0.0 .
```

## Running Oracle Database in a Docker container

Run your Oracle Database Docker image use the **docker run** command as follows:

```bash
docker run --name oud <container name> \
--hostname <container hostname> -p 1521:1521 
-e ORACLE_SID=TDB194S \
-e INSTANCE_INIT=/u01/config \
--volume [<host mount point>:]/u01 \
--volume [<host mount point>:]/u01/config \
oracle/database:19.4.0.0
```

Alternatively you can use the provided Docker compose file.

```bash
docker-compose up -d tdb194s
```