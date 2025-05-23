
########################################
# boost
########################################

macro(${_JCPRE}SETUP_BOOST _COMPONENTS _INDIRECT_COMPONENTS)

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

  message(STATUS "  looking for boost components: ${${_COMPONENTS}}")

#  set(Boost_VERBOSE TRUE)
#  set(Boost_DEBUG TRUE)

  find_package(Boost COMPONENTS ${${_COMPONENTS}} CONFIG)

  if(Boost_FOUND)

    add_library(Boost::custom_definitions INTERFACE IMPORTED)
    set_property(TARGET Boost::custom_definitions 
                   PROPERTY INTERFACE_COMPILE_DEFINITIONS 
                     "BOOST_CONFIG_SUPPRESS_OUTDATED_MESSAGE=1")

    set(        OSG_BOOST_TARGETS Boost::dynamic_linking    )
    list(APPEND OSG_BOOST_TARGETS Boost::disable_autolinking)
    list(APPEND OSG_BOOST_TARGETS Boost::custom_definitions)
    list(APPEND OSG_BOOST_TARGETS Boost::headers            )

  endif() # Boost_FOUND

  message(STATUS "  using boost libs: "
                 "${${_COMPONENTS}} ${${_INDIRECT_COMPONENTS}}")


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

macro(${_JCPRE}SETUP_OPENGL)

  set(_OGL_COMPONENTS OpenGL)

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
    find_package(OpenGL COMPONENTS ${_OGL_COMPONENTS})

    if(NOT ${_JPPRE}NO_EGL AND OpenGL_EGL_FOUND)
      set(${_JPPRE}WITH_EGL   1           )
      set(${_JPPRE}EGL_TARGETS OpenGL::EGL)
    endif()

    if(OpenGL_OpenGL_FOUND)
      set(${_JPPRE}GL_TARGETS OpenGL::GL)
    endif()
    if(OpenGL_GLX_FOUND)
      set(${_JPPRE}GLX_TARGETS OpenGL::GLX)
    endif()
    if(OPENGL_GLU_FOUND)
      set(${_JPPRE}GLU_TARGETS OpenGL::GLU)
    endif()
  endif()

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

macro(${_JCPRE}SETUP_GLM)

  find_package(glm CONFIG)

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

macro(${_JCPRE}SETUP_NETWORK_URI)

#  FIND_PACKAGE(NetworkURI CONFIG)

  if(NOT NetworkURI_FOUND)

    add_library(NetworkURI::network-uri SHARED IMPORTED)

    set_target_properties(NetworkURI::network-uri PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${NetworkURI_DIR}/include")

    if(LINUX)
      set_property(TARGET NetworkURI::network-uri  
                     APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)

      set(_NWU_LIB "${NetworkURI_DIR}/lib64/libnetwork-uri.so.0.1.0")

      if(NOT EXISTS ${_NWU_LIB})
        set(_NWU_LIB "${NetworkURI_DIR}/lib64/libnetwork-uri.so")
      endif()

      set_target_properties(NetworkURI::network-uri PROPERTIES
        IMPORTED_LOCATION_RELEASE "${_NWU_LIB}"
        IMPORTED_SONAME_RELEASE "libnetwork-uri.so.0.1.0"     )

    else()

      set_property(TARGET NetworkURI::network-uri 
                     APPEND PROPERTY IMPORTED_CONFIGURATIONS Debug       )
      set_property(TARGET NetworkURI::network-uri 
                     APPEND PROPERTY IMPORTED_CONFIGURATIONS Release     )
      set_property(TARGET NetworkURI::network-uri 
                     APPEND PROPERTY IMPORTED_CONFIGURATIONS DebugOpt    )
      set_property(TARGET NetworkURI::network-uri 
                     APPEND PROPERTY IMPORTED_CONFIGURATIONS ReleaseNoOpt)

      set_target_properties(NetworkURI::network-uri PROPERTIES
        IMPORTED_LOCATION_DEBUG        "${NetworkURI_DIR}/lib/network-urid.dll"
        IMPORTED_LOCATION_DEBUGOPT     "${NetworkURI_DIR}/lib/network-urid.dll"
        IMPORTED_LOCATION_RELEASE      "${NetworkURI_DIR}/lib/network-uri.dll"
        IMPORTED_LOCATION_RELEASENOOPT "${NetworkURI_DIR}/lib/network-uri.dll"

        IMPORTED_IMPLIB_DEBUG        "${NetworkURI_DIR}/lib/network-urid.lib"
        IMPORTED_IMPLIB_DEBUGOPT     "${NetworkURI_DIR}/lib/network-urid.lib"
        IMPORTED_IMPLIB_RELEASE      "${NetworkURI_DIR}/lib/network-uri.lib"
        IMPORTED_IMPLIB_RELEASENOOPT "${NetworkURI_DIR}/lib/network-uri.lib")
    endif()

    if(EXISTS "${NetworkURI_DIR}/include")
      set(NetworkURI_FOUND TRUE)
    endif()
  endif()

  if(NetworkURI_FOUND)
     cmake_language(CALL ${_JCPRE}SET 
                      ${_JPPRE}WITH_NETWORKURI    1                      )
     cmake_language(CALL ${_JCPRE}SET 
                      ${_JPPRE}NETWORKURI_TARGETS NetworkURI::network-uri)
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES 
              "with cppuri       : ${${_JPPRE}WITH_NETWORKURI}")

endmacro()

########################################
# glew
########################################

macro(${_JCPRE}SETUP_GLEW)
  if(NOT glew_FOUND)
    find_package(glew CONFIG)

    if(glew_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_GLEW    1         )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}GLEW_TARGETS GLEW::glew)

      if(WIN32)
        fixupTargetConfigs(GLEW::glew)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES 
              "with glew         : ${${_JPPRE}WITH_GLEW}")
endmacro()

########################################
# diben
########################################

macro(${_JCPRE}SETUP_DIBEN)
  if(NOT diben_FOUND)
    find_package(diben CONFIG)

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

macro(${_JCPRE}SETUP_RAPIDJSON)
  if(NOT RapidJSON_FOUND)
    find_package(RapidJSON CONFIG)

    if(RapidJSON_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_RAPIDJSON    1        )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}RAPIDJSON_TARGETS rapidjson)
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES 
              "with rapidjson    : ${${_JPPRE}WITH_RAPIDJSON}")
endmacro()

########################################
# openssl
########################################

macro(${_JCPRE}SETUP_OPENSSL)
  if(NOT OPENSSL_FOUND)
    find_package(OpenSSL)

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

macro(${_JCPRE}SETUP_SIMPLEWEBSERVER)
  if(NOT SimpleWebServer_FOUND)
    add_library(SimpleWebServer INTERFACE IMPORTED)
    set_property(TARGET SimpleWebServer PROPERTY
                 INTERFACE_INCLUDE_DIRECTORIES ${SimpleWebServer_DIR}/include)

    if(EXISTS "${SimpleWebServer_DIR}/include")
      set(SimpleWebServer_FOUND TRUE)
    endif()
  endif()

  if(SimpleWebServer_FOUND)
    cmake_language(CALL ${_JCPRE}SET 
                     ${_JPPRE}WITH_SIMPLEWEBSERVER    1              )
    cmake_language(CALL ${_JCPRE}SET 
                     ${_JPPRE}SIMPLEWEBSERVER_TARGETS SimpleWebServer)
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES 
              "with http server  : ${${_JPPRE}WITH_SIMPLEWEBSERVER}")
endmacro()

########################################
# simple web socket server
########################################

macro(${_JCPRE}SETUP_SIMPLEWEBSOCKETSERVER)
  if(NOT SimpleWSocketServer_FOUND)
    add_library(SimpleWSocketServer INTERFACE IMPORTED)
    set_property(TARGET SimpleWSocketServer PROPERTY
                 INTERFACE_INCLUDE_DIRECTORIES 
                   ${SimpleWSocketServer_DIR}/include)

    if(EXISTS "${SimpleWSocketServer_DIR}/include")
      set(SimpleWSocketServer_FOUND TRUE)
    endif()
  endif()

  if(SimpleWSocketServer_FOUND)
    cmake_language(CALL ${_JCPRE}SET 
                     ${_JPPRE}WITH_SIMPLEWSOCKETSERVER    1                  )
    cmake_language(CALL ${_JCPRE}SET 
                     ${_JPPRE}SIMPLEWSOCKETSERVER_TARGETS SimpleWSocketServer)
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES 
              "with ws server    : ${${_JPPRE}WITH_SIMPLEWSOCKETSERVER}")
endmacro()

########################################
# flatbuffer
########################################

macro(${_JCPRE}SETUP_FLATBUFFER)
  find_package(Flatbuffers CONFIG)

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

macro(${_JCPRE}SETUP_CATCH2)
  if(NOT Catch2_FOUND)
    find_package(Catch2 CONFIG)

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

macro(${_JCPRE}SETUP_GLFW)
  if(NOT glfw3_FOUND)
    find_package(glfw3 CONFIG)

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
# embree 4
########################################

macro(${_JCPRE}SETUP_EMBREE)
  if(NOT Embree_FOUND)
    find_package(Embree 4 CONFIG)

    if(Embree_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_EMBREE    1     )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}EMBREE_TARGETS embree)

      if(WIN32)
        fixupTargetConfigs(embree)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES 
              "with embree      : ${${_JPPRE}WITH_EMBREE}")
endmacro()

########################################
# TBB
########################################

macro(${_JCPRE}SETUP_TBB)
  if(NOT TBB_FOUND)
    find_package(TBB CONFIG)

    if(TBB_FOUND)
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}WITH_TBB    1       )
      cmake_language(CALL ${_JCPRE}SET ${_JPPRE}TBB_TARGETS TBB::tbb)

      if(WIN32)
        fixupTargetConfigs(TBB::tbb)
      endif()
    endif()
  endif()

  list(APPEND ${_JPPRE}DEPENDENCY_STATES 
              "with tbb        : ${${_JPPRE}WITH_TBB}")
endmacro()
