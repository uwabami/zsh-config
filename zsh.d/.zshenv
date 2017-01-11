#! /usr/bin/env zsh
# -*- mode: sh; coding: utf-8; indent-tabs-mode: nil -*-
# $Lastupdate: 2017-01-11 20:11:06$
#
# Copyright (c) 2010-2014 Youhei SASAKI <uwabami@gfd-dennou.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the University nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
### BASIC

## config load function: auto-zcompile & source
function _auto_zcompile_source  () {
    local A; A=$1
    [[ -e "${A:r}.zwc" ]] && [[ "$A" -ot "${A:r}.zwc" ]] ||
    zcompile $A >/dev/null 2>&1 ; source $A
}

## LANG
export LANG=ja_JP.UTF-8

## Debian specific
[ -f $ZDOTDIR/utils/userinfo ] && \
    _auto_zcompile_source $ZDOTDIR/utils/userinfo

### PATH
path=(
    # Solaris
    /opt/{csw,sfw}/bin(N-/)
     # Linux, Mac OS X with homebrew
    {/usr/local,/usr,}{/sbin,/bin}(N-/)
    {/usr/local,/usr}/games(N-)
    $path
)
typeset -gxU path
## manpath
manpath=(
    # Solaris
    /opt/{csw,sfw}/share/man(N-/)
     # Linux, Mac OS X with homebrew
    {/usr,/usr/local}/share/man(N-/)
)
typeset -gxU manpath

## treat LD_LIBRARY_PATH, INCLUDE
[ -z "$ld_library_path" ] && typeset -xT LD_LIBRARY_PATH ld_library_path
[ -z "$include" ] && typeset -xT INCLUDE include
typeset -xU ld_library_path include

### Language specific settings

## TeX
export TEXMFHOME=$HOME/.texmf
path=( /usr/tex/bin(N-/) $path )

## Java
whence java >/dev/null && \
    export JAVA_HOME=$(whence -s java | awk '{print $3}' | sed "s:bin/java::")
[[ $OSTYPE == darwin* ]] && export JAVA_HOME=/Library/Java/Home
[[ $OSTYPE == linux* ]] && export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'

## Homebrew, Homebrew-Cask
[[ $OSTYPE == darwin* ]] && export HOMEBREW_CASK_OPTS="--appdir=/Applications"
[[ $OSTYPE == darwin* ]] && \
    [[ -d $HOME/Library/Qt/5.3/clang_64/bin ]] && \
        path=( $HOME/Library/Qt/5.3/clang_64/bin $path )

## Ruby
[ -d $HOME/Library/site_ruby ] && \
    export RUBYLIB=$HOME/Library/site_ruby:$RUBYLIB
whence rbenv >/dev/null && eval "$(rbenv init -)"
# load/unload local gems
function load_local_gems(){
    export GEM_HOME=$HOME/.gem
    path=( $GEM_HOME/bin $path )
    typeset -gxU path
}
function unload_local_gems(){
    path=( ${path:#$HOME/.gem*} )
    unset GEM_HOME
    typeset -gxU path
}

## Perl
function load_perl_env(){
    local arch; arch="$(perl -MConfig -e 'print $Config{archname}')"
    local extlib; extlib="$HOME/Library/CPAN/lib/perl5"
    export PERL5LIB="$extlib:$extlib/$arch"
    path=( $HOME/Library/CPAN/bin $path )
    whence cpanm > /dev/null && \
        export PERL_CPANM_OPT="--local-lib=$HOME/Library/CPAN"
    typeset -gxU path
}
function unload_perl_env(){
    path=( ${path:#$HOME/Library/CPAN/bin*} )
    unset PERL5LIB; unset PERL_CPANM_OPT
    typeset -gxU path
}
load_perl_env

## Python
[ -d $HOME/.local/bin ] && path=( $HOME/.local/bin $path )

## Go
[ -d $HOME/Library/gocode ] && export GOPATH=$HOME/Library/gocode
path=($HOME/Library/gocode/bin $path)
typeset -gxU path

# ## Adobe FDK
# function load_adobe_fdk(){
#     export FDK_EXE=$HOME/Library/FDK/Tools/linux
#     path=( $HOME/Library/FDK/Tools/linux $path )
#     typeset -gxU path
# }
# function unload_adobe_fdk(){
#     path=( ${path:#$HOME/Library/FDK/Tools/linux*} )
#     unset FDK_EXE
#     typeset -gxU path
# }

### VCS
## CVS
export CVS_RSH=ssh
## Git
if [ -d $HOME/Library/git ]; then
    path=( $HOME/Library/git/bin $path)
    ld_library_path=( $HOME/Library/git/lib $ld_library_path )
    manpath=( $HOME/Library/git/share/man $manpath )
fi

### global proxy settings
[ -f $ZDOTDIR/utils/proxy ] && \
    _auto_zcompile_source $ZDOTDIR/utils/proxy

### SKKSERVER settings
[ -f $ZDOTDIR/utils/skkserver ] && \
    _auto_zcompile_source $ZDOTDIR/utils/skkserver

### Vendor Software (e.g., Compiler)
[ -d /opt/pgi ] && _auto_zcompile_source $ZDOTDIR/vendor/pgi.zsh
# [ -d /opt/FJSVplang ] && _auto_zcompile_source $ZDOTDIR/vendor/fujitsu.zsh
# [ -d /opt/intel ] && _auto_zcompile_source $ZDOTDIR/vendor/intel.zsh
# [ -d /opt/SolarisStudio ] && \
#     _auto_zcompile_source $ZDOTDIR/vendor/soralisstudio.zsh

## Emacs Cask
[ -d $HOME/.emacs.d/share/cask ] && \
  path=( $HOME/.emacs.d/share/cask/bin $path)

### misc
## mu index
export XAPIAN_CJK_NGRAM=1

## VTE terminal: fix EAW width
export VTE_CJK_WIDTH=1

### High priority path settings
[ -d $HOME/bin ] && path=( $HOME/bin $path )

### duplicate cleaning
typeset -gxU path cdpath fpath manpath ld_library_path include
