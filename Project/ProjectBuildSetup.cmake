
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

if(${_JPPRE}ENABLE_C++23)
    set(CMAKE_CXX_STANDARD 23)
elseif(${_JPPRE}ENABLE_C++20)
    set(CMAKE_CXX_STANDARD 20)
elseif(${_JPPRE}ENABLE_C++17)
    set(CMAKE_CXX_STANDARD 17)
elseif(${_JPPRE}ENABLE_C++14)
    set(CMAKE_CXX_STANDARD 14)
else()
    set(CMAKE_CXX_STANDARD 11)
ENDIF()

MESSAGE(STATUS "===========================================================")
MESSAGE(STATUS "===========================================================")

MESSAGE(STATUS "-${${_JPPRE}ENABLE_C++11}-${${_JPPRE}ENABLE_C++14}-"
               "${${_JPPRE}ENABLE_C++17}-${${_JPPRE}ENABLE_C++20}-"
               "${${_JPPRE}ENABLE_C++23}"
               "-> ${CMAKE_CXX_STANDARD}")

MESSAGE(STATUS "===========================================================")
MESSAGE(STATUS "===========================================================")

set(CXX_STANDARD_REQUIRED TRUE)

##############################################################################
# Visibility
##############################################################################

set(CMAKE_CXX_VISIBILITY_PRESET     hidden CACHE INTERNAL "")
set(CMAKE_C_VISIBILITY_PRESET       hidden CACHE INTERNAL "")
set(CMAKE_VISIBILITY_INLINES_HIDDEN true   CACHE INTERNAL "")

##############################################################################
# config export
##############################################################################

set(${_JTPRE}CompilerConfigString "")

##############################################################################
# compiler
##############################################################################

add_library(${_JTPRE}::compiler_settings INTERFACE IMPORTED)

string(APPEND ${_JTPRE}CompilerConfigString
       "if(NOT TARGET ${_JTPRE}::compiler_settings)\n\n"
       "  add_library(${_JTPRE}::compiler_settings INTERFACE IMPORTED)\n\n")

add_library(${_JTPRE}::sse2   INTERFACE IMPORTED)
add_library(${_JTPRE}::sse4.1 INTERFACE IMPORTED)
add_library(${_JTPRE}::sse4.2 INTERFACE IMPORTED)

add_library(${_JTPRE}::avx    INTERFACE IMPORTED)
add_library(${_JTPRE}::avx2   INTERFACE IMPORTED)
add_library(${_JTPRE}::avx512 INTERFACE IMPORTED)

add_library(${_JTPRE}::fma    INTERFACE IMPORTED)
add_library(${_JTPRE}::abi6   INTERFACE IMPORTED)

##############################################################################
# compiler gcc
##############################################################################

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

  string(APPEND ${_JTPRE}CompilerConfigString
         "  target_compile_definitions(\n"
         "    ${_JTPRE}::compiler_settings INTERFACE\n"
         "      __STDC_FORMAT_MACROS)\n"               )


  if(NOT __${_JTPRE}__CMFLAGS_SETUP__)
    message(STATUS "----- basic cmake compiler flags setup -----")

    set(CMAKE_CXX_FLAGS_DEBUGGV "${CMAKE_CXX_FLAGS_DEBUG}"
          CACHE STRING "Flags used by the C++ compiler during debug builds."
          FORCE)

    set(CMAKE_C_FLAGS_DEBUGGV "${CMAKE_C_FLAGS_DEBUG}"
          CACHE STRING "Flags used by the C++ compiler during debug builds."
          FORCE)

    set(__${_JTPRE}__CMFLAGS_SETUP__ TRUE CACHE INTERNAL "" FORCE)
  endif()

endif()

##############################################################################
# compiler cl
##############################################################################

if(MSVC)
  if(NOT ${_JPPRE}WIN_VERSION)
    set(${_JPPRE}WIN_VERSION "0x0601" CACHE STRING "" FORCE)
  endif()

  set(CMAKE_CXX_STANDARD_LIBRARIES "" CACHE STRING "cleaned default" FORCE)
  set(CMAKE_C_STANDARD_LIBRARIES   "" CACHE STRING "cleaned default" FORCE)

  if(NOT ${_JPPRE}NUM_COMPILE_PROC)
    cmake_host_system_information(RESULT __NUM_LCORES
                                  QUERY    NUMBER_OF_LOGICAL_CORES )
    cmake_host_system_information(RESULT __NUM_PCORES
                                QUERY      NUMBER_OF_PHYSICAL_CORES)

    set(${_JPPRE}NUM_COMPILE_PROC ${__NUM_PCORES} CACHE STRING "")
  endif()

  message(STATUS
          "using ${${_JPPRE}NUM_COMPILE_PROC} cores /${_JPPRE}NUM_COMPILE_PROC")

#  target_compile_options(${_JTPRE}::sse2   INTERFACE /arch:SSE2  )
#  target_compile_options(${_JTPRE}::sse4.1 INTERFACE /arch:SSE4.1)
#  target_compile_options(${_JTPRE}::sse4.2 INTERFACE /arch:SSE4.2)

  target_compile_options(${_JTPRE}::avx    INTERFACE /arch:AVX   )
  target_compile_options(${_JTPRE}::avx2   INTERFACE /arch:AVX2  )
  target_compile_options(${_JTPRE}::avx512 INTERFACE /arch:AVX512)

  set(CMAKE_MSVC_RUNTIME_LIBRARY
        "MultiThreaded$<$<CONFIG:Debug>:DebugDLL>"                   )
  set(CMAKE_MSVC_RUNTIME_LIBRARY
        "${CMAKE_MSVC_RUNTIME_LIBRARY}$<$<CONFIG:DebugOpt>:DebugDLL>")
  set(CMAKE_MSVC_RUNTIME_LIBRARY
        "${CMAKE_MSVC_RUNTIME_LIBRARY}$<$<CONFIG:Release>:DLL>"      )
  set(CMAKE_MSVC_RUNTIME_LIBRARY
        "${CMAKE_MSVC_RUNTIME_LIBRARY}$<$<CONFIG:ReleaseNoOpt>:DLL>" )

  if(NOT PROJECT_IS_TOP_LEVEL)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "${CMAKE_MSVC_RUNTIME_LIBRARY}"
          PARENT_SCOPE                                                 )
  endif()

  if(NOT __${_JTPRE}__CMFLAGS_SETUP__)
    message(STATUS "----- basic cmake compiler flags setup -----")

    # ReleaseNoOpt

    string(REPLACE "/RTC1" "" __CXX_FLAGS_RELEASENOOPT ${CMAKE_CXX_FLAGS_DEBUG})
    string(REPLACE "/RTC1" "" __C_FLAGS_RELEASENOOPT   ${CMAKE_C_FLAGS_DEBUG}  )

    set(CMAKE_CXX_FLAGS_RELEASENOOPT
        "${__CXX_FLAGS_RELEASENOOPT} /DOSG_DEBUG"
        CACHE STRING
          "Flags used by the C++ compiler during release no opt builds."
        FORCE)

    set(CMAKE_C_FLAGS_RELEASENOOPT
        "${__C_FLAGS_RELEASENOOPT} /DOSG_DEBUG"
        CACHE STRING
          "Flags used by the C compiler during release no opt builds."
        FORCE)

    set(CMAKE_SHARED_LINKER_FLAGS_RELEASENOOPT
        "${CMAKE_SHARED_LINKER_FLAGS_DEBUG}"
        CACHE STRING
          "Flags used by the shared lib linker during release no opt builds."
        FORCE)

    set(CMAKE_EXE_LINKER_FLAGS_RELEASENOOPT
        "${CMAKE_EXE_LINKER_FLAGS_DEBUG}"
        CACHE STRING
          "Flags used by the exe linker during release no opt builds."
        FORCE)

    # Debug

    set(CMAKE_CXX_FLAGS_DEBUG
        "${CMAKE_CXX_FLAGS_DEBUG} /DOSG_DEBUG /DOSG_DEBUGRT"
        CACHE STRING "Flags used by the C++ compiler during debug builds."
        FORCE)

    set(CMAKE_C_FLAGS_DEBUG
        "${CMAKE_C_FLAGS_DEBUG} /DOSG_DEBUG /DOSG_DEBUGRT"
        CACHE STRING "Flags used by the C++ compiler during debug builds."
        FORCE)

    # Debug Opt

    set(CMAKE_CXX_FLAGS_DEBUGOPT
        "${CMAKE_CXX_FLAGS_RELEASE} /DOSG_DEBUGRT"
        CACHE STRING "Flags used by the C++ compiler during debug opt builds."
        FORCE)

    set(CMAKE_C_FLAGS_DEBUGOPT
        "${CMAKE_C_FLAGS_RELEASE} /DOSG_DEBUGRT"
        CACHE STRING "Flags used by the C compiler during debug opt builds."
        FORCE)

    set(CMAKE_SHARED_LINKER_FLAGS_DEBUGOPT
        "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /debug"
        CACHE STRING
          "Flags used by the shared lib linker during debug opt builds."
        FORCE)

    set(CMAKE_EXE_LINKER_FLAGS_DEBUGOPT
        "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /debug"
        CACHE STRING "Flags used by the exe linker during debug opt builds."
        FORCE)

#    STRING(REPLACE "/D NDEBUG " "" OSG_CXX_FLAGS_DEBUGOPT ${OSG_CXX_FLAGS_DEBUGOPT})
#    STRING(REPLACE "/D NDEBUG " "" OSG_C_FLAGS_DEBUGOPT   ${OSG_C_FLAGS_DEBUGOPT})

    # Release

#    SET(OSG_CXX_FLAGS_RELEASE "${OSG_CXX_FLAGS_RELEASE} /Zi /MP${OSG_NUM_COMPILE_PROC}")
#    SET(OSG_C_FLAGS_RELEASE   "${OSG_C_FLAGS_RELEASE} /Zi /MP${OSG_NUM_COMPILE_PROC}")

    set(__${_JTPRE}__CMFLAGS_SETUP__ TRUE CACHE INTERNAL "" FORCE)

  endif()

  add_library(${_JTPRE}::compiler_settings_win   INTERFACE IMPORTED)

  target_compile_options(${_JTPRE}::compiler_settings_win INTERFACE
                                    /Zi
                                    /bigobj
                                    /Zc:__cplusplus
                                    $<$<COMPILE_LANGUAGE:CXX,C>:/GR>
                                    /MP${${_JPPRE}NUM_COMPILE_PROC} )

  target_compile_definitions(
    ${_JTPRE}::compiler_settings_win   INTERFACE
               $<$<COMPILE_LANGUAGE:CXX,C>:_WIN32_WINNT=${${_JPPRE}WIN_VERSION}>
               $<$<COMPILE_LANGUAGE:CXX,C>:WINVER=${${_JPPRE}WIN_VERSION}>     )

  target_link_options   (${_JTPRE}::compiler_settings_win INTERFACE
                                    /nodefaultlib                  )

#      IF(OSG_WINDOWS_LINK_OPTIMIZE)
#          SET(windows_link_optimization "/OPT:REF /OPT:ICF")
#      ENDIF()


  # Shared std Libs
  set(${_JPPRE}MSVC_STD_LIBS_DEBUG   vcruntimed.lib ucrtd.lib
                                     msvcprtd.lib   msvcrtd.lib)
  set(${_JPPRE}MSVC_STD_LIBS_RELEASE vcruntime.lib  ucrt.lib
                                     msvcprt.lib    msvcrt.lib)

  set_property(TARGET ${_JTPRE}::compiler_settings_win APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES
                   $<$<CONFIG:Debug>:${${_JPPRE}MSVC_STD_LIBS_DEBUG}>
                   $<$<CONFIG:DebugOpt>:${${_JPPRE}MSVC_STD_LIBS_DEBUG}>
                   $<$<CONFIG:Release>:${${_JPPRE}MSVC_STD_LIBS_RELEASE}>
                   $<$<CONFIG:ReleaseNoOpt>:${${_JPPRE}MSVC_STD_LIBS_RELEASE}>)

  set_property(TARGET ${_JTPRE}::compiler_settings_win APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES kernel32.lib
                                          DbgHelp.dll
                                          wsock32.lib
                                          Ws2_32.lib
                                          Shlwapi.lib
                                          oldnames.lib
                                          User32.lib                  )

  set_property(TARGET ${_JTPRE}::compiler_settings APPEND PROPERTY
                 INTERFACE_LINK_LIBRARIES ${_JTPRE}::compiler_settings_win)


  add_library(${_JTPRE}::compiler_settings_win_stacktrace INTERFACE IMPORTED)

  set_property(TARGET
                 ${_JTPRE}::compiler_settings_win_stacktrace APPEND PROPERTY
                   INTERFACE_LINK_LIBRARIES ole32.lib
                                            Dbgeng.lib)

  set(${_JTPRE}_STACKTRACE_TARGETS
        ${_JTPRE}::compiler_settings_win_stacktrace CACHE STRING "")

endif()


##############################################################################
# compiler feature config
##############################################################################



if(${_JPPRE}PLATFORM_64 AND LINUX)
  target_compile_options(${_JTPRE}::compiler_settings INTERFACE -m64)
  target_link_options   (${_JTPRE}::compiler_settings INTERFACE -m64)
endif()

if(UNIX)
  target_compile_definitions(
    ${_JTPRE}::compiler_settings INTERFACE
      $<$<OR:$<CONFIG:Debug>,$<CONFIG:DebugGV>>:_DEBUG>)

  string(APPEND ${_JTPRE}CompilerConfigString
         "  target_compile_definitions(\n"
         "    ${_JTPRE}::compiler_settings INTERFACE\n"
         "      $<$<OR:$<CONFIG:Debug>,$<CONFIG:DebugGV>>:_DEBUG>)\n")
endif()

if(MSVC)
  target_compile_definitions(
    ${_JTPRE}::compiler_settings INTERFACE
      $<$<CONFIG:ReleaseNoOpt>:${_JPPRE}DEBUG>)
endif()

target_compile_definitions(
  ${_JTPRE}::compiler_settings INTERFACE
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:DebugGV>>:${_JPPRE}DEBUG>)

string(APPEND ${_JTPRE}CompilerConfigString
         "  target_compile_definitions(\n"
         "    ${_JTPRE}::compiler_settings INTERFACE\n"
         "      $<$<OR:$<CONFIG:Debug>,$<CONFIG:DebugGV>>:${_JPPRE}DEBUG>)\n")


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

string(APPEND ${_JTPRE}CompilerConfigString
         "\nendif()\n")


##############################################################################
# bookkeeping
##############################################################################

if(MSVC)
  set(CMAKE_CXX_FLAGS_MINSIZEREL
      "${CMAKE_CXX_FLAGS_MINSIZEREL}"
      CACHE INTERNAL ""                  )

  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO
      "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}"
      CACHE INTERNAL ""                  )


  set(CMAKE_C_FLAGS_MINSIZEREL
      "${CMAKE_C_FLAGS_MINSIZEREL}"
      CACHE INTERNAL ""                  )

  set(CMAKE_C_FLAGS_RELWITHDEBINFO
      "${CMAKE_C_FLAGS_RELWITHDEBINFO}"
      CACHE INTERNAL ""                  )
endif()
