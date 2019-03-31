#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: TasmoAdmin
# Migrates data from sonweb to TasmoAdmin
# ==============================================================================
if bashio::fs.directory_exists "/data/sonweb"; then
    bashio::log.info 'Migrating data from sonweb to tasmoadmin...'

    # Rename data folder
    mv /data/sonweb /data/tasmoadmin

    # Ensure file permissions
    chown -R nginx:nginx /data/tasmoadmin
    find /data/tasmoadmin -not -perm 0644 -type f -exec chmod 0644 {} \;
    find /data/tasmoadmin -not -perm 0755 -type d -exec chmod 0755 {} \;
fi
