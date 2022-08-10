message("")
message("---------------------------------------- StarPu")
message(STATUS "Checking for StarPu")
if(NOT TARGET STARPU)
    find_package(STARPU QUIET)
    if(STARPU_FOUND)
        message(" Found STARPU")
    else()
        message("Here")
        execute_process(COMMAND "./InstallStarPu.sh"
                WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
                RESULT_VARIABLE res)
        message(${res})
        message("After")
    endif()
endif()
message(STATUS "STARPU Done")
