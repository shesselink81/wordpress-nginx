#!/bin/bash
echo "Starting init script..."

# WP-CLI wrapper: always set path, and append --debug when DEBUG=true
wp() {
  if [ "${DEBUG}" = "true" ]; then
    command wp --path="${WORDPRESS_PATH}" --debug "$@"
  else
    command wp --path="${WORDPRESS_PATH}" "$@"
  fi
}

# Helper to run commands with optional output suppression.
# If DEBUG is true, run the command verbosely; otherwise suppress stdout+stderr.
run() {
  if [ "${DEBUG}" = "true" ]; then
    "$@"
  else
    "$@" >/dev/null 2>&1
  fi
}

# Wait for database to be ready
echo "Waiting for database..."
until run wp db check; do
  echo "Database not ready yet, waiting 15 seconds..."
  sleep 15
done

# wait to get ready
# sleep 20
# Activate maintenance mode during setup
if ! run wp maintenance-mode is-active --url="${WP_URL}"; then
  run wp maintenance-mode activate --force --url="${WP_URL}"
else
  run wp maintenance-mode status --url="${WP_URL}"
fi

# set up WordPress
if [ "${WP_INIT}" = "true" ]; then
  # Check if WordPress database is already installed
  if ! run wp core is-installed --url="${WP_URL}"; then
    echo "Setting up WordPress..."
    run wp core install \
      --url="${WP_URL}" \
      --title="${WP_TITLE}" \
      --admin_user="${WP_ADMIN_USER}" \
      --admin_password="${WP_ADMIN_PASSWORD}" \
      --admin_email="${WP_ADMIN_EMAIL}" \
      --skip-email \
      --locale="${WP_LOCALE}"
  else
    echo "WordPress is already installed, skipping installation."
  fi

  # set up localization
  if [ -n "${WP_LOCALE}" ]; then
    # Set language if WordPress is already installed
    LANG_STATUS=$(wp language core list --language=${WP_LOCALE} --field=status)
    case $LANG_STATUS in
      "uninstalled")
        wp language core install ${WP_LOCALE} --activate
        ;;
      "installed")
        wp site switch-language ${WP_LOCALE}
        ;;
    esac
  fi

  # Set Wordpress permalinks
  echo "Setting WordPress permalinks..."
  if [ ! -z "${WP_PERMALINK_STRUCTURE}" ]; then
    wp rewrite structure "${WP_PERMALINK_STRUCTURE}"
    wp rewrite flush
  fi

  # Set user metadata
  echo "Setting user metadata..."
  if [ ! -z "${WP_ADMIN_FIRSTNAME}" ]; then
    wp user meta update "$WP_ADMIN_USER" first_name "$WP_ADMIN_FIRSTNAME"
  fi
  if [ ! -z "${WP_ADMIN_LASTNAME}" ]; then
    wp user meta update "$WP_ADMIN_USER" last_name "$WP_ADMIN_LASTNAME"
  fi
fi

# Handle WordPress users if specified
echo "Creating custom users..."
USER_USERNAME="johndoe"
USER_EMAIL="johndoe@example.com"
USER_DISPLAYNAME="john doe"
USER_FIRSTNAME="john"
USER_LASTNAME="doe"
USER_ROLE="contributor"
USER_SENDEMAIL=""

# Check if user already exists
if ! run wp user get "${USER_USERNAME}"; then
  echo "Creating user ${USER_USERNAME}..."
  run wp user create "${USER_USERNAME}" "${USER_EMAIL}" \
    --role="${USER_ROLE}" \
    --display_name="${USER_DISPLAYNAME}" \
    --first_name="${USER_FIRSTNAME}" \
    --last_name="${USER_LASTNAME}" \
    --send-email="${USER_SENDEMAIL}"
else
  echo "User ${USER_USERNAME} already exists, skipping."
fi




# Handle WordPress metrics plugin if specified
if [ ! -z "${WORDPRESS_METRICS}" ]; then
  # Check if plugin is installed
  if run wp plugin is-installed ${WORDPRESS_METRICS}; then
    if ! run wp plugin is-active ${WORDPRESS_METRICS}; then
      run wp plugin activate ${WORDPRESS_METRICS}
    fi
  else
    echo "Installing WordPress metrics plugin..."
    wp plugin install ${WORDPRESS_METRICS} --activate --force
  fi

  # Enable auto-updates if disabled
  AUTO_UPDATE_STATUS=$(wp plugin auto-updates status ${WORDPRESS_METRICS} --field=status 2>/dev/null)
  if [ "$AUTO_UPDATE_STATUS" = "disabled" ]; then
    run wp plugin auto-updates enable ${WORDPRESS_METRICS}
  fi
else
  # Remove plugin if WORDPRESS_METRICS is empty
  if run wp plugin is-installed ${WORDPRESS_METRICS}; then
    wp plugin delete ${WORDPRESS_METRICS}
  fi
fi

# Handle WordPress plugins if specified
echo "Installing custom plugins..."
PLUGIN_NAME="plugin-check"
PLUGIN_VERSION=""
PLUGIN_ACTIVATE="true"
PLUGIN_AUTOUPDATE="true"

# Check if plugin is installed
if ! run wp plugin is-installed "${PLUGIN_NAME}"; then
  # Install the plugin
  if [ -n "${PLUGIN_VERSION}" ]; then
    wp plugin install "${PLUGIN_NAME}" --version="${PLUGIN_VERSION}" --force
  else
    wp plugin install "${PLUGIN_NAME}" --force
  fi
fi

# Activate if requested and not active
if [ "${PLUGIN_ACTIVATE}" = "true" ] && ! run wp plugin is-active "${PLUGIN_NAME}"; then
  run wp plugin activate "${PLUGIN_NAME}"
fi

# Enable auto-updates if requested and not enabled
AUTO_UPDATE_STATUS=$(wp plugin auto-updates status "${PLUGIN_NAME}" --field=status 2>/dev/null)
if [ "${PLUGIN_AUTOUPDATE}" = "true" ] && [ "$AUTO_UPDATE_STATUS" = "disabled" ]; then
  run wp plugin auto-updates enable "${PLUGIN_NAME}"
fi
PLUGIN_NAME="https://updraftplus.com/wp-content/uploads/updraftplus.zip"
PLUGIN_VERSION=""
PLUGIN_ACTIVATE="true"
PLUGIN_AUTOUPDATE="true"

# Check if plugin is installed
if ! run wp plugin is-installed "${PLUGIN_NAME}"; then
  # Install the plugin
  if [ -n "${PLUGIN_VERSION}" ]; then
    wp plugin install "${PLUGIN_NAME}" --version="${PLUGIN_VERSION}" --force
  else
    wp plugin install "${PLUGIN_NAME}" --force
  fi
fi

# Activate if requested and not active
if [ "${PLUGIN_ACTIVATE}" = "true" ] && ! run wp plugin is-active "${PLUGIN_NAME}"; then
  run wp plugin activate "${PLUGIN_NAME}"
fi

# Enable auto-updates if requested and not enabled
AUTO_UPDATE_STATUS=$(wp plugin auto-updates status "${PLUGIN_NAME}" --field=status 2>/dev/null)
if [ "${PLUGIN_AUTOUPDATE}" = "true" ] && [ "$AUTO_UPDATE_STATUS" = "disabled" ]; then
  run wp plugin auto-updates enable "${PLUGIN_NAME}"
fi

# Deactivate maintenance mode
if run wp maintenance-mode is-active; then
  wp maintenance-mode deactivate
fi

echo "Init script completed!"