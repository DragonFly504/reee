FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
 python3 \
 python3-pip \
 python3-venv \
 sqlite3 \
 libsqlite3-dev \
 && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_sqlite

WORKDIR /var/www/html

COPY . /var/www/html

RUN pip3 install -r requirements.txt

EXPOSE 80

RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 755 /var/www/html

CMD ["apache2-foreground"]
