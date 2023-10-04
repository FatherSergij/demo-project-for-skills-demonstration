FROM docker.io/richarvey/nginx-php-fpm #Need add docker.io/ for podman
COPY ./index.html /var/www/html/
COPY ./default.conf /etc/nginx/sites-available/
COPY ./www.conf /usr/local/etc/php-fpm.d/