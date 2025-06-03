
message(STATUS "processing common project options")

## cmake

cmake_language(CALL ${_JCPRE}OPTION CMAKE_VERBOSE_MAKEFILE "" ON)

## Compiler

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_SSE2     ""    OFF)
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_SSE4     ""    ON )
cmake_language(CALL ${_JCPRE}SET    ${_JPPRE}SSE4_VARIANT    
                    "4.2" CACHE STRING "")

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_AVX      ""    OFF)
cmake_language(CALL ${_JCPRE}SET    ${_JPPRE}AVX_VARIANT 
                    ""    CACHE STRING "")

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_FMA      ""    OFF)
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_ABI6     ""    OFF)

## C++

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_C++17    ""    OFF)
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_C++20    ""    ON )
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_C++23    ""    OFF)

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}GCC_USE_ATOMICS ""    ON )

## library type

cmake_language(CALL ${_JCPRE}SET ${_JPPRE}BUILD_SHARED_LIBS         ON 
                    CACHE INTERNAL "Set to OFF to build static libraries")

## Debugging

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_VALGRIND_CHECKS  "" OFF)
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_MEMORY_DEBUGGING "" OFF)

## install

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}INSTALL_EXAMPLES     "" OFF)
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}INSTALL_EXAMPLES_EXE "" OFF)
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}INSTALL_APPS         "" ON )

## win32 / visual studio

if(WIN32)
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)
endif()
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}DISABLE_SOURCE_GROUPS "" OFF)

if(WIN32)
  cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}USE_SEPARATE_LIBDIRS  "" ON )
  cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}INSTALL_PDB_FILES     "" OFF)
  cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}WINDOWS_LINK_OPTIMIZE "" OFF)
endif(WIN32)


## Tests

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}BUILD_TESTS        
               "Build test programs"                                  ON )
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}BUILD_APPS        
               "Build app programs"                                   ON )
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}BUILD_UNITTESTS                    
               "Build/run unit test programs"                         ON )
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}BUILD_UNITBENCH                    
               "Build/run unit test benchmark programs"               ON )
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}BUILD_EXAMPLES_SIMPLE              
               "Build example programs during system build"           OFF)
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}BUILD_EXAMPLES_ADVANCED
               "Build advanced example programs during system build"  OFF)
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}BUILD_EXAMPLES_TUTORIAL
               "Build tutorial example programs during system build"  OFF)

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}EXCLUDE_TESTS_FROM_ALL
              "Exclude test programs from all target"                 ON      )
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}EXCLUDE_APPS_FROM_ALL
              "Exclude app programs from all target"                  OFF     )
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}EXCLUDE_UNITTESTS_FROM_ALL
              "Build/run unit test programs"                          ON      )
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}EXCLUDE_UNITBENCH_FROM_ALL
              "Build/run unit bench programs"                         ON      )
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}EXCLUDE_EXAMPLES_SIMPLE_FROM_ALL
              "Build example programs during system build"            OFF     )
cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}EXCLUDE_EXAMPLES_ADVANCED_FROM_ALL
              "Build advanced example programs during system build"   OFF     )

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}ENABLE_TESTCONTAINER               
              ""                                                      OFF     )

cmake_language(CALL ${_JCPRE}OPTION ${_JPPRE}EXCLUDE_BENCH_FROM_TEST
              "Exclude bench programs from test target"               ON      )


message(STATUS "processing common project options -- done")
