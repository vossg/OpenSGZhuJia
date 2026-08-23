#[=======================================================================[.rst:

FindBrotli
----------

Try to find Brotli

IMPORTED Targets
^^^^^^^^^^^^^^^^

This module defines :prop_tgt:`IMPORTED` targets ``Brotli::Brotli``
(aggregate), ``Brotli::BrotliCommon``, ``Brotli::BrotliDecode``, and
``Brotli::BrotliEncode``, if Brotli has been found.

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

``Brotli_FOUND``
  system has Brotli

``BrotliCommon_FOUND``
  system has Brotli common library
``BrotliEncode_FOUND``
  system has Brotli encode library
``BrotliDecode_FOUND``
  system has Brotli decode library

``Brotli_INCLUDE_DIRS``
  the Brotli include directories

``BrotliCommon_LIBRARY``
  Link this to use BrotliCommon
``BrotliEncode_LIBRARY``
  Link this to use BrotliEncode
``BrotliDecode_LIBRARY``
  Link this to use BrotliDecode

Cache variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Brotli_INCLUDE_DIR``
  the directory containing the Brotli headers

``BrotliCommon_LIBRARY_RELEASE``
  the path to the Brotli common library for release configurations
``BrotliCommon_LIBRARY_DEBUG``
  the path to the Brotli common library for debug configurations

``BrotliEncode_LIBRARY_RELEASE``
  the path to the Brotli encode library for release configurations
``BrotliEncode_LIBRARY_DEBUG``
  the path to the Brotli encode library for debug configurations

``BrotliDecode_LIBRARY_RELEASE``
  the path to the Brotli decode library for release configurations
``BrotliDecode_LIBRARY_DEBUG``
  the path to the Brotli decode library for debug configurations

#]=======================================================================]

macro(_UPDATE_BROTLI_COMPONENT_FOUND _COMPONENT)
  if(Brotli_INCLUDE_DIR AND EXISTS "${${_COMPONENT}_LIBRARY}")
    set(${_COMPONENT}_FOUND TRUE)
  endif()
endmacro()

find_path(Brotli_INCLUDE_DIR NAMES brotli/decode.h PATH_SUFFIXES include)

if(Brotli_INCLUDE_DIR AND NOT EXISTS "${Brotli_INCLUDE_DIR}/brotli/encode.h")
  message(WARNING
          "FindBrotli: found ${Brotli_INCLUDE_DIR}/brotli/decode.h but "
          "brotli/encode.h is missing - Brotli::BrotliEncode is unusable")
endif()

include(SelectLibraryConfigurations)

if(NOT BrotliCommon_LIBRARY)
  find_library(BrotliCommon_LIBRARY_RELEASE NAMES brotlicommon  PATH_SUFFIXES lib64 lib)
  find_library(BrotliCommon_LIBRARY_DEBUG   NAMES brotlicommond PATH_SUFFIXES lib64 lib)

  SELECT_LIBRARY_CONFIGURATIONS(BrotliCommon)
else()
  file(TO_CMAKE_PATH "${BrotliCommon_LIBRARY}" BrotliCommon_LIBRARY)
  _UPDATE_BROTLI_COMPONENT_FOUND(BrotliCommon)
endif()

if(NOT BrotliDecode_LIBRARY)
  find_library(BrotliDecode_LIBRARY_RELEASE NAMES brotlidec  PATH_SUFFIXES lib64 lib)
  find_library(BrotliDecode_LIBRARY_DEBUG   NAMES brotlidecd PATH_SUFFIXES lib64 lib)

  SELECT_LIBRARY_CONFIGURATIONS(BrotliDecode)
else()
  file(TO_CMAKE_PATH "${BrotliDecode_LIBRARY}" BrotliDecode_LIBRARY)
  _UPDATE_BROTLI_COMPONENT_FOUND(BrotliDecode)
endif()

if(NOT BrotliEncode_LIBRARY)
  find_library(BrotliEncode_LIBRARY_RELEASE NAMES brotlienc  PATH_SUFFIXES lib64 lib)
  find_library(BrotliEncode_LIBRARY_DEBUG   NAMES brotliencd PATH_SUFFIXES lib64 lib)

  SELECT_LIBRARY_CONFIGURATIONS(BrotliEncode)
else()
  file(TO_CMAKE_PATH "${BrotliEncode_LIBRARY}" BrotliEncode_LIBRARY)
  _UPDATE_BROTLI_COMPONENT_FOUND(BrotliEncode)
endif()

include(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(Brotli
                                  REQUIRED_VARS BrotliCommon_LIBRARY
                                                BrotliDecode_LIBRARY
                                                BrotliEncode_LIBRARY
                                                Brotli_INCLUDE_DIR  )


if(Brotli_FOUND)
  set(Brotli_INCLUDE_DIRS ${Brotli_INCLUDE_DIR})

  if(NOT TARGET Brotli::BrotliCommon)
    add_library(Brotli::BrotliCommon UNKNOWN IMPORTED)
    set_target_properties(Brotli::BrotliCommon PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${Brotli_INCLUDE_DIRS}")

    if(BrotliCommon_LIBRARY_RELEASE)
      set_property(TARGET Brotli::BrotliCommon APPEND PROPERTY
        IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(Brotli::BrotliCommon PROPERTIES
        IMPORTED_LOCATION_RELEASE "${BrotliCommon_LIBRARY_RELEASE}")
    endif()

    if(BrotliCommon_LIBRARY_DEBUG)
      set_property(TARGET Brotli::BrotliCommon APPEND PROPERTY
        IMPORTED_CONFIGURATIONS DEBUG)
      set_target_properties(Brotli::BrotliCommon PROPERTIES
        IMPORTED_LOCATION_DEBUG "${BrotliCommon_LIBRARY_DEBUG}")
    endif()

    if(NOT BrotliCommon_LIBRARY_RELEASE AND NOT BrotliCommon_LIBRARY_DEBUG)
      set_property(TARGET Brotli::BrotliCommon APPEND PROPERTY
        IMPORTED_LOCATION "${BrotliCommon_LIBRARY}")
    endif()
  endif()

  if(NOT TARGET Brotli::BrotliDecode)
    add_library(Brotli::BrotliDecode UNKNOWN IMPORTED)
    set_target_properties(Brotli::BrotliDecode PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${Brotli_INCLUDE_DIRS}")

    if(BrotliDecode_LIBRARY_RELEASE)
      set_property(TARGET Brotli::BrotliDecode APPEND PROPERTY
        IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(Brotli::BrotliDecode PROPERTIES
        IMPORTED_LOCATION_RELEASE "${BrotliDecode_LIBRARY_RELEASE}")
    endif()

    if(BrotliDecode_LIBRARY_DEBUG)
      set_property(TARGET Brotli::BrotliDecode APPEND PROPERTY
        IMPORTED_CONFIGURATIONS DEBUG)
      set_target_properties(Brotli::BrotliDecode PROPERTIES
        IMPORTED_LOCATION_DEBUG "${BrotliDecode_LIBRARY_DEBUG}")
    endif()

    if(NOT BrotliDecode_LIBRARY_RELEASE AND NOT BrotliDecode_LIBRARY_DEBUG)
      set_property(TARGET Brotli::BrotliDecode APPEND PROPERTY
        IMPORTED_LOCATION "${BrotliDecode_LIBRARY}")
    endif()

    target_link_libraries(Brotli::BrotliDecode INTERFACE Brotli::BrotliCommon)
  endif()

  if(NOT TARGET Brotli::BrotliEncode)
    add_library(Brotli::BrotliEncode UNKNOWN IMPORTED)
    set_target_properties(Brotli::BrotliEncode PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${Brotli_INCLUDE_DIRS}")

    if(BrotliEncode_LIBRARY_RELEASE)
      set_property(TARGET Brotli::BrotliEncode APPEND PROPERTY
        IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(Brotli::BrotliEncode PROPERTIES
        IMPORTED_LOCATION_RELEASE "${BrotliEncode_LIBRARY_RELEASE}")
    endif()

    if(BrotliEncode_LIBRARY_DEBUG)
      set_property(TARGET Brotli::BrotliEncode APPEND PROPERTY
        IMPORTED_CONFIGURATIONS DEBUG)
      set_target_properties(Brotli::BrotliEncode PROPERTIES
        IMPORTED_LOCATION_DEBUG "${BrotliEncode_LIBRARY_DEBUG}")
    endif()

    if(NOT BrotliEncode_LIBRARY_RELEASE AND NOT BrotliEncode_LIBRARY_DEBUG)
      set_property(TARGET Brotli::BrotliEncode APPEND PROPERTY
        IMPORTED_LOCATION "${BrotliEncode_LIBRARY}")
    endif()

    target_link_libraries(Brotli::BrotliEncode INTERFACE Brotli::BrotliCommon)
  endif()

  if(NOT TARGET Brotli::Brotli)
    add_library(Brotli::Brotli INTERFACE IMPORTED)

    target_link_libraries(Brotli::Brotli INTERFACE Brotli::BrotliDecode)
    target_link_libraries(Brotli::Brotli INTERFACE Brotli::BrotliEncode)
  endif()
endif()

mark_as_advanced(Brotli_INCLUDE_DIR)
