#! /usr/bin/env zsh
# -*- mode: sh; coding: utf-8; indent-tabs-mode: nil -*-
# $Lastupdate: 2018-08-28 18:24:05$
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
## BASIC
# zmodload zsh/zprof
## LANG
typeset -gx LANG=ja_JP.UTF-8
# custom fpath
fpath=( $ZDOTDIR/modules/faster-vcs-info(N-/)
        $ZDOTDIR/functions(N-/)
        $fpath )
typeset -gxU fpath

## Personal settings
[ -f $ZDOTDIR/tmp/userinfo ] && source $ZDOTDIR/tmp/userinfo

## PATH
path=(
    # Solaris
    /opt/{csw,sfw}/bin(N-/)
    # Linux, Mac OS X with homebrew
    {/usr/local,/usr,}{/sbin,/bin}(N-/)
    {/usr/local,/usr}/games(N-)
    # pip installed app.
    $HOME/.local/bin(N-)
    # load default
    $path
)
## manpath
manpath=(
    # Solaris
    /opt/{csw,sfw}/share/man(N-/)
     # Linux, Mac OS X with homebrew
    {/usr,/usr/local}/share/man(N-/)
)

## treat LD_LIBRARY_PATH, INCLUDE
[ -z "$ld_library_path" ] && typeset -xT LD_LIBRARY_PATH ld_library_path
[ -z "$library_path" ]    && typeset -xT LIBRARY_PATH library_path
[ -z "$include" ]         && typeset -xT INCLUDE include
[ -z "$cpath" ]           && typeset -xT CPATH cpath
[ -z "$nlspath" ]         && typeset -xT NLSPATH nlspath
[ -z "$manpath" ]         && typeset -xT MANPATH manpath

## TeX
typeset -gx TEXMFHOME=$HOME/.texmf
path=( /usr/tex/bin(N-/) $path )

## Java
# typeset -gx _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'
# case ${OSTYPE} in
#     darwin*)
#         typeset -gx JAVA_HOME=/Library/Java/Home
#         ;;
#     linux*)
#         # if [ -d /usr/lib/jvm/default-java/jre ] ; then
#         typeset -gx JAVA_HOME=/usr/lib/jvm/default-java/jre
#         # else
#         #     JAVA_HOME=$(whence -s java | awk '{print $3}' | sed "s:bin/java::")
#         # fi
#         ;;
#     *)
#         ;;
# esac

## Lang -- anyenv
autoload -U load_anyenv
autoload -U unload_anyenv
# perl -- cpanm
autoload -U load_cpanm
autoload -U unload_cpanm
# golang -- for ghq
typeset -gx GOPATH=$HOME/Library/GOPATH
path=( $GOPATH/bin(N-/)
       $path)
# RubyGems
autoload -U load_local_gems
autoload -U unload_local_gems

## CVS
typeset -gx CVS_RSH=ssh

## Git
if [ -d $HOME/Library/git ]; then
    path=( $HOME/Library/git/bin $path)
    ld_library_path=( $HOME/Library/git/lib $ld_library_path )
    manpath=( $HOME/Library/git/share/man $manpath )
fi

## vendor
# intel
if [ -d /opt/intel ] ; then
    autoload -Uz set_intel_vars
    autoload -Uz load_intel
    autoload -Uz unload_intel
fi
# PGI
if [ -d /opt/pgi ] ; then
    autoload -Uz set_pgi_vars
    autoload -Uz load_pgi
    autoload -Uz unload_pgi
fi

## misc
# notmuch
typeset -gx XAPIAN_CJK_NGRAM=1
typeset -gx XAPIAN_PREFER_CHERT=1

# VTE terminal: fix EAW width
typeset -gx VTE_CJK_WIDTH=1

# Chromium workarounds
typeset -gx CHROMIUM_FLAGS="$CHROMIUM_FLAGS --enable-remote-extensions"

## High priority path settings
[ -d $HOME/bin ] && path=( $HOME/bin $path )

## duplicate cleaning
typeset -gxU path ld_library_path library_path include cpath nlspath manpath
