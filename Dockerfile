FROM registry.access.redhat.com/ubi9/ubi:9.7-1767674301 AS build

USER 0

# Install kubedock
ARG KUBEDOCK_VERSION=0.17.0
RUN curl -L https://github.com/joyrex2001/kubedock/releases/download/${KUBEDOCK_VERSION}/kubedock_${KUBEDOCK_VERSION}_linux_amd64.tar.gz | tar -C /usr/local/bin -xz \
    && chmod +x /usr/local/bin/kubedock

FROM registry.access.redhat.com/ubi9/ubi-minimal:9.7-1768783948

ARG KUBEDOCK_VERSION=0.17.0

LABEL name="kubedock"
LABEL maintainer="Red Hat, Inc."
LABEL version="ubi9"
LABEL release="${KUBEDOCK_VERSION}"
LABEL vendor="Red Hat, Inc."
LABEL url="https://github.com/RedHatInsights/kubedock"
LABEL com.redhat.component="kubedock"
LABEL distribution-scope="public"
LABEL io.k8s.description="Kubedock image based on UBI9."

#label for EULA
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"

#labels for container catalog
LABEL description="Kubedock image based on UBI9."
COPY --from=build /usr/local/bin/kubedock /usr/local/bin/kubedock
ENTRYPOINT ["/usr/local/bin/kubedock"]
CMD [ "server" ]
