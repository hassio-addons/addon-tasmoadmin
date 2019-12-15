#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: TasmoAdmin
# Configures NGINX for use with TasmoAdmin
# ==============================================================================
declare certfile
declare keyfile

bashio::config.require.ssl

if bashio::config.true 'ssl'; then
    certfile=$(bashio::config 'certfile')
    keyfile=$(bashio::config 'keyfile')

    sed "s#%%certfile%%#${certfile}#g ; s#%%keyfile%%#${keyfile}#g" /etc/nginx/servers/direct-ssl.disabled > /etc/nginx/servers/direct-ssl.conf
else
    cp /etc/nginx/servers/direct.disabled /etc/nginx/servers/direct.conf
fi
