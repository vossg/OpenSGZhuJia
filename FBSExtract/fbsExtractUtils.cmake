
FUNCTION(extract_fbs_to_cpp_opt_ret SRC_FBEGEN OPT RET)

  MESSAGE(STATUS "Add fbe code-generation command for `${SRC_FBEGEN}` scheme.")

  GET_FILENAME_COMPONENT(SRC_FBEGEN_DIR ${SRC_FBEGEN} PATH)
  string(REGEX REPLACE "\\.fbs$" "_gen.h" FBEGEN_HEADER ${SRC_FBEGEN})

#  message(STATUS "foo ${I3DH_FBE_OUT_DIR}/${FBEGEN_HEADER} | ${SRC_FBEGEN_DIR} | ${CMAKE_CURRENT_SOURCE_DIR}/../flatbuffer/schemes/${SRC_FBEGEN}")
#  message(STATUS "bar ${I3DH_FLATBUFFERS_DIR}/schemes/${SRC_FBEGEN}")

  add_custom_command(
    OUTPUT ${I3DH_FBE_OUT_DIR}/${FBEGEN_HEADER}
    COMMAND ${__LD_LIBRARY_PATH}  
            "${FbsExtractC}"
            --cpp ${OPT}
#            --cpp-private-enum 
#            --cpp-include-generated
            --gen-out-dir
            --out-suffix _gen
            --out "${I3DH_FBE_OUT_DIR}/${SRC_FBEGEN_DIR}"
            --files "${I3DH_FLATBUFFERS_DIR}/schemes/${SRC_FBEGEN}"
    MAIN_DEPENDENCY ${I3DH_FLATBUFFERS_DIR}/schemes/${SRC_FBEGEN}
    
    COMMENT "=================== Generating ${SRC_FBEGEN} fbsExtract Header file ... expected output ${I3DH_FBE_OUT_DIR}/${FBEGEN_HEADER}"
    DEPENDS ${FbsExtractC} ${I3DH_FLATBUFFERS_DIR}/schemes/${SRC_FBEGEN}                                                                  )
    
  SET(${RET} ${I3DH_FBE_OUT_DIR}/${FBEGEN_HEADER} PARENT_SCOPE)
ENDFUNCTION()

