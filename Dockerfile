FROM bitnami/wordpress-nginx:latest
USER root
RUN apt-get update && apt-get install -y --no-install-recommends nano wget
RUN apt-get autoremove -y && apt-get clean -y && apt-get autoclean -y && rm -rf /var/lib/apt/lists/*
COPY ./updraftplus.zip /updraftplus.zip
COPY bitnami /opt/bitnami
COPY ./default-https-server-block.conf /opt/bitnami/nginx/conf/server_blocks/default-https-server-block.conf
RUN chown -R daemon:root /opt/bitnami/php && chown -R daemon:root /opt/bitnami/nginx && chown daemon:root /opt/bitnami/wordpress/wp-content && chown daemon:root /opt/bitnami/wordpress/wp-config.php && chown daemon:root /usr/local/share/ca-certificates/ && chown daemon:root /etc/ssl/certs/ && rm -r -d -f /opt/bitnami/wordpress/wp-content/uploads/*
EXPOSE 8080 8443
USER daemon
RUN chmod 755 /opt/bitnami/wordpress/wp-content && chmod 770 /opt/bitnami/wordpress/wp-config.php
