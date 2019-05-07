# NetCDF header extraction for iRODS

This is a simple microservice , callable from any iRODS rule base, which can read the header data 
from a NetCDF-formatted file in the filesystem. 

The hierarchical structure of the NetCDF formatted
data in the file (variable types, dimensions, etc.) is gathered into a KeyValuePair object, which
may then be associated to the file's data object once it is registered into iRODS.

This use-case is codified in the demonstration script `src/reg_with_metadata.r`, which may be run 
by following the instructions below


## Running the microservice demo script
----

### System requirements 

The following support libraries should be installed before building and installing the microservice:

   - netcdf-devel
   - hdf5-devel
   - zlib-devel

(As always when building iRODS software, make sure irods-devel is installed as well.)

### Demonstration of usage on CentOS 7

   - Enable the [EPEL](https://fedoraproject.org/wiki/EPEL) repo
     and install the above mentioned libraries
   - cd into the repo top level directory, then `mkdir build; cd build`
   - Build the microservice as a shared object. (May also need to change irods version number in the find_package directive in 
     CMakeLists.txt)
     ```
     cmake ../  && make && sudo install lib*.so /usr/lib/irods/plugins/microservices
     ```
   - copy `src/reg_with_metadata.r` to /tmp
   - as irods service account make sure we're in /tmp and download an example NetCDF binary data file
     ```
     myuser@host:~$ su - irods
     irods@host:~$ cd /tmp
     irods@host:/tmp$ wget https://www.unidata.ucar.edu/software/netcdf/examples/test_hgroups.nc
     irods@host:/tmp$ irule -F reg_with_metadata.r "*phyFile='$(pwd)/test_hgroups.nc'"
     ```
