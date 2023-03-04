FROM bitnami/wordpress-nginx:latest
USER 0
RUN install_packages nano wget
COPY ./updraftplus.zip /updraftplus.zip
COPY bitnami /opt/bitnami
COPY certs /certs
COPY ./default-https-server-block.conf /opt/bitnami/nginx/conf/server_blocks/default-https-server-block.conf
RUN chown -R 1001:root /certs && chown -R 1001:root /opt/bitnami/php && chown -R 1001:root /opt/bitnami/nginx && chown 1001:root /opt/bitnami/wordpress/wp-content && chown 1001:root /opt/bitnami/wordpress/wp-config.php && chown 1001:root /usr/local/share/ca-certificates/ && chown 1001:root /etc/ssl/certs/ && rm -r -d -f /opt/bitnami/wordpress/wp-content/uploads/*
EXPOSE 8080 8443
USER 1001
RUN chmod 755 /opt/bitnami/wordpress/wp-content && chmod 770 /opt/bitnami/wordpress/wp-config.php