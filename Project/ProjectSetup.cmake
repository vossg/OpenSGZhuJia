
#############################################################################
# build targets
#############################################################################

if(WIN32)
  set(CMAKE_CONFIGURATION_TYPES
        "Debug;Release;DebugOpt;ReleaseNoOpt"
        CACHE STRING "${PROJECT_NAME} Build Types" FORCE)
else()
  set(CMAKE_CONFIGURATION_TYPES
        "Debug;Release;DebugGV;ReleaseGV"
        CACHE STRING "${PROJECT_NAME} Build Types" FORCE)
endif() # WIN32

if(NOT WIN32 AND NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING
      "Choose the type of build, options are: Debug Release."
      FORCE)
endif()

set(CMAKE_ROOT_DIR                 ${PROJECT_SOURCE_DIR}   CACHE STRING "" FORCE)


if(NOT CMAKE_LIBRARY_OUTPUT_DIRECTORY)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY
        ${CMAKE_BINARY_DIR}/bin CACHE STRING "" FORCE)
endif()

if(NOT CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY
        ${CMAKE_BINARY_DIR}/bin CACHE STRING "" FORCE)
endif()

if(NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY
        ${CMAKE_BINARY_DIR}/bin CACHE STRING "" FORCE)
endif()


set(${_JPPRE}ADDITIONAL_CONFIGURE_LINES     "")
set(${_JPPRE}ADDITIONAL_CONFIGURE_VER_LINES "")


set(${_JPPRE}CMAKE_PASSES "main" "secondary")

set(${_JPPRE}PASSDIR_main      "main"     )
set(${_JPPRE}PASSDIR_secondary "secondary")

set(${_JPPRE}DEPENDENCY_STATES "")

set(FBSExtractSourceDir ${CMAKE_CURRENT_LIST_DIR}/../FBSExtract)

set_property(GLOBAL PROPERTY CTEST_TARGETS_ADDED 1)

if(NOT WIN32)
  string(ASCII 27 __Esc)
  set(ColorReset "${__Esc}[m")
  set(ColorBold  "${__Esc}[1m")
  set(ColorRed   "${__Esc}[31m")
endif()

