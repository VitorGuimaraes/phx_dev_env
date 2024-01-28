![Elixir](https://img.shields.io/badge/elixir-%234B275F.svg?style=for-the-badge&logo=elixir&logoColor=white)
![Phoenix](https://img.shields.io/badge/Phoenix%20Framework-FD4F00?style=for-the-badge&logo=phoenixframework&logoColor=fff)
![Postgres](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)

# Phoenix Development Environment

Set up your environment without install Elixir and Phoenix locally.
By this way, you don't need to download, install and configure dependencies or create and build a Docker image manually by yourself to start developing a new project.

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
> git clone <https://github.com/VitorGuimaraes/phx_dev_env.git>

### 2. Setup your project variables in `.env`

In `.env` you can setup your postgres variables and some variables used in [`docker-compose.yaml`](https://github.com/VitorGuimaraes/phx_dev_env/blob/master/docker-compose.yaml).

### 3. Give permission to execute the bash scripts

> chmod +x *.sh

### 4. Run the shell script

It will run a elixir container in shell, so you can create your Phoenix project.  
Check [`run.sh`](https://github.com/VitorGuimaraes/phx_dev_env/blob/master/run.sh) file for more information.  
> ./run.sh

### 5. Install CommitLint, Husky and Commitizen (optional)

Optionally you can install these tools, so you can easily implement GitFlow and [`Conventional Commits`](https://www.conventionalcommits.org/) in your project.  
After you exit from the container in step 5, the installer will ask you for install it.  
We also recommend that you use [`Gitmoji`](https://gitmoji.dev/)

### 6. Add Credo Dependency (optional)

Check current [`credo`](https://github.com/rrrene/credo) version

```elixir
defp deps do
  [
    {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
  ]
end
```

### 7. Source .env

Load the environment variables  
> source .env

### 8. Get and compile dependencies

`docker compose run --rm api_service sh`
> mix deps.get  
> mix deps.compile  
> exit

### 9. Checking if is everything ok

run `docker compose up -d`  
Visit [`http://localhost:4000/`](http://localhost:4000/) and check Phoenix page.  

### 10. Files Ownership

Always that you create a new file for you Phoenix project using the container, it will be owned by root.  
To change the ownership to your user, run in terminal: `sudo chown -R $USER *`  

### 11. Connecting in DBeaver

Host: `localhost`  
Port: `container port`. Check it with `docker ps`  
Database: POSTGRES_DB defined in `.env`  
Username: POSTGRES_USER defined in `.env`  
Password: POSTGRES_PASSWORD defined in `.env`  

### 12. Managing images and containers

- `docker compose up -d`  
   up services.

- `docker compose down`  
   down services

- `docker exec -it $CONTAINER_NAME sh`  
   exec shell in a running container.

- `docker compose run --rm phoenix_service sh`  
   run a new container with shell and clean up when exit.

- `docker rm $(docker ps -aq) -f`  
   delete all running containers
