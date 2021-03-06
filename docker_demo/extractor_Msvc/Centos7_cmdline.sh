#!/bin/bash

# Intended usage: 
#
# - On Ubuntu, for syntax check:
#
#   Bash$ NOLINK=1 ./Centos7_cmdline [clean]
#
# - On Centos 7, for command line with debug symbols:
#
#   Bash$ ./Centos7_cmdline [clean]
#

Script_Path=$(dirname "$0")

#===============================

if [ "$MAINFILE" = "" ] ; then
    MAINFILE=lib-microservice-extract_netcdf_header.cpp
else
    :
fi

MAINPATH="$Script_Path/src/$MAINFILE"

if [ "$LOG2BUF" = "" ] ; then
  LOG2BUF=7
fi

# ------------------- Main  -------------------

Compile_Status=""

if [ "$1" = clean ]
then
    rm -f $MAINFILE.o netcdf_debug
else
    /opt/irods-externals/clang3.8-0/bin/clang++   -DBOOST_SYSTEM_NO_DEPRECATED \
    -DENABLE_RE -DRODS_SERVER -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE   \
    -D_LARGEFILE_SOURCE -D_LARGE_FILES -Dlinux_platform -Dirods_build=0 \
    -Dmsiextract_netcdf_header_EXPORTS -I/opt/irods-externals/clang3.8-0/include/c++/v1 \
    -I/usr/include/irods -I/opt/irods-externals/qpid-with-proton0.34-0/include \
    -I/opt/irods-externals/boost1.60.0-0/include -I/opt/irods-externals/jansson2.7-0/include \
    -I/opt/irods-externals/libarchive3.3.2-0/include  -O0 -DNDEBUG -nostdinc++ \
    -std=c++14 -Wno-write-strings -std=gnu++14 \
    -o $MAINFILE.o \
    -c $MAINPATH -g -DIRODS_NETCDF_ATTRS=$LOG2BUF
    Compile_Status=$?
fi

if [ "$Compile_Status" = 0 \
     -a "$NOLINK" = "" ]
then
    LD_RUN=/opt/irods-externals/clang-runtime3.8-0/lib
    /opt/irods-externals/clang3.8-0/bin/clang++ -O0 -DNDEBUG  -stdlib=libc++ $MAINFILE.o \
    -lc++abi -lnetcdf -lhdf5 -lz /opt/irods-externals/boost1.60.0-0/lib/libboost_filesystem.so \
    /opt/irods-externals/boost1.60.0-0/lib/libboost_system.so \
    /opt/irods-externals/libarchive3.3.2-0/lib/libarchive.so /usr/lib64/libcrypto.so \
    -Wl,-rpath,/opt/irods-externals/boost1.60.0-0/lib:/opt/irods-externals/libarchive3.3.2-0/lib:$LD_RUN \
    -g -o netcdf_debug

# /opt/irods-externals/clang3.8-0/bin/clang++ -O0 -DNDEBUG -stdlib=libc++ lib-microservice-extract_netcdf_header.cpp.o -lc++abi -lnetcdf -lhdf5_serial -lz /opt/irods-externals/boost1.60.0-0/lib/libboost_filesystem.so /opt/irods-externals/boost1.60.0-0/lib/libboost_system.so /opt/irods-externals/libarchive3.3.2-0/lib/libarchive.so /usr/lib/x86_64-linux-gnu/libcrypto.so -Wl,-rpath,/opt/irods-externals/boost1.60.0-0/lib:/opt/irods-externals/libarchive3.3.2-0/lib:/opt/irods-externals/clang-runtime3.8-0/lib -g -o netcdf_debug

fi

