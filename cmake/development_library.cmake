# TODO static dev libraries?
# TODO symlinks for h -> hpp headers?

install(
  TARGETS
    RodsAPIs
  ARCHIVE
    DESTINATION usr/lib
    COMPONENT ${IRODS_PACKAGE_COMPONENT_DEVELOPMENT_NAME}
  )

set(
  RULE_ENGINE_PLUGIN_AUDIT_AMQP
  ${CMAKE_BINARY_DIR}/libirods-microservice-extract_netcdf_header.so
  )

install(
  FILES
  ${CMAKE_BINARY_DIR}/libirods-microservice-extract_netcdf_header.so
  DESTINATION usr/include/irods
  COMPONENT ${IRODS_PACKAGE_COMPONENT_DEVELOPMENT_NAME}
  )

install(
  EXPORT
  IRODSTargets
  DESTINATION usr/lib/irods/cmake
  COMPONENT ${IRODS_PACKAGE_COMPONENT_DEVELOPMENT_NAME}
  )

set(CPACK_DEBIAN_${IRODS_PACKAGE_COMPONENT_DEVELOPMENT_NAME_UPPERCASE}_PACKAGE_NAME "irods-development")
set(CPACK_DEBIAN_${IRODS_PACKAGE_COMPONENT_DEVELOPMENT_NAME_UPPERCASE}_PACKAGE_DEPENDS "libssl-dev")

set(CPACK_RPM_${IRODS_PACKAGE_COMPONENT_DEVELOPMENT_NAME}_PACKAGE_NAME "irods-development")
if (IRODS_LINUX_DISTRIBUTION_NAME STREQUAL "centos")
  set(CPACK_RPM_${IRODS_PACKAGE_COMPONENT_SERVER_NAME}_PACKAGE_REQUIRES "openssl-devel")
elseif (IRODS_LINUX_DISTRIBUTION_NAME STREQUAL "opensuse")
  set(CPACK_RPM_${IRODS_PACKAGE_COMPONENT_SERVER_NAME}_PACKAGE_REQUIRES "libopenssl-devel")
endif()
