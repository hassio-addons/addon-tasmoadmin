ARG BUILD_FROM=hassioaddons/base:4.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
RUN \
    apk add --no-cache \
        nginx=1.16.0-r2 \
        php7-curl=7.3.6-r0 \
        php7-fpm=7.3.6-r0 \
        php7-json=7.3.6-r0 \
        php7-opcache=7.3.6-r0 \
        php7-session=7.3.6-r0 \
        php7-zip=7.3.6-r0 \
        php7=7.3.6-r0 \
    \
    && apk add --no-cache --virtual .build-dependencies \
        git=2.22.0-r0 \
    \
    && git clone --branch v1.6.1-beta1 --depth=1 \
        https://github.com/reloxx13/TasmoAdmin.git /var/www/tasmoadmin \
    \
    && apk del --purge .build-dependencies \
    \
    && rm -f -r /var/www/tasmoadmin/.git \
    && find /var/www/tasmoadmin -type f -name ".htaccess" -depth -exec rm -f {} \; \
    && find /var/www/tasmoadmin -type f -name "*.md" -depth -exec rm -f {} \; \
    && find /var/www/tasmoadmin -type f -name ".gitignore" -depth -exec rm -f {} \; \
    && find /var/www/tasmoadmin -type f -name ".empty" -depth -exec rm -f {} \;

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="TasmoAdmin" \
    io.hass.description="Centrally manage all your Sonoff-Tasmota devices" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Centrally manage all your Sonoff-Tasmota devices" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="TasmoAdmin" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-tasmoadmin/54155?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-tasmoadmin/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-tasmoadmin" \
    org.label-schema.vendor="Community Hass.io Addons"
