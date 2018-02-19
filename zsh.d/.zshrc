#! /usr/bin/env zsh
# -*- mode: sh; coding: utf-8; indent-tabs-mode: nil -*-
# $Lastupdate: 2018-02-19 20:15:00$
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
# NOTE:
# Refernce:
# - Qitta article http://qiita.com/kubosho_/items/c200680c26e509a4f41c
# - @satoh_fumiyasu: https://twitter.com/satoh_fumiyasu/status/519386124020482049
#
# Code:

### Basic Settings
umask 022                   # default umask
bindkey -e                  # keybind  -> emacs like
setopt no_beep              # beep を無効化

## Change Directory
setopt auto_pushd           # cd 時に Tab 補完
setopt pushd_to_home        # pushd を引数無しで実行した時に pushd ~ とする
setopt pushd_ignore_dups    # ディレクトリスタックに重複する物は古い方を削除
DIRSTACKSIZE=20
[[ $OSTYPE == (cygwin*|msys*) ]] || limit coredumpsize 0
                            # cygwin 以外では core を吐かないようにする.
## Correct command
setopt correct              # コマンドのスペル訂正
setopt rc_quotes            # '' で \' を表現(エスケープをちょっとだけ省く)
unsetopt correct_all        # 全ての引数のスペル訂正: 無効化
unsetopt ignore_eof         # ^D でのログアウトするために unsetopt

## Job
setopt long_list_jobs       # jobs -l にする, らしいけれど上手く動いてない.
setopt auto_resume          # リダイレクトしてない suspend job を同じ操作で再開
setopt bg_nice              # bg の nice を低くして実行
setopt notify               # バックグラウンドジョブの状態変化を即時報告する
setopt nohup                # default は nohup

### Functions
## functions treat as array
typeset -Uga chpwd_functions
typeset -Uga precmd_functions
typeset -Uga preexec_functions

## utilities
autoload -Uz is-at-least     # zsh のバージョンチェック
autoload -Uz colors; colors  # 色指定を $fg[red] 等で行なえるように.

### History
## change history file for root/sudo
HISTFILE=$ZDOTDIR/tmp/${USER}-zhistory
## メモリ内の履歴の数
HISTSIZE=100000
SAVEHIST=$HISTSIZE
setopt extended_history                # コマンドの開始時刻と経過時間を登録
setopt share_history                   # ヒストリの共有 for GNU Screen
setopt inc_append_history              # 履歴を直ぐに反映
setopt hist_ignore_space               # コマンド行先頭が空白の時登録しない
setopt hist_ignore_all_dups            # 重複ヒストリは古い方を削除
setopt hist_reduce_blanks              # 余分なスペースを削除
setopt hist_no_store                   # historyコマンドは登録しない

### Completion
## LSCOLORS
# 本来なら LSCOLORS は別途設定すべきかもしれないが, 補完の表示に使用した
# いのでここで設定することに.
export LSCOLORS=exgxfxdxcxdxdxbxadacec
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
## Options
setopt auto_list              # 補完候補を一覧で表示
setopt auto_param_slash       # 補完候補がディレクトリの場合, 末尾に / を追加
setopt auto_param_keys        # カッコの対応も補完
setopt list_packed            # 補完候補をできるだけ詰めて表示
setopt list_types             # 補完候補のファイル種別を識別
unsetopt list_beep            # 補完の beep を無効化
setopt rec_exact              # 曖昧補完を有効化
setopt interactive_comments   # コマンドでも # 以降をコメントとみなす
setopt magic_equal_subst      # = 以降も補完(--prefix= 等)
setopt complete_in_word       # コマンドの途中でもカーソル位置で補完
setopt always_last_prompt     # カーソル位置を保持してファイル名一覧を補完
## style
zstyle ':completion:*' menu select=2 # カーソルによる補完候補の選択を有効化
# 色指定に LS_COLORS を使用
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# 種別を別々に表示させるため, グループを空白に
zstyle ':completion:*' group-name ''
# ディレクトリ名の補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# ...はて?
zstyle ':completion:*' keep-prefix
# リモートディレクトリも補完
zstyle ':completion:*' remote-access true
# ...はて?
zstyle ':completion:*' completer \
    _oldlist _complete _match _ignored _approximate _list _history
## 補完候補の追加
# is-at-least 4.3.10 && [ -d $ZDOTDIR/modules/zsh-completions ] && \
#     fpath+=( $ZDOTDIR/modules/zsh-completions/src $fpath )
# is-at-least 4.3.10 && [ -d $HOME/.rbenv/completions/rbenv.zsh ] && \
#     fpath+=( $HOME/.rbenv/completions/rbenv.zsh $fpath )
typeset -gxU fpath
# 初期化
autoload -Uz compinit
compinit -u -d $ZDOTDIR/tmp/$USER-zcompdump

### PROMPT
## option
setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
setopt prompt_percent    # %文字から始まる置換機能を有効に
unsetopt promptcr        # 被る時は右プロンプトを消す
setopt transient_rprompt # コマンド実行後は右プロンプトを消す

# autoload -Uz promptinit ;  promptinit

# isemacs(){
#     [[ x"$EMACS" != x"" ]] && return 0
#     return 1
# }

## chroot info
# Debian の chroot 環境には /etc/debian_chroot がある
function prompt_chroot_info() {
    chroot=$(cat /etc/debian_chroot 2>/dev/null) || return
    chroot_info="|%F{green}$chroot%f"
}
precmd_functions+=prompt_chroot_info

## VCS info
if is-at-least 4.3.10 ; then
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git bzr svn hg
    zstyle ':vcs_info:*' formats '%s:%b'
    zstyle ':vcs_info:*' actionformats '%s:%b%a'
    zstyle ':vcs_info:(svn|bzr)' branchformat '%b:r%r'
    zstyle ':vcs_info:bzr:*' use-simple true
    function prompt_vcs_info(){
        [[ -n $_PR_GIT_UPDATE_ ]] && LANG=C vcs_info "$@"
        if [[ -n "$vcs_info_msg_0_" ]]; then
            ps_vcs_info="[%B%F{red}$vcs_info_msg_0_%f%b]"
        else
            ps_vcs_info=''
        fi
    }
    precmd_functions+=prompt_vcs_info
else
    ps_vcs_info=''
fi

# 変数の文字列計算用関数
function count_prompt_chars (){
    # @see https://twitter.com/satoh_fumiyasu/status/519386124020482049
    # Thanks to @satoh_fumiyasu
    if [[ $OSTYPE == darwin* ]] ; then
        print -n -P -- "$1" | sed -e $'s/\e\[[0-9;]*m//g' | iconv -f UTF-8-MAC -t US-ASCII//TRANSLIT | sed 's/?/aa/g' | wc -m | sed -e 's/ //g'
    else
        print -n -P -- "$1" | sed -e $'s/\e\[[0-9;]*m//g' | sed -e 's/[^\x01-\x7e]/aa/g' | wc -m | sed -e 's/ //g'
    fi
}
# precmd のプロンプト更新用関数
function update_prompt (){
    ## プロンプト: 1段目左
    local ps_user="%(!,%B%F{magenta}%n%b,%n)"
    local ps_host="%m"
    [[ -n ${SSH_CONNECTION} ]] && ps_host="%F{yellow}$ps_host%f"
    local prompt_1st_left="[$ps_user@$ps_host$chroot_info]"
    ## プロンプト: 1段目右
    local prompt_1st_right="[%F{white}%(5~,%-2~/.../%1~,%~)%f]"
    ## 1段目行の残り文字列の計算
    local left_length=$(count_prompt_chars $prompt_1st_left)
    local right_length=$(count_prompt_chars $prompt_1st_right)
    local bar_rest_length=$[ COLUMNS - left_length - right_length -1 ]
    ## 1段目に水平線を引く
    local prompt_1st_hr=${(l:${bar_rest_length}::-:)}
    ## PROMPT の設定
    # @see Zshをかわいくする.zshrcの設定
    # URL: http://qiita.com/kubosho_/items/c200680c26e509a4f41c
    # 横幅等を調整.
    local ps_status="[%j]%(?.%B%F{green}.%B%F{blue})%(?!(*'-')%b!(*;-;%)%b)%f "
    local ps_mark="%(!,%B%F{magenta}#%f%b,%%)"
    PROMPT="$prompt_1st_left$prompt_1st_hr$prompt_1st_right-"$'\n'"$ps_status$ps_mark "
    # local prompt_info="[$ps_user@$ps_host$chroot_info"
    # local prompt_pwd="%F{white}%(5~,%-2~/.../%1~,%~)%f]"
    # PROMPT="$prompt_info:$prompt_pwd"$'\n'"$ps_status$ps_mark "
    PROMPT2='|%j]> '
    SPROMPT="[%j]%B%F{red}%{$suggest%}(*'~'%)?<%b %U%r%u is correct? [n,y,a,e]:%f "
    # 右プロンプト
    RPROMPT="$ps_vcs_info"
}
# isemacs ||
precmd_functions+=update_prompt

# ssh-reagent
function ssh-reagent(){
    for agent in /tmp/ssh-*/agent.*; do
        export SSH_AUTH_SOCK=$agent
        if ssh-add -l 2>&1 > /dev/null; then
            echo "Found working SSH agent:"
            ssh-add -l
            return
        fi
    done
    echo "Cannot find ssh agent - maybe you should reconnect and forward it?"
}

# tmux + ssh
# function ssh() {
#   if [ -n $(printenv TMUX) ]; then
#       local window_name=$(tmux display -p '#{window_name}')
#       tmux rename-window -- "$@[-1]" # zsh specified
#       # tmux rename-window -- "${!#}" # for bash
#       command ssh $@
#       tmux rename-window $window_name
#   else
#       command ssh $@
#   fi
# }

# peco
zstyle ":anyframe:selector:" use peco
zstyle ":anyframe:selector:peco:" command "peco --rcfile=${HOME}/.config/peco/config.json"
autoload -Uz anyframe-init
anyframe-init
bindkey '^R' anyframe-widget-put-history

# emacs <-> zsh
## Invoke the ``dired'' of current working directory in Emacs buffer.
## Chdir to the ``default-directory'' of currently opened in Emacs buffer.
autoload -Uz cde
autoload -Uz dired
### Aliases
export PAGER='less'
export LESS='-R'
export LESSCHARSET=utf-8
export MANPAGER=less
export LV="-c -T8192 -l -m -k -s"
autoload man
whence vim >/dev/null && alias vi=vim
export EDITOR=vi

## ls
alias sl='ls'  #fxxk!!
export TIME_STYLE=long-iso
export LS_OPTIONS="-N -T 0 --time-style=$TIME_STYLE"
case $OSTYPE in
    darwin*)
        alias ls='ls -FG'
        alias la='ls -haFG'
        alias ll='ls -hlFG'
        alias lla='ls -hlaFG'
        alias lsd='ls -ld *(-/DN)'
        ;;
    solaris*)
        alias ls='/opt/sfw/bin/ls -F --color=auto'
        alias la='/opt/sfw/bin/ls -haF --color=auto'
        alias ll='/opt/sfw/bin/ls -hlF --color=auto'
        alias lla='/opt/sfw/bin/ls -hlaF --color=auto'
        alias lsd='/opt/sfw/bin/ls -ld *(-/DN)'
        ;;
    cygwin*)
        alias ls='ls -F --color=auto --show-control-chars'
        alias la='ls -haF --color=auto --show-control-chars'
        alias ll='ls -hlF --color=auto --show-control-chars'
        alias lla='ls -hlaF --color=auto --show-control-chars'
        alias lsd='ls -ld *(-/DN)'
        ;;
    *)
        alias ls='ls -F --color=auto'
        alias la='ls -haF --color=auto'
        alias ll='ls -hlF --color=auto'
        alias lla='ls -hlaF --color=auto'
        alias lsd='ls -ld *(-/DN)'
        ;;
esac

alias rm='nocorrect rm -i'
alias mv='nocorrect mv -i'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias dmesg='sudo dmesg'

whence pry >/dev/null && alias irb=pry
if whence gbp >/dev/null ; then
    auto_zcompile_and_source $ZDOTDIR/utils/gbp
fi

if whence systemctl 2>&1 1>/dev/null ; then
    alias halt="sudo systemctl poweroff"
    alias reboot="sudo systemctl reboot"
fi

# if whence khal 2>&1 1>/dev/null ; then
#     function khal (){
#         urxvt -title khal -e sh -c "env LANG=en_US.UTF-8 khal --color interactive"
#     }
# fi

# load last
source $ZDOTDIR/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# if type zprof > /dev/null 2>&1; then
#   zprof | less
# fi
