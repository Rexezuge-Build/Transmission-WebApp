FROM alpine:3

RUN apk add --no-cache build-base git

RUN git clone https://github.com/ronggang/transmission-web-control.git

COPY Init.c Init.c

RUN gcc -o Init.out -Ofast Init.c

FROM alpine:3

RUN apk add --no-cache transmission-daemon

RUN mkdir -p /etc/transmission-daemon

RUN rm -rf /sbin/apk /lib/apk /etc/apk /var/lib/apk /usr/share/apk-tools

COPY .FILES/settings.json /etc/transmission-daemon/settings.json

COPY --from=0 /Init.out /usr/bin/init

COPY --from=0 /transmission-web-control/src /.TransmissionWebControl

FROM scratch

COPY --from=1 / /

VOLUME ["/transmission/downloads"]

VOLUME ["/etc/transmission-daemon"]

EXPOSE 9091/tcp

ENTRYPOINT ["/usr/bin/init"]
