# Transmission

Light weight container ships with both transmission daemon and web interface

## Run

```bash
docker pull rexezugebuild/transmission
docker volume create Transmission_DATA
docker volume create Transmission_DOWNLOAD
docker run -d \
    --name Transmission \
    --restart=unless-stopped \
    --log-driver=none \
    --volume Transmission_DATA:/etc/transmission-daemon \
    --volume Transmission_DOWNLOAD:/transmission/downloads \
    rexezugebuild/transmission
```

## Source Code

[Github](https://github.com/Rexezuge-Forks/Transmission-Docker)

## Dependency

[Transmission-Web-Control](https://github.com/ronggang/transmission-web-control)

