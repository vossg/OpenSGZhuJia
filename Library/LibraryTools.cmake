
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

macro(${_JCPRE}SETUP_MAIN_PROJECT _VMAJOR _VMINOR _VPATCH)

  SET   (${_JPPRE}TARGET_NAME         ${PROJECT_NAME}                       )
  SET   (${_JPPRE}PROJECT_TARGET_NAME ${PROJECT_NAME}                       )
  STRING(TOUPPER                      ${PROJECT_NAME} ${_JPPRE}TARGET_NAME_UC)

  SET(${${_JPPRE}TARGET_NAME_UC}_VERSION_MAJOR ${_VMAJOR})
  SET(${${_JPPRE}TARGET_NAME_UC}_VERSION_MINOR ${_VMINOR})
  SET(${${_JPPRE}TARGET_NAME_UC}_VERSION_PATCH ${_VPATCH})

  SET(${${_JPPRE}TARGET_NAME_UC}_VERSION_STRING 
      ${${${_JPPRE}TARGET_NAME_UC}_VERSION_MAJOR}.${${${_JPPRE}TARGET_NAME_UC}_VERSION_MINOR}.${${${_JPPRE}TARGET_NAME_UC}_VERSION_PATCH})

  SET(${_JPPRE}TARGET_LIST "" CACHE INTERNAL "")

  IF(CMAKE_VERSION VERSION_GREATER_EQUAL "3.29.0")
    SET(_CMAKE_WITH_PACKAGE_DEP                         TRUE                                )
    SET( CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_DEPENDENCIES 1942b4fa-b2c5-4546-9385-83f254070067)
    SET(_EXPORT_PACKAGE_DEPENDENCIES_PARAM_             "EXPORT_PACKAGE_DEPENDENCIES"       )
  ELSE()
    SET(_CMAKE_WITH_PACKAGE_DEP             FALSE)
    SET(_EXPORT_PACKAGE_DEPENDENCIES_PARAM_ ""   )
  ENDIF()

endmacro()

MACRO(${_JCPRE}SORT_TARGET_LIST)

  MESSAGE(STATUS "sort targets : ${${_JPPRE}TARGET_LIST}")

  #TO Implement
  #SET(SORTED_TARGET_LIST Lib1;Lib2;Lib3 CACHE INTERNAL "") 

  SET(${_JPPRE}SORTED_TARGET_LIST ${${_JPPRE}TARGET_LIST} CACHE INTERNAL "") 

  MESSAGE(STATUS "  ${${_JPPRE}SORTED_TARGET_LIST}")

ENDMACRO()

macro(${_JCPRE}EXPORT_MAIN_PROJECT)

  write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${${_JPPRE}TARGET_NAME}ConfigVersion.cmake
    VERSION       ${${${_JPPRE}TARGET_NAME_UC}_VERSION_STRING}
    COMPATIBILITY SameMajorVersion                                       )

  configure_package_config_file(
    ${CMAKE_SOURCE_DIR}/${${_JPPRE}TARGET_NAME}Config.cmake.in ${${_JPPRE}TARGET_NAME}Config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${${_JPPRE}TARGET_NAME}                     )


  install(FILES       ${PROJECT_BINARY_DIR}/${${_JPPRE}TARGET_NAME}Config.cmake
                      ${PROJECT_BINARY_DIR}/${${_JPPRE}TARGET_NAME}ConfigVersion.cmake
          DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${${_JPPRE}TARGET_NAME} 
          COMPONENT   dev                                                            )

endmacro()

MACRO(${_JCPRE}RESET_LIBRARY_PROJECT)

  set(${${_JPPRE}TARGET_NAME}_BASE_DIR        "" CACHE INTERNAL "")

  set(${${_JPPRE}TARGET_NAME}_SRC             "" CACHE INTERNAL "")
  set(${${_JPPRE}TARGET_NAME}_INS             "" CACHE INTERNAL "")

  set(${${_JPPRE}TARGET_NAME}_HDR             "" CACHE INTERNAL "")
  set(${${_JPPRE}TARGET_NAME}_PUBLIC_HDR      "" CACHE INTERNAL "")

  set(${${_JPPRE}TARGET_NAME}_INL             "" CACHE INTERNAL "")
  set(${${_JPPRE}TARGET_NAME}_PUBLIC_INL      "" CACHE INTERNAL "")

  set(${${_JPPRE}TARGET_NAME}_APP_SRC         "" CACHE INTERNAL "")
  set(${${_JPPRE}TARGET_NAME}_TEST_SRC        "" CACHE INTERNAL "")
  set(${${_JPPRE}TARGET_NAME}_UTEST_SRC       "" CACHE INTERNAL "")

  set(${${_JPPRE}TARGET_NAME}_ll              "" CACHE INTERNAL "")
  set(${${_JPPRE}TARGET_NAME}_yy              "" CACHE INTERNAL "")

  set(${${_JPPRE}TARGET_NAME}_EXCL_FILES      "" CACHE INTERNAL "")


  set(${${_JPPRE}TARGET_NAME}_SRC_PATTERNS    "" CACHE INTERNAL "")
  set(${${_JPPRE}TARGET_NAME}_HDR_PATTERNS    "" CACHE INTERNAL "")
  set(${${_JPPRE}TARGET_NAME}_INL_PATTERNS    "" CACHE INTERNAL "")
  set(${${_JPPRE}TARGET_NAME}_INS_PATTERNS    "" CACHE INTERNAL "")

  set(${${_JPPRE}TARGET_NAME}_PUBLIC_INCDIR   "" CACHE INTERNAL "")

  set(${${_JPPRE}TARGET_NAME}_PUB_DEP_TARGETS "" CACHE INTERNAL "")

  if(FALSE)
    SET(${PROJECT_NAME}_DEP_PUBLIC_INCDIR            )
    SET(${PROJECT_NAME}_DEP_SYS_PUBLIC_INCDIR        )

    SET(${PROJECT_NAME}_DEP_PRIVATE_INCDIR           )
    SET(${PROJECT_NAME}_DEP_SYS_PRIVATE_INCDIR       )

    SET(${PROJECT_NAME}_DEP_INTERFACE_INCDIR         )
    SET(${PROJECT_NAME}_DEP_SYS_INTERFACE_INCDIR     )

    SET(${PROJECT_NAME}_DEP_TEST_PUBLIC_INCDIR       )
    SET(${PROJECT_NAME}_DEP_SYS_TEST_PUBLIC_INCDIR   )

    SET(${PROJECT_NAME}_DEP_TEST_PRIVATE_INCDIR      )
    SET(${PROJECT_NAME}_DEP_SYS_TEST_PRIVATE_INCDIR  )

    SET(${PROJECT_NAME}_DEP_TEST_INTERFACE_INCDIR    )
    SET(${PROJECT_NAME}_DEP_SYS_TEST_INTERFACE_INCDIR)

    # clear dependency variables
    SET(${PROJECT_NAME}_DEP_OSG_LIB)
    SET(${PROJECT_NAME}_DEP_TEST_OSG_LIB)

    SET(${PROJECT_NAME}_DEP_LIB)
    SET(${PROJECT_NAME}_DEP_DEFS)

    SET(${PROJECT_NAME}_DEP_TEST_LIB)
    SET(${PROJECT_NAME}_DEP_TEST_DEFS)


    set(${PROJECT_NAME}_SUFFIX)

    SET(${PROJECT_NAME}_NO_DOC)

    SET(${PROJECT_NAME}_NO_PYTHON)
    SET(${PROJECT_NAME}_NO_DBG_INSTALL FALSE)
    SET(${PROJECT_NAME}_ENABLE_WRITE_PYTHON_TO_SOURCE)
  endif()
ENDMACRO()


macro(${_JCPRE}ADD_DIRECTORY _DIRNAME)

  cmake_language(CALL ${_JCPRE}MSG "  Adding directory: ${_DIRNAME}")

  set(_ADD_SRC_LOOKUP  )
  set(_ADD_HDR_LOOKUP  )
  set(_ADD_INL_LOOKUP  )
  set(_ADD_INS_LOOKUP  )
  set(_ADD_LL_LOOKUP   )
  set(_ADD_YY_LOOKUP   )
  set(_ADD_UTEST_LOOKUP)

  set(_RESDIR                       )
  set(_PREFIXPROC ${${_JPPRE}PREFIX})

  if(EXISTS "${CMAKE_SOURCE_DIR}/${_DIRNAME}")
    set(_RESDIR "${CMAKE_SOURCE_DIR}/${_DIRNAME}")
  elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${_DIRNAME}")
    set(_RESDIR "${CMAKE_CURRENT_SOURCE_DIR}/${_DIRNAME}")
  else()
    set(_RESDIR "${_DIRNAME}")
  endif()

  if(NOT DEFINED ${_JPPRE}PREFIX)
    message(FATAL_ERROR "${_JPPRE}PREFIX not set")
  endif()

  cmake_language(CALL ${_JCPRE}MSG "  using : -${_PREFIXPROC}- in ${_RESDIR}")

  list(LENGTH _PREFIXPROC _PREFIXSIZE)

  if(_PREFIXSIZE EQUAL 0)
    list(APPEND _PREFIXPROC "__UNSET__")
  endif()

  foreach(_FILE_PREFIX ${_PREFIXPROC})
    if((_FILE_PREFIX STREQUAL "\"\""     ) OR
       (_FILE_PREFIX STREQUAL "__UNSET__")   )
      set(_FILE_PREFIX )
    endif()

    if(FALSE)
      message(STATUS "  adding prefix : -${_FILE_PREFIX}-")
    endif()

    list(APPEND _ADD_SRC_LOOKUP   "${_RESDIR}/${_FILE_PREFIX}*.cpp"    )
    list(APPEND _ADD_HDR_LOOKUP   "${_RESDIR}/${_FILE_PREFIX}*.h"      )
 
    list(APPEND _ADD_INL_LOOKUP   "${_RESDIR}/${_FILE_PREFIX}*.inl"    )
    list(APPEND _ADD_INS_LOOKUP   "${_RESDIR}/${_FILE_PREFIX}*.ins"    )
    list(APPEND _ADD_LL_LOOKUP    "${_RESDIR}/${_FILE_PREFIX}*.ll"     )
    list(APPEND _ADD_YY_LOOKUP    "${_RESDIR}/${_FILE_PREFIX}*.yy"     )
    list(APPEND _ADD_LPP_LOOKUP   "${_RESDIR}/${_FILE_PREFIX}*.lpp"    )
    list(APPEND _ADD_Y_LOOKUP     "${_RESDIR}/${_FILE_PREFIX}*.y"      )
    list(APPEND _ADD_UTEST_LOOKUP "${_RESDIR}/${_FILE_PREFIX}*Test.cpp")
  endforeach()

  if(FALSE)
    cmake_language(CALL ${_JCPRE}MSG "    glob src   with: ${_ADD_SRC_LOOKUP}"  )
    cmake_language(CALL ${_JCPRE}MSG "    glob hdr   with: ${_ADD_HDR_LOOKUP}"  )
    cmake_language(CALL ${_JCPRE}MSG "    glob inl   with: ${_ADD_INL_LOOKUP}"  )
    cmake_language(CALL ${_JCPRE}MSG "    glob ins   with: ${_ADD_INS_LOOKUP}"  )

    cmake_language(CALL ${_JCPRE}MSG "    glob ll    with: ${_ADD_LL_LOOKUP}"   )
    cmake_language(CALL ${_JCPRE}MSG "    glob yy    with: ${_ADD_YY_LOOKUP}"   )

    cmake_language(CALL ${_JCPRE}MSG "    glob utest with: ${_ADD_UTEST_LOOKUP}")
  endif()

  file(GLOB _LOCAL_SRC       ${_ADD_SRC_LOOKUP}   )
  file(GLOB _LOCAL_HDR       ${_ADD_HDR_LOOKUP}   )
  file(GLOB _LOCAL_INL       ${_ADD_INL_LOOKUP}   )
  file(GLOB _LOCAL_INS       ${_ADD_INS_LOOKUP}   )

  file(GLOB _LOCAL_LL        ${_ADD_LL_LOOKUP}    )
  file(GLOB _LOCAL_YY        ${_ADD_YY_LOOKUP}    )

  file(GLOB _LOCAL_UTEST_SRC ${_ADD_UTEST_LOOKUP} )

  file(GLOB _LOCAL_TEST_SRC  "${_RESDIR}/test*.cpp")
  file(GLOB _LOCAL_APP_SRC   "${_RESDIR}/app*.cpp" )

  if(${${_JPPRE}TARGET_NAME}_EXCL_FILES)
    list(REMOVE_ITEM _LOCAL_SRC       ${${_JPPRE}TARGET_NAME}_EXCL_FILES})
    list(REMOVE_ITEM _LOCAL_HDR       ${${_JPPRE}TARGET_NAME}_EXCL_FILES})
    list(REMOVE_ITEM _LOCAL_INL       ${${_JPPRE}TARGET_NAME}_EXCL_FILES})
    list(REMOVE_ITEM _LOCAL_INS       ${${_JPPRE}TARGET_NAME}_EXCL_FILES})

    list(REMOVE_ITEM _LOCAL_LL        ${${_JPPRE}TARGET_NAME}_EXCL_FILES})
    list(REMOVE_ITEM _LOCAL_YY        ${${_JPPRE}TARGET_NAME}_EXCL_FILES})

    list(REMOVE_ITEM _LOCAL_UTEST_SRC ${${_JPPRE}TARGET_NAME}_EXCL_FILES})

    list(REMOVE_ITEM _LOCAL_TEST_SRC  ${${_JPPRE}TARGET_NAME}_EXCL_FILES})
    list(REMOVE_ITEM _LOCAL_APP_SRC   ${${_JPPRE}TARGET_NAME}_EXCL_FILES})
  endif() # ${${_JPPRE}TARGET_NAME}_EXCL_FILES

  # filter unittest sources out of library sources
  if(_LOCAL_UTEST_SRC)
    list(REMOVE_ITEM _LOCAL_SRC ${_LOCAL_UTEST_SRC})
  endif() # LOCAL_UTEST_SRC

  # filter test sources out of library sources
  if(_LOCAL_TEST_SRC)
    list(REMOVE_ITEM _LOCAL_SRC ${_LOCAL_TEST_SRC})
  endif() # _LOCAL_TEST_SRC)

  # filter test sources out of library sources
  if(_LOCAL_APP_SRC)
        LIST(REMOVE_ITEM _LOCAL_SRC ${_LOCAL_APP_SRC})
  endif() # _LOCAL_APP_SRC

  if(FALSE)
    cmake_language(CALL ${_JCPRE}MSG "    got src       : ${_LOCAL_SRC}"      )
    cmake_language(CALL ${_JCPRE}MSG "    got hdr       : ${_LOCAL_HDR}"      )
    cmake_language(CALL ${_JCPRE}MSG "    got inl       : ${_LOCAL_INL}"      )
    cmake_language(CALL ${_JCPRE}MSG "    got ins       : ${_LOCAL_INS}"      )

    cmake_language(CALL ${_JCPRE}MSG "    got ll        : ${_LOCAL_LL} "      )
    cmake_language(CALL ${_JCPRE}MSG "    got yy        : ${_LOCAL_YY} "      )

    cmake_language(CALL ${_JCPRE}MSG "    got utest src : ${_LOCAL_UTEST_SRC}")

    cmake_language(CALL ${_JCPRE}MSG "    got test src  : ${_LOCAL_TEST_SRC}" )
    cmake_language(CALL ${_JCPRE}MSG "    got app  src  : ${_LOCAL_APP_SRC}"  )
  endif()

if(FALSE)
    IF(NOT OSG_DISABLE_SOURCE_GROUPS)
      IF(NOT ${PROJECT_NAME}_BASE_DIR)
        # Add the source files to the source group
        #Strip the path down to a relative one
        IF(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${DIRNAME}")
          FILE(RELATIVE_PATH THE_SOURCE_GROUP
                             ${CMAKE_CURRENT_SOURCE_DIR}/Source
                             ${CMAKE_CURRENT_SOURCE_DIR}/${DIRNAME})
        ELSEIF(EXISTS "${CMAKE_SOURCE_DIR}/${DIRNAME}")
          FILE(RELATIVE_PATH THE_SOURCE_GROUP
                             ${CMAKE_SOURCE_DIR}/Source
                             ${CMAKE_SOURCE_DIR}/${DIRNAME})
        ELSE()
          FILE(RELATIVE_PATH THE_SOURCE_GROUP
                             ${CMAKE_SOURCE_DIR}/Source
                             ${CMAKE_SOURCE_DIR}/${DIRNAME})
        ENDIF()
      ELSE()
          FILE(RELATIVE_PATH THE_SOURCE_GROUP
                             ${${PROJECT_NAME}_BASE_DIR}/
                             ${_OSG_CURR_DIRNAME})
      ENDIF()

      IF(THE_SOURCE_GROUP)
           STRING(REPLACE "/" "\\" THE_SOURCE_GROUP ${THE_SOURCE_GROUP})
      ELSE(THE_SOURCE_GROUP)
           SET(THE_SOURCE_GROUP "Source")
      ENDIF(THE_SOURCE_GROUP)

      IF(${THE_SOURCE_GROUP} STREQUAL "\\")
           SET(THE_SOURCE_GROUP "Source")
      ENDIF()

      LIST(APPEND ${PROJECT_NAME}_SOURCE_GROUPS ${THE_SOURCE_GROUP})
      SET(${PROJECT_NAME}_SOURCE_GROUPS ${${PROJECT_NAME}_SOURCE_GROUPS}
                                        CACHE INTERNAL "" FORCE)

      STRING(REPLACE "\\" "_" THE_SOURCE_GROUP ${THE_SOURCE_GROUP})
      LIST(APPEND ${PROJECT_NAME}_SOURCE_GROUP_${THE_SOURCE_GROUP}
                  ${LOCAL_SRC}
                  ${LOCAL_HDR}
                  ${LOCAL_INL}
                  ${LOCAL_INS}
                  ${LOCAL_FCD}
                  ${LOCAL_LL}
                  ${LOCAL_YY}
                  ${LOCAL_MOC})

      SET(${PROJECT_NAME}_SOURCE_GROUP_${THE_SOURCE_GROUP}
            ${${PROJECT_NAME}_SOURCE_GROUP_${THE_SOURCE_GROUP}}
            CACHE INTERNAL "" FORCE)

    ENDIF(NOT OSG_DISABLE_SOURCE_GROUPS)
endif()

  list(APPEND ${${_JPPRE}TARGET_NAME}_SRC           ${_LOCAL_SRC})
  list(APPEND ${${_JPPRE}TARGET_NAME}_INS           ${_LOCAL_INS})

  list(APPEND ${${_JPPRE}TARGET_NAME}_HDR           ${_LOCAL_HDR})
  list(APPEND ${${_JPPRE}TARGET_NAME}_PUBLIC_HDR    ${_LOCAL_HDR})

  list(APPEND ${${_JPPRE}TARGET_NAME}_INL           ${_LOCAL_INL})
  list(APPEND ${${_JPPRE}TARGET_NAME}_PUBLIC_INL    ${_LOCAL_INL})

  list(APPEND ${${_JPPRE}TARGET_NAME}_ll            ${_LOCAL_LL})
  list(APPEND ${${_JPPRE}TARGET_NAME}_yy            ${_LOCAL_YY})

  list(APPEND ${${_JPPRE}TARGET_NAME}_TEST_SRC      ${_LOCAL_TEST_SRC})
  list(APPEND ${${_JPPRE}TARGET_NAME}_APP_SRC       ${_LOCAL_APP_SRC} )

  list(APPEND ${${_JPPRE}TARGET_NAME}_PUBLIC_INCDIR ${_RESDIR}        )


  if(FALSE)
    cmake_language(CALL ${_JCPRE}MSG 
                     "    got src     : ${${${_JPPRE}TARGET_NAME}_SRC}"     )
    cmake_language(CALL ${_JCPRE}MSG 
                     "    got hdr     : ${${${_JPPRE}TARGET_NAME}_HDR}"     )
    cmake_language(CALL ${_JCPRE}MSG 
                     "    got inl     : ${${${_JPPRE}TARGET_NAME}_INL}"     )
    cmake_language(CALL ${_JCPRE}MSG 
                     "    got ins     : ${${${_JPPRE}TARGET_NAME}_INS}"     )

    cmake_language(CALL ${_JCPRE}MSG 
                     "    got ll      : ${${${_JPPRE}TARGET_NAME}_ll}"      )
    cmake_language(CALL ${_JCPRE}MSG
                     "    got yy      : ${${${_JPPRE}TARGET_NAME}_yy}"      )

    cmake_language(CALL ${_JCPRE}MSG
                     "    got test src: ${${${_JPPRE}TARGET_NAME}_TEST_SRC}")
    cmake_language(CALL ${_JCPRE}MSG
                     "    got app  src: ${${${_JPPRE}TARGET_NAME}_APP_SRC}" )
  endif()

  cmake_language(CALL ${_JCPRE}MSG "    ")

endmacro()


macro(${_JCPRE}INIT_LIBRARY_PROJECT PRJ_NAME)

  project(${PRJ_NAME})

  set(${_JPPRE}TARGET_NAME ${PROJECT_NAME})

  option(${_JTPRE}BUILD_${${_JPPRE}TARGET_NAME} 
         "Build the ${${_JPPRE}TARGET_NAME} library" ON)

  if(NOT OSG_DISABLE_SOURCE_GROUPS)
    set(${${_JPPRE}TARGET_NAME}_SOURCE_GROUPS "" CACHE INTERNAL "" FORCE)
  endif()

  if(${_JTPRE}BUILD_${${_JPPRE}TARGET_NAME})
    message(STATUS "Processing ${${_JPPRE}TARGET_NAME}")
  else()
    cmake_language(CALL ${_JCPRE}MSG "Skipping ${${_JPPRE}TARGET_NAME}")
    RETURN()
  endif()

  cmake_language(CALL ${_JCPRE}RESET_LIBRARY_PROJECT ${PRJ_NAME})

  set_directory_properties(PROPERTIES CLEAN_NO_CUSTOM TRUE)

endmacro()



function(${_JCPRE}SETUP_LIBRARY_TARGET _TARGET_COMPILE_TAG)

  string(TOUPPER ${CMAKE_PROJECT_NAME}    _CPN_UC                )
  string(TOUPPER ${${_JPPRE}TARGET_NAME}  ${_JPPRE}TARGET_NAME_UC)

  message(STATUS "Adding library : ${${_JPPRE}TARGET_NAME} in ${CMAKE_PROJECT_NAME} with aliases")
  message(STATUS "  ${${_JPPRE}PROJECT_TARGET_NAME}::${${_JPPRE}TARGET_NAME}")

  add_library(${${_JPPRE}TARGET_NAME} SHARED ${${${_JPPRE}TARGET_NAME}_SRC} 
                                             ${${${_JPPRE}TARGET_NAME}_HDR})

  add_library(${${_JPPRE}PROJECT_TARGET_NAME}::${${_JPPRE}TARGET_NAME} 
                ALIAS ${${_JPPRE}TARGET_NAME})

  set(${_JPPRE}TARGET_LIST ${${_JPPRE}TARGET_LIST};${${_JPPRE}TARGET_NAME} CACHE INTERNAL "")


  foreach(_PUB_INCDIR ${${${_JPPRE}TARGET_NAME}_PUBLIC_INCDIR})
    target_include_directories(
      ${${_JPPRE}TARGET_NAME}
      PRIVATE   ${_PUB_INCDIR}
	  INTERFACE $<BUILD_INTERFACE:${_PUB_INCDIR}>
	            $<INSTALL_INTERFACE:include/${CMAKE_PROJECT_NAME}>)
  endforeach()


  target_link_options(
    ${${_JPPRE}TARGET_NAME}
    PRIVATE $<$<COMPILE_LANG_AND_ID:CXX,AppleClang,Clang>:LINKER:--no-undefined>
    PRIVATE $<$<COMPILE_LANG_AND_ID:CXX,GNU>:LINKER:--no-undefined>)

  set_property(TARGET ${${_JPPRE}TARGET_NAME} 
               PROPERTY
                 PUBLIC_HEADER "${${${_JPPRE}TARGET_NAME}_PUBLIC_HDR}")
  set_property(TARGET ${${_JPPRE}TARGET_NAME} 
               APPEND PROPERTY
                 PUBLIC_HEADER "${${${_JPPRE}TARGET_NAME}_PUBLIC_INL}")

  set_property(TARGET ${${_JPPRE}TARGET_NAME} 
               PROPERTY POSITION_INDEPENDENT_CODE ON)

  set_property(TARGET ${${_JPPRE}TARGET_NAME} 
               PROPERTY VERSION   ${${_CPN_UC}_VERSION_STRING})

  set_property(TARGET ${${_JPPRE}TARGET_NAME} 
               PROPERTY SOVERSION ${${_CPN_UC}_VERSION_MAJOR} )

  if(_TARGET_COMPILE_TAG)
    set_property(TARGET ${${_JPPRE}TARGET_NAME} 
                 PROPERTY 
                   DEFINE_SYMBOL ${_TARGET_COMPILE_TAG})
  else()
    set_property(TARGET ${${_JPPRE}TARGET_NAME} 
                 PROPERTY 
                   DEFINE_SYMBOL COMPILE_${${_JPPRE}TARGET_NAME_UC}LIB)
  endif()

  if(WIN32)
    set_property(TARGET   ${${_JPPRE}TARGET_NAME}
                 PROPERTY DEBUG_POSTFIX           D)
  endif()

  target_link_libraries(${${_JPPRE}TARGET_NAME} PUBLIC ${_JTPRE}::compiler_settings)

  foreach(_PUB_DEP_TARGET ${${${_JPPRE}TARGET_NAME}_PUB_DEP_TARGETS})
    target_link_libraries(${${_JPPRE}TARGET_NAME} PUBLIC ${${_PUB_DEP_TARGET}})
  endforeach()


  install(EXPORT      ${${_JPPRE}TARGET_NAME}Targets 
          NAMESPACE   ${${_JPPRE}PROJECT_TARGET_NAME}::
          DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${${_JPPRE}TARGET_NAME}
          COMPONENT   dev
          ${_EXPORT_PACKAGE_DEPENDENCIES_PARAM_}                          )

  write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${${_JPPRE}TARGET_NAME}ConfigVersion.cmake
    VERSION ${${_CPN_UC}_VERSION_STRING}
    COMPATIBILITY SameMajorVersion                                        )

  configure_package_config_file(
    ${CMAKE_CURRENT_FUNCTION_LIST_DIR}/LibConfig.cmake.in ${${_JPPRE}TARGET_NAME}Config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${${_JPPRE}TARGET_NAME}                )


  install(FILES       ${CMAKE_CURRENT_BINARY_DIR}/${${_JPPRE}TARGET_NAME}Config.cmake
                      ${CMAKE_CURRENT_BINARY_DIR}/${${_JPPRE}TARGET_NAME}ConfigVersion.cmake
          DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${${_JPPRE}TARGET_NAME}
          COMPONENT   dev                                                                    )

  install(TARGETS     ${${_JPPRE}TARGET_NAME} 

          EXPORT      ${${_JPPRE}TARGET_NAME}Targets

	      ARCHIVE 
                  DESTINATION        ${CMAKE_INSTALL_LIBDIR}$<$<CONFIG:Debug>:/debug>
                  COMPONENT          dev

          LIBRARY 
                  DESTINATION        ${CMAKE_INSTALL_LIBDIR}$<$<CONFIG:Debug>:/debug>
                  COMPONENT          run
                  NAMELINK_COMPONENT dev

          RUNTIME 
                  DESTINATION        ${CMAKE_INSTALL_BINDIR}$<$<CONFIG:Debug>:/debug>
                  COMPONENT          run

          PUBLIC_HEADER 
                  DESTINATION        ${CMAKE_INSTALL_INCLUDEDIR}/${CMAKE_PROJECT_NAME}
                  COMPONENT          dev                                              )

endfunction()


###############
# Configured.h
###############

function(${_JCPRE}SETUP_CONFIGURED_H _SRC_CFGFILE _TARGET_CFGFILE)

  execute_process(
    COMMAND "${CMAKE_COMMAND}" -E copy
                     "${_SRC_CFGFILE}"
                     "${_TARGET_CFGFILE}.tmp.cmake")

  foreach(_ADD_CONFIGURE_LINE ${${_JPPRE}ADDITIONAL_CONFIGURE_LINES})
    file(APPEND "${_TARGET_CFGFILE}.tmp.cmake" "\n${_ADD_CONFIGURE_LINE}\n")
  endforeach()

  file(APPEND "${_TARGET_CFGFILE}.tmp.cmake" "\n#endif // _${_JPPRE}CONFIGURED_H_\n")

  configure_file("${_TARGET_CFGFILE}.tmp.cmake"
                 "${_TARGET_CFGFILE}.tmp")

  execute_process(
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different
                     "${_TARGET_CFGFILE}.tmp"
                     "${_TARGET_CFGFILE}"    )

endfunction()

function(${_JCPRE}SETUP_CONFIGURED_VERSION_H _SRC_CFGFILE _TARGET_CFGFILE)

  execute_process(
    COMMAND "${CMAKE_COMMAND}" -E copy
                     "${_SRC_CFGFILE}"
                     "${_TARGET_CFGFILE}.tmp.cmake")

  foreach(_ADD_CONFIGURE_LINE ${${_JPPRE}ADDITIONAL_CONFIGURE_VER_LINES})
    file(APPEND "${_TARGET_CFGFILE}.tmp.cmake" "\n${_ADD_CONFIGURE_LINE}\n")
  endforeach()

  file(APPEND "${_TARGET_CFGFILE}.tmp.cmake" "\n#endif // _${_JPPRE}CONFIGUREDVERSIONS_H_\n")

  configure_file("${_TARGET_CFGFILE}.tmp.cmake"
                 "${_TARGET_CFGFILE}.tmp")

  execute_process(
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different
                     "${_TARGET_CFGFILE}.tmp"
                     "${_TARGET_CFGFILE}"    )

endfunction()
