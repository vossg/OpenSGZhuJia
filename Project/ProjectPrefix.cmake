
if(NOT DEFINED JIAN_PRJ_PREFIX)
  set(_JPPRE "JIAN_")
else()
  set(_JPPRE ${JIAN_PRJ_PREFIX})
endif()

if(NOT DEFINED JIAN_FILE_PREFIX)
  set(_JFPRE "")
else()
  set(_JFPRE ${JIAN_FILE_PREFIX})
endif()

if(NOT DEFINED JIAN_TARGET_PREFIX)
  set(_JTPRE "")
else()
  set(_JTPRE ${JIAN_TARGET_PREFIX})
endif()

if(NOT DEFINED JIAN_CID_PREFIX)
  if(NOT _JPPRE)
  set(_JCPRE "JIAN_")
  else()
    set(_JCPRE ${_JPPRE})
  endif()
else()
  set(_JCPRE ${JIAN_CID_PREFIX})
endif()

if(NOT DEFINED JIAN_GEN_SUFFIX)
  set   (_JGSUF "fcd")
else()
  set(_JGSUF ${JIAN_GEN_SUFFIX})
endif()

string(TOUPPER ${_JGSUF} _JGSUF_UC)

string(TOUPPER ${CMAKE_PROJECT_NAME} ${_JPPRE}PROJECT_NAME_UC)
string(TOLOWER ${CMAKE_PROJECT_NAME} ${_JPPRE}PROJECT_NAME_LC)
set   (        ${_JPPRE}PROJECT_NAME ${CMAKE_PROJECT_NAME}   )

message(STATUS "using cmake   prefix ${_JCPRE}")
message(STATUS "using project prefix ${_JPPRE}")

message(STATUS "using target  prefix ${_JTPRE}")
message(STATUS "using gen     suffix ${_JGSUF}/${_JGSUF_UC}")

message(STATUS "using project lc ${${_JPPRE}PROJECT_NAME_UC}/"
                                "${${_JPPRE}PROJECT_NAME}"    )
message(STATUS "using project uc ${${_JPPRE}PROJECT_NAME_LC}/"
                                "${${_JPPRE}PROJECT_NAME}"    )
