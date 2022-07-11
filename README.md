mkdir project_name && cd project_name 

docker compose build \
docker compose run app bash

[container]
mix phx.new . [--no-ecto if you won't use db]

[host]
In config/dev.exs change the ip to {0, 0, 0, 0} so is possible to access from the host machine.

[host]
Change the hostname from the databese to **db** (this is the default database name in docker-compose)

[host]
If you change the user or password from postgres, change it in config/dev.exs and config/test.exs.

[host]
In the host terminal run: sudo chown -R $USER *
You need run this command always that a new file is created

TODO
adicionar .sh que copia o Dockerfile e docker compose pra raiz do projeto e deleta a pasta do git clone
o .sh deverá ser executado da pasta raiz do projeto, por ex: ./dev_phoenix_image/run.sh
.sh:
cp Dockerfile docker-compose.yaml ../
rm -rf dev_phoenix_image
