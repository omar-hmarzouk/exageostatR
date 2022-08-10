message("")
message("---------------------------------------- Exageostat")
message(STATUS "Installing Exageostat")

execute_process(COMMAND "./InstallExageostat.sh"
        WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
        RESULT_VARIABLE res)

message(STATUS "Exageostat Done")
