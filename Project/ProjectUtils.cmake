
#############################################################################
# print variables per dir
#############################################################################

function(${_JCPRE}PRINT_DIRECTORY_VARS _DIR)
  # Dump variables:
  get_property(_VARIANBLENAMES DIRECTORY ${_DIR} PROPERTY VARIABLES)
  list (SORT _VARIANBLENAMES)
  foreach (_VARIANBLENAME ${_VARIANBLENAMES})
    if((NOT DEFINED ARGV1) OR _VARIANBLENAME MATCHES "${ARGV1}")
      get_directory_property(_VARIABLEVALUE DIRECTORY ${_DIR} DEFINITION ${_VARIANBLENAME})
      message(STATUS "DIR ${_DIR}: ${_VARIANBLENAME}=${_VARIABLEVALUE}")
    endif()
  endforeach()
endfunction() # JCPRE_PRINT_DIRECTORY_VARS

function(${_JCPRE}PRINT_DIRECTORY_VARS_CLEANED _DIR)
  # Dump variables:
  get_property(_VARIANBLENAMES DIRECTORY ${_DIR} PROPERTY VARIABLES)
  list (SORT _VARIANBLENAMES)
  foreach (_VARIANBLENAME ${_VARIANBLENAMES})
    if((_VARIANBLENAME MATCHES "^CMAKE_"  ) OR
       (_VARIANBLENAME MATCHES "^_"       ) OR
       (_VARIANBLENAME MATCHES "^ARG[CVN]")  )
      continue()
    endif()

    get_directory_property(_VARIABLEVALUE DIRECTORY ${_DIR} DEFINITION ${_VARIANBLENAME})
    message(STATUS "DIR ${_DIR}: ${_VARIANBLENAME}=${_VARIABLEVALUE}")
  endforeach()
endfunction() # JCPRE_PRINT_DIRECTORY_VARS

#############################################################################
# print various c++/c flags
#############################################################################

macro(${_JCPRE}PRINT_COMPILER_LINKER_FLAGS HEADER)

  if(NOT "${HEADER}" STREQUAL "")
    message(STATUS "${HEADER}")
  endif()

  message(STATUS "  CXX_DEBUG        ${CMAKE_CXX_FLAGS_DEBUG}")
  message(STATUS "  C_DEBUG          ${CMAKE_C_FLAGS_DEBUG}")
  message(STATUS "  SHL_DEBUG        ${CMAKE_SHARED_LINKER_FLAGS_DEBUG}")
  message(STATUS "  EXL_DEBUG        ${CMAKE_EXE_LINKER_FLAGS_DEBUG}")

  message(STATUS "  CXX_DEBUGOPT     ${CMAKE_CXX_FLAGS_DEBUGOPT}")
  message(STATUS "  C_DEBUGOPT       ${CMAKE_C_FLAGS_DEBUGOPT}")
  message(STATUS "  SHL_DEBUGOPT     ${CMAKE_SHARED_LINKER_FLAGS_DEBUGOPT}")
  message(STATUS "  EXL_DEBUGOPT     ${CMAKE_EXE_LINKER_FLAGS_DEBUGOPT}")

  message(STATUS "  CXX_RELEASE      ${CMAKE_CXX_FLAGS_RELEASE}")
  message(STATUS "  C_RELEASE        ${CMAKE_C_FLAGS_RELEASE}")
  message(STATUS "  SHL_RELEASE      ${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
  message(STATUS "  EXL_RELEASE      ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")

  message(STATUS "  CXX_RELEASENOOPT ${CMAKE_CXX_FLAGS_RELEASENOOPT}")
  message(STATUS "  C_RELEASENOOPT   ${CMAKE_C_FLAGS_RELEASENOOPT}")
  message(STATUS "  SHL_RELEASENOOPT ${CMAKE_SHARED_LINKER_FLAGS_RELEASENOOPT}")
  message(STATUS "  EXL_RELEASENOOPT ${CMAKE_EXE_LINKER_FLAGS_RELEASENOOPT}")

  message(STATUS "  CXX_FLAGS        ${CMAKE_CXX_FLAGS}")
  message(STATUS "  C_FLAGS          ${CMAKE_C_FLAGS}")

  message(STATUS "  CXX_STD_LIBS     ${CMAKE_CXX_STANDARD_LIBRARIES}")
  message(STATUS "  C_STDD_LIBS      ${CMAKE_C_STANDARD_LIBRARIES}  ")

endmacro()

#############################################################################
# print message depending on the setting of ${_JCPRE}VERBOSE_BUILD_MESSAGES
#############################################################################

function(${_JCPRE}MSG MSG)
  if(${_JCPRE}VERBOSE_BUILD_MESSAGES)
    message(STATUS "${MSG}")
  endif()
endfunction() # _JCPRE_MSG

#############################################################################
# set variables/options/values with optional loggin
#############################################################################

macro(${_JCPRE}OPTION NAME DESC VALUE)
  cmake_language(CALL ${_JCPRE}MSG "adding option ${NAME} = ${VALUE}")

  option(${NAME} "${DESC}" ${VALUE})
endmacro() # _JCPRE_OPTION

macro(${_JCPRE}ADVANCED_OPTION NAME DESC VALUE)
  cmake_language(CALL ${_JCPRE}OPTION ${NAME} "${DESC}" ${VALUE})
  mark_as_advanced(${NAME}                                     )
endmacro() # _JCPRE_ADVANCED_OPTION

macro(${_JCPRE}SET NAME VALUE)
  set(__OptionalArgs "${ARGN}"                       )
  list(LENGTH        __OptionalArgs __NumOptionalArgs)

  if(__NumOptionalArgs GREATER 1)
    list(GET __OptionalArgs -1 __LastArgument)

    if("${__LastArgument}" STREQUAL "")
      set(${NAME} ${VALUE} ${__OptionalArgs} "")
    else()
      set(${NAME} ${VALUE} ${__OptionalArgs})
    endif()

    unset(__LastArgument)
  else()
    set(${NAME} ${VALUE})
  endif()

  unset(__OptionalArgs   )
  unset(__NumOptionalArgs)
endmacro() # _JCPRE_SET


#############################################################################
# store variable
#############################################################################

macro(JIAN_SAVE_AND_REPLACE_VAR VAR_NAME VAR_VAL)
  set(__JIAN_SAVE_${VAR_NAME} ${${VAR_NAME}})
  set(${VAR_NAME}               ${VAR_VAL}  )
endmacro()

macro(JIAN_RESTORE_SAVED_VAR VAR_NAME)
  set  (${VAR_NAME} ${__JIAN_SAVE_${VAR_NAME}})
  unset(              __JIAN_SAVE_${VAR_NAME} )
endmacro()

#############################################################################
# support lib _DIR var
#############################################################################

macro(${_JCPRE}CHECK_SUPPORTLIB_DIR LIBDIR RELPATH)
  if(NOT ${LIBDIR})
    if(EXTLIBSDIR AND EXISTS ${EXTLIBSDIR})
      set(${LIBDIR} "${EXTLIBSDIR}/${RELPATH}"    CACHE INTERNAL "")
    elseif(DEFINED ENV{EXTLIBSDIR} AND EXISTS $ENV{EXTLIBSDIR})
      set(${LIBDIR} "$ENV{EXTLIBSDIR}/${RELPATH}" CACHE INTERNAL "")
    endif()
  endif()
endmacro()

