#!/bin/bash -e

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "httpd" ]]; then
    . /apache-init.sh
    . /wordpress-init.sh
    nami_initialize apache mysql-client wordpress
    info "Starting gosu... "
    . /post-init.sh
fi

if [[ ! -f "/bitnami/wordpress/.user_scripts1_initialized" ]]; then
    wp plugin update --all
    wp theme update --all
    wp config delete WP_AUTO_UPDATE_CORE
    echo php_value upload_max_filesize 256M > /bitnami/wordpress/.htaccess
    echo php_value post_max_size 256M >> /bitnami/wordpress/.htaccess
    echo php_value memory_limit 512M >> /bitnami/wordpress/.htaccess
    echo php_value max_execution_time 600 >> /bitnami/wordpress/.htaccess
    echo php_value max_input_time 600 >> /bitnami/wordpress/.htaccess
    #chmod 755 /opt/bitnami/wordpress/wp-content
    chmod 775 /opt/bitnami/wordpress/wp-config.php
    wp plugin activate w3-total-cache
    touch "/bitnami/wordpress/.user_scripts1_initialized"
fi
exec tini -- "$@"
