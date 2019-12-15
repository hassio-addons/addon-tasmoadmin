#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: TasmoAdmin
# Configures Hass.io Ingress for use with TasmoAdmin
# ==============================================================================


# The general idea is that the nginx server will be configured to have a root of
# /var/www/ingress. Then the actual application files will be hosted in a 
# sub-path within that root directory that matches the ingress path. However the
# actual hass.io ingress request will still be hitting the root path, so the
# nginx server will proxy requests to the ingress sub-path 
# (i.e. /api/hassio_ingress/blahblah). The reason this is important is that 
# tasmoadmin determines the baseurl by the url path. So in order for it to be
# able to redirect to /api/hassio_ingress/blahblah/login, we need to be
# requesting using that same (/api/hassio_ingress/blahblah) base url.

declare ingress_root_dir=/var/www/ingress
declare app_root_dir=/var/www/tasmoadmin/tasmoadmin
declare ingress_entry="$(bashio::addon.ingress_entry)"
declare ingress_dir="${ingress_root_dir}${ingress_entry}"

# Create nginx server
sed "s#%%ingress_entry%%#${ingress_entry}#g" \
    /etc/nginx/servers/ingress.template > /etc/nginx/servers/ingress.conf

# Setup application filesystem as symlink to the app
mkdir -p "$(dirname ${ingress_dir})"
ln -s "${app_root_dir}" "${ingress_dir}"

# Create special config class file for ingress
awk '1;/public function read\(/{ print "if ($key == \"login\" && @$_SERVER[\"ASSUMED_AUTH\"] == \"1\") return \"0\";"}' \
    "${app_root_dir}/includes/Config.php" > "${app_root_dir}/includes/IngressConfig.php"

cat << EOF > "${app_root_dir}/includes/IngressInit.php"
<?php
spl_autoload_register(function (\$class) {
    \$file = "${app_root_dir}/includes/IngressConfig.php";
    if (\$class == 'Config' && file_exists(\$file)) {
        require \$file;
        return true;
    }
    return false;
});
EOF


