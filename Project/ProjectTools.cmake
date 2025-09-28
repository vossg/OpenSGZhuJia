
#############################################################################
# common target
#############################################################################

macro(${_JCPRE}COMMON_TARGETS)

  add_custom_target(${_JTPRE}All)

  add_custom_target(             ${_JTPRE}AllApps)
  add_dependencies (${_JTPRE}All ${_JTPRE}AllApps)

  # optional pass for test programs
  if(${_JPPRE}BUILD_TESTS)
    add_custom_target(             ${_JTPRE}AllTests)
    add_dependencies (${_JTPRE}All ${_JTPRE}AllTests)
  endif() 

  if(${_JPPRE}BUILD_UNITTESTS)
    add_custom_target(             ${_JTPRE}AllUTests)
    add_dependencies (${_JTPRE}All ${_JTPRE}AllUTests)
  endif()

  if(${_JPPRE}BUILD_UNITBENCH)
    add_custom_target(             ${_JTPRE}AllUBench)
    add_dependencies (${_JTPRE}All ${_JTPRE}AllUBench)
  endif()

  add_custom_target(                ${_JTPRE}AllLibs       )
  add_custom_target(                ${_JTPRE}AllCoreLibs   )
  add_custom_target(                ${_JTPRE}AllContribLibs)

  add_dependencies(${_JTPRE}All     ${_JTPRE}AllLibs       )
  add_dependencies(${_JTPRE}AllLibs ${_JTPRE}AllCoreLibs   )
  add_dependencies(${_JTPRE}AllLibs ${_JTPRE}AllContribLibs)

endmacro()

#############################################################################
# import target mapping
#############################################################################

macro(${_JCPRE}GEN_IMPORT_MAPS)
  if(WIN32)
    set_property(GLOBAL PROPERTY CMAKE_MAP_IMPORTED_CONFIG_DEBUGOPT     Debug  )
    set_property(GLOBAL PROPERTY CMAKE_MAP_IMPORTED_CONFIG_RELEASENOOPT Release)
  endif()

  if(LINUX)
    set_property(GLOBAL PROPERTY CMAKE_MAP_IMPORTED_CONFIG_DEBUGGV      Debug  )
    set_property(GLOBAL PROPERTY CMAKE_MAP_IMPORTED_CONFIG_RELEASEGV    Release)
  endif()
endmacro()

function(fixupTargetConfigs _tgt)

  if(WIN32)
    set_property(TARGET ${_tgt} 
                 PROPERTY MAP_IMPORTED_CONFIG_DEBUGOPT     Debug  )

    set_property(TARGET ${_tgt} 
                 PROPERTY MAP_IMPORTED_CONFIG_RELEASENOOPT Release)
  endif()

  if(WIN32)
    set_property(TARGET ${_tgt} 
                 PROPERTY MAP_IMPORTED_CONFIG_DEBUGGV      Debug  )

    set_property(TARGET ${_tgt} 
                 PROPERTY MAP_IMPORTED_CONFIG_RELEASEGV    Release)
  endif()

ENDFUNCTION()

#############################################################################
# record git versions
#############################################################################

macro(${_JCPRE}FIND_REVISION_GIT DIRECTORY NAME)

  find_package(Git)

  if(GIT_FOUND)
    if(EXISTS ${DIRECTORY}/.git)
    
      execute_process(COMMAND ${GIT_EXECUTABLE} rev-list --count HEAD
                      WORKING_DIRECTORY ${DIRECTORY}
                      OUTPUT_VARIABLE _${NAME}_WC_REVISION_COUNT 
                      OUTPUT_STRIP_TRAILING_WHITESPACE                )

      EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
                      WORKING_DIRECTORY ${DIRECTORY}
                      OUTPUT_VARIABLE _${NAME}_WC_REVISION_ABBREV_HEAD 
                      OUTPUT_STRIP_TRAILING_WHITESPACE                )

      EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
                      WORKING_DIRECTORY ${DIRECTORY}
                      OUTPUT_VARIABLE _${NAME}_WC_REVISION_HEAD 
                      OUTPUT_STRIP_TRAILING_WHITESPACE                )

      EXECUTE_PROCESS(COMMAND ${GIT_EXECUTABLE} show -s --format=%ai HEAD
                      WORKING_DIRECTORY ${DIRECTORY}
                      OUTPUT_VARIABLE ${NAME}_WC_REVISION_DATE 
                      OUTPUT_STRIP_TRAILING_WHITESPACE                )

      SET(${NAME}_WC_REVISION_ID "${_${NAME}_WC_REVISION_COUNT}_${_${NAME}_WC_REVISION_ABBREV_HEAD}_${_${NAME}_WC_REVISION_HEAD}")
    ELSE()
      SET(${NAME}_WC_REVISION -1)
    ENDIF()
  ELSE()
    SET(${NAME}_WC_REVISION -2)
  ENDIF()
  
endmacro() # FIND_REVISION_GIT)


macro(${_JCPRE}CREATE_VERSIONFILE DIRECTORY PNAME)

  find_package(Git)

  add_custom_target(${PNAME}CreateVersionFile 
                    ALL 
                    COMMENT  "${PName} create version files")

  if(NOT WIN32)
    add_custom_command(
      TARGET ${PNAME}CreateVersionFile 
      POST_BUILD
      COMMAND echo "################### ${PNAME} #################" >  ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND echo -n "head: "                                      >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD         >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND echo -n "headenv: "                                   >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND echo "$ENV{GIT_BRANCH}$ENV{GIT_BRANCH_SENLIN}"        >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND echo -n "hash: "                                      >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND ${GIT_EXECUTABLE} rev-parse HEAD                      >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND echo -n "date: "                                      >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND ${GIT_EXECUTABLE} show -s --format=%ai HEAD           >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND echo -n "ccount: "                                    >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND ${GIT_EXECUTABLE} rev-list --count HEAD               >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      COMMAND echo "##############################################" >> ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
      WORKING_DIRECTORY ${DIRECTORY}
      COMMENT "processing ${PNAME} version"
      VERBATIM
    )
  else()
    add_custom_command(
      TARGET ${PNAME}CreateVersionFile 
      POST_BUILD
      COMMAND ${ZhuJiaSourceDir}/Project/createVersionFile.bat ${GIT_EXECUTABLE} ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt ${PNAME}
      WORKING_DIRECTORY ${DIRECTORY}
      COMMENT "processing ${PNAME} version"
      VERBATIM
    )
  ENDIF()

  install(FILES       ${CMAKE_BINARY_DIR}/${PNAME}Versions.txt
          DESTINATION share/${PNAME}
          PERMISSIONS OWNER_WRITE OWNER_READ
                                  GROUP_READ
                                  WORLD_READ)

  MESSAGE(STATUS "foo : ${DIRECTORY} ${PNAME}  | ")

endmacro()

#############################################################################
# passes
#############################################################################

macro(${_JCPRE}COLLECT_LIBRARIES)

  # Find files describing libraries to build, but make sure base
  # and system are processed first
  #file(GLOB_RECURSE OSG_LIBRARY_CONFIG_FILE_BASE RELATIVE "${CMAKE_ROOT_DIR}"
  #     "Source/CMakeLists${_CMVER_}.Lib.OSGBase.txt")

  #file(GLOB_RECURSE OSG_LIBRARY_CONFIG_FILE_SYSTEM RELATIVE "${CMAKE_ROOT_DIR}"
  #     "Source/CMakeLists${_CMVER_}.Lib.OSGSystem.txt")

  file(GLOB_RECURSE _LIB_CFG_FILES RELATIVE "${CMAKE_ROOT_DIR}"
     "Source/*CMakeLists${_CMVER_}.Lib.*.txt")

  #file(REMOVE_ITEM _OSG_LIBRARY_CONFIG_FILES ${OSG_LIBRARY_CONFIG_FILE_BASE})
  #file(REMOVE_ITEM _OSG_LIBRARY_CONFIG_FILES ${OSG_LIBRARY_CONFIG_FILE_SYSTEM})

  #(APPEND OSG_LIBRARY_CONFIG_FILES ${OSG_LIBRARY_CONFIG_FILE_BASE})
  #LIST(APPEND OSG_LIBRARY_CONFIG_FILES ${OSG_LIBRARY_CONFIG_FILE_SYSTEM})

  message(STATUS "processing ${_LIB_CFG_FILES}")

  foreach(_LIB_CFG ${_LIB_CFG_FILES})
    string(REGEX MATCH Source/Contrib 
           _FOUND_CONTRIB_CFG ${_LIB_CFG})

    if(_FOUND_CONTRIB_CONFIG)
      list(APPEND _CONTRIB_LIB_CFG_FILES ${_LIB_CFG})
    else()
      list(APPEND ${_JPPRE}LIBRARY_CONFIG_FILES ${_LIB_CFG})
    endif()
  endforeach() # _SENLIN_LIBRARY_CONFIG_FILES

  list(APPEND ${_JPPRE}LIBRARY_CONFIG_FILES ${_CONTRIB_LIB_CFG_FILES})

endmacro()

#############################################################################
# passes
#############################################################################

macro(${_JCPRE}PRINT_DEPENDENCY_STATES)
  message(STATUS "----- dependencies -----")
  foreach(_DEP_STATE ${${_JCPRE}DEPENDENCY_STATES})
    message(STATUS "${_DEP_STATE}")
  endforeach()
  message(STATUS "----- dependencies -----")
endmacro()

macro(${_JCPRE}RUN_PREPARE _PRJPREP)

  if(EXISTS "${CMAKE_ROOT_DIR}/${_PRJPREP}.Prepare${_CMVER_}.cmake")
    include("${CMAKE_ROOT_DIR}/${_PRJPREP}.Prepare${_CMVER_}.cmake")
  endif()

  foreach(_LIB_CFG ${${_JPPRE}LIBRARY_CONFIG_FILES})

    get_filename_component(_LIB_CFG_DIR
                          ${_LIB_CFG}
                          PATH         )

    get_filename_component(_LIBCFG_BASENAME
                           ${_LIB_CFG}
                            NAME           )


    string(REPLACE CMakeLists${_CMVER_}.Lib. "" _LIBCFG_BASENAME_1
           ${_LIBCFG_BASENAME})

    get_filename_component(_LIBCFG_BASENAME
                            ${_LIBCFG_BASENAME_1}
                            NAME_WE              )

    set(_LIB_BASEDIR ${CMAKE_CURRENT_SOURCE_DIR}/${_LIB_CFG_DIR})

    if(EXISTS "${_LIB_BASEDIR}/${_LIBCFG_BASENAME}.Prepare${_CMVER_}.cmake")
      include("${_LIB_BASEDIR}/${_LIBCFG_BASENAME}.Prepare${_CMVER_}.cmake")
    endif()

  endforeach() # _SENLIN_LIBRARY_CONFIG

  foreach(_EXTERNAL_CFG ${${_JPPRE}EXTERNAL_CONFIGS})
    if(EXISTS ${${_JPPRE}${_EXTERNAL_CFG}_SOURCE_DIR}/${_EXTERNAL_CFG}.Prepare${_CMVER_}.cmake)
      include(${${_JPPRE}${_EXTERNAL_CFG}_SOURCE_DIR}/${_EXTERNAL_CFG}.Prepare${_CMVER_}.cmake)
    endif()
  endforeach()

  foreach(_EXTRA_PREPARE ${${_JPPRE}EXTRA_PREPARE})
    if(EXISTS ${_EXTRA_PREPARE})
      include(${_EXTRA_PREPARE})
    endif()
  endforeach()

endmacro()

macro(${_JCPRE}RUN_FINALIZE _PRJFIN)

  foreach(_LIB_CFG ${${_JPPRE}LIBRARY_CONFIG_FILES})

    get_filename_component(_LIB_CFG_DIR
                          ${_LIB_CFG}
                          PATH         )

    get_filename_component(_LIBCFG_BASENAME
                           ${_LIB_CFG}
                            NAME           )


    string(REPLACE CMakeLists${_CMVER_}.Lib. "" _LIBCFG_BASENAME_1
           ${_LIBCFG_BASENAME})

    get_filename_component(_LIBCFG_BASENAME
                            ${_LIBCFG_BASENAME_1}
                            NAME_WE              )

    set(_LIB_BASEDIR ${CMAKE_CURRENT_SOURCE_DIR}/${_LIB_CFG_DIR})


    if(EXISTS "${_LIB_BASEDIR}/${_LIBCFG_BASENAME}.Finalize${_CMVER_}.cmake")
      include("${_LIB_BASEDIR}/${_LIBCFG_BASENAME}.Finalize${_CMVER_}.cmake")
    endif()

  endforeach() # _SENLIN_LIBRARY_CONFIG

  foreach(_EXTERNAL_CFG ${${_JPPRE}EXTERNAL_CONFIGS})
    if(EXISTS ${${_JPPRE}${_EXTERNAL_CFG}_SOURCE_DIR}/${_EXTERNAL_CFG}.Finalize${_CMVER_}.cmake)
      include(${${_JPPRE}${_EXTERNAL_CFG}_SOURCE_DIR}/${_EXTERNAL_CFG}.Finalize${_CMVER_}.cmake)
    endif()
  endforeach()

  foreach(_EXTRA_FINALIZE ${${_JPPRE}EXTRA_FINALIZE})
    if(EXISTS ${_EXTRA_FINALIZE})
      include(${_EXTRA_FINALIZE})
    endif()
  endforeach()

  if(EXISTS "${CMAKE_ROOT_DIR}/${_PRJFIN}.Finalize${_CMVER_}.cmake")
    include("${CMAKE_ROOT_DIR}/${_PRJFIN}.Finalize${_CMVER_}.cmake")
  endif()

endmacro()

macro(${_JCPRE}RUN_PASSES)

  # run build passes
  foreach(PASS ${${_JPPRE}CMAKE_PASSES})
    set(${_JPPRE}CMAKE_PASS ${PASS})

    message(STATUS 
            "\nPASS : ${${_JPPRE}CMAKE_PASS} in ${${_JPPRE}PASSDIR_${PASS}}\n")

    foreach(_LIBCONFIGFILE ${${_JPPRE}LIBRARY_CONFIG_FILES})

      get_filename_component(_LIBCONFIGDIR "${_LIBCONFIGFILE}" PATH)
      get_filename_component(_LIBFILENAME  "${_LIBCONFIGFILE}" NAME)

      string(REPLACE "CMakeLists${_CMVER_}.Lib." "" _LIBFILENAME "${_LIBFILENAME}")
      string(REPLACE ".txt"                      "" _LIBFILENAME "${_LIBFILENAME}")

      string(REGEX MATCH ${_JTPRE}Contrib*|${_JTPRE}Test* 
                     _${_JPPRE}IS_CONTRIBLIB ${_LIBFILENAME})

      if(_${_JPPRE}IS_CONTRIBLIB)
        set(${_JPPRE}MAIN_LIB_TARGET ${_JTPRE}AllContribLibs)
      else()
        set(${_JPPRE}MAIN_LIB_TARGET ${_JTPRE}AllCoreLibs   )
      endif()

      add_subdirectory("${_LIBCONFIGDIR}" 
                       "${${_JPPRE}PASSDIR_${PASS}}/${_LIBFILENAME}")

    endforeach() # _LIBCONFIGFILE

    set(${_JPPRE}MAIN_LIB_TARGET ${_JTPRE}AllContribLibs)

    foreach(_EXTERNAL_CONFIG ${${_JPPRE}EXTERNAL_CONFIGS})
      add_subdirectory(
        "${${_JPPRE}${_EXTERNAL_CONFIG}_SOURCE_DIR}"
        "External/${_EXTERNAL_CONFIG}/${${_JPPRE}PASSDIR_${PASS}}")
    endforeach() # _EXTERNAL_CONFIG
  endforeach() # _PASS

endmacro()

#############################################################################
# export
#############################################################################

macro(${_JCPRE}SORT_TARGET_LIST)

  #_STL
  set(_TARGETLIST_WORK ${${_JPPRE}TARGET_LIST})

  list(REVERSE _TARGETLIST_WORK)

  #_STR
  set(_TARGETLIST_RESULT "")
  set(_RETRYCOUNT        50)

  #_STLT
  foreach(_TL_ITEM ${_TARGETLIST_WORK})
    set(${_TL_ITEM}_DEPLIST ${${_TL_ITEM}_PUB_PRJ_TARGETS})
  endforeach()

  while(_TARGETLIST_WORK)

    #_STET
    set(_TARGETLIB_EMPTY "")

    #_STLT
    foreach(_TL_ITEM ${_TARGETLIST_WORK})
      if(NOT ${_TL_ITEM}_DEPLIST)
        list(APPEND _TARGETLIB_EMPTY ${_TL_ITEM})
      endif()
    endforeach()

    list(REMOVE_ITEM _TARGETLIST_WORK   ${_TARGETLIB_EMPTY})
    list(APPEND      _TARGETLIST_RESULT ${_TARGETLIB_EMPTY})

    foreach(_TL_ITEM ${_TARGETLIST_WORK})
      list(REMOVE_ITEM ${_TL_ITEM}_DEPLIST ${_TARGETLIB_EMPTY})
    endforeach()

    math(EXPR _RETRYCOUNT "${_RETRYCOUNT} - 1")

    if(_RETRYCOUNT EQUAL 0)
      break()
    endif()

  endwhile()

  if(_RETRYCOUNT EQUAL 0 AND _TARGETLIST_WORK)
    message(SEND_ERROR "fatal could not sort target list within 50 steps")
  endif()

  list(REVERSE _TARGETLIST_RESULT)

  set(${_JPPRE}SORTED_TARGET_LIST ${_TARGETLIST_RESULT} CACHE INTERNAL "") 
  set(PROJECT_SORTED_TARGET_LIST  ${_TARGETLIST_RESULT} CACHE INTERNAL "") 

  message(STATUS "sorted targets :")
  message(STATUS "  ${${_JPPRE}SORTED_TARGET_LIST}")
  message(STATUS "    from ${${_JPPRE}TARGET_LIST}")

endmacro()

macro(${_JCPRE}EXPORT_MAIN_PROJECT)

  configure_file("${ZhuJiaSourceDir}/Packages/PackageHelper.cmake.in"
                 "${CMAKE_BINARY_DIR}/PackageHelper.cmake"
                 @ONLY                                              )

  install(FILES
            ${CMAKE_BINARY_DIR}/PackageHelper.cmake

          DESTINATION
            ${CMAKE_INSTALL_LIBDIR}/cmake/${${_JPPRE}TARGET_NAME}/

          COMPONENT
            dev                                                     )

  write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${${_JPPRE}TARGET_NAME}ConfigVersion.cmake

    VERSION       ${${${_JPPRE}TARGET_NAME_UC}_VERSION_STRING}
    COMPATIBILITY SameMajorVersion                                        )

  configure_package_config_file(
#    ${CMAKE_ROOT_DIR}/${${_JPPRE}TARGET_NAME}Config.cmake.in 
    ${ZhuJiaSourceDir}/Project/ProjectConfig.cmake.in 
    ${${_JPPRE}TARGET_NAME}Config.cmake

    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${${_JPPRE}TARGET_NAME})


  install(FILES       
            ${PROJECT_BINARY_DIR}/${${_JPPRE}TARGET_NAME}Config.cmake
            ${PROJECT_BINARY_DIR}/${${_JPPRE}TARGET_NAME}ConfigVersion.cmake

          DESTINATION 
            ${CMAKE_INSTALL_LIBDIR}/cmake/${${_JPPRE}TARGET_NAME} 

          COMPONENT   
            dev                                                            )

endmacro()

set(ZhuJiaSourceDir ${CMAKE_CURRENT_LIST_DIR}/..)
