FROM alpine:3

RUN apk add --no-cache build-base git

RUN git clone https://github.com/ronggang/transmission-web-control.git

COPY Init.c Init.c

RUN gcc -o Init.out -Ofast Init.c

FROM alpine:3

RUN apk add --no-cache transmission-daemon

RUN mkdir -p /etc/transmission-daemon

COPY .FILES/setAuth.sh /.setAuth.sh

RUN chmod +x /.setAuth.sh

COPY .FILES/etc/transmission-daemon/ /etc/transmission-daemon/

COPY --from=0 /Init.out /usr/bin/init

COPY --from=0 /transmission-web-control/src /.TransmissionWebControl

VOLUME ["/transmission/downloads"]

ENV USERNAME=${USERNAME}

ENV PASSWORD=${PASSWORD}

EXPOSE 9091/tcp

ENTRYPOINT ["/usr/bin/init"]
