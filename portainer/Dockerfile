ARG BUILD_FROM=hassioaddons/base:2.2.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Setup base
ARG BUILD_ARCH
RUN \
    if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    && if [ "${BUILD_ARCH}" = "armhf" ]; then ARCH="arm"; fi \
    && if [ "${BUILD_ARCH}" = "amd64" ]; then ARCH="amd64"; fi \
    \
    && mkdir /opt \
    \
    && curl -L -s \
        "https://github.com/portainer/portainer/releases/download/1.19.2/portainer-1.19.2-linux-${ARCH}.tar.gz" \
        | tar zxvf - -C /opt/

# Build arugments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="portainer" \
    io.hass.description="Manage your Docker environment with ease" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Manage your Docker environment with ease" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Portainer" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-portainer/68836?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-portainer/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-portainer" \
    org.label-schema.vendor="Community Hass.io Add-ons"
