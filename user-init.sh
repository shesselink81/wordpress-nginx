#!/bin/bash

if [[ ! -f "/opt/bitnami/wordpress/wp-content/.user_scripts1_initialized" ]]; then
    chmod 775 /opt/bitnami/wordpress/wp-config.php
    wp plugin install /updraftplus.zip --activate
    wp plugin delete all-in-one-seo-pack
    wp plugin delete amazon-polly
    wp plugin delete google-analytics-for-wordpress
    wp plugin delete wp-mail-smtp
    wp plugin delete amp
    wp plugin auto-updates enable --all
    wp plugin activate --all
    wp config delete WP_AUTO_UPDATE_CORE
    touch "/opt/bitnami/wordpress/wp-content/.user_scripts1_initialized"
fi