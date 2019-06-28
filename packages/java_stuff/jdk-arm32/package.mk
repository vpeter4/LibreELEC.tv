# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="jdk-arm32"
PKG_VERSION="8u211"
PKG_URL="file://$ROOT/../java/jdk-${PKG_VERSION}-linux-arm32-vfp-hflt.tar.gz"
PKG_ARCH="any"
PKG_LICENSE="Oracle License"
PKG_SITE="http://www.oracle.com/"
PKG_DEPENDS_TARGET=""
PKG_LONGDESC="Java SE Development Kit 8 ..."
PKG_TOOLCHAIN="manual"
GET_HANDLER_SUPPORT="file"

post_unpack() {
  echo "PKG_URL: $PKG_URL"
  rm -f $PKG_BUILD/src.zip
  rm -f $PKG_BUILD/javafx-src.zip
}
