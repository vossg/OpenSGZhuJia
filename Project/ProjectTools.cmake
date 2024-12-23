
#############################################################################
# common target
#############################################################################

macro(${_JCPRE}COMMON_TARGETS)

  add_custom_target(${_JTPRE}All)

  add_custom_target(             ${_JTPRE}AllApps)
  add_dependencies (${_JTPRE}All ${_JTPRE}AllApps)

  # optional pass for test programs
  if(${_JTPRE}BUILD_TESTS)
    add_custom_target(             ${_JTPRE}AllTests)
    add_dependencies (${_JTPRE}All ${_JTPRE}AllTests)
  endif() 

  add_custom_target(                ${_JTPRE}AllLibs       )
  add_custom_target(                ${_JTPRE}AllContribLibs)

  add_dependencies(${_JTPRE}All     ${_JTPRE}AllLibs       )
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
# import target mapping
#############################################################################

macro(${_JCPRE}FIND_REVISION_GIT DIRECTORY NAME)

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

#############################################################################
# passes
#############################################################################

macro(${_JCPRE}COLLECT_LIBRARIES)

  # Find files describing libraries to build, but make sure base
  # and system are processed first
  #file(GLOB_RECURSE OSG_LIBRARY_CONFIG_FILE_BASE RELATIVE "${CMAKE_SOURCE_DIR}"
  #     "Source/CMakeLists3.Lib.OSGBase.txt")

  #file(GLOB_RECURSE OSG_LIBRARY_CONFIG_FILE_SYSTEM RELATIVE "${CMAKE_SOURCE_DIR}"
  #     "Source/CMakeLists3.Lib.OSGSystem.txt")

  file(GLOB_RECURSE _LIB_CFG_FILES RELATIVE "${CMAKE_SOURCE_DIR}"
     "Source/*CMakeLists3.Lib.*.txt")

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

macro(${_JCPRE}RUN_PREPARE _PRJPREP)

  if(EXISTS "${CMAKE_SOURCE_DIR}/${_PRJPREP}.Prepare3.cmake")
    include("${CMAKE_SOURCE_DIR}/${_PRJPREP}.Prepare3.cmake")
  endif()

  foreach(_LIB_CFG ${${_JPPRE}LIBRARY_CONFIG_FILES})

    get_filename_component(_LIB_CFG_DIR
                          ${_LIB_CFG}
                          PATH         )

    get_filename_component(_LIBCFG_BASENAME
                           ${_LIB_CFG}
                            NAME           )


    string(REPLACE CMakeLists3.Lib. "" _LIBCFG_BASENAME_1
           ${_LIBCFG_BASENAME})

    get_filename_component(_LIBCFG_BASENAME
                            ${_LIBCFG_BASENAME_1}
                            NAME_WE              )

    set(_LIB_BASEDIR ${CMAKE_CURRENT_SOURCE_DIR}/${_LIB_CFG_DIR})

    if(EXISTS "${_LIB_BASEDIR}/${_LIBCFG_BASENAME}.Prepare3.cmake")
      include("${_LIB_BASEDIR}/${_LIBCFG_BASENAME}.Prepare3.cmake")
    endif()

  endforeach() # _SENLIN_LIBRARY_CONFIG

  foreach(_EXTERNAL_CFG ${${_JPPRE}EXTERNAL_CONFIGS})
    if(EXISTS ${${_JPPRE}${_EXTERNAL_CFG}_SOURCE_DIR}/${_EXTERNAL_CFG}.Prepare3.cmake)
      include(${${_JPPRE}${_EXTERNAL_CFG}_SOURCE_DIR}/${_EXTERNAL_CFG}.Prepare3.cmake)
    endif()
  endforeach()

endmacro()

macro(${_JCPRE}RUN_FINALIZE _PRJFIN)

  if(EXISTS "${CMAKE_SOURCE_DIR}/${_PRJFIN}.Finalize3.cmake")
    include("${CMAKE_SOURCE_DIR}/${_PRJFIN}.Finalize3.cmake")
  endif()

  foreach(_LIB_CFG ${${_JPPRE}LIBRARY_CONFIG_FILES})

    get_filename_component(_LIB_CFG_DIR
                          ${_LIB_CFG}
                          PATH         )

    get_filename_component(_LIBCFG_BASENAME
                           ${_LIB_CFG}
                            NAME           )


    string(REPLACE CMakeLists3.Lib. "" _LIBCFG_BASENAME_1
           ${_LIBCFG_BASENAME})

    get_filename_component(_LIBCFG_BASENAME
                            ${_LIBCFG_BASENAME_1}
                            NAME_WE              )

    set(_LIB_BASEDIR ${CMAKE_CURRENT_SOURCE_DIR}/${_LIB_CFG_DIR})


    if(EXISTS "${_LIB_BASEDIR}/${_LIBCFG_BASENAME}.Finalize3.cmake")
      include("${_LIB_BASEDIR}/${_LIBCFG_BASENAME}.Finalize3.cmake")
    endif()

  endforeach() # _SENLIN_LIBRARY_CONFIG

  foreach(_EXTERNAL_CFG ${${_JPPRE}EXTERNAL_CONFIGS})
    if(EXISTS ${${_JPPRE}${_EXTERNAL_CFG}_SOURCE_DIR}/${_EXTERNAL_CFG}.Finalize3.cmake)
      include(${${_JPPRE}${_EXTERNAL_CFG}_SOURCE_DIR}/${_EXTERNAL_CFG}.Finalize3.cmake)
    endif()
  endforeach()

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

      string(REPLACE "CMakeLists3.Lib." "" _LIBFILENAME "${_LIBFILENAME}")
      string(REPLACE ".txt"             "" _LIBFILENAME "${_LIBFILENAME}")

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
