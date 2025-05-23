
MESSAGE(STATUS "processing fbs extract /${SENLIN_WITH_FBSEXTRACT}")

IF(NOT SENLIN_WITH_FBSEXTRACT)
  RETURN()
ENDIF()

SET(FBS_PROJECT_NAME ${I3DH_FLATBUFFER_TARGETS})

SET(PROJECT_NAME i3dhubFbsExtract)

CMAKE_MINIMUM_REQUIRED(VERSION 3.7)

IF(DEFINED ENV{_IREXTLIBS_ROOT})
  IF(EXISTS $ENV{_IREXTLIBS_ROOT})
    LIST(APPEND CMAKE_PROGRAM_PATH $ENV{_IREXTLIBS_ROOT}/consumer/diben/bin)
  ENDIF()
ELSEIF(DEFINED IREXTLIBS_ROOT)
  IF(EXISTS ${IREXTLIBS_ROOT})
    LIST(APPEND CMAKE_PROGRAM_PATH ${IREXTLIBS_ROOT}/consumer/diben/bin)
  ENDIF()
ELSEIF(DEFINED IREXTLIB_ROOT)
  IF(EXISTS ${IREXTLIB_ROOT})
    LIST(APPEND CMAKE_PROGRAM_PATH ${IREXTLIB_ROOT}/consumer/diben/bin)
  ENDIF()
ENDIF()

IF(UNIX)
  IF($ENV{LD_LIBRARY_PATH})
    SET(ENV{LD_LIBRARY_PATH} "$ENV{LD_LIBRARY_PATH}:${BOOST_ROOT}/lib64") 
    SET(__LD_LIBRARY_PATH "LD_LIBRARY_PATH=$ENV{LD_LIBRARY_PATH}:${BOOST_ROOT}/lib64") 
  ELSE()
    SET(ENV{LD_LIBRARY_PATH} "${BOOST_ROOT}/lib64") 
    SET(__LD_LIBRARY_PATH "LD_LIBRARY_PATH=${BOOST_ROOT}/lib64") 
  ENDIF()

  MESSAGE(STATUS "running with LD_LIBRARY_PATH $ENV{LD_LIBRARY_PATH}")
ENDIF()

#check if specific directories were whitelisted
FILE(GLOB_RECURSE FBSE_FILES RELATIVE ${I3DH_FLATBUFFERS_DIR}/schemes ${I3DH_FLATBUFFERS_DIR}/schemes/*.fbs)

MESSAGE(STATUS "Found FBSE schemes: ${FBSE_FILES} from ${I3DH_FLATBUFFERS_DIR}/schemes")


# include const gen utils and required const gen compiler depdendency 
FIND_PROGRAM(FbsExtractC fbsExtract fbsExtract.exe)

IF(NOT FbsExtractC)
  RETURN()
ENDIF()

INCLUDE(${CMAKE_CURRENT_LIST_DIR}/fbsExtractUtils.cmake)

SET(FBEGEN_HEADER_FILES )

FOREACH(FBEFile ${FBSE_FILES})
    extract_fbs_to_cpp_opt_ret(${FBEFile} "" FBEGEN_HEADER)
    list(APPEND FBEGEN_HEADER_FILES ${FBEGEN_HEADER})
ENDFOREACH(FBEFile)


ADD_CUSTOM_TARGET(
    ${PROJECT_NAME}_generator
    ALL
    SOURCES ${FBEGEN_HEADER_FILES})


ADD_DEPENDENCIES(${FBS_PROJECT_NAME}_generator ${PROJECT_NAME}_generator )

#MESSAGE(FATAL_ERROR "FBEGEN_HEADER_FILES : ${FBEGEN_HEADER_FILES}")
