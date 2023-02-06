FROM php:8.2.2

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="OneOffTech <info@oneofftech.xyz>" \
  PHP="8.2" \
  NODE="16" \
  org.label-schema.name="klinktech/k-box-ci-pipeline-php" \
  org.label-schema.description="Docker image for build and test K-Box application with Gitlab CI (or any other CI platform!)" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/k-box/k-box-ci-pipeline-php" \
  org.label-schema.vcs-ref=$VCS_REF

ENV IMAGE_USER=php
ENV HOME=/home/$IMAGE_USER
ENV COMPOSER_HOME=$HOME/.composer
ENV PATH=$HOME/.yarn/bin:$PATH
ENV GOSS_VERSION="0.3.16"
ENV PHP_VERSION=8.2

USER root

WORKDIR /tmp

COPY ./scripts/*.sh /tmp/

RUN chmod +x /tmp/*.sh \
  && bash ./packages.sh \
  && bash ./extensions.sh \
  && bash ./node.sh \
  && adduser --disabled-password --gecos "" $IMAGE_USER && \
  echo "PATH=$(yarn global bin):$PATH" >> /root/.profile && \
  echo "PATH=$(yarn global bin):$PATH" >> /root/.bashrc && \
  echo "$IMAGE_USER  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers && \
  mkdir -p /var/www/html \
  && rm -rf ~/.composer/cache/* \
  && chown -R $IMAGE_USER:$IMAGE_USER /var/www $HOME \
  && curl -fsSL https://goss.rocks/install | GOSS_VER=v${GOSS_VERSION} sh \
  && bash ./cleanup.sh \
  && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.disabled \
  && sed -i -e '/rights="none" pattern="{PS,PDF,XPS}"/ s#<!--##g;s#-->##g;' /etc/ImageMagick-6/policy.xml \
  && sed -i -e 's/rights="none" pattern="{PS,PDF,XPS}"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml

WORKDIR /var/www/html

USER $IMAGE_USER
