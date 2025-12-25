# Base image with PHP and Apache (for the web UI)
FROM php:8.2-apache

# Install Python, pip, SQLite, and build dependencies
RUN sudo apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    sqlite3 \
    libsqlite3-dev \
    build-essential \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip to avoid fetch/install issues
RUN pip install --upgrade pip setuptools wheel

# Enable PHP SQLite extension
RUN docker-php-ext-install pdo_sqlite

# Set working directory (Apache default)
WORKDIR /var/www/html

# Copy repo files
COPY . /var/www/html

# Install Python dependencies (now more robust)
RUN pip install -r requirements.txt

# Set permissions for Apache user
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port
EXPOSE 80

# Start Apache]
CMD ["apache2ctl", "-D", "FOREGROUND"]
