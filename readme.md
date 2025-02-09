![Build Docker Image](https://github.com/k-box/k-box-ci-pipeline-php/workflows/Build%20Docker%20Image/badge.svg)

# Build and test K-Box with Gitlab CI (or any other CI platform)

PHP Docker images with the necessary dependencies to execute [K-Box](https://github.com/k-box/k-box) development and testing.

Docker images are inspired or based on [edbizarro/gitlab-ci-pipeline-php images](https://github.com/edbizarro/gitlab-ci-pipeline-php).

All versions comes with:

- [Node 22](https://nodejs.org/en/), 
- [Composer 2](https://getcomposer.org/),
- [Yarn](https://yarnpkg.com)
- Image Magick PHP extension.

**Available PHP versions**

- `8.1` [(8.1/Dockerfile)](./php/8.1/Dockerfile)
- `8.2` [(8.2/Dockerfile)](./php/8.2/Dockerfile)
- `8.3` [(8.3/Dockerfile)](./php/8.3/Dockerfile)
- `8.4` [(8.4/Dockerfile)](./php/8.4/Dockerfile)

PHP version < 8.1 are not actively updated, old Docker tags still works.

## Usage

`k-box-ci-pipeline-php` can be used on different continuous integration platforms that make use of docker images 
and also as build step for a multi-step docker image. You can also use it locally to work on the K-Box code
without having php installed.

_as your development environment_

```bash
# use it to host your development environment
docker run -t --rm -v $(pwd):/var/www/html -p 8000:8000 klinktechnology/k-box-ci-pipeline-php:8.4 bash
# then execute the K-Box developer installation and run php artisan serve
# to keep this example short additional services, like MariaDB/MySQL, are not linked
```

_on Gitlab CI_

```yaml
# reference it as the source of a Gitlab CI job
image: "klinktechnology/k-box-ci-pipeline-php:8.4"
```

_on GitHub actions_

```yaml
# reference it as the container for a GitHub Action job
container:
  image: klinktechnology/k-box-ci-pipeline-php:8.4
  options: --user root 
```

## Examples

### Gitlab pipeline example

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
  image: klinktechnology/k-box-ci-pipeline-php:8.4
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

### GitHub Actions workflow example

This simple example shows how to execute unit tests for a PHP project with 
a MariaDB linked database using GitHub Actions.

```yaml
name: CI

on: 
  push:
    branches: 
      - "master"
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  phpunit:
    name: Tests PHP 8.4
    runs-on: ubuntu-latest
    container: 
      image: klinktechnology/k-box-ci-pipeline-php:8.4
      options: --user root 

    services:
      mariadb:
        image: mariadb:10
        env:
          MYSQL_DATABASE: example
          MYSQL_USER: example
          MYSQL_ROOT_PASSWORD: "example"
          MYSQL_PASSWORD: "example"
          MYSQL_INITDB_SKIP_TZINFO: 1
        ports:
          - 3306
        options: --health-cmd="mysqladmin ping" --health-interval=10s --health-timeout=5s --health-retries=3

    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 1
    
    - name: Cache dependencies
      uses: actions/cache@v1
      with:
        path: ~/.composer/cache/files
        key: dependencies-php-8.4-composer-${{ hashFiles('composer.json') }}
      
    - name: Install dependencies
      run: |
        composer install --prefer-dist
        
    - name: Run Testsuite
      run: |
        vendor/bin/phpunit
```

> For a more complex example see the 
[CI workflow in the K-Box repository](https://github.com/k-box/k-box/blob/master/.github/workflows/ci.yml)

## Test

Docker images are tested on every build using [Goss](https://github.com/aelsabbahy/goss).

To run the test suite you need to build the Docker image first and then execute the goss
command.

```bash
docker build -t k-box-pipeline:8.4 ./php/8.4/
docker run --rm -v $(pwd):/var/www/html k-box-pipeline:8.4 goss -g goss.yml v
```

## License

Licensed under [MIT](./LICENSE).


--------

Special thanks to [Eduardo Bizarro](https://github.com/edbizarro) and
his [gitlab-ci-pipeline-php images](https://hub.docker.com/r/edbizarro/gitlab-ci-pipeline-php/).
