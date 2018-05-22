#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: SonWEB
# Applies patch to remove SelfUpdate, since that is useless shit in Docker
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

patch -F2 -R --ignore-whitespace /var/www/sonweb/includes/header.php <<'PATCH'
--- header.php	2018-05-22 00:00:00.463304792 +0200
+++ header.php	2018-05-22 00:00:00.291634513 +0200
@@ -178,6 +178,15 @@
 					</li>
 				<?php endif; ?>

+				<?php if ( $loggedin ): ?>
+					<li class="nav-item">
+						<a class="nav-link <?php echo $page == "selfupdate" ? "active" : ""; ?>"
+						   href='<?php echo _BASEURL_; ?>selfupdate'>
+							<?php echo __( "SELFUPDATE", "NAVI" ); ?>
+						</a>
+					</li>
+				<?php endif; ?>
+
 			</ul>


PATCH

# shellcheck disable=SC2181
if [[ "$?" -ne 0 ]];
then
    hass.die 'Patching SonWEB SelfUpdate failed'
fi

hass.log.debug 'Applied SonWEB SelfUpdate fix'
