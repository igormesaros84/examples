- [Podman Cheat sheet](#podman-cheat-sheet)
  - [Skopeo](#skopeo)
    - [Install Skopeo](#install-skopeo)
    - [Inspect online metadata](#inspect-online-metadata)
      - [Download the desired version of ubuntu that we found above](#download-the-desired-version-of-ubuntu-that-we-found-above)
  - [Podman commands](#podman-commands)
    - [Build Docker file](#build-docker-file)
    - [Publish docker image to registry](#publish-docker-image-to-registry)
    - [List containers](#list-containers)
    - [Remove not running containers](#remove-not-running-containers)
    - [Run container in the background](#run-container-in-the-background)
    - [Monitoring containers](#monitoring-containers)
    - [Run command on running container](#run-command-on-running-container)
    - [Run container with env variable and port mapping](#run-container-with-env-variable-and-port-mapping)
    - [Give access to volume files to the container (SELinux)](#give-access-to-volume-files-to-the-container-selinux)
    - [Start container on startup](#start-container-on-startup)
    - [Pods](#pods)
      - [Add containers to a pod](#add-containers-to-a-pod)
    - [Kubernetes](#kubernetes)
- [Notes to self](#notes-to-self)

# Podman Cheat sheet

## Skopeo
`Skopeo` can be used to inspect the metadata of an image that is online to ensure it has the right components installed that we need.

### Install Skopeo

```shell
sudo yum install -y skopeo
```

### Inspect online metadata

```shell
skopeo inspect --format "{{.RepoTags}}" docker://docker.io/library/ubuntu:latest | tr ' ' '\n' | grep focal
```

- `format` - only show repo tags from the metadata
- `tr ' ' '\n'` - the result will be a space separated list, we want to instead see it in a more readable way so we are going to replace spaces `' '`  with a new line `'\n'`
- `grep focal` - we want to focus on a certain version of ubuntu so we are filtering by the `focal` version

#### Download the desired version of ubuntu that we found above

```shell
podman image pull docker.io/ubuntu:focal
```

## Podman commands

### Build Docker file
Building the image
```shell
podman build -t <image_name> .
```
Running the image
```shell
podman run --name <container_name> -p 8080:8080 <image_name>:<tag>
```
### Publish docker image to registry
Login to registry
```shell
podman login docker.io
```
- `docker.io` - Docker io container registry

Build the container image in the folder same as above
```shell
podman build -t guisecara/pdm-golang
```
- `guisecara` - username
- `pdm-golang` - container image name

Push the container image to the registry
```shell
podman push guisecara/pdm-golang
```


### List containers
```shell
podman ps
podman container ps
podman container ls
podman container list
```
These above all do the same thing

### Remove not running containers
```shell
podman container prune -f
```

### Run container in the background
```shell
podman container run -dit --name ubuntu --hostname ubuntu ubuntu:focal
podman container attach ubuntu
<use the shell>
ctrl + p ctrl + q
```
- `dit` - run container in detached interactive mode
- `name` - name of the container
- `hostmane` - name of the host
- `attach ubuntu` - attach to the sell of the container named `ubuntu`
- `ctrl + p ctrl + q` - exit shell and leave the container running. If exiting the shell with `exit` it would also shut down the container


### Monitoring containers
```shell
podman container top ubuntu
podman container inspect ubuntu
podman container logs ubuntu
```
- `ubuntu` - is the name of the container
- `top` - see the running processes
- `inspect` - see the container metadata. You can filter just tha same as explained [above](#inspect-online-metadata)
- `logs` show logs (all the logs and commands that have been ran on the container last)

### Run command on running container
```shell
podman exec -it www /bin/bash
```

- `www` - name of the container
- `/bin/bash` - we want to run `/bin/bash

`exit` will close down bash but wont close the container

### Run container with env variable and port mapping
```shell
podman container run -d --name www -p 8080:80 -e'TZ=Europe/London' apache2
```

- `d` - run it in detached mode
- `p` - Port mapping
- `e` - Set the environment variable `TZ` (time zone) to `Europe/London` 

### Give access to volume files to the container (SELinux)
In order for the container to access a website that is located on the host `~/podman/www` you need to grant permissions
```shell
chcon -Rt container_file_t podman/www
```

- `R` - Recursive
- `t` - type
- `podman/www` - directory

```shell
podman container run -d --name www -p 8080:80 -e'TZ=Europe/London' -v /home/user/podman/www:/var/www/html apache2
```

- `v` - volume mapping
- `/home/user/podman/www` - path to the directory on the host
- `/var/www/html` - The web servers document root on the container. This can be different based on the web server and can be looked at by inspecting the configuration directives

### Start container on startup
This needs to be done with root access
```shell
sudo -i
```

```shell
podman container run -d --name www -p 8080:80 -e'TZ=Europe/London' -v /home/user/podman/www:/var/www/html docker.io/ubuntu/apache2
```

Download the container as it hasn't been downloaded before and run it.
It is not required for it to run so you can stop it

```shell
podman container stop www
```

Generate systemd file
```shell
podman generate systemd www > /etc/systemd/system/www.service
```
- `/etc/systemd/system/www.service` - create a service unit, we called it `www.service` to match the container

Update systemd saying that it has new system information it needs to load in

```shell
systemctl daemon-reload
```

Start up the service through system ctl
```shell
systemctl enable --now www
```

### Pods
A pod is a group of one or more containers sharing the same network, pid and ipc namespace.

```shell
podman pod --help
podman pod create --name <pod_name>
podman pod start
podman pod stop
podman pod rm <pod_name>
```
- `create` - when you create an empty pod, podman automatically ads an *infra* container. This servers holding the namespaces associated with the pod. This enables you to start and stop containers while keeping the pod running.

List all created pods
```shell
podman pod ls
```

List all the containers in the pod
```shell
podman ps -a --pod
```

#### Add containers to a pod
Run new container image inside a pod
```shell
podman run -dt --pod <name of the pod> <container image name>
```

### Kubernetes
Generate kubernetes manifest.yaml from existing pod
```shell
podman generate kube <name_of_existing_pod>
```

Create kubernetes from a manifest file
```shell
podman play kube <yaml-file-name>
```

# Notes to self
Check if the podman wsl is running
```powershell
 wsl -l -v
 ```
|NAME|STATE|VERSION|
|---|-|-|
|* podman-machine-default|Running|2|
|Ubuntu|Stopped|2|


If the `podman-machine-default` is not running then run this command:
```powershell
podman machine start 
```
