[[_TOC_]]

# Docker Cheat Sheet

## Basic Docker File

``` docker
# Test web app that returns the name of the host/pod/container servicing req (node based linux image)
FROM node:current-alpine

LABEL org.opencontainers.image.title="Hello Docker Learners!" \
      org.opencontainers.image.description="Web server showing host that responded" \
      org.opencontainers.image.authors="@nigelpoulton"

# Create directory in container image for app code
RUN mkdir -p /usr/src/app

# Copy app code (.) to /usr/src/app in container image
COPY . /usr/src/app

# Set working directory context
WORKDIR /usr/src/app

# Install dependencies from package.json
RUN npm install

# Command for container to execute
ENTRYPOINT [ "node", "app.js" ]
```

## Commands

### Command to build the image:
``` powershell
docker image build -t nigelpoulton/gsd:ctr2023 .
```

- `nigelpoulton` - docker hub id
- `gsd` - name of the repository
- `ctr2023` - name of the image
- `.` - tell docker that all the files are in the same directory as the command

### Pushing this to the docker container registry:
``` powershell
docker image push nigelpoulton/gsd:xtrl2023
```

### Building image supporting different architectures
``` powershell
docker buildx build \
--platform linux/arm64/v8,linux/amd64 \
--push --tag nigelpoulton/gsd:ctr2023 .
```

### Remove container locally
``` powershell
docker image rm nigelpoulton/gsd:ctr2023
```

### Run the container
``` powershell
docker containter run -d --name web -p 8000:8080 \
docker.io/nigelpoulton/gsd:2023
```

- `name` - name of the container that you need to remember in this instance its *web*
- `p` - port mapping map the host port **8000** to the port in the container **8080**
- `docker.io` - [optional] the url of the registry host. it defaults to this if not specified

### List running containers
``` powershell
docker container ls
```

### Start / Stop container
``` powershell
docker container stop web
docker container start web
```

### Delete container
``` powershell
docker container stop web
docker container rm web
```

### Attach terminal to the container
``` powershell
docker container run -it --name web alpine sh
```

- `it` - interactive
- `alpine` - base alpine image
- `sh` - type of terminal

## Docker Swarm

### Create the swarm cluster

#### Initialize the swarm, the node where you run this will be the lead swarm manager.

```powershell
docker swarm init --advertise-addr 192.168.64.19
```

- `advertise-addr` - ip to use for cluster communication for the other nodes to communicate

#### Get the command that needs running to join all the other managers
```powershell
docker swarm join-token manager
```
The resulting command needs to be ran on the other manager nodes

#### Get command that joins the worker
```powershell
docker swarm join-token worker
```
The resulting command needs to be ran on the worker nodes.

#### List all the nodes
```powershell
docker node ls
```
#### Stop business apps from being ran on manager nodes
```powershell
docker node update --availability drain node1
```

#### Create service containers on the nodes
```powershell
docker service create --name web -p 8080:8080 --replicas 3 nigelpoulton/gsd:web2023
```
This will spin up 3 identical containers all running the same image spread around evenly on the worker nodes

#### List all the service containers
```powershell
docker service pw web
```

### Docker compose in Swarm (Stack)

#### Compose file
```yaml
# Un-comment the 'version' field if you get an 'unsupported Compose file version: 1.0' ERROR
version: '3.8'
networks:
  counter-net:

volumes:
  counter-vol:
  
services:
  web-fe:
    image: nigelpoulton/gsd:swarm2023
    command: python app.py
    deploy:
      replicas: 10
    ports:
      - target: 8080
        published: 5001
    networks:
      - counter-net
    volumes:
      - type: volume
        source: counter-vol
        target: /app
  redis:
    image: "redis:alpine"
    networks:
      counter-net:
```
- `image` this time it needs to point to an image on the hub, it can't be built locally like it was in the [compose example](./DockerCompose)

#### Deploy docker to the swarm
> The following command is being run on the Leader manager node that was created above in the [swarm example](#create-the-swarm-cluster)

```powershell
docker stack deploy -c compose.yml counter
```

Check if it was created
```powershell
docker stack ls
docker stack services counter
docker stack ps counter
```


