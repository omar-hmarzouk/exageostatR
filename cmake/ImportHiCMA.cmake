message("")
message("---------------------------------------- Hicma")
message(STATUS "Installing Hicma")

execute_process(COMMAND "./InstallHiCMA.sh"
        WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
        RESULT_VARIABLE res)

message(STATUS "Hicma Done")
