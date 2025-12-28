FROM php:8.2-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    sqlite3 \
    libsqlite3-dev \
 && rm -rf /var/lib/apt/lists/*

# Enable PHP SQLite extension
RUN docker-php-ext-install pdo_sqlite

WORKDIR /var/www/html

# Copy project files (with .dockerignore to exclude junk)
COPY . /var/www/html

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
 && find /var/www/html -type d -exec chmod 755 {} \; \
 && find /var/www/html -type f -exec chmod 644 {} \;

EXPOSE 80

CMD ["apache2-foreground"]
