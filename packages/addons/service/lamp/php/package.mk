################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014-2016 ultraman
#      Copyright (C) 2014 streppuiu
#      Copyright (C) 2014 dominic7il
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

PKG_NAME="php"
PKG_VERSION="5.6.39"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.php.net"
PKG_URL="http://www.php.net/distributions/$PKG_NAME-$PKG_VERSION.tar.xz"
# add some other libraries which are need by php extensions
PKG_DEPENDS_TARGET="toolchain zlib pcre curl libxml2 openssl libmcrypt libxslt libiconv mysqld httpd icu4c libjpeg-turbo"
PKG_LONGDESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
PKG_TOOLCHAIN="autotools"
#PKG_BUILD_FLAGS="+pic"
#PKG_BUILD_FLAGS="-gold"
#PKG_BUILD_FLAGS="+pic -gold"

post_unpack() {
  PHP_BUILD_DIR=$(get_build_dir php)
  echo "downloading pear..."
  if [ ! -f "$PHP_BUILD_DIR/../go-pear.phar" ]; then
    wget -O $PHP_BUILD_DIR/../go-pear.phar http://pear.php.net/go-pear.phar
  fi
  cp $PHP_BUILD_DIR/../go-pear.phar $PHP_BUILD_DIR/pear/go-pear.phar

  # libtool fix
  rm $PKG_BUILD/aclocal.m4
}

configure_target() {
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME

  # quick hack - freetype is in different folder
  # not for new
  #sed -i "s|freetype2/freetype/freetype.h|freetype2/freetype.h|g" configure
  
  MYSQL_DIR_TARGET=$(get_build_dir mysqld)/.install_dev
  LIBMCRYPT_DIR_TARGET=$(get_build_dir libmcrypt)/.install_dev
  HTTPD_DIR=$(get_build_dir httpd)/.install_dev
  ICU_DIR=$(get_build_dir icu4c)/.install_pkg

  CFLAGS+=" -DSQLITE_OMIT_LOAD_EXTENSION"
  CFLAGS+=" -I$HTTPD_DIR/usr/include"
  CFLAGS+=" -I$ICU_DIR/usr/include"

  # Dynamic Library support
  LDFLAGS+=" -ldl -lpthread"
  LDFLAGS+=" -L$ICU_DIR/usr/lib"

  # libiconv
  CFLAGS+=" -I$SYSROOT_PREFIX/usr/include/iconv"
  LDFLAGS+=" -L$SYSROOT_PREFIX/usr/lib/iconv -liconv"

  # overwrite mysql library location
  CFLAGS+=" -L$MYSQL_DIR_TARGET/usr/lib -lmysqlclient"
  
  export CFLAGS="$CFLAGS"
  export CXXFLAGS="$CFLAGS"
  export CPPFLAGS="$CFLAGS"

  APXS_FILE=$(get_build_dir httpd)/.install_dev/usr/bin/apxs
  chmod +x $APXS_FILE

  PKG_CONFIGURE_OPTS_TARGET="
    --enable-cli \
    --enable-opcache=no \
    --with-pear \
    --with-config-file-path=/storage/.kodi/userdata/addon_data/service.web.lamp/srvroot/conf \
    --localstatedir=/var \
    --enable-sockets \
    --enable-session \
    --enable-posix \
    --enable-mbstring \
    --enable-dom \
    --enable-ctype \
    --enable-zip \
    --enable-ftp \
    --with-openssl-dir=$SYSROOT_PREFIX/usr \
    --enable-libxml \
    --enable-xml \
    --enable-xmlreader \
    --enable-xmlwriter \
    --enable-simplexml \
    --enable-fileinfo \
    --with-curl=$SYSROOT_PREFIX/usr \
    --with-openssl=$SYSROOT_PREFIX/usr \
    --with-zlib=$SYSROOT_PREFIX/usr \
    --with-bz2=$SYSROOT_PREFIX/usr \
    --with-zlib=$SYSROOT_PREFIX/usr \
    --with-iconv \
    --with-icu-dir=$ICU_DIR/usr \
    --with-xsl=$SYSROOT_PREFIX/usr \
    --enable-intl \
    --disable-cgi \
    --with-gettext \
    --without-gmp \
    --enable-json \
    --enable-pcntl \
    --disable-sysvmsg \
    --disable-sysvsem \
    --disable-sysvshm \
    --enable-filter \
    --enable-calendar \
    --with-pcre-regex \
    --with-sqlite3=$SYSROOT_PREFIX/usr \
    --with-pdo-sqlite=$SYSROOT_PREFIX/usr \
    --enable-pdo \
    --with-mcrypt=$LIBMCRYPT_DIR_TARGET/usr \
    --with-mysqli=$MYSQL_DIR_TARGET/usr/bin/mysql_config \
    --with-mysql=$MYSQL_DIR_TARGET/usr \
    --with-pdo-mysql=$MYSQL_DIR_TARGET/usr \
    --with-mysql-sock=/run/mysql.sock \
    --with-gd \
    --enable-gd-native-ttf \
    --enable-gd-jis-conv \
    --enable-exif \
    --with-jpeg-dir=$SYSROOT_PREFIX/usr \
    --with-freetype-dir=$SYSROOT_PREFIX/usr \
    --with-png-dir=$SYSROOT_PREFIX/usr \
    --with-apxs2=$APXS_FILE \
  "

  ac_cv_func_strcasestr=yes \
  $PKG_CONFIGURE_SCRIPT $TARGET_CONFIGURE_OPTS $PKG_CONFIGURE_OPTS_TARGET \

#  ac_cv_lib_mcrypt_mcrypt_module_open=yes \
#  ac_cv_lib_mysqlclient___mysql_close=yes \
# ac_cv_lib_mysqlclient___mysql_error=yes \
# ac_cv_lib_mysqlclient___mysql_set_server_option=yes \
}

post_configure_target() {
  : # dummy
  # quick hack
  # not for new
  sed -i "s|-I/usr/include|-I$SYSROOT_PREFIX/usr/include|g" Makefile
  sed -i "s|-L/usr/lib|-L$SYSROOT_PREFIX/usr/lib|g" Makefile

  PHP_BIN=$(which php)

  sed -i "s|PHP_EXECUTABLE =.*|PHP_EXECUTABLE = $PHP_BIN|g" Makefile
  sed -i 's|$(top_builddir)/$(SAPI_CLI_PATH)|dummy_sapi_cli_path|g' Makefile
}

makeinstall_target() {
  export INSTALL_DEV=$(pwd)/.install_dev

  mkdir -p $INSTALL_DEV/etc/
  cp $(get_build_dir httpd)/.install_dev/etc/httpd.conf $INSTALL_DEV/etc/httpd.conf

  #sed -i "s|install-pear-installer:.*|install-pear-installer:\ndummy123:|g" Makefile

  #
  sed -i 's|@$(top_builddir)/sapi/cli/php|php|g' Makefile

  make -j1 install INSTALL_ROOT=$INSTALL_DEV $PKG_MAKEINSTALL_OPTS_TARGET

  sed -i "/prefix/ s|/usr|$INSTALL_DEV/usr|" $INSTALL_DEV/usr/bin/phpize
  sed -i "/extension_dir/ s|/usr|$INSTALL_DEV/usr|" $INSTALL_DEV/usr/bin/php-config
  sed -i "/prefix/ s|/usr|$INSTALL_DEV/usr|" $INSTALL_DEV/usr/bin/php-config
  
  sed -i "/phpdir=/ s|phpdir=.*|phpdir=\"$INSTALL_DEV/usr/lib/build\"|" $INSTALL_DEV/usr/bin/phpize
}

# zamenjaj php in naj namesti pear tudi
