#!/usr/bin/env bash

## Original https://github.com/edbizarro/gitlab-ci-pipeline-php/blob/master/php/scripts/extensions.sh (c) Eduardo Bizarro
## Modification: Changed the way PHP extensions are installed as we target only PHP 8.1

set -euo pipefail

curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    IPE_GD_WITHOUTAVIF=1 install-php-extensions \
    @composer \
    redis-stable \
    imagick/imagick@master \
    xdebug-stable \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    intl \
    pdo_mysql \
    pdo_pgsql \
    pcntl \
    opcache \
    soap \
    zip
    

{ \
    echo 'opcache.enable=1'; \
    echo 'opcache.revalidate_freq=0'; \
    echo 'opcache.validate_timestamps=1'; \
    echo 'opcache.max_accelerated_files=10000'; \
    echo 'opcache.memory_consumption=192'; \
    echo 'opcache.max_wasted_percentage=10'; \
    echo 'opcache.interned_strings_buffer=16'; \
    echo 'opcache.fast_shutdown=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

{ \
    echo 'apc.shm_segments=1'; \
    echo 'apc.shm_size=1024M'; \
    echo 'apc.num_files_hint=7000'; \
    echo 'apc.user_entries_hint=4096'; \
    echo 'apc.ttl=7200'; \
    echo 'apc.user_ttl=7200'; \
    echo 'apc.gc_ttl=3600'; \
    echo 'apc.max_file_size=100M'; \
    echo 'apc.stat=1'; \
} > /usr/local/etc/php/conf.d/apcu-recommended.ini

echo 'memory_limit=1024M' > /usr/local/etc/php/conf.d/zz-conf.ini

echo "date.timezone=UTC" > /usr/local/etc/php/conf.d/php_timezone.ini

# https://xdebug.org/docs/upgrade_guide#changed-xdebug.coverage_enable
echo 'xdebug.mode=coverage' > /usr/local/etc/php/conf.d/20-xdebug.ini