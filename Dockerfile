
# Use a base image with PHP and Apache for the web UI
FROM php:8.2-apache

# Install system dependencies, Python, and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    sqlite3 \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules and SQLite for PHP
RUN docker-php-ext-install pdo_sqlite

# Set working directory
WORKDIR /var/www/html

# Copy all repo files to the web root
COPY . /var/www/html

# Install Python dependencies
RUN pip3 install -r requirements.txt

# Expose ports (default Apache is 80; adjust if needed for tool's --port)
EXPOSE 80

# Set permissions for scripts and database (adjust paths as per your setup)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Start Apache in the foreground
CMD ["apache2-foreground"]
