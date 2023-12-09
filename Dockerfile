# Étape 1: Utiliser une image de base officielle PHP avec Apache
FROM php:8.2-apache

# Étape 2: Installer les extensions PHP nécessaires
RUN apt-get update && apt-get install -y \
        libicu-dev \
        libzip-dev \
        zip \
        git \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        intl \
        zip \
        opcache

# Étape 3: Activer le mod_rewrite pour Apache
RUN a2enmod rewrite

# Étape 4: Définir le répertoire de travail
WORKDIR /var/www/html

# Étape 5: Copier les fichiers de l'application dans le conteneur
COPY . .

# Étape 6: Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Étape 7: Installer les dépendances de l'application
RUN composer install --no-dev --optimize-autoloader

# Étape 8: Changer les permissions des dossiers var et vendor
RUN chown -R www-data:www-data var vendor

# Étape 9: Exposer le port 80
EXPOSE 80

# Étape 10: Lancer Apache en arrière-plan
CMD ["apache2-foreground"]