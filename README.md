mkdir project_name && \
cd project_name 

docker build . -t phoenix_container -f Dockerfile.dev_enviroment   
docker run --rm -it -v "$(pwd)":/app -p 4000:4000 --name app phoenix_container bash

mix phx.new "$(pwd)" [--no-ecto]
In config/dev.exs change the ip to {0, 0, 0, 0} so is possible to access from the host machine.
Change the hostname from the databese to **db** (this is the default database name in docker-compose)
If you change the user or password from postgres, change it in config/dev.exs and config/test.exs.
In the host terminal run: sudo chown -R $USER *
