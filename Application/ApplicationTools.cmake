
MACRO(SETUP_APPLICATION_TARGET)

  FOREACH(_APP_SRC ${APP_SRCFILES})

    GET_FILENAME_COMPONENT(_APP_TARGET ${_APP_SRC} NAME_WLE)

    ADD_EXECUTABLE       (${_APP_TARGET} ${_APP_SRC})

    TARGET_LINK_LIBRARIES(${_APP_TARGET} ${TARGET_NAME})

    INSTALL(TARGETS ${_APP_TARGET} 

            RUNTIME 
                  DESTINATION        ${CMAKE_INSTALL_BINDIR}$<$<CONFIG:Debug>:/debug>
                  COMPONENT          run                                             )

  ENDFOREACH() 

ENDMACRO()