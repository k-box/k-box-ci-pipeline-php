# Changelog

All notable changes to this project will be documented in this file.

The versioning follows the PHP version number. Docker images are 
tagged with PHP major and minor releases, builds are generated
from the `master` branch.

## 2020-07-25

- Add PHP 7.4 image [#14](https://github.com/k-box/k-box-ci-pipeline-php/pull/14)
- Improve testing for gdal and ghostscript installation [#16](https://github.com/k-box/k-box-ci-pipeline-php/pull/16)
- Add pconv instead of xdebug for code coverage [#14](https://github.com/k-box/k-box-ci-pipeline-php/pull/14), as seen in [Michael Dyrynda's article](https://dyrynda.com.au/blog/using-pcov-instead-of-xdebug-for-coverage)
- Add a bi-weekly automatic build to ensure images are always up-to-date [#17](https://github.com/k-box/k-box-ci-pipeline-php/pull/17)
- Documented how image testing works

## 2020-07-18

- Update documentation with GitHub Actions example
- `7.2` Use Node 12 [#6](https://github.com/k-box/k-box-ci-pipeline-php/pull/6)
- `7.2` Ensure PDF read/write is enabled in Image Magick [#12](https://github.com/k-box/k-box-ci-pipeline-php/pull/12)
