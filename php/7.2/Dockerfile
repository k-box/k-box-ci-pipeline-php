FROM edbizarro/gitlab-ci-pipeline-php:7.2

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="OneOffTech <info@oneofftech.xyz>" \
  PHP="7.2" \
  NODE="11" \
  org.label-schema.name="klinktech/k-box-ci-pipeline-php" \
  org.label-schema.description="Docker image for build and test K-Box application with Gitlab CI (or any other CI platform!)" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/k-box/k-box-ci-pipeline-php" \
  org.label-schema.vcs-ref=$VCS_REF

USER root

# Install Gdal
RUN apt-get update -yqq && \
    apt-get install -yqq --no-install-recommends \ 
        gdal-bin \
        ghostscript \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Change nodejs version to 11.x as our frontend script
# do not support node 12
RUN yes | apt-get remove nodejs && \
    curl -s -L https://deb.nodesource.com/setup_11.x | bash - \
    && DEBIAN_FRONTEND=noninteractive apt-get install nodejs --no-install-recommends -yqq \
    && npm i -g npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Insert the timezone and disable xdebug
RUN echo "date.timezone=UTC" > /usr/local/etc/php/conf.d/php_timezone.ini \
    mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.disabled

USER $IMAGE_USER
