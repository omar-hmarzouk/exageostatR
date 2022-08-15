message("")
message("---------------------------------------- Chameleon")
message(STATUS "Installing Chameleon through Hicma")

execute_process(COMMAND ./InstallChameleon.sh --prefix ${CMAKE_INSTALL_PREFIX} --setup ${TMP_DIR} --cuda ${CUDA_VALUE} --mpi ${MPI_VALUE}
        WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
        RESULT_VARIABLE res)
if(${res} EQUAL 0)
    set(CHAMELEON_INSTALLED TRUE)
endif()
message(STATUS "Chameleon Done")
