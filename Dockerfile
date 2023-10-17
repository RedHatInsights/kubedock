FROM quay.io/devfile/base-developer-image:ubi8-latest AS build
LABEL maintainer="Red Hat, Inc."

LABEL version="ubi8"
#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL description="Kubedock image based on UBI8."

USER 0

# Install kubedock
ENV KUBEDOCK_VERSION 0.13.0
RUN curl -L https://github.com/joyrex2001/kubedock/releases/download/${KUBEDOCK_VERSION}/kubedock_${KUBEDOCK_VERSION}_linux_amd64.tar.gz | tar -C /usr/local/bin -xz \
    && chmod +x /usr/local/bin/kubedock

ENTRYPOINT ["/usr/local/bin/kubedock"]
CMD [ "server" ]
