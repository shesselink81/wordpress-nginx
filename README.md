# wordpress-nginx

Custom wordpress Docker image, from bitnami base image

Helm install example:

```console
helm repo add gh-shesselink81-public https://shesselink81.github.io/helm-charts/public-charts/
helm install wordpress-nginx gh-shesselink81-public/wordpress-nginx
```

Docker Compose example:

```console
curl -sSL https://raw.githubusercontent.com/shesselink81/wordpress-nginx/main/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

Helm Chart:
<https://artifacthub.io/packages/helm/gh-shesselink81-public/wordpress-nginx>

Docker images:
<https://quay.io/repository/shesselink81/wordpress-nginx?tab=tags>

Version info:

* Wordpress version:  6.2
* Nginx version:      1.23
* PHP version:        8.0

Installed php extensions:

* memcached v1.6
* imagick v3.7
