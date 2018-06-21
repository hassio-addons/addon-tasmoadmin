#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: TasmoAdmin
# Ensures data is store in a persistent location
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if ! hass.directory_exists "/data/tasmoadmin"; then
    hass.log.debug 'Data directory not initialized, doing that now...'

    # Setup structure
    cp -R /var/www/tasmoadmin/tasmoadmin/data /data/tasmoadmin

    # Ensure file permissions
    chown -R nginx:nginx /data/tasmoadmin
    find /data/tasmoadmin -not -perm 0644 -type f -exec chmod 0644 {} \;
    find /data/tasmoadmin -not -perm 0755 -type d -exec chmod 0755 {} \;
fi

hass.log.debug 'Symlinking data directory to persistent storage location...'
rm -f -r /var/www/tasmoadmin/tasmoadmin/data
ln -s /data/tasmoadmin /var/www/tasmoadmin/tasmoadmin/data
