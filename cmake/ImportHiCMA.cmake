message("")
message("---------------------------------------- Hicma")
message(STATUS "Installing Hicma")

execute_process(COMMAND ./InstallHiCMA.sh --prefix ${CMAKE_INSTALL_PREFIX} --setup ${TMP_DIR} --mpi ${MPI_VALUE}
                WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
                RESULT_VARIABLE res)
if(${res} EQUAL 0)
    set(HiCMA_INSTALLED TRUE)
endif()
message(STATUS "Hicma Done")
