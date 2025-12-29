
########################################
# boost
########################################

macro(fixupBoostDllLocation _COMPONENT)

  get_target_property(_DLL_LOC_OPT ${_COMPONENT} IMPORTED_LOCATION_RELEASE)
  get_target_property(_DLL_LOC_DBG ${_COMPONENT} IMPORTED_LOCATION_DEBUG)

  string(REPLACE "/lib/" "/bin/" _DLL_LOC_OPT_NEW ${_DLL_LOC_OPT})
  string(REPLACE "/lib/" "/bin/" _DLL_LOC_DBG_NEW ${_DLL_LOC_DBG})

  set_target_properties(${_COMPONENT} PROPERTIES
                        IMPORTED_LOCATION_RELEASE "${_DLL_LOC_OPT_NEW}"
                        IMPORTED_LOCATION_DEBUG   "${_DLL_LOC_DBG_NEW}")

endmacro()

macro(${_JCPRE}SETUP_BOOST _COMPONENTS _INDIRECT_COMPONENTS _REQUIRED)

  set(Boost_USE_MULTITHREADED    ON)
  set(Boost_NO_WARN_NEW_VERSIONS ON)

  if(NOT Boost_USE_STATIC_LIBS)
    set(Boost_USE_STATIC_LIBS OFF CACHE INTERNAL "")
  endif()

#  LIST(APPEND OSG_GLOBAL_DEP_DEFS "BOOST_ALL_NO_LIB")

  if(Boost_DIR AND NOT BOOST_ROOT)
    cmake_path(SET BOOST_ROOT NORMALIZE ${Boost_DIR}/../../..)
  endif()

  unset(Boost_USE_DEBUG_LIBS    )
  unset(Boost_USE_RELEASE_LIBS  )
  unset(Boost_USE_DEBUG_RUNTIME )
  unset(Boost_USE_STATIC_RUNTIME)

  if(${_REQUIRED})
    set(_REQ_PARAM "REQUIRED")
  endif()

  message(STATUS
          "  looking for boost components: ${${_COMPONENTS}} | ${_REQ_PARAM}")

#  set(Boost_VERBOSE TRUE)
#  set(Boost_DEBUG TRUE)

  find_package(Boost ${_REQ_PARAM} COMPONENTS ${${_COMPONENTS}} CONFIG)

  unset(_REQ_PARAM)

  if(Boost_FOUND)

    add_library(Boost::custom_definitions INTERFACE IMPORTED)
    set_property(TARGET Boost::custom_definitions
                   PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     "BOOST_CONFIG_SUPPRESS_OUTDATED_MESSAGE=1")

    set(        ${_JPPRE}BOOST_TARGETS Boost::dynamic_linking    )
    list(APPEND ${_JPPRE}BOOST_TARGETS Boost::disable_autolinking)
    list(APPEND ${_JPPRE}BOOST_TARGETS Boost::custom_definitions)
    list(APPEND ${_JPPRE}BOOST_TARGETS Boost::headers            )

    string(APPEND ${_JTPRE}CompilerConfigString
             "\nif(NOT TARGET Boost::custom_definitions)\n"
             "  add_library(Boost::custom_definitions INTERFACE IMPORTED)\n"
             "  set_property(TARGET Boost::custom_definitions\n"
             "                 PROPERTY INTERFACE_COMPILE_DEFINITIONS\n"
             "                   \"BOOST_CONFIG_SUPPRESS_OUTDATED_MESSAGE"
                                                                      "=1\")\n"
             "endif()\n")

  endif() # Boost_FOUND

  message(STATUS "  using boost libs: "
                 "${${_COMPONENTS}} ${${_INDIRECT_COMPONENTS}}")

  if(WIN32)
    foreach(_COMPONENT ${${_COMPONENTS}})
      if(boost_${_COMPONENT}_FOUND)
        fixupBoostDllLocation(Boost::${_COMPONENT})
      endif()
    endforeach()

    foreach(_COMPONENT ${${_INDIRECT_COMPONENTS}})
      if(boost_${_COMPONENT}_FOUND)
        fixupTargetConfigs(Boost::${_COMPONENT})
      endif()
    endforeach()
  endif()

  foreach(_COMPONENT ${${_COMPONENTS}})
    if(boost_${_COMPONENT}_FOUND)
      fixupTargetConfigs(Boost::${_COMPONENT})
    endif()
  endforeach()

  foreach(_COMPONENT ${${_INDIRECT_COMPONENTS}})
    if(boost_${_COMPONENT}_FOUND)
      fixupTargetConfigs(Boost::${_COMPONENT})
    endif()
  endforeach()

endmacro()

########################################
# OpenGL
########################################

macro(${_JCPRE}SETUP_OPENGL _REQUIRED)

  set(_OGL_COMPONENTS OpenGL)

  if(${_REQUIRED})
    set(_REQ_PARAM "REQUIRED")
  endif()

  if(LINUX)
    list(APPEND _OGL_COMPONENTS GLX)
  else()
    set(${_JPPRE}GLX_LIB ${_JPPRE}GLX_LIB-NOTFOUND)
  endif()

  if(LINUX AND NOT ${_JPPRE}NO_EGL)
    list(APPEND _OGL_COMPONENTS EGL)
  else()
    set(${_JPPRE}EGL_LIB ${_JPPRE}EGL_LIB-NOTFOUND)
  endif()

  if(NOT ${_JPPRE}NO_OPENGL)
    find_package(OpenGL ${_REQ_PARAM} COMPONENTS ${_OGL_COMPONENTS})

    if(NOT ${_JPPRE}NO_EGL AND OpenGL_EGL_FOUND)
      set(${_JPPRE}WITH_EGL   1           )
      set(${_JPPRE}EGL_TARGETS OpenGL::EGL)
    endif()

    if(OpenGL_OpenGL_FOUND)
      set(${_JPPRE}GL_TARGETS  OpenGL::GL)
    endif()
    if(OpenGL_GLX_FOUND)
      set(${_JPPRE}GLX_TARGETS OpenGL::GLX)
    endif()
    if(OPENGL_GLU_FOUND)
      set(${_JPPRE}GLU_TARGETS OpenGL::GLU)
    endif()
  endif()

  unset(_REQ_PARAM)

  message(STATUS " opengl: OpenGL : ${OpenGL_OpenGL_FOUND}")
  message(STATUS "         GLX    : ${OpenGL_GLX_FOUND}"   )
  message(STATUS "         EGL    : ${OpenGL_EGL_FOUND}"   )
  message(STATUS "         GLU    : ${OPENGL_GLU_FOUND}"   )

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with opengl       : OpenGL : ${OpenGL_OpenGL_FOUND}")
  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "                    GLX    : ${OpenGL_GLX_FOUND}"   )
  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "                    EGL    : ${OpenGL_EGL_FOUND}"   )
  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "                    GLU    : ${OPENGL_GLU_FOUND}"   )

endmacro()

########################################
# glm
########################################

macro(${_JCPRE}SETUP_GLM _REQUIRED)

  if(${_REQUIRED})
    set(_REQ_PARAM "REQUIRED")
  endif()

  find_package(glm ${_REQ_PARAM} CONFIG)

  unset(_REQ_PARAM)

  if(glm_FOUND)
    cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_GLM    1       )
    cmake_language(CALL ${_JCPRE}SET ${_JPPRE}GLM_TARGETS glm::glm)
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with glm          : ${${_JPPRE}WITH_GLM}")
endmacro()

########################################
# network uri
########################################

macro(${_JCPRE}SETUP_NETWORK_URI _REQUIRED)

  if(NOT NetworkURI_FOUND)

    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(NetworkURI ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(LINUX)
    else()

#      add_library(NetworkURI::network-uri SHARED IMPORTED)

#      set_target_properties(NetworkURI::network-uri PROPERTIES

#      INTERFACE_INCLUDE_DIRECTORIES "${NetworkURI_DIR}/include")

#      set_property(TARGET NetworkURI::network-uri
#                     APPEND PROPERTY IMPORTED_CONFIGURATIONS Debug       )
#      set_property(TARGET NetworkURI::network-uri
#                     APPEND PROPERTY IMPORTED_CONFIGURATIONS Release     )
#      set_property(TARGET NetworkURI::network-uri
#                     APPEND PROPERTY IMPORTED_CONFIGURATIONS DebugOpt    )
#      set_property(TARGET NetworkURI::network-uri
#                     APPEND PROPERTY IMPORTED_CONFIGURATIONS ReleaseNoOpt)

#      set_target_properties(NetworkURI::network-uri PROPERTIES
#        IMPORTED_LOCATION_DEBUG        "${NetworkURI_DIR}/lib/network-urid.dll"
#        IMPORTED_LOCATION_DEBUGOPT     "${NetworkURI_DIR}/lib/network-urid.dll"
#        IMPORTED_LOCATION_RELEASE      "${NetworkURI_DIR}/lib/network-uri.dll"
#        IMPORTED_LOCATION_RELEASENOOPT "${NetworkURI_DIR}/lib/network-uri.dll"

#        IMPORTED_IMPLIB_DEBUG        "${NetworkURI_DIR}/lib/network-urid.lib"
#        IMPORTED_IMPLIB_DEBUGOPT     "${NetworkURI_DIR}/lib/network-urid.lib"
#        IMPORTED_IMPLIB_RELEASE      "${NetworkURI_DIR}/lib/network-uri.lib"
#        IMPORTED_IMPLIB_RELEASENOOPT "${NetworkURI_DIR}/lib/network-uri.lib")

    endif()

    if(NetworkURI_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}WITH_NETWORKURI    1                      )
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}NETWORKURI_TARGETS NetworkURI::network-uri)

      if(WIN32)
        fixupTargetConfigs(NetworkURI::network-uri)
      endif()
    endif()

  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with cppuri       : ${${_JPPRE}WITH_NETWORKURI}")

endmacro()

########################################
# glew
########################################

macro(${_JCPRE}SETUP_GLEW _REQUIRED)
  if(NOT glew_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(glew ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(glew_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_GLEW    1         )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}GLEW_TARGETS GLEW::glew)

      if(WIN32)
        fixupTargetConfigs(GLEW::glew)
      endif()
      if(LINUX)
        target_link_libraries(GLEW::glew INTERFACE OpenGL::GLX)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with glew         : ${${_JPPRE}WITH_GLEW}")
endmacro()

########################################
# diben
########################################

macro(${_JCPRE}SETUP_DIBEN _REQUIRED)
  if(NOT diben_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(diben ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(diben_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}WITH_DIBEN     1                )
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}DIBEN_TARGETS  diben::diben     )
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}FBSEXTRACT_EXE diben::fbsExtract)

      fixupTargetConfigs(diben::diben)
    endif()
  endif()

  IF(FALSE)
    ADD_LIBRARY(i3dhubConstGen INTERFACE)
    TARGET_INCLUDE_DIRECTORIES(i3dhubConstGen SYSTEM INTERFACE
      "${CMAKE_CURRENT_SOURCE_DIR}/../ARVIDA_Pixi/Source/GenStatic")

      SET(I3DH_CONSTGEN_TARGET i3dhubConstGen)
  ENDIF()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with diben        : ${${_JPPRE}WITH_DIBEN}")
endmacro()

########################################
# rapid json
########################################

macro(${_JCPRE}SETUP_RAPIDJSON _REQUIRED)
  if(NOT RapidJSON_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(RapidJSON ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(RapidJSON_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_RAPIDJSON    1        )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}RAPIDJSON_TARGETS rapidjson)
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with rapidjson    : ${${_JPPRE}WITH_RAPIDJSON}")
endmacro()

########################################
# yaml-cpp
########################################

macro(${_JCPRE}SETUP_YAMLCPP _REQUIRED)
  if(NOT yaml-cpp_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(yaml-cpp ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(yaml-cpp_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}WITH_YAMLCPP    1                 )
      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}YAMLCPP_TARGETS yaml-cpp::yaml-cpp)
      if(WIN32)
        fixupTargetConfigs(yaml-cpp::yaml-cpp)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with yamp-cpp     : ${${_JPPRE}WITH_YAMLCPP}")
endmacro()

########################################
# json spirit
########################################

macro(${_JCPRE}SETUP_JSONSPIRIT _REQUIRED)
  if(NOT jsonSpirit_FOUND)

    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(jsonSpirit ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(jsonSpirit_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}WITH_JSONSPIRIT    1          )
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}JSONSPIRIT_TARGETS json_spirit)
    endif()

  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with json spirit  : ${${_JPPRE}WITH_JSONSPIRIT}")
endmacro()


########################################
# openssl
########################################

macro(${_JCPRE}SETUP_OPENSSL _REQUIRED)
  if(NOT OPENSSL_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    if(WIN32)
      find_package(OpenSSL ${_REQ_PARAM} CONFIG)
    else()
      find_package(OpenSSL ${_REQ_PARAM}       )
    endif()

    unset(_REQ_PARAM)

    if(OPENSSL_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}WITH_OPENSSL    1                           )
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}OPENSSL_TARGETS OpenSSL::SSL;OpenSSL::Crypto)

#    requires debug OpenSSL builds
#    fixupTargetConfigs(OpenSSL::SSL)
#    fixupTargetConfigs(OpenSSL::Crypto)
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with openssl      : ${${_JPPRE}WITH_OPENSSL}")
endmacro()

########################################
# simple web server
########################################

macro(${_JCPRE}SETUP_SIMPLEWEBSERVER _REQUIRED)

  if(NOT SimpleWebServer_FOUND)

    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(SimpleWebServer ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(SimpleWebServer_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}WITH_SIMPLEWEBSERVER    1              )
      cmake_language(CALL ${_JCPRE}SET
                     ${_JPPRE}SIMPLEWEBSERVER_TARGETS SimpleWebServer)
    endif()

  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with http server  : ${${_JPPRE}WITH_SIMPLEWEBSERVER}")
endmacro()

########################################
# simple web socket server
########################################

macro(${_JCPRE}SETUP_SIMPLEWEBSOCKETSERVER _REQUIRED)

  if(NOT SimpleWSocketServer_FOUND)

    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(SimpleWSocketServer ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(SimpleWSocketServer_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}WITH_SIMPLEWSOCKETSERVER    1                  )
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}SIMPLEWSOCKETSERVER_TARGETS SimpleWSocketServer)
    endif()

  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with ws server    : ${${_JPPRE}WITH_SIMPLEWSOCKETSERVER}")
endmacro()

########################################
# flatbuffer
########################################

macro(${_JCPRE}SETUP_FLATBUFFER _REQUIRED)
  if(${_REQUIRED})
    set(_REQ_PARAM "REQUIRED")
  endif()

  find_package(Flatbuffers ${_REQ_PARAM} CONFIG)

  unset(_REQ_PARAM)

  if(Flatbuffers_FOUND AND TARGET flatbuffers::flatc)
    cmake_language(CALL ${_JCPRE}SET
                     ${_JPPRE}WITH_FLATBUFFERS 1                 )
    cmake_language(CALL
                     ${_JCPRE}SET ${_JPPRE}FLATC            flatbuffers::flatc)

    if(NOT WIN32)
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}FLATBUFFERS_TARGETS
                         flatbuffers::flatbuffers_shared)
    else()
      cmake_language(CALL ${_JCPRE}SET
                       ${_JPPRE}FLATBUFFERS_TARGETS flatbuffers::flatbuffers)

      fixupTargetConfigs(flatbuffers::flatbuffers)
    endif()

    list(APPEND ${_JPPRE}ADDITIONAL_CONFIGURE_LINES
         "#cmakedefine ${_JPPRE}WITH_FLATBUFFERS 1")
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with flatbuffer   : ${${_JPPRE}WITH_FLATBUFFERS}")

endmacro()

########################################
# catch2
########################################

macro(${_JCPRE}SETUP_CATCH2 _REQUIRED)
  if(NOT Catch2_FOUND)

    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(Catch2 ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(Catch2_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}WITH_CATCH2    1             )
      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}CATCH2_TARGETS Catch2::Catch2WithMain)

      if(WIN32)
        fixupTargetConfigs(Catch2::Catch2WithMain)
        fixupTargetConfigs(Catch2::Catch2        )
      endif()

      enable_testing()
      include(CTest)
      include(Catch)
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with catch2       : ${${_JPPRE}WITH_CATCH2}")
endmacro()

########################################
# glfw
########################################

macro(${_JCPRE}SETUP_GLFW _REQUIRED)
  if(NOT glfw3_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(glfw3 ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(glfw3_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_GLFW3    1   )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}GLFW3_TARGETS glfw)

      if(WIN32)
        fixupTargetConfigs(glfw)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with glfw3        : ${${_JPPRE}WITH_GLFW3}")
endmacro()

########################################
# TBB
########################################

macro(${_JCPRE}SETUP_TBB _REQUIRED)
  if(NOT TBB_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(TBB ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(TBB_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_TBB    1       )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}TBB_TARGETS TBB::tbb)

      if(WIN32)
        fixupTargetConfigs(TBB::tbb)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with tbb          : ${${_JPPRE}WITH_TBB}")
endmacro()

########################################
# embree 4
########################################

macro(${_JCPRE}SETUP_EMBREE _REQUIRED)

  if(LINUX AND NOT TBB_FOUND)
    cmake_language(CALL ${_JCPRE}SETUP_TBB TRUE)
  endif()

  if(NOT Embree_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(Embree 4 ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(Embree_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_EMBREE    1     )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}EMBREE_TARGETS embree)

      if(WIN32)
        fixupTargetConfigs(embree)
      endif()

      if(LINUX AND TBB_FOUND)
        target_link_libraries(${${_JPPRE}EMBREE_TARGETS} INTERFACE
                                ${${_JPPRE}TBB_TARGETS})
      endif()

    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with embree       : ${${_JPPRE}WITH_EMBREE}")
endmacro()

########################################
# zlib
########################################

macro(${_JCPRE}SETUP_ZLIB _REQUIRED)
  if(NOT ZLIB_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(ZLIB ${_REQ_PARAM}) # CONFIG)

    unset(_REQ_PARAM)

    if(ZLIB_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_ZLIB    1         )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}ZLIB_TARGETS ZLIB::ZLIB)

      if(WIN32)
        fixupTargetConfigs(ZLIB::ZLIB)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with zlib         : ${${_JPPRE}WITH_ZLIB}")
endmacro()

########################################
# png
########################################

macro(${_JCPRE}SETUP_PNG _REQUIRED)
  if(NOT PNG_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(PNG ${_REQ_PARAM}) # CONFIG)

    unset(_REQ_PARAM)

    if(PNG_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_PNG    1       )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}PNG_TARGETS PNG::PNG)

      if(WIN32)
        fixupTargetConfigs(PNG::PNG)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with PNG          : ${${_JPPRE}WITH_PNG}")
endmacro()

########################################
# fast dxt
########################################

macro(${_JCPRE}SETUP_FASTDXT _REQUIRED)
  if(NOT FastDXT_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(FastDXT ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(FastDXT_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                            ${_JPPRE}WITH_FASTDXT    1               )
      cmake_language(CALL ${_JCPRE}SET
                            ${_JPPRE}FASTDXT_TARGETS FastDXT::fastdxt)

      if(WIN32)
        fixupTargetConfigs(FastDXT::fastdxt)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with fast dxt     : ${${_JPPRE}WITH_FASTDXT}")
endmacro()

########################################
# squish
########################################

macro(${_JCPRE}SETUP_SQUISH _REQUIRED)
  if(NOT Squish_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(Squish ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(Squish_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_SQUISH    1             )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}SQUISH_TARGETS Squish::squish)

      if(WIN32)
        fixupTargetConfigs(Squish::squish)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with squish       : ${${_JPPRE}WITH_SQUISH}")
endmacro()

########################################
# imgui
########################################

macro(${_JCPRE}SETUP_IMGUI _REQUIRED)
  if(NOT ImGUI_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(ImGUI ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(ImGUI_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}WITH_IMGUI    1                     )
      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}IMGUI_TARGETS ImGUI::imgui_ogl3_glfw)
      if(WIN32)
        fixupTargetConfigs(ImGUI::imgui_ogl3_glfw)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with imgui        : ${${_JPPRE}WITH_IMGUI}")
endmacro()

########################################
# curl
########################################

macro(${_JCPRE}SETUP_CURL _REQUIRED)
  if(NOT CURL_FOUND)

    if(WIN32)
      set(_CURL_CFG CONFIG)
    endif()

    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(CURL ${_REQ_PARAM} ${_CURL_CFG})

    unset(_REQ_PARAM)

    if(CURL_FOUND)

      if(WIN32 AND NOT TARGET CURL::libcurl)
        add_library(CURL::libcurl ALIAS CURL::libcurl_shared)
      endif()

      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}WITH_CURL    1            )
      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}CURL_TARGETS CURL::libcurl)
      if(WIN32)
        get_property(_lcat TARGET   "CURL::libcurl"
                           PROPERTY ALIASED_TARGET)
        if(NOT "${_lac}" STREQUAL "")
          fixupTargetConfigs(CURL::libcurl)
        endif()
        fixupTargetConfigs(CURL::libcurl_shared)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with curl         : ${${_JPPRE}WITH_CURL}")
endmacro()

########################################
# protobuf
########################################

macro(${_JCPRE}SETUP_PROTOBUF _REQUIRED)
  if(NOT Protobuf_FOUND)

    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(Protobuf ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(Protobuf_FOUND)

      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}WITH_PROTOBUF    1                    )
      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}PROTOBUF_TARGETS protobuf::libprotobuf)
      if(WIN32)
        fixupTargetConfigs(protobuf::libprotobuf)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with protobuf     : ${${_JPPRE}WITH_PROTOBUF}")
endmacro()

########################################
# OpenTelemetry
########################################

macro(${_JCPRE}SETUP_OPENTELEMETRY _REQUIRED)

  if(NOT Protobuf_FOUND)
    cmake_language(CALL ${_JCPRE}SETUP_PROTOBUF ${_REQUIRED})
  endif()

  if(NOT opentelemetry-cpp_FOUND)
    if(${_REQUIRED})
      set(_REQ_PARAM "REQUIRED")
    endif()

    find_package(opentelemetry-cpp ${_REQ_PARAM} CONFIG)

    unset(_REQ_PARAM)

    if(opentelemetry-cpp_FOUND)
      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}WITH_OTEL
                          1                                          )
      cmake_language(CALL ${_JCPRE}SET
                          ${_JPPRE}OTEL_TARGETS
                          opentelemetry-cpp::in_memory_span_exporter
                          opentelemetry-cpp::ostream_span_exporter
                          opentelemetry-cpp::otlp_file_exporter      )

      if(opentelemetry-cpp_exporters_otlp_http_FOUND)
        cmake_language(CALL ${_JCPRE}SET
                            ${_JPPRE}OTEL_TARGETS
                            ${${_JPPRE}OTEL_TARGETS}
                            opentelemetry-cpp::otlp_http_exporter)
      endif()

      if(WIN32)
        fixupTargetConfigs(opentelemetry-cpp::otlp_file_exporter     )
        fixupTargetConfigs(opentelemetry-cpp::in_memory_span_exporter)
        fixupTargetConfigs(opentelemetry-cpp::ostream_span_exporter  )

        fixupTargetConfigs(opentelemetry-cpp::common                 )
        fixupTargetConfigs(opentelemetry-cpp::proto                  )
        fixupTargetConfigs(opentelemetry-cpp::logs                   )
        fixupTargetConfigs(opentelemetry-cpp::resources              )
        fixupTargetConfigs(opentelemetry-cpp::trace                  )
        fixupTargetConfigs(opentelemetry-cpp::metrics                )
        fixupTargetConfigs(opentelemetry-cpp::otlp_recordable        )
        fixupTargetConfigs(opentelemetry-cpp::otlp_file_client       )

        if(opentelemetry-cpp_exporters_otlp_http_FOUND)
          fixupTargetConfigs(opentelemetry-cpp::otlp_http_exporter)
          fixupTargetConfigs(opentelemetry-cpp::otlp_http_client  )
          fixupTargetConfigs(opentelemetry-cpp::http_client_curl  )
        endif()
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES
              "with otel         : ${${_JPPRE}WITH_OTEL}")
endmacro()
