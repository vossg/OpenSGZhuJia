
###############
#### Doxygen
###############

message(STATUS "check for : ${Doxgen_DIR}/bin/doxygen")

if(EXISTS "${Doxgen_DIR}/bin/doxygen" AND NOT DOXYGEN_EXECUTABLE)
  set(DOXYGEN_EXECUTABLE "${Doxgen_DIR}/bin/doxygen" 
                         CACHE FILEPATH "doxygen executable (custom)" FORCE)
endif()

find_package(Doxygen)

list(APPEND ${_JPPRE}DEPENDENCY_STATES "with doxygen      : ${Doxygen_FOUND}")

# set up variables for the config file
if(DOXYGEN_DOT_EXECUTABLE)
  set(${_JPPRE}DOXY_HAVE_DOT "YES")
endif(DOXYGEN_DOT_EXECUTABLE)

list(APPEND ${_JPPRE}DEPENDENCY_STATES 
            "with dot          : ${${_JPPRE}DOXY_HAVE_DOT}")


##################
# Documentation I
##################

set(${_JDPRE}MAIN_DOC_PAGES                                   )

set(${_JDPRE}DOXY_DIR
        "${CMAKE_BINARY_DIR}/${${_JPPRE}PROJECT_NAME}Doc"     )
set(${_JDPRE}DOXY_HTML_DIR
        "${CMAKE_BINARY_DIR}/${${_JPPRE}PROJECT_NAME}Doc/html")

file(MAKE_DIRECTORY ${${_JDPRE}DOXY_HTML_DIR})


set(${_JDPRE}${${_JPPRE}PROJECT_NAME}_DOC_DIRECTORY 
      "${${_JDPRE}DOXY_HTML_DIR}/Full")

FILE(MAKE_DIRECTORY ${${_JDPRE}${${_JPPRE}PROJECT_NAME}_DOC_DIRECTORY})


set(${_JDPRE}DOXY_MAINPAGE_IN 
        "${${${_JPPRE}PROJECT_NAME}SourceDir}/Doc/mainpage.dox.in"   )
set(${_JDPRE}DOXY_MAINPAGE  
        "${${_JDPRE}DOXY_DIR}/mainpage.dox"                          )

set(${_JDPRE}SORTED_DOC_PAGES "" CACHE INTERNAL ""                   )

set(${_JDPRE}DOXY_HTML_CSS 
        "${${${_JPPRE}PROJECT_NAME}SourceDir}/Doc/doxygen_${${_JPPRE}PROJECT_NAME_LC}.css")

set(${_JDPRE}DOXY_FULL_PATH_NAMES     "YES"                          )
set(${_JDPRE}DOXY_STRIP_FROM_PATH     
        "${CMAKE_BINARY_DIR} ${${${_JPPRE}PROJECT_NAME}SourceDir}"   )
set(${_JDPRE}DOXY_INTERNAL_DOCS       "YES"                          )
set(${_JDPRE}DOXY_STRIP_CODE_COMMENTS "NO"                           )
set(${_JDPRE}DOXY_GENERATE_TREEVIEW   "YES"                          )
set(${_JDPRE}DOXY_SEARCHENGINE        "NO"                           )

set(${_JDPRE}DOC_SECTION "all_in_one")
set(${_JDPRE}${${_JPPRE}PROJECT_NAME}_DOXY_TAGFILE 
        "${${_JDPRE}DOXY_DIR}/${${_JPPRE}PROJECT_NAME}_DOXYGEN_TAGS")

set(${_JDPRE}DOC_BASIC_INPUT 
      "${${_JDPRE}DOXY_DIR}/Include/${${_JPPRE}PROJECT_NAME}FullDoc.include"   )
set(${_JDPRE}DOC_GENERAL_INPUT 
      "${${_JDPRE}DOXY_DIR}/Include/${${_JPPRE}PROJECT_NAME}GeneralDoc.include")



set(_DOXY_CFG_IN  "${ZhuJiaSourceDir}/Doc/doxy-cfg.in"                      )
set(_DOXY_CFG_OUT "${${_JDPRE}DOXY_DIR}/${${_JPPRE}PROJECT_NAME_LC}-doxy.in")

# write doxygen config file
configure_file("${_DOXY_CFG_IN}" "${_DOXY_CFG_OUT}" @ONLY)


set(${_JDPRE}DOXY_CONFIGURATION_FILE_IN 
        "${${_JDPRE}DOXY_DIR}/${${_JPPRE}PROJECT_NAME_LC}-doxy.in"   )
set(${_JDPRE}DOXY_CONFIGURATION_FILE    
        "${${_JDPRE}DOXY_DIR}/${${_JPPRE}PROJECT_NAME_LC}-doxy")


# find/process documentation include files
file(GLOB ${_JDPRE}DOC_INCLUDES 
          "${${${_JPPRE}PROJECT_NAME}SourceDir}/Doc/Include/*.include")

foreach(_${_JDPRE}DOC_INCLUDE_FULL ${${_JDPRE}DOC_INCLUDES})

  get_filename_component(_${_JDPRE}DOC_INCLUDE 
                          ${_${_JDPRE}DOC_INCLUDE_FULL} 
                          NAME                         )

  configure_file(
    "${_${_JDPRE}DOC_INCLUDE_FULL}"
    "${${_JDPRE}DOXY_DIR}/Include/${_${_JDPRE}DOC_INCLUDE}")

endforeach()




# write doxygen config file
configure_file("${${_JDPRE}DOXY_CONFIGURATION_FILE_IN}"
               "${${_JDPRE}DOXY_CONFIGURATION_FILE}"  )

execute_process(
  COMMAND "${CMAKE_COMMAND}" -E copy
            "${${_JDPRE}DOXY_MAINPAGE_IN}"
            "${${_JDPRE}DOXY_MAINPAGE}"   )


set(${_JDPRE}DOC_PIPES "")

if(${_JDPRE}DOXY_STDOUT_LOG)
  set(${_JDPRE}DOC_PIPES > ${${_JDPRE}DOXY_STDOUT_LOG})
endif() # ${_JDPRE}DOXY_STDOUT_LOG

if(DOXYGEN_EXECUTABLE)
MESSAGE(STATUS "foo ${_JPPRE}PROJECT_NAME ${${_JPPRE}PROJECT_NAME} ${${_JPPRE}PROJECT_NAME}Doc")
  add_custom_target(
    ${${_JPPRE}PROJECT_NAME}Doc
      VERBATIM
      COMMAND ${DOXYGEN_EXECUTABLE} ${${_JDPRE}DOXY_CONFIGURATION_FILE} 
              ${${_JDPRE}DOC_PIPES}                                    )
endif()
