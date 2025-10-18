#!/bin/bash
set -euo pipefail

echo "=== WordPress init script started ==="

# Zet veilige defaults
export WP_PATH="/var/www/html"
#export WP_CLI_PHP_ARGS="-d memory_limit=512M"
export WP_URL="${WP_URL:-http://192.168.30.177:8090}"

# Controleer database connectie voordat we verdergaan
echo "⏳ Wachten op database (${WORDPRESS_DB_HOST})..."
until mariadb-admin ping -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; do
  sleep 2
done
echo "✅ Database bereikbaar!"

# Controleer of WP al is geïnstalleerd
if php -d memory_limit=512M /usr/local/bin/wp core is-installed --path="${WP_PATH}" --allow-root >/dev/null 2>&1; then
  echo "ℹ️  WordPress is al geïnstalleerd — overslaan van init."
else
  echo "🚀 Nieuwe WordPress installatie gestart..."

  # Download core (indien nog niet aanwezig)
  if [ ! -f "${WP_PATH}/wp-settings.php" ]; then
    echo "⬇️  Downloaden van WordPress (${WP_LOCALE})..."
    php -d memory_limit=512M /usr/local/bin/wp core download --path="${WP_PATH}" --locale="${WP_LOCALE}" --allow-root
  fi

  # Config aanmaken als hij nog niet bestaat
  if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "⚙️  Aanmaken wp-config.php..."
    php -d memory_limit=512M /usr/local/bin/wp config create \
      --path="${WP_PATH}" \
      --dbname="${WORDPRESS_DB_NAME}" \
      --dbuser="${WORDPRESS_DB_USER}" \
      --dbpass="${WORDPRESS_DB_PASSWORD}" \
      --dbhost="${WORDPRESS_DB_HOST}" \
      --locale="${WP_LOCALE}" \
      --allow-root
  fi

  # Installatie uitvoeren
  echo "🧩 Installeren van WordPress..."
  php -d memory_limit=512M /usr/local/bin/wp core install \
    --path="${WP_PATH}" \
    --url="${WP_URL}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root

  echo "✅ WordPress installatie voltooid!"
fi

# Memcached ondersteuning inschakelen
if ping -c 1 memcached &>/dev/null; then
  echo "💾 Memcached server gevonden, plugin installeren..."
  if ! php -d memory_limit=512M /usr/local/bin/wp plugin is-installed memcached --path="${WP_PATH}" --allow-root; then
    php -d memory_limit=512M /usr/local/bin/wp plugin install memcached --allow-root --path="${WP_PATH}"
  # else
  #   php -d memory_limit=512M /usr/local/bin/wp plugin activate memcached --allow-root --path="${WP_PATH}" || true
  fi

  # Voeg caching aan wp-config toe (indien nog niet aanwezig)
  if ! grep -q "WP_CACHE" "${WP_PATH}/wp-config.php"; then
    echo "define('WP_CACHE', true);" >> "${WP_PATH}/wp-config.php"
  fi

  if ! grep -q "memcached_servers" "${WP_PATH}/wp-config.php"; then
    echo "\$memcached_servers = array( 'default' => array('memcached:11211') );" >> "${WP_PATH}/wp-config.php"
  fi

  echo "✅ Memcached caching geconfigureerd."
else
  echo "⚠️  Geen memcached service bereikbaar — overslaan caching setup."
fi

# File permissies herstellen
echo "🧾 Herstellen van permissies..."
chown -R 33:33 "${WP_PATH}"
chmod 755 "${WP_PATH}"/*

echo "🎉 Init script voltooid!"
