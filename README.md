mkdir project_name && \
cd project_name 

docker compose build 
docker compose run app bash

[container]
mix phx.new "$(pwd)" [--no-ecto]

[host]
In config/dev.exs change the ip to {0, 0, 0, 0} so is possible to access from the host machine.

[host]
Change the hostname from the databese to **db** (this is the default database name in docker-compose)

[host]
If you change the user or password from postgres, change it in config/dev.exs and config/test.exs.

[host]
In the host terminal run: sudo chown -R $USER *
