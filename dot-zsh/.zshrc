#! /usr/bin/env zsh
# -*- mode: sh; coding: utf-8; indent-tabs-mode: nil -*-
# $Lastupdate: 22024-07-03 16:20:03$
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

# source $ZDOTDIR/wezterm.sh

### Basic Settings
umask 002                   # default umask
bindkey -e                  # keybind  -> emacs like
setopt no_beep              # beep を無効化
setopt combiningchars       # 結合文字処理

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
unsetopt ignore_eof         # ^D でログアウトするために unsetopt

## Job
setopt long_list_jobs       # jobs -l にする, らしいけれど上手く動いてない.
setopt auto_resume          # リダイレクトしてない suspend job を同じ操作で再開
setopt bg_nice              # bg の nice を低くして実行
setopt notify               # バックグラウンドジョブの状態変化を即時報告する
setopt nohup                # default は nohup

### Functions
## hook
autoload -Uz add-zsh-hook


## functions treat as array
typeset -Uga chpwd_functions
typeset -Uga precmd_functions
typeset -Uga preexec_functions

## utilities
autoload -Uz colors         # 色指定を $fg[red] 等で行なえるように.
autoload -Uz 256colors      # 256色表示用簡易コマンド
                            # @see functions/256colors
### History
## zsh-history-filter
# source $ZDOTDIR/modules/zsh-history-filter/zsh-history-filter.plugin.zsh
# HISTORY_FILTER_SILENT=1
# HISTORY_FILTER_EXCLUDE=("ls" "la" "ll" "lv" "cd" "man" "rm")
## change history file for root/sudo
HISTFILE=$ZDOTDIR/tmp/${USER}-zhistory
## メモリ内の履歴の数
HISTSIZE=40960
SAVEHIST=400000
setopt extended_history                # コマンドの開始時刻と経過時間を登録
setopt share_history                   # ヒストリの共有 for tmux
setopt inc_append_history              # 履歴を直ぐに反映
setopt hist_ignore_space               # コマンド行先頭が空白の時登録しない
setopt hist_ignore_all_dups            # 重複ヒストリは古い方を削除
setopt hist_reduce_blanks              # 余分なスペースを削除
setopt hist_no_store                   # historyコマンドは登録しない
setopt hist_find_no_dups               # history検索時に重複を除外
# 特定コマンド除外用関数
zshaddhistory() {
    local line=${1%%$'\n'} #コマンドライン全体から改行を除去したもの
    local cmd=${line%% *}  # １つ目のコマンド
    # 以下の条件をすべて満たすものだけをヒストリに追加する
    [[ ${#line} -ge 5
        && ${cmd} != (l|l[salv])
        && ${cmd} != (c|cd)
        && ${cmd} != (m|man)
        && ${cmd} != (r[mr])
    ]]
}

### 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified

# Ctrl+sのロック, Ctrl+qのロック解除を無効にする
setopt no_flow_control

### Completion
## LSCOLORS
# 本来なら LSCOLORS は別途設定すべきかもしれないが,
# 補完の表示に使用したいのでここで設定することに.
typeset -gx LSCOLORS=ExGxFxDxCxDxDxBxadacec
typeset -gx LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
typeset -gx ZLS_COLORS=$LS_COLORS
typeset -gx CLICOLOR=true
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
zstyle ':completion:*' format '%F{white}%d%f'
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
# 初期化
autoload -Uz compinit
_ZCOMPDUMP=$ZDOTDIR/tmp/$USER-zcompdump
for dump in $_ZCOMPDUMP(N.mh+24); do
    compinit -d $_ZCOMPDUMP
done
[[ -e "${_ZCOMPDUMP:r}.zwc" ]] && [[ "$_ZCOMPDUMP" -ot "${_ZCOMPDUMP:r}.zwc" ]] ||
    zcompile $_ZCOMPDUMP >/dev/null 2>&1
compinit -C -d $_ZCOMPDUMP

### PROMPT
## option
setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
setopt prompt_percent    # %文字から始まる置換機能を有効に
unsetopt promptcr        # 被る時は右プロンプトを消す
setopt transient_rprompt # コマンド実行後は右プロンプトを消す

## chroot info
# Debian の chroot 環境には /etc/debian_chroot がある
function prompt_chroot_info() {
    chroot=$(cat /etc/debian_chroot 2>/dev/null) || return
    chroot_info="|%F{green}$chroot%f"
}
autoload -Uz prompt_chroot_info
add-zsh-hook precmd prompt_chroot_info

function prompt_venv_info() {
    venv_info="|%F{green}$VIRTUAL_ENV_PROMPT%f"
}
autoload -Uz prompt_venv_info
add-zsh-hook precmd prompt_venv_info


## async VCS info at RPROMPT
if [[ x"$_PR_GIT_UPDATE_" = x"0"  ]] ; then

    ### git-prompt.zsh ###
    typeset -gx ZSH_GIT_PROMPT_FORCE_BLANK=1
    typeset -gx ZSH_GIT_PROMPT_SHOW_STASH=1
    typeset -gx ZSH_GIT_PROMPT_SHOW_UPSTREAM=0
    typeset -gx ZSH_THEME_GIT_PROMPT_PREFIX="%b%f["
    typeset -gx ZSH_THEME_GIT_PROMPT_SUFFIX="%b%f]"
    typeset -gx ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
    typeset -gx ZSH_THEME_GIT_PROMPT_BRANCH="%F{magenta}"
    typeset -gx ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%F{yellow}󰑓 "
    typeset -gx ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%F{yellow}󰁔 "
    typeset -gx ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX=""
    typeset -gx ZSH_THEME_GIT_PROMPT_DETACHED="%F{cyan}:"
    typeset -gx ZSH_THEME_GIT_PROMPT_BEHIND="%F{cyan}󰁅 "
    typeset -gx ZSH_THEME_GIT_PROMPT_AHEAD="%F{cyan}󰁝 "
    typeset -gx ZSH_THEME_GIT_PROMPT_UNMERGED="%F{red} "
    typeset -gx ZSH_THEME_GIT_PROMPT_STAGED="%F{green} "
    typeset -gx ZSH_THEME_GIT_PROMPT_UNSTAGED="%F{red} "
    typeset -gx ZSH_THEME_GIT_PROMPT_UNTRACKED="%B%F{yellow}󰇘 "
    typeset -gx ZSH_THEME_GIT_PROMPT_STASHED="%F{blue}󰈻 "
    typeset -gx ZSH_THEME_GIT_PROMPT_CLEAN="%F{green}󰸞 "
    ## load
    source $ZDOTDIR/modules/git-prompt/git-prompt.zsh
    ps_vcs_info='$(gitprompt)'
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
        print -n -P -- "$1" | sed -e $'s/\e\[[0-9;]*m//g' -e 's/[^\x01-\x7e]/aa/g' | wc -m | sed -e 's/ //g'
    fi
}
os_type="(%{%G%})"
if whence lsb_release 2>&1 1>/dev/null  ; then
    case $(lsb_release -d) in
        *Debian*)
            os_type="(%{[38;5;196m%}%{%G %}%{[0m%} )"
            ;;
        *Ubuntu*)
            os_type="(%{[38;5;172m%}%{%G %}%{[0m%} )"
            ;;
        *Red*Hat*)
            os_type="(%{[38;5;255m%}%{%G %}%{[0m%} )"
            ;;
    esac
fi
[[ $OSTYPE == darwin* ]] && os_type="(%B%F{red}%{%G %}%b%f )"
[[ -d /mnt/wslg ]] && os_type="(%B%F{blue}%{%G %}%b%f )"

# precmd のプロンプト更新用関数
function update_prompt (){
    ## プロンプト: 1段目左
    local ps_user="%(!,%B%F{magenta}%n%b%F{white},%n)"
    local ps_host="%m"
    [[ -n ${SSH_CONNECTION} ]] && ps_host="%F{yellow}$ps_host%f"
    [[ -d /mnt/wslg ]] && ps_host="%m"
    local prompt_1st_left="$ps_user@$ps_host$chroot_info$venv_info"
    ## プロンプト: 1段目右
    local prompt_1st_right="[%F{white}%(4~,%-2~/.../%1~,%~)%f]"
    ## 1段目行の残り文字列の計算
    local left_length=$(count_prompt_chars $prompt_1st_left)
    local right_length=$(count_prompt_chars $prompt_1st_right)
    local bar_rest_length=$[ COLUMNS - left_length - right_length - 8 ]
    ## 1段目に水平線を引く
    local prompt_1st_hr=${(l:${bar_rest_length}::-:)}
    ## PROMPT の設定
    # @see Zshをかわいくする.zshrcの設定
    # URL: http://qiita.com/kubosho_/items/c200680c26e509a4f41c
    # 横幅等を調整.
    local ps_status="[%j]%(?.%B%F{green}.%B%F{blue})%(?!(*'-')%b!(*;-;%)%b)%f "
    local ps_mark="%(!,%B%F{magenta}#%f%b,%%)"
    PROMPT="[$prompt_1st_left$os_type]$prompt_1st_hr$prompt_1st_right-"$'\n'"$ps_status$ps_mark "
    PROMPT2='|%j]> '
    SPROMPT="[%j]%B%F{red}%{$suggest%}(*'~'%)?<%b %U%r%u is correct? [n,y,a,e]:%f "
    # 右プロンプト
    RPROMPT="$ps_vcs_info"
}
add-zsh-hook precmd update_prompt

if whence tmux > /dev/null ; then
    autoload -Uz ssh
fi
# ssh config update
autoload -Uz ssh-config-update
# ssh-reagent
autoload -Uz ssh-reagent

# fzf
typeset -gz FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
typeset -gx FZF_DEFAULT_OPTS='--layout=reverse --height=60% --border=sharp --no-unicode --select-1 --exit-0 --info=inline --ansi --cycle --algo=v2 -x -e'
# https://github.com/junegunn/fzf/wiki/Color-schemes
typeset -gx FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg:#eceff1,bg:-1,hl:#40c4ff
 --color=fg+:#ffffff,bg+:,hl+:#5fd7ff
 --color=info:#ffd740,prompt:#ff5252,pointer:#ff4cff
 --color=marker:#5cf19e,spinner:#bf7fff,header:#64FCDA'
if whence fzf > /dev/null ; then
    autoload -Uz fzf-select-history
    zle -N fzf-select-history
    bindkey '^R' fzf-select-history
fi
if whence ghq > /dev/null && whence fzf >/dev/null ; then
    autoload -Uz fzf-ghq
    zle -N fzf-ghq
    bindkey '^S' fzf-ghq
fi

# # peco, ghq
# if whence peco >/dev/null ; then
#     alias peco='peco --rcfile=$HOME/.config/peco/config.json'
#     autoload -Uz peco-select-history
#     zle -N peco-select-history
#     bindkey '^R' peco-select-history
# fi
# if whence ghq > /dev/null && whence peco >/dev/null ; then
#     autoload -Uz peco-ghq
#     zle -N peco-ghq
#     bindkey '^S' peco-ghq
# fi

# emacs <-> zsh
## Invoke the ``dired'' of current working directory in Emacs buffer.
## Chdir to the ``default-directory'' of currently opened in Emacs buffer.
autoload -Uz cde
autoload -Uz dired
### Aliases
typeset -gx LESSCHARSET=utf-8
typeset -gx LESSHISTFILE='~/.cache/lesshst'
# typeset -gx LESSHISTFILE='-'
if whence lesspipe >/dev/null ;then
   # eval "$(lesspipe)"
   typeset -gx LESSOPEN="| /usr/bin/lesspipe %s";
   typeset -gx LESSCLOSE="/usr/bin/lesspipe %s %s";
fi
typeset -gx MANPAGER=less
typeset -gx PAGER='less'
typeset -gx LESS='-R'
typeset -gx LV="-c -T8192 -l -m -k -s"
autoload -Uz man
whence vim >/dev/null && alias vi=vim
typeset EDITOR=vi

## ls
alias sl='ls'  #fxxk!!
typeset -gx TIME_STYLE=long-iso
typeset -gx LS_OPTIONS="-N -T 0 --time-style=$TIME_STYLE"
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
alias rsync2nd='rsync -urlptv'

whence /usr/bin/ranger >/dev/null && alias ranger='urxvtcd -e /usr/bin/ranger'

# whence pry >/dev/null && alias irb=pry

whence nmtui > /dev/null && alias nmtui="LANG=C nmtui"

if [ x"$XDG_CURRENT_DESKTOP" = x"i3" ] ; then
    alias xdg-open="DE=gnome xdg-open"
fi

if whence gbp >/dev/null ; then
    autoload -Uz git-bs
    alias git-b="gbp buildpackage --git-ignore-new --git-builder='debuild --lintian -rfakeroot -i.git -I.git -sa -k${GPG_KEY_ID} '"
    alias git-bp="git-b --git-debian-branch=patche-queue/master"
    alias git-bsp="git-bs --git-debian-branch=patch-queue/master"
    alias git-bss="git-bs --git-debian-branch=jessie-backports"
    alias git-bst="git-bs --git-tag"
fi

## zsh syntax highlihter -- load last
# load する plugin
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
# style のカスタマイズ
typeset -A ZSH_HIGHLIGHT_STYLES
# alias, function
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=magenta,bold'
# 存在するパスのハイライト <-- default
ZSH_HIGHLIGHT_STYLES[path]='underline'
# グロブ
ZSH_HIGHLIGHT_STYLES[globbing]='none'
# マッチしない括弧
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold'
# 括弧の階層
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan,bold'
# カーソルがある場所の括弧にマッチする括弧
ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'
# load
source $ZDOTDIR/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias checkmail="systemctl --user start checkmail.service"
alias wp-mute="systemctl --user start wp-mute.service"
alias en="env TERM=tmux-direct emacs -nw"

# for WSL2 gnome-keyring
if [[ -d /mnt/wslg ]]; then
    # setxkbmap -model pc105 -layout jp -option ctrl:nocaps 2>/dev/null
    # if [[ -z $GPG_AGENT_INFO ]]; then
    #     eval $(keychain -q --eval --agents ssh,gpg $GPG_KEY_ID)
    # fi
    # . $HOME/.keychain/$HOST-sh-gpg
    # typeset -gx SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    ####################################################################
    typeset -gx GNOME_KEYRING_CONTROL=/run/user/$(id -u)/keyring
    typeset -gx SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    typeset -gx GPG_TTY=$(tty)
    # if [[ ! -d /run/user/$(id -u)/keyring ]] ;then
    #     sleep 15 # Uglyyyy
    #     echo | gnome-keyring-daemon --unlock --replace 2>&1 1>/dev/null
    # fi
    gpg-connect-agent updatestartuptty /bye > /dev/null
    setxkbmap -model pc105 -layout jp -option ctrl:nocaps 2>/dev/null
    ## WezTerm ssh hack
    typeset -gx DISPLAY=:0
    typeset -gx WAYLAND_DISPLAY=wayland-0
    unset LC_ALL
fi

# for Emacs vterm
if [[ "$INSIDE_EMACS" ==  "vterm" ]]; then
    autoload -Uz vterm_printf
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi

# for Emacs tramp
if [[ "$TERM" == "dumb" ]]; then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi

# if type zprof > /dev/null 2>&1; then
#   zprof | less
# fi
