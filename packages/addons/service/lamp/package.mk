################################################################################
#      This file is part of LibreELEC - https://LibreELEC.tv
#      Copyright (C) 2016 Team LibreELEC
#      Copyright (C) 2014 streppuiu
#      Copyright (C) 2014 dominic7il
#      Copyright (C) 2014-2016 vpeter
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="lamp"
PKG_VERSION="1.0"
PKG_REV="21"
PKG_ARCH="any"
PKG_LICENSE=""
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain httpd php mysqld ssh2 phpMyAdmin eglibc-localedef:host smbclient msmtp aria2"
# only httpd for debug
#PKG_DEPENDS_TARGET="toolchain httpd"
PKG_PRIORITY="optional"
PKG_SECTION="service/web"
PKG_SHORTDESC="LAMP (Linux Apache MySQL PHP) software bundle."
PKG_LONGDESC="LAMP (Linux Apache MySQL PHP) software bundle. Done by ultraman, streppuiu, dominic7il"
PKG_MAINTAINER="vpeter"
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_AUTORECONF="no"
PKG_ADDON_NAME="Web server"
# not actually used
#PKG_ADDON_REPOVERSION="7.0"

make_target() {
  : # no sources here
}

makeinstall_target() {
  : # no sources here
}

addon() {
#set +e  # no exit on error

  HTTPD_DIR=$(get_build_dir httpd)/.install_dev
  MYSQL_DIR=$(get_build_dir mysqld)/.install_pkg
  PHPMYADMIN_BASE_DIR=$(basename $(get_build_dir phpMyAdmin))
  PHPMYADMIN_ZIP_DIR=$(readlink -f $SOURCES/phpMyAdmin)

  # create bin folder and copy binaries
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $HTTPD_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $HTTPD_DIR/usr/sbin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  # allow mounting SMB share in owncloud
  cp $(get_build_dir samba)/.$TARGET_NAME/bin/smbclient $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $(get_build_dir php)/.install_dev/usr/bin/php $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $(get_build_dir msmtp)/.install_pkg/usr/bin/msmtp $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp $(get_build_dir aria2)/.$TARGET_NAME/src/aria2c $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $MYSQL_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $MYSQL_DIR/usr/lib/mysqld $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $MYSQL_DIR/usr/lib/mysqlmanager $ADDON_BUILD/$PKG_ADDON_ID/bin

  # create lib folder and copy libraries
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $HTTPD_DIR/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $(get_build_dir libressl)/.install_pkg/usr/lib/lib*.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $(get_build_dir apr)/.install_dev/usr/lib/lib*.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $(get_build_dir apr-util)/.install_dev/usr/lib/lib*.so* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $(get_build_dir apr-util)/.install_dev/usr/lib/apr-util-1/*.so* $ADDON_BUILD/$PKG_ADDON_ID/lib

  cp $(get_build_dir ssh2)/modules/ssh2.so $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir php)/.install_dev/usr/lib/libphp5.so $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir bzip2)/.install_pkg/usr/lib/libbz2.so.1.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir curl)/.install_pkg/usr/lib/libcurl.so.4 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir expat)/.install_pkg/usr/lib/libexpat.so.1 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir freetype)/.install_pkg/usr/lib/libfreetype.so.6 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir libxml2)/.install_pkg/usr/lib/libxml2.so.2 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir zlib)/.install_pkg/usr/lib/libz.so.1 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir libgcrypt)/.install_pkg/usr/lib/libgcrypt.so.20 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir icu4c)/.install_pkg/usr/lib/lib*.so.* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $(get_build_dir libtool)/.install_pkg/usr/lib/libltdl.so.7 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # locale stuff (en_US.UTF8)
  cp -a $(get_build_dir eglibc-localedef)/lib/locale $ADDON_BUILD/$PKG_ADDON_ID/lib

  # add httpd www folder
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/www

  cp -PR $HTTPD_DIR/usr/htdocs $ADDON_BUILD/$PKG_ADDON_ID/www
  #cp -PR $HTTPD_DIR/usr/cgi-bin $ADDON_BUILD/$PKG_ADDON_ID/www
  #cp -PR $HTTPD_DIR/usr/manual $ADDON_BUILD/$PKG_ADDON_ID/www
  cp -PR $HTTPD_DIR/usr/icons $ADDON_BUILD/$PKG_ADDON_ID/www

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
  cp -a $PKG_DIR/config/php-tests $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
  cp $PKG_DIR/config/*.php $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs/
  cp $PKG_DIR/config/*.sql $ADDON_BUILD/$PKG_ADDON_ID/
  cp $PKG_DIR/config/ssl-server.conf $ADDON_BUILD/$PKG_ADDON_ID/

  # create httpd server root
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot

  # add httpd configuration files to server root
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/original $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/magic $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/mime.types $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/httpd.conf $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/extra $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/php.ini $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/mysqld.cnf $ADDON_BUILD/$PKG_ADDON_ID
  cp -PR $PKG_DIR/config/msmtprc $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf

  # add other httpd files to server root
  cp -PR $HTTPD_DIR/usr/error $ADDON_BUILD/$PKG_ADDON_ID/srvroot

  # create httpd server root log dir
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/logs

  # copy share and config files
  cp -PR $MYSQL_DIR/usr/share $ADDON_BUILD/$PKG_ADDON_ID

  # phpMyAdmin stuff
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
(
  cd $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
  unzip -qq "$PHPMYADMIN_ZIP_DIR/$PHPMYADMIN_BASE_DIR-*.zip"
  mv phpMyAdmin-* phpMyAdmin
)

  cp $PKG_DIR/config/config.inc.php $ADDON_BUILD/$PKG_ADDON_ID

  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf/certs
  # fix this
  cp /etc/ssl/certs/ca-certificates.crt $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf/certs

  # list libraries
  echo "Required libraries:"
  find $ROOT/$BUILD/addons/lamp/service.web.lamp/ -type f -exec objdump -x "{}" ";" 2>/dev/null | grep NEEDED | sort | uniq | grep -Ev "libc.so|libdl.so|libgcc_s.so|libm.so|libnsl.so|libpthread.so|libresolv.so|librt.so|librtmp.so|libstdc\+\+.so|libuuid.so|libcrypt.so" | awk '{printf("  %s\n", $2)}' | tee $ADDON_BUILD/libs-required.dat
  cat $ADDON_BUILD/libs-required.dat
  missing_lib="0"

  # dont use cat file | while read f; do  because variable scope is inside loop only
  while read f; do
    ff=$(find $ADDON_BUILD -name $f 2>/dev/null)
    if [ ! -f "$ff" ]; then
      if [ "$f" != "ld-linux-armhf.so.3" ]; then
        echo "not copied: $f"
        missing_lib="1"
      fi
    fi
  done < $ADDON_BUILD/libs-required.dat

  if [ "$missing_lib" == "0" ]; then
    echo "no missing libraries"
    echo ""
  else
    echo "missing libraries"
    echo ""
  fi



}

remove_all_packages() {

(
rm -fr target/addons
rm -fr build.OpenELEC-*/addons
rm -fr build.OpenELEC-*/apr*
rm -fr build.OpenELEC-*/apr-util*
rm -fr build.OpenELEC-*/eglibc*
rm -fr build.OpenELEC-*/eglibc-localedef*
rm -fr build.OpenELEC-*/httpd*
rm -fr build.OpenELEC-*/libmcrypt*
rm -fr build.OpenELEC-*/libssh2*
rm -fr build.OpenELEC-*/msmtp*
rm -fr build.OpenELEC-*/mysqld*
rm -fr build.OpenELEC-*/openssl*
rm -fr build.OpenELEC-*/php*
rm -fr build.OpenELEC-*/phpMyAdmin*
rm -fr build.OpenELEC-*/smbclient*
rm -fr build.OpenELEC-*/ssh2*
rm -fr build.OpenELEC-*/sendmail*
rm -fr build.OpenELEC-*/cyrus-sasl*
rm -fr build.OpenELEC-*/icu4c*

rm -fr build.OpenELEC-*/.stamps/lamp*
rm -fr build.OpenELEC-*/.stamps/apr*
rm -fr build.OpenELEC-*/.stamps/apr-util*
rm -fr build.OpenELEC-*/.stamps/eglibc*
rm -fr build.OpenELEC-*/.stamps/eglibc-localedef*
rm -fr build.OpenELEC-*/.stamps/httpd*
rm -fr build.OpenELEC-*/.stamps/libmcrypt*
rm -fr build.OpenELEC-*/.stamps/libssh2*
rm -fr build.OpenELEC-*/.stamps/msmtp*
rm -fr build.OpenELEC-*/.stamps/mysqld*
rm -fr build.OpenELEC-*/.stamps/openssl*
rm -fr build.OpenELEC-*/.stamps/php*
rm -fr build.OpenELEC-*/.stamps/phpMyAdmin*
rm -fr build.OpenELEC-*/.stamps/smbclient*
rm -fr build.OpenELEC-*/.stamps/ssh2*
rm -fr build.OpenELEC-*/.stamps/sendmail*
rm -fr build.OpenELEC-*/.stamps/cyrus-sasl*
rm -fr build.OpenELEC-*/.stamps/icu4c*

rm -fr build.OpenELEC-*/addons/lamp
)

(
PROJECT=Generic ARCH=x86_64 ./scripts/create_addon lamp 2>&1 | tee lamp-generic
PROJECT=RPi ARCH=arm ./scripts/create_addon lamp | tee lamp-rpi
PROJECT=RPi2 ARCH=arm ./scripts/create_addon lamp | tee lamp-rpi2
PROJECT=imx6 ARCH=arm ./scripts/create_addon lamp | tee lamp-imx6
)

(
PROJECT=Generic ARCH=x86_64 make release | tee log1
PROJECT=imx6 ARCH=arm make release | tee log2
PROJECT=RPi ARCH=arm make release | tee log3
PROJECT=RPi2 ARCH=arm make release | tee log4
)


}
