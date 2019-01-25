################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014 ultraman
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="apcu"
# PHP 5.3.0 or newer
PKG_VERSION="4.0.11"
# Release 5.1.5:  PHP Version: PHP 7.0.0-dev or newer
PKG_LICENSE=""
PKG_SITE="https://pecl.php.net/package/APCu"
PKG_URL="https://pecl.php.net/get/$PKG_NAME-$PKG_VERSION.tgz"
#PKG_DEPENDS_TARGET="toolchain libssh2 php"
PKG_DEPENDS_TARGET="toolchain php"
PKG_LONGDESC="APC User Caching"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  PHP_DIR=$(get_build_dir php)/.install_dev

  PKG_CONFIGURE_OPTS_TARGET="--with-php-config=$PHP_DIR/usr/bin/php-config"

  PHP_AUTOCONF=$TOOLCHAIN/bin/autoconf \
  PHP_AUTOHEADER=$TOOLCHAIN/bin/autoheader \
  $PHP_DIR/usr/bin/phpize

  rm aclocal.m4
  mkdir m4
  do_autoreconf .
}

makeinstall_target() {
  : # nothing to install
}
