# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

# need to rebuild my libbluray package to enable .jar
#  ./scripts/clean libbluray

PKG_NAME="java"
PKG_VERSION="1.0"
PKG_SHA256=""
PKG_REV="101"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL=""

if [ "$PROJECT" = "Generic" ]; then
  PKG_DEPENDS_TARGET="jdk-x64"
elif [ "$PROJECT"="WeTek_Play" -o "$PROJECT" = "RPi" ]; then
  PKG_DEPENDS_TARGET="jdk-arm32"
fi

PKG_DEPENDS_TARGET+=" apache-ant:host libbluray"
PKG_SECTION="program"
PKG_SHORTDESC="Java SE Runtime Environment 8 for Blu-ray Disc Java menus"
PKG_LONGDESC="$PKG_SHORTDESC"
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="JRE for BD-J"
PKG_ADDON_TYPE="xbmc.python.script"

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID

  if [ "$PROJECT" = "Generic" ]; then
    cp -a $(get_build_dir jdk-x64)/jre $ADDON_BUILD/$PKG_ADDON_ID
    tar -xJf $PKG_DIR/lib-Generic.tar.xz -C $ADDON_BUILD/$PKG_ADDON_ID
  elif [ "$PROJECT"="WeTek_Play" -o "$PROJECT" = "RPi" ]; then
    cp -a $(get_build_dir jdk-arm32)/jre $ADDON_BUILD/$PKG_ADDON_ID
    tar -xJf $PKG_DIR/lib-RPi2.tar.xz -C $ADDON_BUILD/$PKG_ADDON_ID
  fi

  cp -a $PKG_DIR/profile.d $ADDON_BUILD/$PKG_ADDON_ID

  cp $(get_build_dir libbluray)/.install_pkg/usr/share/java/libbluray-j2se-*.jar \
     $ADDON_BUILD/$PKG_ADDON_ID
}
