################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="aria2"
PKG_VERSION="1.34.0"
PKG_LICENSE="GPL"
PKG_SITE="https://aria2.github.io/"
PKG_URL="https://github.com/tatsuhiro-t/aria2/releases/download/release-$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain zlib openssl libxml2"
PKG_LONGDESC="aria2 is a lightweight multi-protocol & multi-source command-line download utility. It supports HTTP/HTTPS, FTP, BitTorrent and Metalink. aria2 can be manipulated via built-in JSON-RPC and XML-RPC interfaces"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="
  XML2_CONFIG=$SYSROOT_PREFIX/usr/bin/xml2-config \
  --without-libuv \
  --without-appletls \
  --without-wintls \
  --without-gnutls \
  --without-libnettle \
  --without-libgcrypt \
  --with-openssl \
  --without-sqlite3 \
  --disable-xmltest \
  --without-libexpat \
  --with-libxml2 \
  --without-libcares \
  --with-ca-bundle=$SSL_CERTIFICATES/cacert.pem \
  --with-gnu-ld \
"

makeinstall_target() {
  : # meh
}
