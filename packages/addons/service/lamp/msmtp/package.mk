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

PKG_NAME="msmtp"
PKG_VERSION="1.6.6"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE=""
PKG_SITE="http://msmtp.sourceforge.net/"
PKG_URL="http://sourceforge.net/projects/msmtp/files/msmtp/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="security"
PKG_SHORTDESC="msmtp is an SMTP client."
PKG_LONGDESC="msmtp is an SMTP client."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  PKG_CONFIGURE_OPTS_TARGET="--sysconfdir=/storage/.kodi/userdata/addon_data/service.web.lamp/srvroot/conf"
}

makeinstall_target() {
  # use this version only for addon (don't install it to a system)
  make -j1 install DESTDIR=$INSTALL $PKG_MAKEINSTALL_OPTS_TARGET
  $STRIP $INSTALL/usr/bin/msmtp
}
