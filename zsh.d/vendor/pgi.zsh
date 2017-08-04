#!/bin/zsh
# -*- mode: sh; coding: utf-8-unix; indent-tabs-mode: nil -*-

[ -z "$ld_library_path" ] && typeset -xT LD_LIBRARY_PATH ld_library_path

function _my_set_pgi_vars(){
    PGI=/opt/pgi
    LM_LICENSE_FILE=$PGI/license.dat
    _PGI_PATH=$PGI/linux86-64/17.4/bin
    _PGI_LIB_PATH=$PGI/linux86-64/17.4/lib
    _PGI_MPI_PATH=$PGI/linux86-64/17.4/mpi/openmpi/bin
    _PGI_MPI_LIB_PATH=$PGI/linux86-64/17.4/mpi/openmpi/lib
    _PGI_MANPATH=$PGI/linux86-64/17.4/man
}

function load_pgi_vars(){
    _my_set_pgi_vars
    export PGI=$PGI
    export LM_LICENSE_FILE=$LM_LICENSE_FILE
    path=($_PGI_MPI_PATH $_PGI_PATH $path)
    ld_library_path=($_PGI_LIB_PATH $_PGI_MPI_LIB_PATH $ld_library_path)
    manpath=($_PGI_MANPATH $manpath)
    typeset -U path manpath ld_library_path
}
function unload_pgi_vars(){
    _my_set_pgi_vars
    export PATH=${PATH//$_PGI_PATH:}
    export PATH=${PATH//$_PGI_MPI_PATH:}
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH//$_PGI_LIB_PATH:}
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH//$_PGI_MPI_LIB_PATH:}
    if [ x"$LD_LIBRARY_PATH" = x"$_PGI_MPI_LIB_PATH" -o \
          x"$LD_LIBRARY_PATH" = x"$_PGI_LIB_PATH" ] ; then
        export LD_LIBRARY_PATH=""
    fi
    export MANPATH=${MANPATH//$_PGI_MANPATH:}
    typeset -U path manpath ld_library_path
    unset PGI
    unset LM_LICENSE_FILE
}
