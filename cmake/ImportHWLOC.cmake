message("")
message("---------------------------------------- HWLOC")
message(STATUS "Checking for HWLOC")
if(NOT TARGET HWLOC)
    find_package(HWLOC QUIET)
    if(HWLOC_FOUND)
        message(" Found HWLOC")
    else()
        message("Here")
        execute_process(COMMAND "./InstallHWLOC.sh"
                WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
                RESULT_VARIABLE res)
        message(${res})
        message("After")
    endif()
endif()
message(STATUS "HWLOC Done")
