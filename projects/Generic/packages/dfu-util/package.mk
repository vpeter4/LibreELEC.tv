################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016 Team LibreELEC
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

PKG_NAME="dfu-util"
PKG_VERSION="0.9"
PKG_ARCH="any"
PKG_LICENSE="GPL2"
PKG_SITE="http://dfu-util.sourceforge.net/"
PKG_URL="http://dfu-util.sourceforge.net/releases/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="system"
PKG_SHORTDESC="dfu-util is intended to download firmware to devices connected over USB."
PKG_LONGDESC="dfu-util is intended to download firmware to devices connected over USB."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp $PKG_DIR/stm_fw/flashStm $INSTALL/usr/bin

  mkdir -p $INSTALL/usr/share/solidpc
  cp $PKG_DIR/stm_fw/CECbridge.bin* $INSTALL/usr/share/solidpc
}
