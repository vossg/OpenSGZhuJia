
message(STATUS "project build setup")

##############################################################################
# platform bits
##############################################################################

set(${_JPPRE}PLATFORM_64 0)
set(${_JPPRE}PLATFORM_32 0)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(${_JPPRE}PLATFORM_64 1)
else()
  set(${_JPPRE}PLATFORM_32 1)
endif()

##############################################################################
# C++ standard
##############################################################################

IF(${_JPPRE}ENABLE_C++20)
    SET(CMAKE_CXX_STANDARD 20)
ELSEIF(${_JPPRE}ENABLE_C++17)
    SET(CMAKE_CXX_STANDARD 17)
ELSEIF(${_JPPRE}ENABLE_C++14)
    SET(CMAKE_CXX_STANDARD 14)
ELSE()
    SET(CMAKE_CXX_STANDARD 11)
ENDIF()

MESSAGE(STATUS "===========================================================")
MESSAGE(STATUS "===========================================================")

MESSAGE(STATUS "-${${_JPPRE}ENABLE_C++11}-${${_JPPRE}ENABLE_C++14}-"
               "${${_JPPRE}ENABLE_C++17}-${${_JPPRE}ENABLE_C++20} "
               "-> ${CMAKE_CXX_STANDARD}")

MESSAGE(STATUS "===========================================================")
MESSAGE(STATUS "===========================================================")

set(CXX_STANDARD_REQUIRED TRUE)

##############################################################################
# compiler
##############################################################################

add_library(${_JTPRE}::compiler_settings INTERFACE IMPORTED)

add_library(${_JTPRE}::sse2   INTERFACE IMPORTED)
add_library(${_JTPRE}::sse4.1 INTERFACE IMPORTED)
add_library(${_JTPRE}::sse4.2 INTERFACE IMPORTED)

add_library(${_JTPRE}::avx    INTERFACE IMPORTED)
add_library(${_JTPRE}::avx2   INTERFACE IMPORTED)
add_library(${_JTPRE}::avx512 INTERFACE IMPORTED)

add_library(${_JTPRE}::fma    INTERFACE IMPORTED)
add_library(${_JTPRE}::abi6   INTERFACE IMPORTED)

if(CMAKE_COMPILER_IS_GNUCC)
  target_compile_options(${_JTPRE}::sse2   INTERFACE -mfpmath=sse -msse2   )
  target_compile_options(${_JTPRE}::sse4.1 INTERFACE -mfpmath=sse -msse4.1 )
  target_compile_options(${_JTPRE}::sse4.2 INTERFACE -mfpmath=sse -msse4.2 )

  target_compile_options(${_JTPRE}::avx    INTERFACE -mfpmath=sse -mavx    )
  target_compile_options(${_JTPRE}::avx2   INTERFACE -mfpmath=sse -mavx2   )
  target_compile_options(${_JTPRE}::avx512 INTERFACE -mfpmath=sse -mavx512f)

  target_compile_options(${_JTPRE}::fma    INTERFACE -mfma                 )
  target_compile_options(${_JTPRE}::abi6   INTERFACE -fabi-version=6       )

  target_compile_definitions(${_JTPRE}::compiler_settings INTERFACE
                               __STDC_FORMAT_MACROS                )

  target_compile_options    (${_JTPRE}::compiler_settings INTERFACE
                               -Wall      -Wextra 
                               -Wshadow   -Werror
                               -Wpedantic -Weffc++

                               -Wno-unused-parameter
                               -Wreturn-type 
                               -Wold-style-cast 
                               -Wno-unused-parameter 
                               -Wwrite-strings      )

  target_compile_options    (
    ${_JTPRE}::compiler_settings INTERFACE
      $<$<OR:$<CONFIG:Release>,$<CONFIG:ReleaseGV>>:-Wno-strict-aliasing>)

endif()

if(${_JPPRE}PLATFORM_64 AND LINUX)
  target_compile_options(${_JTPRE}::compiler_settings INTERFACE -m64)
  target_link_options   (${_JTPRE}::compiler_settings INTERFACE -m64)
endif()

if(UNIX)
  target_compile_definitions(
    ${_JTPRE}::compiler_settings INTERFACE
      $<$<OR:$<CONFIG:Debug>,$<CONFIG:DebugGV>>:_DEBUG>)
endif()

target_compile_definitions(
  ${_JTPRE}::compiler_settings INTERFACE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:DebugGV>>:${_JPPRE}DEBUG>)

#target_compile_definitions(
#  ${_JTPRE}::compiler_settings INTERFACE
#    $<$<OR:$<CONFIG:Release>,$<CONFIG:ReleaseGV>>:${_JPPRE}DEBUGX>)



if(${_JPPRE}ENABLE_SSE4)
  message(STATUS "Apply sse4 settings (${${_JPPRE}SSE4_VARIANT})")

  set_property(TARGET ${_JTPRE}::compiler_settings APPEND PROPERTY 
                 INTERFACE_LINK_LIBRARIES ${_JTPRE}::sse${${_JPPRE}SSE4_VARIANT})
elseif(${_JPPRE}ENABLE_SSE2)
  message(STATUS "Apply sse2 settings")

  set_property(TARGET ${_JTPRE}::compiler_settings APPEND PROPERTY 
                 INTERFACE_LINK_LIBRARIES ${_JTPRE}::sse2)
endif()

if(${_JPPRE}ENABLE_AVX)
  MESSAGE(STATUS "Apply avx settings (${${_JPPRE}AVX_VARIANT}) ")

  set_property(TARGET ${_JTPRE}::compiler_settings APPEND PROPERTY 
                 INTERFACE_LINK_LIBRARIES ${_JTPRE}::avx${${_JPPRE}AVX_VARIANT})
endif()

if(${_JPPRE}ENABLE_FMA)
  message(STATUS "Apply fma settings")

  set_property(TARGET ${_JTPRE}::compiler_settings APPEND PROPERTY 
                 INTERFACE_LINK_LIBRARIES ${_JTPRE}::fma          )
endif()

if(${_JPPRE}ENABLE_ABI6)
  MESSAGE(STATUS "Apply abi6 settings")

  set_property(TARGET ${_JTPRE}::compiler_settings APPEND PROPERTY 
                 INTERFACE_LINK_LIBRARIES ${_JTPRE}::abi6         )
endif()
