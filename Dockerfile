FROM elixir:latest

RUN apt update && \
    apt upgrade -y && \
    apt install nodejs -y && \
    apt install inotify-tools -y 

RUN curl -L https://npmjs.org/install.sh | sh && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex phx_new --force 

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN touch Dockerfile && \
    touch Dockerfile.prod

CMD ["mix", "phx.server"]

EXPOSE 4000
