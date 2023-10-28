#Need add docker.io/ for podman
FROM docker.io/richarvey/nginx-php-fpm:3.1.6
COPY ./index.html /var/www/html/
COPY ./default.conf /etc/nginx/sites-available/
COPY ./www.conf /usr/local/etc/php-fpm.d/