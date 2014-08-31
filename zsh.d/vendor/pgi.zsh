#! /usr/bin/env zsh
# -*- mode: sh ; coding: utf-8; indent-tabs-mode: nil -*-
#
# Copyright(C) Youhei SASAKI <uwabami@gfd-dennou.org> All rights reserved.
# $Lastupdate: 2014-02-18 18:03:19$
# License: CC0 or MIT/X11 @see LICENSE in detail
#
# Code:
#
# ...too ad hoc (sigh)...
if [ -d /opt/pgi/linux86-64/2014 ]; then
  PGI_DIR=/opt/pgi/linux86-64/2014
elif [ -d /opt/pgi/linux86-64/2013 ]; then
  PGI_DIR=/opt/pgi/linux86-64/2013
elif [ -d /opt/pgi/linux86-64/2012 ]; then
  PGI_DIR=/opt/pgi/linux86-64/2012
elif [ -d /opt/pgi/linux86-64/2011 ]; then
  PGI_DIR=/opt/pgi/linux86-64/2011
else
  PGI_DIR=/opt/pgi/linux86-64/2010
fi
PGI_BIN=${PGI_DIR}/bin
PGI_MANPATH=${PGI_DIR}/man
if [ -d ${PGI_DIR}/mpi/openmpi ]; then
    MPI_PGI=${PGI_DIR}/mpi/openmpi
    MPI_PGI_LIB=${MPI_PGI}/lib
    MPI_PGI_BIN=${MPI_PGI}/bin
    MPI_PGI_MANPATH=${MPI_PGI}/share/man
fi
## def load_function
function load_PGI(){
    export PATH=${MPI_PGI_BIN}:${PGI_BIN}:${PATH}
    export LD_LIBRARY_PATH=${MPI_PGI_LIB}:${LD_LIBRARY_PATH}
    export MANPATH=${MPI_PGI_MANPATH}:${PGI_MANPATH}:${MANPATH}
    export LM_LICENSE_FILE=${PGI}/license.dat
    typeset -xU path ld_library_path manpath
}
## def unload_function
function unload_PGI(){
    export PATH=${${PATH//$PGI_BIN:/}//$MPI_PGI_BIN:}
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH//$MPI_PGI_LIB:}
    export MANPATH=${${MANPATH//$MPI_PGI_MANPATH:/}//$PGI_MANPATH:}
    unset LM_LICENSE_FILE
    typeset -xU path ld_library_path manpath
}
