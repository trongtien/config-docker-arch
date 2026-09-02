# config-docker-arch


## Run builder docker linux
docker build -f Dockerfile.Arch -t arch .

## Mount volume share folder window using docker linux
docker run -it -v C:\Users\Tên_Bạn\Documents:/projects --name workspace arch-dev


## Run build with docker compose
docker compose build --no-cache


## Run exect docker linux
docker compose exec arch tmux attach


## Run exect bash
docker compose exec arch bash



