message("")
message("---------------------------------------- StarPu")
message(STATUS "Checking for StarPu")
if(NOT TARGET STARPU)
    find_package(STARPU 1.3.0)
    if(STARPU_FOUND)
        message(" Found STARPU")
    else()
        execute_process(COMMAND ./InstallStarPu.sh --prefix ${CMAKE_INSTALL_PREFIX} --setup ${TMP_DIR} --cuda ${CUDA_VALUE} --mpi ${MPI_VALUE}
                        WORKING_DIRECTORY ${CMAKE_MODULE_PATH}/scripts
                        RESULT_VARIABLE res)
        if(${res} EQUAL 0)
            set(STARPU_FOUND TRUE)
        endif()
    endif()
endif()
message(STATUS "STARPU Done")
