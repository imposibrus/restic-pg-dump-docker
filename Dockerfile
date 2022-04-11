FROM restic/restic:0.12.0

# temp fix for network issues
RUN sed -i -e 's/dl-cdn/dl-4/' /etc/apk/repositories

RUN apk update \
    && apk upgrade \
    && apk add \
        bash \
        tini \
    && apk add --repository=http://dl-4.alpinelinux.org/alpine/edge/main \
        util-linux \
        postgresql14-client \
    && rm -rf /var/cache/apk/*

# temp fix for network issues
COPY dockerize-linux-amd64-v0.5.0.tar.gz /tmp/
RUN tar -xz -C /usr/local/bin/ -f /tmp/dockerize-linux-amd64-v0.5.0.tar.gz \
    && rm /tmp/dockerize-linux-amd64-v0.5.0.tar.gz

ENV PATH="$PATH:/opt/restic-pg-dump/bin"

ENTRYPOINT ["/sbin/tini", "--", "entrypoint.sh"]
CMD ["crond.sh"]

WORKDIR /opt/restic-pg-dump/
COPY . /opt/restic-pg-dump/
