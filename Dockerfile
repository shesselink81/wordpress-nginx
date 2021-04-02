FROM quay.io/bitnami/wordpress:5-debian-10
LABEL maintainer "Bitnami <containers@bitnami.com>"

USER 0
RUN apt-get update && apt-get install -y --no-install-recommends nano wget net-tools iputils-ping unzip pkg-config autoconf build-essential
RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libmagickwand-dev \
		libpng-dev \
		libzip-dev \
	; \
	\
	pecl install imagick-3.4.4; \
	pecl install redis-5.3.2; \
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
RUN echo 'extension=redis.so' >> /opt/bitnami/php/lib/php.ini
RUN echo 'extension=imagick.so' >> /opt/bitnami/php/lib/php.ini
RUN sed -i -r 's/#LoadModule ext_filter_module/LoadModule ext_filter_module/' /opt/bitnami/apache/conf/httpd.conf
RUN sed -i -r 's/#LoadModule expires_module/LoadModule expires_module/' /opt/bitnami/apache/conf/httpd.conf
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
COPY ./app-entrypoint.sh /app-entrypoint.sh
RUN chmod 755 /app-entrypoint.sh
RUN rm -r -d -f /opt/bitnami/wordpress/wp-content/uploads/*
