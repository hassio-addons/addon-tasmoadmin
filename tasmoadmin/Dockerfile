ARG BUILD_FROM=ghcr.io/hassio-addons/base:13.1.4
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
ARG TASMOADMIN_VERSION="v3.0.1"
# hadolint ignore=DL3003
RUN \
    apk add --no-cache \
        nginx=1.22.1-r0 \
        php81-curl=8.1.17-r0 \
        php81-dom=8.1.17-r0 \
        php81-fpm=8.1.17-r0 \
        php81-iconv=8.1.17-r0 \
        php81-mbstring=8.1.17-r0 \
        php81-opcache=8.1.17-r0 \
        php81-session=8.1.17-r0 \
        php81-zip=8.1.17-r0 \
        php81=8.1.17-r0 \
    \
    && apk add --no-cache --virtual .build-dependencies \
        composer=2.4.4-r0 \
        git=2.38.4-r1 \
        nodejs=18.14.2-r0 \
        npm=9.1.2-r0 \
    \
    && git clone --branch "${TASMOADMIN_VERSION}" --depth=1 \
        "https://github.com/TasmoAdmin/TasmoAdmin.git" /var/www/tasmoadmin \
    \
    && cd /var/www/tasmoadmin/tasmoadmin \
    && composer install --no-dev \
    \
    && npm ci \
    && node minify.js \
    && NODE_ENV=production npm ci \
    \
    && apk del --no-cache --purge .build-dependencies \
    \
    && rm -f -r \
        /root/.composer \
        /root/.npm \
        /var/www/tasmoadmin/.docker \
        /var/www/tasmoadmin/.git \
        /var/www/tasmoadmin/.github \
        /var/www/tasmoadmin/.iocage \
        /var/www/tasmoadmin/docker-compose.yml \
        /var/www/tasmoadmin/tasmoadmin/tests \
    \
    && find /var/www/tasmoadmin -type f -name ".htaccess" -depth -exec rm -f {} \; \
    && find /var/www/tasmoadmin -type f -name "*.md" -depth -exec rm -f {} \; \
    && find /var/www/tasmoadmin -type f -name ".gitignore" -depth -exec rm -f {} \; \
    && find /var/www/tasmoadmin -type f -name ".empty" -depth -exec rm -f {} \;

# Copy root filesystem
COPY rootfs /

# Health check
HEALTHCHECK CMD [[ "curl --fail http://127.0.0.1:9541" ] || [ "curl --fail --insecure https://127.0.0.1:9541" ]] || exit 1

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
