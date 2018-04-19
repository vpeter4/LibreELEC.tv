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

PKG_NAME="phpMyAdmin"
#PKG_VERSION="4.2.2"
# needs new mysql
PKG_VERSION="4.6.6"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL2"
PKG_SITE="http://www.phpmyadmin.net/home_page/index.php"
PKG_URL="https://files.phpmyadmin.net/phpMyAdmin/$PKG_VERSION/phpMyAdmin-$PKG_VERSION-all-languages.zip"
PKG_DEPENDS_TARGET=""
PKG_SECTION="tools"
PKG_SHORTDESC="phpMyAdmin is a tool to handle the administration of MySQL databases."
PKG_LONGDESC="phpMyAdmin is a free software tool written in PHP, intended to handle the administration of MySQL over the Web."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  : # nothing
}

make_target() {
  : # nothing
}

makeinstall_target() {
  : # nothing
}

unpack() {
  # folder required to make .libreelec-unpack file
  mkdir $PKG_BUILD
  # unpack directly in addon script
}
