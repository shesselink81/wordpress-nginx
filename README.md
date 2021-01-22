# Wordpress-Apache
Custom wordpress Docker image, from bitnami base image

Helm install example:
* helm repo add center https://repo.chartcenter.io
* helm install wordpress-apache center/gh-shesselink81/wordpress-apache

Docker Compose example:
* curl -sSL https://raw.githubusercontent.com/shesselink81/wordpress-apache/main/docker-compose.yml > docker-compose.yml
* docker-compose up -d

Helm Chart
https://chartcenter.io/gh-shesselink81/wordpress-apache

Docker Hub
https://hub.docker.com/r/shesselink81/wordpress-apache

Version info:
* Wordpress version:  5.6
* Apache version:     2.4
* PHP version:        7.4

Installed php extensions:
* redis v5.3.2
* memcached v3.1.5
* ssh2 v1.2
* imagick v3.4.4
  
Installed extra packages:
* nano
* wget
* net-tools
* iputils-ping
* unzip