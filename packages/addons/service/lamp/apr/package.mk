################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014-2015 vpeter
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

PKG_NAME="apr"
PKG_VERSION="1.6.5"
PKG_LICENSE="Apache License"
PKG_SITE="http://apr.apache.org/"
PKG_URL="http://archive.apache.org/dist/apr/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The Apache Portable Runtime (APR) is a supporting library for the Apache web server."
PKG_TOOLCHAIN="configure"

# for largefile seems only important thing are ac_cv_sizeof_*
# but maybe I'm wrong
export CFLAGS="$CFLAGS -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"

if [ "$TARGET_ARCH" = x86_64 ]; then
  SIZEOF_SIZES="ac_cv_sizeof_pid_t=4 \
                ac_cv_sizeof_ssize_t=8 \
                ac_cv_sizeof_size_t=8 \
                ac_cv_sizeof_off_t=8 \
                ac_cv_sizeof_ino_t=8 \
                ac_cv_sizeof_struct_iovec=16"
else
  SIZEOF_SIZES="ac_cv_sizeof_pid_t=4 \
                ac_cv_sizeof_ssize_t=4 \
                ac_cv_sizeof_size_t=4 \
                ac_cv_sizeof_off_t=8 \
                ac_cv_sizeof_ino_t=8 \
                ac_cv_sizeof_struct_iovec=8"
fi

PKG_CONFIGURE_OPTS_TARGET="
  ac_cv_file__dev_zero=yes \
  ac_cv_func_setpgrp_void=yes \
  apr_cv_tcp_nodelay_with_cork=no \
  apr_cv_process_shared_works=no \
  $SIZEOF_SIZES \
  --disable-static \
  --disable-libtool-lock \
  --enable-lfs \
  --enable-dso \
  --disable-ipv6 \
  --with-gnu-ld \
  cross_compiling=yes \
"

make_target() {
  make BUILDCC="$HOSTCC" CFLAGS_FOR_BUILD=""
}

pre_configure_target() {
  # build in same folder for gen_test_char program which must run on host
  cd $PKG_BUILD
  rm -rf ".$TARGET_NAME"
}

makeinstall_target() {
  # use this version only for addon (don't install it to a system)
  INSTALL_DEV="$PKG_BUILD/.install_dev"
  make -j1 install DESTDIR="$INSTALL_DEV" $PKG_MAKEINSTALL_OPTS_TARGET

  $STRIP $(find $INSTALL_DEV -name "*.so" 2>/dev/null) 2>/dev/null || :
  $STRIP $(find $INSTALL_DEV -name "*.so.[0-9]*" 2>/dev/null) 2>/dev/null || :

  for i in $(find $INSTALL_DEV/usr/lib -name "*.la" 2>/dev/null); do
    sed -i "s|\(['= ]\)/usr|\\1$INSTALL_DEV/usr|g" $i   #'
  done

  sed -i "s|^prefix=\"|prefix=\"$INSTALL_DEV|" $INSTALL_DEV/usr/bin/apr-1-config
  sed -i "s|^bindir=\"|bindir=\"$INSTALL_DEV|" $INSTALL_DEV/usr/bin/apr-1-config
  #sed -i "s|^libdir=\"|libdir=\"$INSTALL_DEV|" $INSTALL_DEV/usr/bin/apr-1-config

  sed -i "s|apr_builddir=|apr_builddir=$INSTALL_DEV|" $INSTALL_DEV/usr/build-1/apr_rules.mk
  sed -i "s|apr_builders=|apr_builders=$INSTALL_DEV|" $INSTALL_DEV/usr/build-1/apr_rules.mk
  sed -i "s|top_builddir=|top_builddir=$INSTALL_DEV|" $INSTALL_DEV/usr/build-1/apr_rules.mk
}
