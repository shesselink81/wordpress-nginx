FROM bitnami/wordpress:5-debian-10
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
RUN apt-get update && apt-get install -y --no-install-recommends nano wget net-tools iputils-ping unzip autoconf build-essential libssh2-1-dev libssh2-1 php-imagick pkg-config libmagickwand-dev
RUN pecl install redis-5.3.2 \
	&& pecl install ssh2-1.2 \
    && pecl install imagick-3.4.4
RUN echo 'extension=redis.so' >> /opt/bitnami/php/lib/php.ini
RUN echo 'extension=ssh2.so' >> /opt/bitnami/php/lib/php.ini
RUN echo 'extension=imagick.so' >> /opt/bitnami/php/lib/php.ini
RUN sed -i -r 's/#LoadModule expires_module/LoadModule expires_module/' /opt/bitnami/apache/conf/httpd.conf
RUN sed -i -r 's/#LoadModule filter_module/LoadModule filter_module/' /opt/bitnami/apache/conf/httpd.conf
RUN sed -i -r 's/#LoadModule ext_filter_module/LoadModule ext_filter_module/' /opt/bitnami/apache/conf/httpd.conf
RUN sed -i -r 's/#LoadModule imagick_module/LoadModule imagick_module/' /opt/bitnami/apache/conf/httpd.conf
RUN apt remove build-essential libssh2-1-dev -y
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
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
	; \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*
COPY ./app-entrypoint.sh /app-entrypoint.sh
RUN chmod 755 /app-entrypoint.sh
## Revert to the original non-root user
USER 1001