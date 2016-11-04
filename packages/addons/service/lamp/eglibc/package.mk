################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="eglibc"
PKG_VERSION="2.19-25249"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.eglibc.org/"
PKG_URL="http://sources.openelec.tv/devel/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET=""
PKG_DEPENDS_INIT=""
PKG_SECTION="virtual"
PKG_SHORTDESC="eglibc: The Embedded GNU C library"
KG_LONGDESC="The Embedded GLIBC (EGLIBC) is a variant of the GNU C Library (GLIBC) that is designed to work well on embedded systems. EGLIBC strives to be source and binary compatible with GLIBC. EGLIBCs goals include reduced footprint, configurable components, better support for cross-compilation and cross-testing. In contrast to what Ulrich Drepper makes out of GLIBC, in EGLIBC all patches assigned to the FSF will be considered regardless of individual or company affiliation and cooperation is encouraged, as well as communication, civility, and respect among developers."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

# don't build here - used by eglibc-localedef:host
