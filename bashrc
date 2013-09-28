#
# DESCRIPTION: My awesome bash prompt with additional information.
#      AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
#
# Based on Armin Ronacher's `.bashrc`.
#

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  STANDARD DEBIAN .BASHRC
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'
    alias dir='dir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi

  _pip_completion()
  {
      COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                     COMP_CWORD=$COMP_CWORD \
                     PIP_AUTO_COMPLETE=1 $1 ) )
  }
  complete -o default -F _pip_completion pip
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  AUXILIARY FUNCTIONS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

_bold()      { echo -e "\033[1m$1\033[0m"; }
_underline() { echo -e "\033[4m$1\033[0m"; }

_black()   { echo -e "\033[30m$1\033[00m"; }
_red()     { echo -e "\033[31m$1\033[00m"; }
_green()   { echo -e "\033[32m$1\033[00m"; }
_yellow()  { echo -e "\033[33m$1\033[00m"; }
_blue()    { echo -e "\033[34m$1\033[00m"; }
_magenta() { echo -e "\033[35m$1\033[00m"; }
_cyan()    { echo -e "\033[36m$1\033[00m"; }
_white()   { echo -e "\033[37m$1\033[00m"; }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  SETUP BASH PROMPT
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# print useful information of some vcs
_vcs_prompt() {
  path=`pwd`
  prompt=$' on \033[1m\033[34m%n\033[00m:\033[00m%b\033[00m'
  vcprompt -f "$prompt"
}

# print current activated virtualenv
_virtualenv() {
  if [ x$VIRTUAL_ENV != x ]; then
    if [[ $VIRTUAL_ENV == *.virtualenvs/* ]]; then
      ENV_NAME=`basename "${VIRTUAL_ENV}"`
    else
      folder=`dirname "${VIRTUAL_ENV}"`
      ENV_NAME=`basename "$folder"`
    fi
    echo -n $' \033[00mworkon \033[1m\033[35m'
    echo -n $ENV_NAME
    echo -n $'\033[00m'
  fi
}
VIRTUAL_ENV_DISABLE_PROMPT=1

export BASEPROMPT='\n'
export BASEPROMPT=$BASEPROMPT'$(_bold `_red \u`) '          # username
export BASEPROMPT=$BASEPROMPT'at $(_bold `_yellow \h`) '    # hostname
export BASEPROMPT=$BASEPROMPT'in $(_bold `_green :\w`)'     # current dir
export BASEPROMPT=$BASEPROMPT'`_vcs_prompt`'                # vcs status
export BASEPROMPT=$BASEPROMPT'`_virtualenv`'                # venv status

export PS1="\[\033[G\]${BASEPROMPT}\n\$ "


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  EXPORT DEFINITIONS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

export EDITOR=vim
export TERM=xterm-256color

export CC=clang
export CXX=clang++
