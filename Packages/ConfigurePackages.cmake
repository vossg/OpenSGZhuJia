
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

