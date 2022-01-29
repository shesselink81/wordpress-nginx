FROM quay.io/bitnami/wordpress
LABEL maintainer "Bitnami <containers@bitnami.com>"

USER 0
RUN apt-get update && apt-get install -y --no-install-recommends nano wget net-tools iputils-ping unzip pkg-config autoconf build-essential pkg-config
RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libzip-dev \
		libltdl-dev \
	; \
	\
	pecl install redis-5.3.4; \
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual
RUN echo 'extension=redis.so' >> /opt/bitnami/php/lib/php.ini
RUN sed -i -r 's/#LoadModule ext_filter_module/LoadModule ext_filter_module/' /opt/bitnami/apache/conf/httpd.conf
RUN sed -i -r 's/#LoadModule expires_module/LoadModule expires_module/' /opt/bitnami/apache/conf/httpd.conf
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
COPY ./post-init.sh /post-init.d/user-init.sh
COPY ./ImageMagick.tar.gz /ImageMagick.tar.gz
RUN tar xvzf ImageMagick.tar.gz
RUN cd ImageMagick-7.1.0-4
RUN chmod 755 /ImageMagick-7.1.0-4/configure
RUN sh /ImageMagick-7.1.0-4/configure --with-modules
RUN make
RUN make install
RUN ldconfig /usr/local/lib
RUN pecl install imagick
COPY ./updraftplus.zip /updraftplus.zip
RUN apt-get purge pkg-config autoconf build-essential -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
RUN rm -rf /var/lib/apt/lists/*
RUN chown 1001:1001 /opt/bitnami/wordpress/wp-content
RUN chown 1001:1001 /opt/bitnami/wordpress/wp-config.php
RUN rm -r -d -f /opt/bitnami/wordpress/wp-content/uploads/*
COPY ./entrypoint.sh /opt/bitnami/scripts/wordpress/entrypoint.sh
RUN chmod 775 /opt/bitnami/scripts/wordpress/entrypoint.sh
RUN chmod 775 /post-init.d/user-init.sh
EXPOSE 8080 8443
USER 1001
RUN chmod 755 /opt/bitnami/wordpress/wp-content
RUN chmod 775 /opt/bitnami/wordpress/wp-config.php
ENTRYPOINT [ "/opt/bitnami/scripts/wordpress/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]