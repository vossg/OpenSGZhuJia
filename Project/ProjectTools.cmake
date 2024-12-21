
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

