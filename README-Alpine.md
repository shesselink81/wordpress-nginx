docker build -f .\DockerfileAlpine --no-cache -t quay.io/shesselink81/wordpress-nginx:alpine-latest .
docker compose -f .\docker-compose-alpine.yml up -d

cd /usr/html
wp-cli core download --locale=en_GB
wp-cli config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$DB_HOST --locale=en_GB
wp-cli core install --url=$VIRTUAL_HOST --title=Example --admin_user=$WORDPRESS_USER --admin_password=$WORDPRESS_PASSWORD --admin_email=$WORDPRESS_EMAIL
