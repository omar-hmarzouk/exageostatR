message("")
message("---------------------------------------- Exageostat")
message(STATUS "Installing Exageostat")

execute_process(COMMAND ./InstallExageostat.sh --base ${BASE_DIR}
        WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
        RESULT_VARIABLE res)
if(${res} EQUAL 0)
    set(Exageostat_INSTALLED TRUE)
endif()
message(STATUS "Exageostat Done")
