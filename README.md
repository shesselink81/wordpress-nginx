# Wordpress-Apache
Custom wordpress Docker image, from bitnami base image

Docker Hub:
https://hub.docker.com/r/hessanheutinkict/wordpress

Helm install example:
* helm repo add bitnami https://charts.bitnami.com/bitnami
* helm install wordpress bitnami/wordpress -f "https://raw.githubusercontent.com/shesselink81/wordpress-apache/main/Example-Settings.yaml" --set mariadb.metrics.enabled=true --set wordpressPassword=[password] --set mariadb.auth.rootPassword=[password] --set mariadb.auth.password=[password] --set mariadb.auth.replicationPassword=[password] --set mariadb.metrics.serviceMonitor.enabled=true --set mariadb.metrics.serviceMonitor.namespace=monitoring --set ingress.certManager=true

Version info:
* Wordpress version:  5.6
* Apache version:     2.4
* PHP version:        7.4

Installed php extensions:
* redis v5.3.1
* memcached v3.1.5
* ssh2 v1.2
  
Installed extra packages:
* nano
* wget
* net-tools
* iputils-ping
* unzip
