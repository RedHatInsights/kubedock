FROM registry.access.redhat.com/ubi9/ubi:latest AS build

USER 0

# Install kubedock
ENV KUBEDOCK_VERSION 0.14.0
RUN curl -L https://github.com/joyrex2001/kubedock/releases/download/${KUBEDOCK_VERSION}/kubedock_${KUBEDOCK_VERSION}_linux_amd64.tar.gz | tar -C /usr/local/bin -xz \
    && chmod +x /usr/local/bin/kubedock

FROM registry.access.redhat.com/ubi9/ubi-minimal:9.3-1361.1699548032

LABEL maintainer="Red Hat, Inc."

LABEL version="ubi8"
#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL description="Kubedock image based on UBI8."
COPY --from=build /usr/local/bin/kubedock /usr/local/bin/kubedock
ENTRYPOINT ["/usr/local/bin/kubedock"]
CMD [ "server" ]
