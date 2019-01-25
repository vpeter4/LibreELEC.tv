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

PKG_NAME="eglibc-localedef"
PKG_VERSION="2.19-25249"
PKG_LICENSE="GPL"
PKG_SITE="http://www.eglibc.org/"
#PKG_URL="http://sources.openelec.tv/devel/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_URL="http://vpeter.libreelec.tv/lamp/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_HOST="eglibc:host"
PKG_DEPENDS_TARGET="toolchain eglibc eglibc-localedef:host"
PKG_LONGDESC="locale"
PKG_TOOLCHAIN="configure"

pre_configure_host() {
  PKG_CONFIGURE_OPTS_HOST="
    --prefix=$PKG_BUILD \
    --with-glibc=$(get_build_dir eglibc) \
  "

	export CFLAGS="$CFLAGS -fgnu89-inline"
}

make_host() {
  # http://cross-lfs.org/view/clfs-sysroot/arm/cross-tools/eglibc.html
  SUPPORTED_LOCALES="en_US.UTF-8/UTF-8"
  make install-locales SUPPORTED-LOCALES=$SUPPORTED_LOCALES
}

makeinstall_host() {
  : # done with make
}

# nothing for target #####

configure_target() {
  : # nothing
}

make_target() {
  # remove empty folder
  rm -fr "$PKG_BUILD/.$TARGET_NAME"
}

makeinstall_target() {
  : # nothing
}
