
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

set(${_JPPRE}MAIN_DOC_PAGES                                   )

set(${_JPPRE}DOXY_DIR
        "${CMAKE_BINARY_DIR}/${${_JPPRE}PROJECT_NAME}Doc"     )
set(${_JPPRE}DOXY_HTML_DIR
        "${CMAKE_BINARY_DIR}/${${_JPPRE}PROJECT_NAME}Doc/html")

file(MAKE_DIRECTORY ${${_JPPRE}DOXY_HTML_DIR})


set(${_JPPRE}${${_JPPRE}PROJECT_NAME}_DOC_DIRECTORY 
      "${${_JPPRE}DOXY_HTML_DIR}/Full")

FILE(MAKE_DIRECTORY ${${_JPPRE}${${_JPPRE}PROJECT_NAME}_DOC_DIRECTORY})


set(${_JPPRE}DOXY_MAINPAGE_IN 
        "${${${_JPPRE}PROJECT_NAME}SourceDir}/Doc/mainpage.dox.in"   )
set(${_JPPRE}DOXY_MAINPAGE  
        "${${_JPPRE}DOXY_DIR}/mainpage.dox"                          )

set(${_JPPRE}SORTED_DOC_PAGES "" CACHE INTERNAL ""                   )

set(${_JPPRE}DOXY_HTML_CSS 
        "${${${_JPPRE}PROJECT_NAME}SourceDir}/Doc/doxygen_${${_JPPRE}PROJECT_NAME_LC}.css")

set(${_JPPRE}DOXY_FULL_PATH_NAMES     "YES"                          )
set(${_JPPRE}DOXY_STRIP_FROM_PATH     
        "${CMAKE_BINARY_DIR} ${${${_JPPRE}PROJECT_NAME}SourceDir}"   )
set(${_JPPRE}DOXY_INTERNAL_DOCS       "YES"                          )
set(${_JPPRE}DOXY_STRIP_CODE_COMMENTS "NO"                           )
set(${_JPPRE}DOXY_GENERATE_TREEVIEW   "YES"                          )
set(${_JPPRE}DOXY_SEARCHENGINE        "NO"                           )

set(${_JPPRE}DOC_SECTION "all_in_one")
set(${_JPPRE}${${_JPPRE}PROJECT_NAME}_DOXY_TAGFILE 
        "${${_JPPRE}DOXY_DIR}/${${_JPPRE}PROJECT_NAME}_DOXYGEN_TAGS")

set(${_JPPRE}DOC_BASIC_INPUT 
      "${${_JPPRE}DOXY_DIR}/Include/${${_JPPRE}PROJECT_NAME}FullDoc.include"   )
set(${_JPPRE}DOC_GENERAL_INPUT 
      "${${_JPPRE}DOXY_DIR}/Include/${${_JPPRE}PROJECT_NAME}GeneralDoc.include")



set(_DOXY_CFG_IN  "${ZhuJiaSourceDir}/Doc/doxy-cfg.in"                      )
set(_DOXY_CFG_OUT "${${_JPPRE}DOXY_DIR}/${${_JPPRE}PROJECT_NAME_LC}-doxy.in")

# write doxygen config file
configure_file("${_DOXY_CFG_IN}" "${_DOXY_CFG_OUT}" @ONLY)


set(${_JPPRE}DOXY_CONFIGURATION_FILE_IN 
        "${${_JPPRE}DOXY_DIR}/${${_JPPRE}PROJECT_NAME_LC}-doxy.in"   )
set(${_JPPRE}DOXY_CONFIGURATION_FILE    
        "${${_JPPRE}DOXY_DIR}/${${_JPPRE}PROJECT_NAME_LC}-doxy")


# find/process documentation include files
file(GLOB ${_JPPRE}DOC_INCLUDES 
          "${${${_JPPRE}PROJECT_NAME}SourceDir}/Doc/Include/*.include")

foreach(_${_JPPRE}DOC_INCLUDE_FULL ${${_JPPRE}DOC_INCLUDES})

  get_filename_component(_${_JPPRE}DOC_INCLUDE 
                          ${_${_JPPRE}DOC_INCLUDE_FULL} 
                          NAME                         )

  configure_file(
    "${_${_JPPRE}DOC_INCLUDE_FULL}"
    "${CMAKE_BINARY_DIR}/SanWeiJiDoc/Include/${_${_JPPRE}DOC_INCLUDE}")

endforeach()





# write doxygen config file
configure_file("${${_JPPRE}DOXY_CONFIGURATION_FILE_IN}"
               "${${_JPPRE}DOXY_CONFIGURATION_FILE}"  )

execute_process(
  COMMAND "${CMAKE_COMMAND}" -E copy
            "${${_JPPRE}DOXY_MAINPAGE_IN}"
            "${${_JPPRE}DOXY_MAINPAGE}"   )


set(${_JPPRE}DOC_PIPES "")

if(${_JPPRE}DOXY_STDOUT_LOG)
  set(${_JPPRE}DOC_PIPES > ${${_JPPRE}DOXY_STDOUT_LOG})
endif() # ${_JPPRE}DOXY_STDOUT_LOG

if(DOXYGEN_EXECUTABLE)
  add_custom_target(
    ${${_JPPRE}PROJECT_NAME}Doc
      VERBATIM
      COMMAND ${DOXYGEN_EXECUTABLE} ${${_JPPRE}DOXY_CONFIGURATION_FILE} 
              ${${_JPPRE}DOC_PIPES}                                    )
endif()
