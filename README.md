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

### 1. Clone the repository locally  
In your terminal use `git` to clone the repository locally.
> git clone https://github.com/VitorGuimaraes/phx_dev_env.git

### 2. Setup your project variables in .env.sample 
In `.env.sample` you can setup your postgres variables and some variables used in [`docker-compose_dev.yaml`](https://github.com/VitorGuimaraes/phx_dev_env/blob/master/docker-compose_dev.yaml).

### 3. Give permission to execute the bash scripts
> chmod +x *.sh

### 4. Run the shell script
It will run a elixir container in shell, so you can create your Phoenix project.<br> 
Check [`run.sh`](https://github.com/VitorGuimaraes/phx_dev_env/blob/master/run.sh) file for more information.  
> ./run.sh 

### 5. Create your Phoenix Project
In the container's terminal, run:
> mix phx.new `your_project_name`<br>
> exit

Use `--no-ecto` at the end of this command if you don't need database.

### 6. Set up your `config/dev.exs`
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


### 7. Get and compile dependencies
`docker compose -f $COMPOSE_FILE -p $PROJECT_NAME run --rm dev sh` <br>
> mix deps.get<br> 
> mix deps.compile<br>
> exit

obs: check if you have postgres and phx_dev containers up. If not, run:<br>
`docker compose -f $COMPOSE_FILE -p $PROJECT_NAME up -d`<br> 

Visit [`http://localhost:4000/`](http://localhost:4000/) and check if Phoenix page loads<br>

## 8. Files Ownership
Always that you create a new file for you Phoenix project using the container, it will be owned by root. <br>
To change the ownership for your user, run in terminal: `sudo chown -R $USER *`<br>

## 9. Managing images and containers
- `docker compose -f $COMPOSE_FILE -p $PROJECT_NAME up -d`<br> 
   up services.

- `docker compose down`  
   down services 

- `docker exec -it $CONTAINER_NAME sh`<br> 
   exec shell in a running container.

- `docker compose -f $COMPOSE_FILE -p $PROJECT_NAME run --rm dev sh`<br> 
   run a new container with shell and clean up when exit.

- `docker rm $(docker ps -aq) -f`<br>
   delete all running containers
   
