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
    echo php_value upload_max_filesize 256M > /opt/bitnami/wordpress/.htaccess
    echo php_value post_max_size 256M >> /opt/bitnami/wordpress/.htaccess
    echo php_value memory_limit 512M >> /opt/bitnami/wordpress/.htaccess
    echo php_value max_execution_time 600 >> /opt/bitnami/wordpress/.htaccess
    echo php_value max_input_time 600 >> /opt/bitnami/wordpress/.htaccess
    touch "/opt/bitnami/wordpress/wp-content/.user_scripts1_initialized"
fi