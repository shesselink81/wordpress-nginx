# Wordpress-Apache

Custom wordpress Docker image, from bitnami base image

Helm install example:
```console
helm repo add gh-shesselink81-public https://shesselink81.github.io/helm-charts/public-charts/
helm install wordpress-apache gh-shesselink81-public/wordpress-apache
```

Docker Compose example:
```console
curl -sSL https://raw.githubusercontent.com/shesselink81/wordpress-apache/main/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Helm Chart:
https://shesselink81.github.io/helm-charts/public-charts/wordpress-apache

Docker Hub:
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