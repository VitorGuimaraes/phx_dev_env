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

### 3. Give permission to execute the bash scripts
> sudo chmod +x phx_dev_env/*.sh

### 4. Run the shell script
It will copy the files to your project's directory, build the image, delete the folder `/phx_dev_env` and start a container in shell.<br> 
Check [`run.sh`](https://github.com/VitorGuimaraes/phx_dev_env/blob/master/run.sh) file for more information.  
> ./phx_dev_env/run.sh 

### 5. Create your Phoenix Project
In the container's terminal, run:
> mix phx.new .<br>
> exit

The dot at the end of the command means that the project will be created at the current directory.<br> 
Use `mix phx.new . --no-ecto` if you don't need database.

### 6. Set up your project
In the host terminal run: `sudo chown -R $USER *`<br>
You need to run this command always that a new file is created by the running container, because the files created by the container are associated to the user/group of the container, not of the host machine.

user/group owner before run `chown`:
```
Permissions Size User     Date Modified Name
drwxr-xr-x     - root     11 jul 15:25  _build
drwxr-xr-x     - root     11 jul 15:25  assets
drwxr-xr-x     - root     11 jul 15:25  config
```
user/group owner after run `chown`:
```
Permissions Size User     Date Modified Name
drwxr-xr-x     - predator 11 jul 15:25  _build
drwxr-xr-x     - predator 11 jul 15:25  assets
drwxr-xr-x     - predator 11 jul 15:25  config
```

### 7. Set up your `config/dev.exs`
You can use the variables in `.env` to config postgres variables in compose file. Copy them to your `dev.exs` changing `username`, `password`, `hostname` and `database`. Also change the `pool_size` to `2` 
```
   username: "postgres",
   password: "postgres",
   hostname: "localhost",
   database: "app_dev",
   stacktrace: true,
   show_sensitive_data_on_connection_error: true,
   pool_size: 2 
```
In `config/dev.exs` change the ip to `{0, 0, 0, 0}` so wil be possible to access the application endpoint from the host machine.<br>

### 8. Source environment
```source .env```

### 9. Get and compile dependencies
`docker compose -f $COMPOSE_FILE -p $PROJECT_NAME run --rm dev sh` <br>
> mix deps.get<br> 
> mix deps.compile<br>
> exit

obs: check if you have postgres and phx_dev containers up. If not, run:<br>
`docker compose -f $COMPOSE_FILE -p $PROJECT_NAME up -d`<br> 

Visit [`http://localhost:4000/`](http://localhost:4000/)<br>

## 10. Managing the image and container
- `docker compose -f $COMPOSE_FILE -p $PROJECT_NAME up -d`<br> 
up services.

- `docker compose down`  
   down services 

- `docker exec -it $CONTAINER_NAME sh`<br> 
   exec shell in a running container.

- `docker compose -f $COMPOSE_FILE -p $PROJECT_NAME run --rm dev sh`<br> 
   run a new container with shell and clean up when exit.
  
