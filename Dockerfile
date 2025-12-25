# Use official Python slim image (up-to-date pip, lightweight)
FROM python:3.12-slim

# Install Apache, PHP, and required extensions (for UI and SQLite)
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-php \
    php-sqlite3 \
    php-mbstring \  # Optional, but useful for PHP strings
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && a2enmod rewrite  # For .htaccess if used in the tool

# Set Apache document root
WORKDIR /var/www/html

# Copy repo files
COPY . /var/www/html

# Install Python dependencies (pip is modern here, no upgrade needed)
RUN pip install --no-cache-dir -r requirements.txt

# Set permissions for Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port
EXPOSE 80

# Start Apache in foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
