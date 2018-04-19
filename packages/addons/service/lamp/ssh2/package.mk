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

PKG_NAME="ssh2"
PKG_VERSION="0.13"
#PKG_VERSION="1.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE=""
PKG_SITE="http://pecl.php.net/package/ssh2"
PKG_URL="http://pecl.php.net/get/$PKG_NAME-$PKG_VERSION.tgz"
PKG_DEPENDS_TARGET="toolchain libssh2"
PKG_SECTION="security"
PKG_SHORTDESC="ssh2 php extension"
PKG_LONGDESC="ssh2 php extension"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  LIBSSH2_DIR=$(get_build_dir libssh2)/.install_dev
  PHP_DIR=$(get_build_dir php)/.install_dev

  PKG_CONFIGURE_OPTS_TARGET="--with-ssh2=$LIBSSH2_DIR/usr \
                             --with-php-config=$PHP_DIR/usr/bin/php-config"

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
