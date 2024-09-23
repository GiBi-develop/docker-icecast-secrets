FROM debian:bookworm-slim

EXPOSE 8000

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt update \
    && apt install -y --no-install-recommends icecast2 media-types xmlstarlet \
    && ln -sf /dev/stdout /var/log/icecast2/access.log \
    && ln -sf /dev/stderr /var/log/icecast2/error.log \
    && apt-get -y autoclean \
    && apt-get clean

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

USER icecast2

CMD ["icecast2", "-c", "/tmp/icecast.xml"]
