
message(STATUS "processing fbs extract "
               "/${${_JPPRE}WITH_FBSEXTRACT} | ${EXTLIBSDIR}")

if(NOT ${_JPPRE}WITH_FBSEXTRACT)
  return()
endif()

set(FBS_PROJECT_NAME ${I3DH_FLATBUFFER_TARGETS})

set(PROJECT_NAME i3dhubFbsExtract)

CMAKE_MINIMUM_REQUIRED(VERSION 3.30)

if(DEFINED ENV{EXTLIBSDIR})
  if(EXISTS $ENV{EXTLIBSDIR})
    list(APPEND CMAKE_PROGRAM_PATH $ENV{EXTLIBSDIR}/consumer/diben/bin)
  endif()
elseif(DEFINED EXTLIBSDIR)
  if(EXISTS ${EXTLIBSDIR})
    list(APPEND CMAKE_PROGRAM_PATH ${EXTLIBSDIR}/consumer/diben/bin)
  endif()
elseif(DEFINED ENV{_IREXTLIBS_ROOT})
  if(EXISTS $ENV{_IREXTLIBS_ROOT})
    list(APPEND CMAKE_PROGRAM_PATH $ENV{_IREXTLIBS_ROOT}/consumer/diben/bin)
  endif()
elseif(DEFINED IREXTLIBS_ROOT)
  if(EXISTS ${IREXTLIBS_ROOT})
    list(APPEND CMAKE_PROGRAM_PATH ${IREXTLIBS_ROOT}/consumer/diben/bin)
  endif()
elseif(DEFINED IREXTLIB_ROOT)
  if(EXISTS ${IREXTLIB_ROOT})
    list(APPEND CMAKE_PROGRAM_PATH ${IREXTLIB_ROOT}/consumer/diben/bin)
  endif()
endif()

message(STATUS "  looking in ${CMAKE_PROGRAM_PATH}")

if(UNIX)
  if($ENV{LD_LIBRARY_PATH})
    set(ENV{LD_LIBRARY_PATH} "$ENV{LD_LIBRARY_PATH}:${BOOST_ROOT}/lib64")
    set(__LD_LIBRARY_PATH "LD_LIBRARY_PATH=$ENV{LD_LIBRARY_PATH}:${BOOST_ROOT}/lib64")
  else()
    set(ENV{LD_LIBRARY_PATH} "${BOOST_ROOT}/lib64")
    set(__LD_LIBRARY_PATH "LD_LIBRARY_PATH=${BOOST_ROOT}/lib64")
  endif()

  message(STATUS "  running with LD_LIBRARY_PATH $ENV{LD_LIBRARY_PATH}")
endif()

if(DEFINED Flatbuffers_whitelist_DIRS OR DEFINED Flatbuffers_whitelist_FILES)
  message(STATUS "  running whitelisted: ${Flatbuffers_whitelist_DIRS} | ${Flatbuffers_whitelist_FILES}")
  set(FBSE_FILES ) 
  if(DEFINED Flatbuffers_whitelist_DIRS)
    foreach(dir ${Flatbuffers_whitelist_DIRS})
      file(GLOB_RECURSE FBSE_FILES_TMP RELATIVE ${I3DH_FLATBUFFERS_DIR}/schemes 
                                                ${I3DH_FLATBUFFERS_DIR}/schemes/${dir}/*.fbs)
      list(APPEND FBSE_FILES ${FBSE_FILES_TMP})
    endforeach(dir)
  endif()
  if(DEFINED Flatbuffers_whitelist_FILES)
    list(APPEND FBSE_FILES ${Flatbuffers_whitelist_FILES})
  endif()  
else()
  #check if specific directories were whitelisted
  file(GLOB_RECURSE FBSE_FILES RELATIVE ${I3DH_FLATBUFFERS_DIR}/schemes 
                                        ${I3DH_FLATBUFFERS_DIR}/schemes/*.fbs)
endif()


message(STATUS "  Found FBSE schemes: ${FBSE_FILES} from "
               "${I3DH_FLATBUFFERS_DIR}/schemes"          )


# include const gen utils and required const gen compiler depdendency
find_program(FbsExtractC fbsExtract fbsExtract.exe)

if(NOT FbsExtractC)
  message(STATUS "  fbsExtract not found")

  return()
endif()

include(${CMAKE_CURRENT_LIST_DIR}/fbsExtractUtils.cmake)

set(FBEGEN_HEADER_FILES )

foreach(FBEFile ${FBSE_FILES})
    extract_fbs_to_cpp_opt_ret(${FBEFile} "" FBEGEN_HEADER)
    list(APPEND FBEGEN_HEADER_FILES ${FBEGEN_HEADER})
endforeach(FBEFile)


add_custom_target(
    ${PROJECT_NAME}_generator
    ALL
    SOURCES ${FBEGEN_HEADER_FILES})


add_dependencies(${FBS_PROJECT_NAME}_generator ${PROJECT_NAME}_generator )

#MESSAGE(FATAL_ERROR "FBEGEN_HEADER_FILES : ${FBEGEN_HEADER_FILES}")
