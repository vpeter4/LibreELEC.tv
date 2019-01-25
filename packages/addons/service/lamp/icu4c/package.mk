################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="icu4c"
PKG_VERSION="63.1"
PKG_VERSION_UNDERSCORE="${PKG_VERSION//./_}"
PKG_LICENSE="OpenSource"
PKG_SITE="http://site.icu-project.org/"
PKG_URL="http://download.icu-project.org/files/$PKG_NAME/$PKG_VERSION/$PKG_NAME-$PKG_VERSION_UNDERSCORE-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain icu4c:host"
PKG_LONGDESC="libraries providing Unicode"
PKG_TOOLCHAIN="configure"

post_unpack() {
  mv $PKG_BUILD/source/* $PKG_BUILD
  rmdir $PKG_BUILD/source
}

post_configure_host() {
  # we are not in source folder
  sed -i 's|../LICENSE|LICENSE|' Makefile
}

post_configure_target() {
  # same as above
  post_configure_host
}

makeinstall_host() {
  : # not required
}


pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="
    --with-cross-build=$(get_build_dir $PKG_NAME)/.$HOST_NAME \
    --with-data-packaging=archive \
    --disable-samples \
    --disable-tests \
  "
}
