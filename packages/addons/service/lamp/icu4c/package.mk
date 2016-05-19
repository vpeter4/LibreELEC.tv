################################################################################
#      This file is part of LibreELEC - https://LibreELEC.tv
#      Copyright (C) 2016 Team LibreELEC
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

PKG_NAME="icu4c"
PKG_VERSION="57.1"
PKG_VERSION_UNDERSCORE="$(echo $PKG_VERSION | tr '.' '_' )"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://site.icu-project.org/"
PKG_URL="http://download.icu-project.org/files/$PKG_NAME/$PKG_VERSION/$PKG_NAME-$PKG_VERSION_UNDERSCORE-src.tgz"
PKG_SOURCE_DIR="icu"
PKG_DEPENDS_TARGET="toolchain icu4c:host"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="libraries providing Unicode"
PKG_LONGDESC="libraries providing Unicode"
PKG_MAINTAINER="vpeter"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

post_unpack() {
  mv $ROOT/$PKG_BUILD/source/* $ROOT/$PKG_BUILD
  rmdir $ROOT/$PKG_BUILD/source
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
  PKG_CONFIGURE_OPTS_TARGET="--with-cross-build=$(get_build_dir $PKG_NAME)/.$HOST_NAME \
                             --with-data-packaging=archive \
                             --disable-samples \
                             --disable-tests"
}
