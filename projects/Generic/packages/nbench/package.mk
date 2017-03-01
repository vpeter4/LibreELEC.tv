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

PKG_NAME="nbench"
PKG_VERSION="592e671"
PKG_ARCH="any"
PKG_LICENSE="no idea"
PKG_SITE="https://github.com/santoshsahoo/nbench"
PKG_URL="https://github.com/santoshsahoo/nbench/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="$PKG_NAME-${PKG_COMMIT}*"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="system"
PKG_SHORTDESC="Linux/Unix nbench (previously known as BYTE's Native Mode Benchmarks)."
PKG_LONGDESC="Linux/Unix nbench (previously known as BYTE's Native Mode Benchmarks)."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make CC="$CC" CFLAGS="$CFLAGS"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp nbench $INSTALL/usr/bin
  
  mkdir -p $INSTALL/usr/share/nbench
  cp COM.DAT  $INSTALL/usr/share/nbench
  cp NNET.DAT $INSTALL/usr/share/nbench
}
