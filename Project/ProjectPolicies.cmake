
if(${CMAKE_VERSION} VERSION_LESS "3.28.0")
  message(FATAL_ERROR "require cmake version > 3.28.0, got ${CMAKE_VERSION}")
endif()

cmake_policy(SET CMP0144 OLD)
cmake_policy(SET CMP0148 OLD)
