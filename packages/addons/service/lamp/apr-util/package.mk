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

PKG_NAME="apr-util"
PKG_VERSION="1.6.1"
PKG_LICENSE="Apache License"
PKG_SITE="http://apr.apache.org/"
PKG_URL="http://archive.apache.org/dist/apr/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain apr openssl"
PKG_LONGDESC="The Apache Portable Runtime Utility Library provides a predictable and consistent interface to underlying client library interfaces."
PKG_TOOLCHAIN="configure"

pre_configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME

  APR_DIR_TARGET=$(get_build_dir apr)/.install_dev

  export APRUTIL_LDFLAGS="-L$APR_DIR_TARGET/usr/lib"

  export CFLAGS="$CFLAGS -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
  export CPPFLAGS="-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"

  PKG_CONFIGURE_OPTS_TARGET="
    --with-apr=$APR_DIR_TARGET/usr/bin/apr-1-config \
    --with-openssl \
    --with-crypto \
    --with-openssl=$SYSROOT_PREFIX/usr \
    --with-sqlite3=$SYSROOT_PREFIX/usr \
  "
}


makeinstall_target() {
  # use this version only for addon (don't install it to a system)
  INSTALL_DEV=$PKG_BUILD/.install_dev
  make -j1 install DESTDIR=$INSTALL_DEV $PKG_MAKEINSTALL_OPTS_TARGET

  $STRIP $(find $INSTALL_DEV -name "*.so" 2>/dev/null) 2>/dev/null || :
  $STRIP $(find $INSTALL_DEV -name "*.so.[0-9]*" 2>/dev/null) 2>/dev/null || :

  for i in $(find $INSTALL_DEV/usr/lib -name "*.la" 2>/dev/null); do
    sed -i "s|\(['= ]\)/usr|\\1$INSTALL_DEV/usr|g" $i   #'
  done

  sed -i "s|^prefix=\"|prefix=\"$INSTALL_DEV|" $INSTALL_DEV/usr/bin/apu-1-config
  sed -i "s|^bindir=\"|bindir=\"$INSTALL_DEV|" $INSTALL_DEV/usr/bin/apu-1-config
  
  sed -i "s|-L/usr/lib /usr/lib/libapr-1.la||" $INSTALL_DEV/usr/lib/libaprutil-1.la
}
