message("")
message("---------------------------------------- Chameleon")
message(STATUS "Installing Chameleon through Hicma")

execute_process(COMMAND "./InstallChameleon.sh"
        WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
        RESULT_VARIABLE res)

message(STATUS "Chameleon Done")
