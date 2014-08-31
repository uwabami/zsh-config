#! /usr/bin/env zsh
# -*- mode: sh ; coding: utf-8; indent-tabs-mode: nil -*-
#
# Copyright(C) Youhei SASAKI <uwabami@gfd-dennou.org> All rights reserved.
# $Lastupdate: 2013-09-30 00:07:06$
# License: CC0 or MIT/X11 @see LICENSE in detail
# License: MIT/X11. @see
#
# Code:
FUJITSU_DIR=/opt/FJSVplang
FUJITSU_BIN=$FUJITSU_DIR/bin
FUJITSU_LIB=$FUJITSU_DIR/lib
FUJITSU_MAN=$FUJITSU_DIR/man
function load_Fujitsu(){
    export PATH=$FUJITSU_BIN:$PATH
    export LD_LIBRARY_PATH=$FUJITSU_LIB:$LD_LIBRARY_PATH
    export MANPATH=$FUJITSU_MAN:$MANPATH
    # path=( $FUJITSU_BIN $path)
    # ld_library_path=( $FUJITSU_LIB $ld_library_path )
    # manpath=( $FUJITSU_MAN $manpath )
    typeset -xU path ld_library_path manpath
}
function unload_Fujitsu(){
    export PATH=${PATH//$FUJITSU_BIN:/}
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH//$FUJITSU_LIB:}
    export MANPATH=${MANPATH//$FUJITSU_MAN:/}
    typeset -xU path ld_library_path manpath
}
