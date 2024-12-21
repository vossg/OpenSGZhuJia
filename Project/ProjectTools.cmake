
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
