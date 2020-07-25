FROM edbizarro/gitlab-ci-pipeline-php:7.4

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="OneOffTech <info@oneofftech.xyz>" \
  PHP="7.4" \
  NODE="12" \
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

# Insert the timezone
# Disable xdebug
# Ensure PDF support is enabled in Image Magick
RUN echo "date.timezone=UTC" > /usr/local/etc/php/conf.d/php_timezone.ini \
    && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.disabled \
    && sed -i -e '/rights="none" pattern="{PS,PDF,XPS}"/ s#<!--##g;s#-->##g;' /etc/ImageMagick-6/policy.xml \
    && sed -i -e 's/rights="none" pattern="{PS,PDF,XPS}"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml \
    && pecl install pcov \
    && docker-php-ext-enable pcov \
    && rm -rf /tmp/pear/

USER $IMAGE_USER
