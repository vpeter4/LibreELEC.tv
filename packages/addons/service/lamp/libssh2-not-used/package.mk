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

PKG_NAME="libssh2"
PKG_VERSION="1.8.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE=""
PKG_SITE="http://libssh2.org/"
PKG_URL="http://libssh2.org/download/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libgcrypt openssl"
PKG_LONGDESC="libssh2 library"
PKG_TOOLCHAIN="autotools"

#PKG_BUILD_FLAGS="+pic -gold"
#PKG_BUILD_FLAGS="+pic -lto"

  PKG_CONFIGURE_OPTS_TARGET="
    --enable-static \
    --disable-shared \
    --disable-examples-build \
    --with-libgcrypt=$SYSROOT_PREFIX/usr \
    --with-openssl=$SYSROOT_PREFIX/usr \
    --with-libz \
    --with-libz-prefix=$SYSROOT_PREFIX/usr \
  "

makeinstall_target() {
  # use this version only for addon (don't install it to a system)
  INSTALL_DEV=$PKG_BUILD/.install_dev
  make -j1 install DESTDIR=$INSTALL_DEV $PKG_MAKEINSTALL_OPTS_TARGET

  $STRIP $(find $INSTALL_DEV -name "*.so" 2>/dev/null) 2>/dev/null || :
  $STRIP $(find $INSTALL_DEV -name "*.so.[0-9]*" 2>/dev/null) 2>/dev/null || :

  for i in $(find $INSTALL_DEV/usr/lib/ -name "*.la" 2>/dev/null); do
    sed -i "s|\(['= ]\)/usr|\\1$INSTALL_DEV/usr|g" $i   #'
  done
}
