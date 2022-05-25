FROM bitnami/wordpress:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"
USER 0
#RUN apt-get update && apt-get install -y --no-install-recommends nano wget net-tools iputils-ping
COPY ./updraftplus.zip /updraftplus.zip
RUN chown 1001:1001 /opt/bitnami/wordpress/wp-content
RUN chown 1001:1001 /opt/bitnami/wordpress/wp-config.php
RUN rm -r -d -f /opt/bitnami/wordpress/wp-content/uploads/*
EXPOSE 8080 8443
USER 1001
RUN chmod 755 /opt/bitnami/wordpress/wp-content
RUN chmod 775 /opt/bitnami/wordpress/wp-config.php
