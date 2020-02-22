# README

Para rodar o projeto com docker:
```
make start
```

Para criar o banco de dados:
```
make db-create
```

## Instalação de dependencias

Para ubuntu:
```
sudo apt install pandoc calibre
```

## Resolução de problemas

Se tiver problemas com docker tente setar o host:
```
export DOCKER_HOST="tcp://0.0.0.0:2375"
```