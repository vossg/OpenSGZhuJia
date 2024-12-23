
#############################################################################
# build targets
#############################################################################

if(WIN32)
  SET(CMAKE_CONFIGURATION_TYPES 
        "Debug;Release;DebugOpt;ReleaseNoOpt"
        CACHE STRING "${PROJECT_NAME} Build Types" FORCE)
else()
  SET(CMAKE_CONFIGURATION_TYPES 
        "Debug;Release;DebugGV;ReleaseGV"
        CACHE STRING "${PROJECT_NAME} Build Types" FORCE)
endif() # WIN32

if(NOT WIN32 AND NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Debug CACHE STRING
      "Choose the type of build, options are: Debug Release."
      FORCE)
endif()

SET(${_JPPRE}ADDITIONAL_CONFIGURE_LINES     "")
SET(${_JPPRE}ADDITIONAL_CONFIGURE_VER_LINES "")


SET(${_JPPRE}CMAKE_PASSES "main")
SET(${_JPPRE}PASSDIR_main "main")
