# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mysqld"
PKG_VERSION="5.7.20"
PKG_SHA256="5397549bb7c238f396c123db2df4cad2191b11adf8986de7fe63bff8e2786487"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.mysql.com"
PKG_URL="https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain zlib:host"
PKG_DEPENDS_TARGET="toolchain zlib ncurses openssl boost mysqld:host"
PKG_LONGDESC="A SQL database server."

# boost 1.59.0 officialy supported and required version (for server)"

# need to unpack in different folder
unpack() {
  SRC_ARCHIVE="$SOURCES/$PKG_NAME/mysqld-$PKG_VERSION.tar.gz"
  mkdir $PKG_BUILD
  tar xzf "$SRC_ARCHIVE" -C $PKG_BUILD
  mv $PKG_BUILD/mysql-$PKG_VERSION/* $PKG_BUILD
  rm -fr "$PKG_BUILD/mysql-$PKG_VERSION"

  if [ ! -f $SOURCES/boost_1_59_0.tar.gz ]; then
    wget -O $SOURCES/boost_1_59_0.tar.gz wget http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz
  fi

  tar xzf $SOURCES/boost_1_59_0.tar.gz -C $BUILD
}

post_unpack() {
  sed -i 's|GET_TARGET_PROPERTY(LIBMYSQL_OS_OUTPUT_NAME libmysql OUTPUT_NAME)|SET(LIBMYSQL_OS_OUTPUT_NAME "mysqlclient")|' $PKG_BUILD/scripts/CMakeLists.txt
  sed -i "s|COMMAND comp_err|COMMAND $PKG_BUILD/.$HOST_NAME/extra/comp_err|" $PKG_BUILD/extra/CMakeLists.txt
  sed -i "s|COMMAND comp_sql|COMMAND $PKG_BUILD/scripts/comp_sql|" $PKG_BUILD/scripts/CMakeLists.txt
  sed -i "s|COMMAND gen_lex_hash|COMMAND $PKG_BUILD/.$HOST_NAME/sql/gen_lex_hash|" $PKG_BUILD/sql/CMakeLists.txt
  sed -i "s|COMMAND gen_lex_token|COMMAND $PKG_BUILD/.$HOST_NAME/sql/gen_lex_token|" $PKG_BUILD/sql/CMakeLists.txt
}
                    
PKG_CMAKE_OPTS_HOST="
  -DCMAKE_BUILD_TYPE=Release \
  -DSTACK_DIRECTION=-1 \
  -DHAVE_LLVM_LIBCPP_EXITCODE=0 \
  -DHAVE_FALLOC_PUNCH_HOLE_AND_KEEP_SIZE=1 \
  -DWITHOUT_SERVER=OFF \
  -DWITH_EMBEDDED_SERVER=OFF \
  -DWITH_INNOBASE_STORAGE_ENGINE=OFF \
  -DWITH_PARTITION_STORAGE_ENGINE=OFF \
  -DWITH_PERFSCHEMA_STORAGE_ENGINE=OFF \
  -DWITH_EXTRA_CHARSETS=none \
  -DWITH_EDITLINE=bundled \
  -DWITH_LIBEVENT=bundled \
  -DDOWNLOAD_BOOST=0 \
  -DWITH_BOOST=$SOURCES/boost_1_59_0.tar.gz \
  -DWITH_UNIT_TESTS=OFF \
  -DWITH_PROTOBUF=bundled \
  -DWITH_ZLIB=bundled \
"

make_host() {
  ninja comp_err
  ninja gen_lex_hash
  ninja gen_lex_token
  ninja comp_sql
  ninja protoc
}

post_make_host() {
  # needed so the binary isn't built for target
  cp scripts/comp_sql ../scripts/comp_sql
}

makeinstall_host() {
  : # nothing
}

configure_package() {
  PKG_CMAKE_OPTS_TARGET="
    -DINSTALL_INCLUDEDIR=include/mysql \
    -DCMAKE_BUILD_TYPE=Release \
    -DFEATURE_SET=classic \
    -DDISABLE_SHARED=OFF \
    -DENABLE_DTRACE=OFF \
    -DWITH_EMBEDDED_SERVER=OFF \
    -DWITH_INNOBASE_STORAGE_ENGINE=ON \
    -DWITH_PARTITION_STORAGE_ENGINE=ON \
    -DWITH_PERFSCHEMA_STORAGE_ENGINE=ON \
    -DWITH_EXTRA_CHARSETS=all \
    -DWITH_UNIT_TESTS=OFF \
    -DWITHOUT_SERVER=OFF \
    -DWITH_EDITLINE=bundled \
    -DWITH_LIBEVENT=bundled \
    -DWITH_ZLIB=system \
    -DWITH_SSL=$SYSROOT_PREFIX/usr \
    \
    -DHAVE_FALLOC_PUNCH_HOLE_AND_KEEP_SIZE=1 \
    -DHAVE_IB_GCC_SYNC_SYNCHRONISE=1 \
    -DHAVE_IB_GCC_ATOMIC_THREAD_FENCE=1 \
    -DHAVE_IB_GCC_ATOMIC_COMPARE_EXCHANGE=1 \
    -DHAVE_IB_ATOMIC_PTHREAD_T_GCC=1 \
    -DHAVE_IB_LINUX_FUTEX=1 \
    \
    -DWITH_INNODB=1 \
    -DDOWNLOAD_BOOST=0 \
    -DWITH_BOOST=$SOURCES/boost_1_59_0.tar.gz \
    -DBOOST_INCLUDE_DIR=$BUILD/boost_1_59_0 \
    -DLOCAL_BOOST_DIR=$BUILD/boost_1_59_0 \
    -DWITH_PROTOBUF=bundled \
    -DPROTOBUF_PROTOC_EXECUTABLE=$PKG_BUILD/.$HOST_NAME/extra/protobuf/protoc \
    -DMYSQL_UNIX_ADDR=/run/mysql.sock \
    \
    -DSTACK_DIRECTION=1 \
    -DHAVE_LLVM_LIBCPP=1 \
    $HAVE_LIBAIO_ARG \
  "
}

#                       -DHAVE_FALLOC_PUNCH_HOLE_AND_KEEP_SIZE_EXITCODE=0 \
#                       -DHAVE_FUNC_IN_CXX_EXITCODE=0 \
#                       -DHAVE___BUILTIN_FFS_EXITCODE=0 \
#                       -DMUTEX_FUTEX=1 \
                                                                                        
# --with-plugins=innobase,innodb_plugin,myisam,myisammrg,csv"
#  -DWITH_<PLUGIN>=1

makeinstall_target() {
  # use this version only for addon (don't install it to a system)
  DESTDIR=$INSTALL ninja install $PKG_MAKEINSTALL_OPTS_TARGET
  
  INSTALL_DEV="$PKG_BUILD/.install_dev"
  DESTDIR=$INSTALL_DEV ninja install $PKG_MAKEINSTALL_OPTS_TARGET
}

# https://dev.mysql.com/doc/refman/5.7/en/show-plugins.html
# https://dev.mysql.com/doc/refman/5.7/en/csv-storage-engine.html
