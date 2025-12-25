FROM php:8.2-apache

# Install Python, pip, and minimal extras, then enable Apache mod_rewrite
RUN apt-get update && apt-get install -y \
 ca-certificates \
 python3 \
 python3-pip \
 && rm -rf /var/lib/apt/lists/* \
 && a2enmod rewrite

# Set working directory to the web root
WORKDIR /var/www/html

# Copy application code into the container
# (add a .dockerignore so you don't copy .git, docker-compose.yml, etc.)
COPY . /var/www/html

# Install Python dependencies if requirements.txt exists
RUN if [ -f requirements.txt ]; then \
 pip3 install --no-cache-dir -r requirements.txt; \
 fi

# Fix ownership and permissions for the web server user
RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 755 /var/www/html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
