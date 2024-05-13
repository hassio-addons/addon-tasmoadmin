ARG BUILD_FROM=ghcr.io/hassio-addons/base:15.0.8

# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG TASMOADMIN_VERSION="v4.1.0"

# hadolint ignore=DL3003
RUN \
    apk add --no-cache \
        nginx=1.24.0-r16 \
        php82-curl=8.2.19-r0 \
        php82-dom=8.2.19-r0 \
        php82-fpm=8.2.19-r0 \
        php82-iconv=8.2.19-r0 \
        php82-mbstring=8.2.19-r0 \
        php82-opcache=8.2.19-r0 \
        php82-session=8.2.19-r0 \
        php82-zip=8.2.19-r0 \
        php82=8.2.19-r0 \
    \
    && apk add --no-cache --virtual .build-dependencies \
        composer=2.7.6-r0 \
    \
    && curl -J -L -o /tmp/tasmoadmin.tar.gz \
        "https://github.com/TasmoAdmin/TasmoAdmin/releases/download/${TASMOADMIN_VERSION}/tasmoadmin_${TASMOADMIN_VERSION}.tar.gz" \
    && mkdir -p /var/www/tasmoadmin \
    && tar zxf /tmp/tasmoadmin.tar.gz -C \
        /var/www/tasmoadmin --strip-components=1 \
    \
    && cd /var/www/tasmoadmin \
    && rm -r vendor \
    && composer install --no-dev --optimize-autoloader \
    \
    && apk del --no-cache --purge .build-dependencies \
    \
    && rm -f -r \
        /root/.composer \
        /var/www/tasmoadmin/tests \
    \
    && find /var/www/tasmoadmin -type f -name ".htaccess" -depth -exec rm -f {} \; \
    && find /var/www/tasmoadmin -type f -name "*.md" -depth -exec rm -f {} \; \
    && find /var/www/tasmoadmin -type f -name ".gitignore" -depth -exec rm -f {} \; \
    && find /var/www/tasmoadmin -type f -name ".empty" -depth -exec rm -f {} \;

# Copy root filesystem
COPY rootfs /

# Health check
HEALTHCHECK CMD if ! curl --fail http://127.0.0.1:9541  && ! curl --fail --insecure https://127.0.0.1:9541; then exit 1; fi

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
