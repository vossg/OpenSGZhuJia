
#####################
# External extensions
#####################

cmake_language(CALL ${_JCPRE}SET EXTRA_EXTERNAL_MODULES   "" CACHE STRING
                    "Extra modules that OpenSG will try to import."          )

cmake_language(CALL ${_JCPRE}SET IGNORE_INSTALL           "" CACHE STRING
                    "Extra modules that OpenSG will build but not installed.")

cmake_language(CALL ${_JCPRE}SET EXTERNAL_MODULES_INCLUDE "" CACHE FILEPATH
                    "Include file of extra modules"                          )

if(EXISTS "${${_JPPRE}EXTERNAL_MODULES_INCLUDE}")
  include("${${_JPPRE}EXTERNAL_MODULES_INCLUDE}")
endif()

foreach(_EXTERNAL ${${_JPPRE}EXTRA_EXTERNAL_MODULES})
  message(STATUS "processing external ${_EXTERNAL}")

  cmake_language(CALL ${_JCPRE}OPTION ${_JTPRE}BUILD_${_EXTERNAL}
                      "Build using ${_EXTERNAL} module" OFF      )

  if(${_JTPRE}BUILD_${_EXTERNAL})
    find_path(${_JPPRE}${_EXTERNAL}_SOURCE_DIR
              CMakeLists.${_EXTERNAL}.Lib.txt
              ${CMAKE_CURRENT_SOURCE_DIR}/../${_EXTERNAL})

    set(_CMFILE "CMakeLists${_CMVER_}.Lib.${_EXTERNAL}.txt")

    if(NOT EXISTS "${${_JPPRE}${_EXTERNAL}_SOURCE_DIR}/${_CMFILE}")
      message(SEND_ERROR "Cannot find ${_EXTERNAL} sources directory: "
                         "${${_JPPRE}${_EXTERNAL}_SOURCE_DIR}/"
                         "${_CMFILE}"                                  )
    else()
      list(APPEND ${_JPPRE}EXTERNAL_CONFIGS "${_EXTERNAL}")

      get_filename_component(_EXT_SRC_DIR
                              "${${_JPPRE}${_EXTERNAL}_SOURCE_DIR}/.."
                              REALPATH                                )

      set(_CMPFILE CMakeLists${_CMVER_}.PackagePrepare.cmake)

      if(EXISTS "${${_JPPRE}${_EXTERNAL}_SOURCE_DIR}/${_CMPFILE}")
        list(APPEND ${_JPPRE}EXTERNAL_PREPARE
                      "${${_JPPRE}${_EXTERNAL}_SOURCE_DIR}")
      endif()

      if(EXISTS "${_EXT_SRC_DIR}/CMakeLists.PackagePrepare.cmake")
        list(APPEND ${_JPPRE}EXTERNAL_PREPARE "${_EXT_SRC_DIR}")
      endif()
    endif()

  endif()

endforeach() # _EXTERNAL


if(${_JPPRE}EXTERNAL_PREPARE)
  list(REMOVE_DUPLICATES ${_JPPRE}EXTERNAL_PREPARE)
endif()
