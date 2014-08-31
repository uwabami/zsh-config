#! /usr/bin/env zsh
# -*- mode: sh; coding: utf-8; indent-tabs-mode: nil -*-
#
# Copyright(C) Youhei SASAKI <uwabami@gfd-dennou.org> All rights reserved.
# $Lastupdate: 2014-08-31 17:27:22$
# License: CC0 or MIT/X11 @see LICENSE in detail
#
### BASIC
## LANG
export LANG=ja_JP.UTF-8

## Debian specific
export DEBFULLNAME="Youhei SASAKI"
export DEBEMAIL="uwabami@gfd-dennou.org"
export KPKG_MAINTAINER=${DEBFULLNAME}
export KPKG_EMAIL=${DEBEMAIL}
export COLUMNS=${COLUMNS:-80}

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

## function: auto-zcompile & source
function _auto_zcompile_source  () {
    local A; A=$1
    [[ -e "${A:r}.zwc" ]] && [[ "$A" -ot "${A:r}.zwc" ]] ||
    zcompile $A >/dev/null 2>&1 ; source $A
}

### Language specific settings
## Emacs
[ -d $HOME/.cask/bin ] && path=($HOME/.cask/bin $path)

## TeX
export TEXMFHOME=$HOME/.texmf
path=( /usr/tex/bin(N-/) $path )

## Java
whence java >/dev/null && \
    export JAVA_HOME=$(whence -s java | awk '{print $3}' | sed "s:bin/java::")
[[ $OSTYPE == darwin* ]] && export JAVA_HOME=/Library/Java/Home

## Homebrew
[[ $OSTYPE == darwin* ]] && export HOMEBREW_CASK_OPTS="--appdir=/Applications"

## Ruby
[ -d $HOME/Library/site_ruby ] && \
    export RUBYLIB=$HOME/Library/site_ruby:$RUBYLIB
if [ -d $HOME/.rbenv/bin ] ; then
    path=($HOME/.rbenv/bin $path) && \
        eval "$(rbenv init -)"
fi
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
load_local_gems

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

### Vendor Software (e.g., Compiler)
[ -d /opt/pgi ] && _auto_zcompile_source $ZDOTDIR/vendor/pgi.zsh
[ -d /opt/FJSVplang ] && _auto_zcompile_source $ZDOTDIR/vendor/fujitsu.zsh
[ -d /opt/intel ] && _auto_zcompile_source $ZDOTDIR/vendor/intel.zsh
[ -d /opt/SolarisStudio ] && \
    _auto_zcompile_source $ZDOTDIR/vendor/soralisstudio.zsh

### misc
## VTE terminal: fix EAW width
export VTE_CJK_WIDTH=1

### High priority path settings
[ -d $HOME/bin ] && path=( $HOME/bin $path )

### duplicate cleaning
typeset -gxU path cdpath fpath manpath ld_library_path include
