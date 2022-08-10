message("")
message("---------------------------------------- Stars-H")
message(STATUS "Installing Stars-H")

execute_process(COMMAND ./InstallStarsH.sh --blas ${BLAS_VENDOR}
        WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
        RESULT_VARIABLE res)

message("./InstallStarsH.sh --blas ${BLAS_VENDOR}")
message(${BLAS_VENDOR})
message(${res})

message(STATUS "StarsH Done")
