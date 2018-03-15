################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2018-present Team LibreELEC
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

PKG_NAME="jdk"
PKG_VERSION="8u162"
PKG_VERSION_BUILD="b12"
PKG_SHA256="68ec82d47fd9c2b8eb84225b6db398a72008285fafc98631b1ff8d2229680257"
PKG_ARCH="any"
PKG_LICENSE="probably"
PKG_SITE="http://www.oracle.com/"
PKG_URL="http://download.oracle.com/otn-pub/java/${PKG_NAME}/${PKG_VERSION}-${PKG_VERSION_BUILD}/0da788060d494f5095bf8624735fa2f1/${PKG_NAME}-${PKG_VERSION}-linux-x64.tar.gz"
PKG_SOURCE_NAME="${PKG_NAME}-${PKG_VERSION}-${PKG_VERSION_BUILD}.tar.gz"
PKG_SOURCE_DIR="${PKG_NAME}1.8.0_${PKG_VERSION##*u}"
PKG_DEPENDS_TARGET=""
PKG_SECTION="lang"
PKG_SHORTDESC="Java SE Development Kit 8 ..."
PKG_LONGDESC="$PKG_SHORTDESC"
PKG_TOOLCHAIN="manual"

# hack to set some wget parameters
export VERBOSE="yes"
export WGET_OPT="--no-cookies --header=Cookie:oraclelicense=accept-securebackup-cookie"
