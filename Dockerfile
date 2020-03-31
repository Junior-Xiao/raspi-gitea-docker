FROM multiarch/alpine:armv7-edge
LABEL maintainer="juniorxiao@hotmail.com"

EXPOSE 22 3000


RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    linux-pam \
    openssh \
    s6 \
    sqlite \
    su-exec \
    tzdata

RUN addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    -h /data/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git && \
  echo "git:$(dd if=/dev/urandom bs=24 count=1 status=none | base64)" | chpasswd

ENV USER git
ENV GITEA_CUSTOM /data/gitea

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]

COPY root /

ADD https://dl.gitea.io/gitea/1.11.3/gitea-1.11.3-linux-arm-6 /app/gitea/gitea
RUN chmod +x /app/gitea/gitea && ln -s /app/gitea/gitea /usr/local/bin/gitea
