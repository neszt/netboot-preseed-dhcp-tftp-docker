FROM debian:bookworm

LABEL org.opencontainers.image.authors="Neszt Tibor <tibor@neszt.hu>"
LABEL org.opencontainers.image.source="https://github.com/neszt/netboot-preseed-dhcp-tftp-docker"

RUN \
	apt-get update && apt-get -y dist-upgrade && \
	apt-get install -y supervisor isc-dhcp-server atftpd wget iproute2 ipcalc cpio && \
	cd /srv/tftp && chmod 777 . && \
	wget -qO - https://deb.debian.org/debian/dists/bookworm/main/installer-amd64/current/images/netboot/netboot.tar.gz | tar xvzf - && \
	cd / && wget https://cdimage.debian.org/cdimage/firmware/testing/current/firmware.cpio.gz

COPY content /

VOLUME /data

CMD ["/run.sh"]
