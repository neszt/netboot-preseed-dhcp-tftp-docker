# Netboot Preseed with DHCP and TFTP in Docker

This is a Dockerized Debian Netboot Preseed setup, including a DHCP and TFTP server.

## INSTALL

```bash
$ git clone https://github.com/neszt/netboot-preseed-dhcp-tftp-docker.git && cd "$(basename "$_" .git)/deploy/compose"
$ cp -va .env.sample .env
$ cp -va data.sample data
$ # Edit the .env and data/* files to reflect your desired configuration
```

### docker
```bash
$ docker run -it --rm --network=host --env-file=.env -v $(pwd)/data:/data neszt/netboot-preseed-dhcp-tftp-docker
```

### docker-compose
```bash
$ docker-compose up
```
