
# Build and test K-Box with Gitlab CI (or any other CI platform)

PHP Docker images with the necessary dependencies to execute [K-Box](https://github.com/k-box/k-box) development and testing.

Docker images are based on [edbizarro/gitlab-ci-pipeline-php images](https://hub.docker.com/r/edbizarro/gitlab-ci-pipeline-php/).

All versions comes with:

- [Node 12](https://nodejs.org/en/), 
- [Composer](https://getcomposer.org/) (with [hirak/prestissimo](https://github.com/hirak/prestissimo) to speed up installs),
- [Yarn](https://yarnpkg.com)
- Image Magick PHP extension and
- [Gdal](https://gdal.org/).

**Available PHP versions**

- `7.2` [(7.2/Dockerfile)](https://github.com/k-box/k-box-ci-pipeline-php/blob/master/php/7.2/Dockerfile)

## Usage

`k-box-ci-pipeline-php` can be used on different continuous integration platforms that make use of docker images 
and also as build step for a multi-step docker image. You can also use it locally to work on the K-Box code
without having php installed.

_as your development environment_

```bash
# use it to host your development environment
docker run -t --rm -v $(pwd):/var/www/html -p 8000:8000 klinktech/k-box-ci-pipeline-php:7.2 bash
# then execute the K-Box developer installation and run php artisan serve
# to keep this example short additional services, like MariaDB/MySQL, are not linked
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
    name: Tests PHP 7.2
    runs-on: ubuntu-latest
    container: 
      image: klinktech/k-box-ci-pipeline-php:7.2
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
        key: dependencies-php-7.2-composer-${{ hashFiles('composer.json') }}
      
    - name: Install dependencies
      run: |
        composer install --prefer-dist
        
    - name: Run Testsuite
      run: |
        vendor/bin/phpunit
```

> A more complex example can be seen in the 
[K-Box repository](https://github.com/k-box/k-box/blob/master/.github/workflows/ci.yml)

## License

Licensed under [MIT](./LICENSE).


--------

Special thanks to [Eduardo Bizarro](https://github.com/edbizarro) and
his [gitlab-ci-pipeline-php images](https://hub.docker.com/r/edbizarro/gitlab-ci-pipeline-php/).
