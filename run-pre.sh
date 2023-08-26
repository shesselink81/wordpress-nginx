#!/bin/sh

mkdir -p /opt/bitnami
mkdir -p /usr/html
ln -s /usr/html /opt/bitnami/wordpress
cd /usr/html
wp-cli core download --locale=en_GB
wp-cli config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$DB_HOST --locale=en_GB
wp-cli core install --url=$VIRTUAL_HOST --title=Example --admin_user=$WORDPRESS_USER --admin_password=$WORDPRESS_PASSWORD --admin_email=$WORDPRESS_EMAIL
wp-cli plugin install https://updraftplus.com/wp-content/uploads/updraftplus.zip
wp-cli plugin install w3-total-cache
wp-cli plugin install jetpack
wp-cli plugin install contact-form-7
wp-cli plugin install ics-calendar
wp-cli plugin install spotify-play-button-for-wordpress
wp-cli plugin install youtube-embed-plus
wp-cli plugin activate w3-total-cache
wp-cli total-cache fix_environment
wp-cli total-cache option set dbcache.engine memcached --type=string
wp-cli total-cache option set objectcache.engine memcached --type=string
wp-cli total-cache flush all
wp-cli total-cache option set dbcache.memcached.servers memcached:11211 --type=string
wp-cli total-cache option set dbcache.enabled true --type=boolean
wp-cli total-cache option set objectcache.memcached.servers memcached:11211 --type=string
wp-cli total-cache option set objectcache.enabled true --type=boolean
wp-cli total-cache flush all
wp-cli plugin auto-updates enable --all
wp-cli plugin activate --all