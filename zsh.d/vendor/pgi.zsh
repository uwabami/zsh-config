#!/bin/zsh
# -*- mode: sh; coding: utf-8-unix; indent-tabs-mode: nil -*-

function _my_set_pgi_vars(){
    PGI=/opt/pgi
    LM_LICENSE_FILE=$PGI/license.dat
    _PGI_PATH=$PGI/linux86-64/16.10/bin
    _PGI_MPI_PATH=$PGI/linux86-64/16.10/mpi/openmpi/bin
    _PGI_MANPATH=$PGI/linux86-64/16.10/man
}

function load_pgi_vars(){
    _my_set_pgi_vars
    export PGI=$PGI
    export LM_LICENSE_FILE=$LM_LICENSE_FILE
    path=($_PGI_MPI_PATH $_PGI_PATH $path)
    manpath=($_PGI_MANPATH $manpath)
    typeset -U path manpath
}
function unload_pgi_vars(){
    _my_set_pgi_vars
    export PATH=${PATH//$_PGI_PATH:}
    export PATH=${PATH//$_PGI_MPI_PATH:}
    export MANPATH=${MANPATH//$_PGI_MANPATH:}
    typeset -U path manpath
    unset PGI
    unset LM_LICENSE_FILE
}
