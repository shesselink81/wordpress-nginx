ARG IMAGE_NAME
FROM ${IMAGE_NAME}

ARG NEW_RELIC_AGENT_VERSION
ARG NEW_RELIC_LICENSE_KEY
ARG NEW_RELIC_APPNAME
ARG NEW_RELIC_DAEMON_ADDRESS
USER 0
RUN curl -L "https://download.newrelic.com/php_agent/archive/${NEW_RELIC_AGENT_VERSION}/newrelic-php5-${NEW_RELIC_AGENT_VERSION}-linux.tar.gz" | tar -C /tmp -zx \
 && export NR_INSTALL_USE_CP_NOT_LN=1 \
 && export NR_INSTALL_SILENT=1 \
 && /tmp/newrelic-php5-*/newrelic-install install \
 && rm -rf /tmp/newrelic-php5-* /tmp/nrinstall*

RUN sed -i -e s/\"REPLACE_WITH_REAL_KEY\"/${NEW_RELIC_LICENSE_KEY}/ \    
 -e s/newrelic.appname[[:space:]]=[[:space:]].\*/newrelic.appname="${NEW_RELIC_APPNAME}"/ \
 -e s/\;newrelic.daemon.address[[:space:]]=[[:space:]].\*/newrelic.daemon.address="${NEW_RELIC_DAEMON_ADDRESS}"/ \
    $(php -r "echo(PHP_CONFIG_FILE_SCAN_DIR);")/newrelic.ini

RUN chown 1001:1001 $(php -r "echo(PHP_CONFIG_FILE_SCAN_DIR);")/newrelic.ini
RUN chmod 755 $(php -r "echo(PHP_CONFIG_FILE_SCAN_DIR);")/newrelic.ini
USER 1001