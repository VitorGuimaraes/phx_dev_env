# Phoenix Development Environment 
Set up your environment without install Elixir and Phoenix locally. 
By this way, you don't need to download, install and configure dependencies or create and build a Docker image manually by yourself to start developing.

## Technologies 
The project is created with:
- Docker
- Docker compose
- Shell script

## Getting started
- Install [`docker`](https://docs.docker.com/engine/install/) and [`docker-compose`](https://docs.docker.com/compose/install/)


## How to run 

### 1. Create your project
In your terminal, create your `project_name` folder and `cd` to it.
> mkdir `project_name` && cd `project_name` 

### 2. Clone the repository locally  
In your terminal use `git` to clone the repository locally.
> git clone https://github.com/VitorGuimaraes/phx_dev_env.git

### 3. Give permission to execute the bash script
> sudo chmod +x phx_dev_env/run.sh

### 4. Run the shell script
It will copy the `Dockerfile` and `docker-compose` files to your project's directory, build the image and than delete the folder `/phx_dev_env`.<br> 
Check [`run.sh`](https://github.com/VitorGuimaraes/phx_dev_env/blob/master/run.sh) file for more information.  
> ./phx_dev_env/run.sh 

### 5. Run the container
> docker compose -f docker-compose_dev.yaml -p phx_dev_env run dev bash

### 6. Create your Phoenix Project
In the container's terminal, run:
> mix phx.new .<br>
> exit

The dot at the end of the command means that the project will be created at the current directory.<br> 
Use `mix phx.new . --no-ecto` if you don't need database.

### 7. Set up your project
1. In the host terminal run: `sudo chown -R $USER *`<br>
You need to run this command always that a new file is created by the running container, because the files created by the container are associated to the user/group of the container, not of the host machine.

user/group owner before run `chown`:
```
Permissions Size User     Date Modified Name
drwxr-xr-x     - root     11 jul 15:25  _build
drwxr-xr-x     - root     11 jul 15:25  assets
drwxr-xr-x     - root     11 jul 15:25  config
drwxr-xr-x     - root     11 jul 15:25  deps
.rw-rw-r--   171 predator 11 jul 15:24  docker-compose_dev.yaml
.rw-rw-r--   245 predator 11 jul 15:24  Dockerfile.dev
drwxr-xr-x     - root     11 jul 15:25  lib
.rw-r--r--  2,0k root     11 jul 15:25  mix.exs
.rw-r--r--   12k root     11 jul 15:25  mix.lock
drwxr-xr-x     - root     11 jul 15:25  priv
.rw-r--r--   694 root     11 jul 15:25  README.md
drwxr-xr-x     - root     11 jul 15:25  test
```
user/group owner after run `chown`:
```
Permissions Size User     Date Modified Name
drwxr-xr-x     - predator 11 jul 15:25  _build
drwxr-xr-x     - predator 11 jul 15:25  assets
drwxr-xr-x     - predator 11 jul 15:25  config
drwxr-xr-x     - predator 11 jul 15:25  deps
.rw-rw-r--   171 predator 11 jul 15:24  docker-compose_dev.yaml
.rw-rw-r--   245 predator 11 jul 15:24  Dockerfile.dev
drwxr-xr-x     - predator 11 jul 15:25  lib
.rw-r--r--  2,0k predator 11 jul 15:25  mix.exs
.rw-r--r--   12k predator 11 jul 15:25  mix.lock
drwxr-xr-x     - predator 11 jul 15:25  priv
.rw-r--r--   694 predator 11 jul 15:25  README.md
drwxr-xr-x     - predator 11 jul 15:25  test
```

- In `config/dev.exs` change the ip to `{0, 0, 0, 0}` so wil be possible to access the application endpoint from the host machine.<br>
- Change the `hostname`' database to **db** (this is the default database name in `docker-compose_dev.yaml`)<br>
If you change the user or password of postgres, change it in `config/dev.exs` and `config/test.exs`.

## Managing the image and container
- `docker compose -f docker-compose_dev.yaml build`                   build the image.<br>
- `docker compose -f docker-compose_dev.yaml -p phx_env run dev bash` run the container and open bash.<br>
- `docker compose down`                                               down containers<br>   
- `docker rm phx_dev_env`                                             stop and delete the running container.<br> 
- `docker rmi phx_dev_env`                                            delete phx_dev_env image.
