message("")
message("---------------------------------------- Stars-H")
message(STATUS "Installing Stars-H")

execute_process(COMMAND ./InstallStarsH.sh
        WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
        RESULT_VARIABLE res)

message(STATUS "StarsH Done")
