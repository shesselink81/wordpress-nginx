FROM bitnami/wordpress
LABEL maintainer "Bitnami <containers@bitnami.com>"

## Change user to perform privileged actions
USER 0
## Install 'vim'
RUN install_packages nano wget net-tools iputils-ping unzip autoconf build-essential libssh2-1-dev libssh2-1 libphp-predis
RUN pecl install redis-5.3.2 && pecl install ssh2-1.2
RUN echo 'extension=redis.so' >> /opt/bitnami/php/lib/php.ini
RUN echo 'extension=ssh2.so' >> /opt/bitnami/php/lib/php.ini
RUN sed -i -r 's/#LoadModule expires_module/LoadModule expires_module/' /opt/bitnami/apache/conf/httpd.conf
RUN sed -i -r 's/#LoadModule filter_module/LoadModule filter_module/' /opt/bitnami/apache/conf/httpd.conf
RUN sed -i -r 's/#LoadModule ext_filter_module/LoadModule ext_filter_module/' /opt/bitnami/apache/conf/httpd.conf
RUN apt remove build-essential libssh2-1-dev -y
RUN apt autoremove -y
COPY README.md /opt/bitnami/README.md
## Revert to the original non-root user
USER 1001
## TEST
##