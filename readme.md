
# Build and test K-Box with Gitlab CI (or any other CI platform)

PHP Docker images with the necessary dependencies to execute [K-Box](https://github.com/k-box/k-box) development and testing.


## Based on [edbizarro/gitlab-ci-pipeline-php images](https://hub.docker.com/r/edbizarro/gitlab-ci-pipeline-php/)

- ```7```, ```7.2```, ```latest``` [(7.2/Dockerfile)](https://github.com/k-box/k-box-ci-pipeline-php/blob/master/php/7.2/Dockerfile)


All versions come with [Node 11](https://nodejs.org/en/), [Composer](https://getcomposer.org/) (with [hirak/prestissimo](https://github.com/hirak/prestissimo) to speed up installs) and [Yarn](https://yarnpkg.com)

>> PHP 7.0.x and 7.1.x are not supported. If you need a PHP 7.1 image for your build refer to the awesome [PHP images for Gitlab CI](https://github.com/edbizarro/gitlab-ci-pipeline-php) created by [Eduardo Bizarro](https://github.com/edbizarro)


>> The images comes with **Node 11** as the K-Box frontend dependencies are not compatible with newer Node versions

## Usage

`k-box-ci-pipeline-php` can be used on different continuous integration platforms that make use of docker images 
and also as build step for a multi-step docker image. You can also use it locally to work on the K-Box code
without having php installed.

_as your development environment_

```bash
# use it to host your development environment
docker run -t --rm -v $(pwd):/var/www/html -p 8000:8000 klinktech/k-box-ci-pipeline-php:7.2 bash
# then execute the K-Box developer installation and run php artisan serve
# to keep this example short required additional services (e.g. MariaDB/MySQL) are not linked
```

_on Gitlab CI_

```yaml
# reference it as the source of a Gitlab CI job
image: "klinktech/k-box-ci-pipeline-php:7.2"
```

_on GitHub actions_

```yaml
# reference it as the container for a GitHub Action job
container:
  image: klinktech/k-box-ci-pipeline-php:7.2
```


### Gitlab pipeline examples

This simple example shows how we run the unit test of the K-Box on Gitlab CI.

```yaml
# Variables
variables:
  MYSQL_ROOT_PASSWORD: root
  MYSQL_USER: dms
  MYSQL_PASSWORD: dms
  MYSQL_DATABASE: dms
  DB_HOST: mariadb

test:
  stage: test
  services:
    - mariadb:10.3
  image: klinktech/k-box-ci-pipeline-php:7.2
  script:
    - cp env.ci .env
    - mkdir ./storage/documents
    - composer install --prefer-dist
    - composer run install-video-cli
    - composer run install-content-cli
    - composer run install-language-cli
    - composer run install-streaming-client
    - php artisan view:clear
    - php artisan config:clear
    - php artisan route:clear
    - php artisan migrate --env=testing --force
    - php artisan db:seed --env=testing --force
    - yarn install --pure-lockfile
    - yarn run production
    - vendor/bin/phpunit
```

## License

Licensed under [MIT](./LICENSE).


--------

Special thanks to [Eduardo Bizarro](https://github.com/edbizarro) and his [gitlab-ci-pipeline-php images](https://hub.docker.com/r/edbizarro/gitlab-ci-pipeline-php/)..
