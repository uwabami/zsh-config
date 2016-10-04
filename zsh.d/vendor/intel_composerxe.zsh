#!/bin/zsh
# -*- mode: sh; coding: utf-8-unix; indent-tabs-mode: nil -*-
#
#  Code:
#
## PATH ARRAY init
[ -z "$ld_library_path" ] && typeset -xT LD_LIBRARY_PATH ld_library_path
[ -z "$library_path" ] && typeset -xT LIBRARY_PATH library_path
[ -z "$include" ] && typeset -xT INCLUDE include
[ -z "$mic_ld_library_path" ] && typeset -xT MIC_LD_LIBRARY_PATH mic_ld_library_path
[ -z "$mic_library_path" ] && typeset -xT MIC_LIBRARY_PATH mic_library_path
[ -z "$cpath" ] && typeset -xT CPATH cpath
[ -z "$nlspath" ] && typeset -xT NLSPATH nlspath
[ -z "$manpath" ] && typeset -xT MANPATH manpath

## environment variables
function _my_set_intel_vars(){
    _INTEL_PATH=/opt/intel/composer_xe_2015.2.164
    _arch=intel64
    ##
    # license file
    #
    _INTEL_LICENSE_FILE=${_INTEL_PATH}/licenses:/opt/intel/licenses
    ##
    # tbbvars.sh
    #
    # _MIC_LD_LIBRARY_PATH=${_INTEL_PATH}/tbb/lib/mic
    # _MIC_LIBRARY_PATH=${_INTEL_PATH}/tbb/lib/mic
    _LD_LIBRARY_PATH=${_INTEL_PATH}/tbb/lib/${_arch}/gcc4.4
    _LIBRARY_PATH=${_INTEL_PATH}/tbb/lib/${_arch}/gcc4.4
    _CPATH=${_INTEL_PATH}/tbb/include
    ##
    # mklvars.h
    #
    _LD_LIBRARY_PATH=${_INTEL_PATH}/compiler/lib/${_arch}:${_INTEL_PATH}/mkl/lib/${_arch}:${_LD_LIBRARY_PATH}
    _LIBRARY_PATH=${_INTEL_PATH}/compiler/lib/${_arch}:${_INTEL_PATH}/mkl/lib/${_arch}:${_LIBRARY_PATH}
    # _MIC_LD_LIBRARY_PATH=${_INTEL_PATH}/compiler/lib/mic:${_INTEL_PATH}/mkl/lib/mic:${_MIC_LD_LIBRARY_PATH}
    _NLSPATH=${_INTEL_PATH}/mkl/lib/${_arch}/locale/%l_%t/%N
    _MANPATH=${_INTEL_PATH}/man/en_US
    _INCLUDE=${_INTEL_PATH}/mkl/include:${_INTEL_PATH}/mkl/include/${_arch}/lp64:${_INCLUDE}
    _CPATH=${_INTEL_PATH}/mkl/include:${_CPATH}
    ##
    # ippvars.sh
    #
    _CPATH=${_INTEL_PATH}/ipp/include:${_CPATH}
    _LD_LIBRARY_PATH=${_INTEL_PATH}/ipp/lib/${_arch}:${_INTEL_PATH}/ipp/tools/${_arch}/perfsys:${_LD_LIBRARY_PATH}
    _LIBRARY_PATH=${INTEL_PATH}/ipp/../compiler/lib/${_arch}:${_INTEL_PATH}/ipp/lib/${_arch}:${_LIBRARY_PATH}
    _NLSPATH=${_INTEL_PATH}/ipp/${_arch}/locale/%l_%t/%N:${_NLSPATH}
    # _MIC_LD_LIBRARY_PATH=${_INTEL_PATH}/ipp/lib/lib/mic:${_MIC_LIBRARY_PATH}
    ##
    #
    # compilervars_arch.sh
    #
    _PATH=${_INTEL_PATH}/bin/${_arch}
    # _MIC_LD_LIBRARY_PATH=${_INTEL_PATH}/compiler/lib/mic:${_INTEL_PATH}/mpirt/lib/mic:${_MIC_LD_LIBRARY_PATH}
    # _MIC_LIBRARY_PATH=${_INTEL_PATH}/compiler/lib/mic:${_INTEL_PATH}/mpirt/lib/mic:${_MIC_LIBRARY_PATH}
    _LD_LIBRARY_PATH=${_INTEL_PATH}/compiler/lib/${_arch}:${_INTEL_PATH}/mpirt/lib/${_arch}:${_LD_LIBRARY_PATH}
    _LIBRARY_PATH=${_INTEL_PATH}/compiler/lib/${_arch}:${_LIBRARY_PATH}
    _NLSPATH=${_INTEL_PATH}/compiler/lib/${_arch}/locale/%l_%t/%N:${_NLSPATH}
    _MANPATH=${_INTEL_PATH}/man/ja_JP:${_MANPATH}
    ##
    #
    # OpenMPI
    #
    if [ -d /opt/openmpi-intel ] ;then
        _MPIROOT=/opt/openmpi-intel
        _PATH=${_MPIROOT}/bin:${_PATH}
        _LD_LIBRARY_PATH=${_MPIROOT}/lib:${_LD_LIBRARY_PATH}
        _MANPATH=${_MPIROOT}/man:${_MANPATH}
    fi
}

## load function
function load_intel(){
    [ ! -d $HOME/.config/intel ] || rsync -auvz $HOME/.config/intel $HOME/
    _my_set_intel_vars
    export INTEL_LICENSE_FILE=${_INTEL_LICENSE_FILE}
    export PATH=${_PATH}:${PATH}
    # export MIC_LD_LIBRARY_PATH=${_MIC_LD_LIBRARY_PATH}:${MIC_LD_LIBRARY_PATH}
    # export MIC_LIBRARY_PATH=${_MIC_LD_LIBRARY_PATH}:${MIC_LIBRARY_PATH}
    export LD_LIBRARY_PATH=${_LD_LIBRARY_PATH}:${LD_LIBRARY_PATH}
    export LIBRARY_PATH=${_LIBRARY_PATH}:${LIBRARY_PATH}
    export NLSPATH=${_NLSPATH}:${NLSPATH}
    export MANPATH=${_MNAPATH}:${MANPATH}
    export NONRPM_DB_DIR=$HOME/.intel
    # typeset -U path ld_library_path library_path include mic_ld_library_path mic_library_path cpath nlspath manpath
    typeset -U path ld_library_path library_path include cpath nlspath manpath
}
## unload function
function unload_intel(){
    [ ! -d $HOME/intel ] || rsync -auvz $HOME/intel/ $HOME/.config/intel/
    rm -fr ${HOME}/intel
    _my_set_intel_vars
    unset INTEL_LICENSE_FILE
    export PATH=${PATH//$_PATH:}
    # unset MIC_LD_LIBRARY_PATH
    # unset MIC_LIBRARY_PATH
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH//$_LD_LIBRARY_PATH:}
    export LIBRARY_PATH=${LIBRARY_PATH//$_LIBRARY_PATH:}
    export NLSPATH=${NLSPATH//$_NLSPATH:}
    export MANPATH=${MANPATH//$_MNAPATH:}
    unset NONRPM_DB_DIR
    typeset -U path ld_library_path library_path include cpath nlspath manpath
    /usr/bin/pkill -9 intelremotemond 2>&1 1>/dev/null
    unset _PATH _LD_LIBRARY_PATH _LIBRARY_PATH _INCLUDE _CPATH _NLSPATH _MANPATH
}
