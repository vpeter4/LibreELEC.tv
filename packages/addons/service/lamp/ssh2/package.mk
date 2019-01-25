# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2014-present ultraman

PKG_NAME="ssh2"
PKG_VERSION="0.13"
#PKG_VERSION="1.0"
PKG_LICENSE=""
PKG_SITE="http://pecl.php.net/package/ssh2"
PKG_URL="http://pecl.php.net/get/$PKG_NAME-$PKG_VERSION.tgz"
PKG_DEPENDS_TARGET="toolchain libssh2 php"
PKG_LONGDESC="ssh2 php extension"
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  LDFLAGS+=" -lcrypto"
  export LDFLAGS="$LDFLAGS"

  #LIBSSH2_DIR=$(get_build_dir libssh2)/.install_dev
  PHP_DIR=$(get_build_dir php)/.install_dev

  PKG_CONFIGURE_OPTS_TARGET="
    --with-ssh2=$SYSROOT_PREFIX/usr \
    --with-php-config=$PHP_DIR/usr/bin/php-config \
  "

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
