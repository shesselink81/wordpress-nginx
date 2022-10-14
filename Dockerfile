FROM bitnami/wordpress-nginx:6.0.2-debian-11-r2
USER 0
RUN apt-get install nano -y && apt-get remove curl -y && apt-get autoremove -y && apt-get clean -y && apt-get autoclean -y && rm -rf /var/lib/apt/lists/*
COPY ./updraftplus.zip /updraftplus.zip
RUN chown 1001:1001 /opt/bitnami/wordpress/wp-content && chown 1001:1001 /opt/bitnami/wordpress/wp-config.php && chown 1001:1001 /usr/local/share/ca-certificates/ && chown 1001:1001 /etc/ssl/certs/ && rm -r -d -f /opt/bitnami/wordpress/wp-content/uploads/*
EXPOSE 8080 8443
USER 1001
RUN chmod 755 /opt/bitnami/wordpress/wp-content && chmod 775 /opt/bitnami/wordpress/wp-config.php
