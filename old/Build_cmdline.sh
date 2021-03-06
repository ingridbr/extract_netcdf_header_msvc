#!/bin/sh

if [ "$(dirname $0)" != ".." ]
then
    echo >&2 "Please execute $0 from a build subdirectory" ; exit 1
fi

#===============================
if [ "$MAINFILE" = "" ] ; then
    MAINFILE=lib-microservice-extract_netcdf_header.cpp
    if [ "$REPEAT" = "" ]; then
      REPEAT=1
    fi
else
    :
fi
MAINPATH="../src/$MAINFILE"

if [ "$LOG2BUF" = "" ] ; then
  LOG2BUF=7
fi
#===============================


if grep -i centos /etc/os-release >/dev/null 2>&1 ; then
  LIBCRYPTO_LOCATION=/usr/lib64
  LINK_TO_HDF5=hdf5
else # (assuming ubuntu/debian)
  LIBCRYPTO_LOCATION=/usr/lib/x86_64-linux-gnu
  LINK_TO_HDF5=hdf5_serial
fi 

if [ "$1" = clean ]
then
    rm -f *.o a.out
else
  {
    /opt/irods-externals/clang3.8-0/bin/clang++   -DBOOST_SYSTEM_NO_DEPRECATED \
    -DENABLE_RE -DRODS_SERVER -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE   \
    -D_LARGEFILE_SOURCE -D_LARGE_FILES -Dlinux_platform                      \
    -Dirods_build=0 -DREPEAT_N=$REPEAT \
    -Dmsiextract_netcdf_header_EXPORTS -I/opt/irods-externals/clang3.8-0/include/c++/v1 \
    -I/usr/include/irods -I/opt/irods-externals/qpid-with-proton0.34-0/include \
    -I/opt/irods-externals/boost1.60.0-0/include -I/opt/irods-externals/jansson2.7-0/include \
    -I/opt/irods-externals/libarchive3.3.2-0/include  -O0 -DNDEBUG -nostdinc++ \
    -std=c++14 -Wno-write-strings -std=gnu++14 \
    -o $MAINFILE.o \
    -c $MAINPATH -g -DIRODS_NETCDF_ATTRS=$LOG2BUF

# -fPIC
  } && \
       \
  {

LD_RUN=/opt/irods-externals/clang-runtime3.8-0/lib

    /opt/irods-externals/clang3.8-0/bin/clang++ -O0 -DNDEBUG  -stdlib=libc++ $MAINFILE.o \
    -lc++abi -lnetcdf -l${LINK_TO_HDF5} -lz /opt/irods-externals/boost1.60.0-0/lib/libboost_filesystem.so \
    /opt/irods-externals/boost1.60.0-0/lib/libboost_system.so \
    /opt/irods-externals/libarchive3.3.2-0/lib/libarchive.so $LIBCRYPTO_LOCATION/libcrypto.so \
    -Wl,-rpath,/opt/irods-externals/boost1.60.0-0/lib:/opt/irods-externals/libarchive3.3.2-0/lib:$LD_RUN -g
  }

fi

# -shared
## CMakeFiles/msiextract_netcdf_header.dir/src/lib-microservice-extract_netcdf_header.cpp.o \
