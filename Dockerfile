FROM quay.io/devfile/base-developer-image:ubi8-latest AS build

ENV GODIR=/usr/local/go APPDIR=/opt/app CGO_ENABLED=0

USER 0

RUN curl -sfL --retry 10 -o /tmp/go.tar.gz https://go.dev/dl/go1.21.1.linux-amd64.tar.gz && \
    echo "b3075ae1ce5dab85f89bc7905d1632de23ca196bd8336afd93fa97434cfa55ae /tmp/go.tar.gz" | sha256sum -c && \
    mkdir -p $GODIR && \
    tar --strip-components=1 -zxf /tmp/go.tar.gz --directory $GODIR && \
    rm /tmp/go.tar.gz && \
    mkdir -p $APPDIR

ENV PATH="$GODIR/bin:$PATH"

WORKDIR $APPDIR/kubedock

COPY . $APPDIR

RUN CGO_ENABLED=0 go build -ldflags "\
  -X github.com/joyrex2001/kubedock/internal/config.Date=`date -u +%Y%m%d-%H%M%S`\
  -X github.com/joyrex2001/kubedock/internal/config.Build=`git rev-list -1 HEAD`\
  -X github.com/joyrex2001/kubedock/internal/config.Version=`git describe --tags`\
  -X github.com/joyrex2001/kubedock/internal/config.Image=joyrex2001/kubedock:`git describe --tags | cut -d- -f1`" \
  -o kubedock

FROM quay.io/devfile/base-developer-image:ubi8-latest

LABEL maintainer="Red Hat, Inc."

LABEL version="ubi8"
#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL description="Kubedock image based on UBI8."

USER 0

COPY --from=build /opt/app/kubedock/kubedock /usr/local/bin/kubedock

ENTRYPOINT ["/usr/local/bin/kubedock"]
CMD [ "server" ]
