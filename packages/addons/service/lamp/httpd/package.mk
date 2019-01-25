################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014-2015 vpeter
#      Copyright (C) 2014 streppuiu
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

PKG_NAME="httpd"
PKG_VERSION="2.4.37"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.linuxfromscratch.org/blfs/view/svn/server/apache.html"
PKG_URL="http://archive.apache.org/dist/httpd/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain apr-util openssl pcre libxml2"
PKG_LONGDESC="The Apache web server."
PKG_TOOLCHAIN="autotools"

# If you still desire to serve pages as root
APACHE_RUN_AS_ROOT=no

configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME

  if [ "$APACHE_RUN_AS_ROOT" == "yes" ]; then
    export CFLAGS="$CFLAGS -DBIG_SECURITY_HOLE"
  fi

  APR_DIR_TARGET="$(get_build_dir apr)/.install_dev"
  APR_UTIL_DIR_TARGET="$(get_build_dir apr-util)/.install_dev"

  export CFLAGS="$CFLAGS -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"

  export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include"
  export LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib -lpthread -ldl"

# fix this
  export LDFLAGS="$LDFLAGS -L$APR_UTIL_DIR_TARGET/usr/lib"

if [ "$TARGET_ARCH" = x86_64 ]; then
  SIZEOF_SIZES="ac_cv_sizeof_struct_iovec=16"
else
  SIZEOF_SIZES="ac_cv_sizeof_struct_iovec=8"
fi

  PKG_CONFIGURE_OPTS_TARGET="
    CC_FOR_BUILD=$HOSTCC \
    CFLAGS_FOR_BUILD= \
    --with-crypto \
    --enable-ssl \
    --enable-so \
    --enable-mods-shared=all \
    --with-mpm=prefork \
    apr_cv_process_shared_works=no \
    ap_cv_void_ptr_lt_long=no \
    apr_cv_tcp_nodelay_with_cork=no
    ac_cv_func_setpgrp_void=yes \
    ac_cv_file__dev_zero=yes \
    cross_compiling=yes \
    $SIZEOF_SIZES \
    \
    --enable-deflate \
    --with-z=$SYSROOT_PREFIX/usr \
    --enable-xml2enc \
    --with-libxml2=$SYSROOT_PREFIX/usr/include/libxml2 \
    --with-ssl \
    --enable-ssl \
    --with-openssl=$SYSROOT_PREFIX/usr \
    --with-pcre=$SYSROOT_PREFIX/usr \
    --with-apr=$APR_DIR_TARGET/usr \
    --with-apr-util=$APR_UTIL_DIR_TARGET/usr \
  "

  $PKG_CONFIGURE_SCRIPT $TARGET_CONFIGURE_OPTS $PKG_CONFIGURE_OPTS_TARGET
}

make_target() {
  make CC_FOR_BUILD="$HOSTCC" CFLAGS_FOR_BUILD=""
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

  sed -i "s|my \$installbuilddir = \"|my \$installbuilddir = \"$INSTALL_DEV|" $INSTALL_DEV/usr/bin/apxs
}
