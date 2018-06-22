#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: TasmoAdmin
# Migrates data from sonweb to TasmoAdmin
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if hass.directory_exists "/data/sonweb"; then
    hass.log.info 'Migrating data from sonweb to tasmoadmin...'

    # Rename data folder
    mv /data/sonweb /data/tasmoadmin

    # Ensure file permissions
    chown -R nginx:nginx /data/tasmoadmin
    find /data/tasmoadmin -not -perm 0644 -type f -exec chmod 0644 {} \;
    find /data/tasmoadmin -not -perm 0755 -type d -exec chmod 0755 {} \;
fi
