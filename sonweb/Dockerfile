ARG BUILD_FROM=hassioaddons/base-amd64:1.4.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Setup base
RUN \
    apk add --no-cache \
        nginx=1.12.2-r3 \
        patch=2.7.5-r2 \
        php7-curl=7.1.17-r0 \
        php7-fpm=7.1.17-r0 \
        php7-json=7.1.17-r0 \
        php7-opcache=7.1.17-r0 \
        php7-session=7.1.17-r0 \
        php7-zip=7.1.17-r0 \
        php7=7.1.17-r0 \
    \
    && apk add --no-cache --virtual .build-dependencies \
        git=2.15.0-r1 \
    \
    && git clone --branch master --single-branch \
        https://github.com/reloxx13/SonWEB.git /var/www/sonweb \
    && git -C /var/www/sonweb checkout 74704ba33f7b4df0d5fd75c55253356edbb65029 \
    \
    && apk del --purge .build-dependencies \
    \
    && rm -f -r /var/www/sonweb/.git \
    && find /var/www/sonweb -type f -name ".htaccess" -depth -exec rm -f {} \; \
    && find /var/www/sonweb -type f -name "*.md" -depth -exec rm -f {} \; \
    && find /var/www/sonweb -type f -name ".gitignore" -depth -exec rm -f {} \; \
    && find /var/www/sonweb -type f -name ".empty" -depth -exec rm -f {} \;

# Copy root filesystem
COPY rootfs /

# Build arugments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="SonWEB" \
    io.hass.description="Centrally manage all your Sonoff-Tasmota devices" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Centrally manage all your Sonoff-Tasmota devices" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="SonWEB" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-sonweb/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-sonweb" \
    org.label-schema.vendor="Community Hass.io Addons"
