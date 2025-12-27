# Use official Python slim image (lightweight, up-to-date)
FROM python:3.12-slim

# Prevent interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install Apache, PHP, and required extensions
RUN apt-get update && apt-get install -y \
 apache2 \
 libapache2-mod-php \
 php-sqlite3 \
 php-mbstring \
 ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && a2enmod rewrite

# Set working directory / document root
WORKDIR /var/www/html

# Copy only requirements first (better layer caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Permissions for Apache
RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 755 /var/www/html

 RUN echo 'ServerName Onlinefcu.com' >/etc/apache2/conf-available/servername.conf \
&& a2enconf servername

# Expose Apache HTTP port (mapping to host is done in docker-compose.yml)
EXPOSE 80

# Run Apache in foreground (required for Docker)
CMD ["apache2ctl", "-D", "FOREGROUND"]
