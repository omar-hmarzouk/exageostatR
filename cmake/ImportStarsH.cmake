message("")
message("---------------------------------------- Stars-H")
message(STATUS "Installing Stars-H")

execute_process(COMMAND ./InstallStarsH.sh --prefix ${CMAKE_INSTALL_PREFIX} --setup ${TMP_DIR} --mpi ${MPI_VALUE} --blas ${BLA_VENDOR}
                WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
                RESULT_VARIABLE res)
if(${res} EQUAL 0)
    set(STARSH_INSTALLED TRUE)
endif()

message(STATUS "StarsH Done")
