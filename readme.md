
# Build and test [K-Box](https://github.com/k-box/k-box) with Gitlab CI (or any other CI platform)

PHP Docker images with the necessary dependencies to execute [K-Box](https://github.com/k-box/k-box) development and testing.


## Based on [edbizarro/gitlab-ci-pipeline-php images](https://hub.docker.com/r/edbizarro/gitlab-ci-pipeline-php/)

- ```7```, ```7.2```, ```latest``` [(7.2/Dockerfile)](https://github.com/k-box/k-box-ci-pipeline-php/blob/master/php/7.2/Dockerfile)


All versions come with [Node 11](https://nodejs.org/en/), [Composer](https://getcomposer.org/) (with [hirak/prestissimo](https://github.com/hirak/prestissimo) to speed up installs) and [Yarn](https://yarnpkg.com)

>> PHP 7.0.x and 7.1.x are not supported. If you need a PHP 7.1 image for your build refer to the awesome [PHP images for Gitlab CI](https://github.com/edbizarro/gitlab-ci-pipeline-php) created by [Eduardo Bizarro](https://github.com/edbizarro)


>> The images comes with **Node 11** as the K-Box frontend dependencies are not compatible with newer Node versions

## Usage

**This is currently under development.**




## License

Licensed under [MIT](./LICENSE).


--------

Special thanks to [Eduardo Bizarro](https://github.com/edbizarro) and his [gitlab-ci-pipeline-php images](https://hub.docker.com/r/edbizarro/gitlab-ci-pipeline-php/)..
