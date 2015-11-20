#
# DESCRIPTION: My awesome bash prompt with additional information.
#      AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
#

#
# GENERAL SETTINGS
# ````````````````

# If not running interactively, don't do anything.
case $- in
  *i*) ;;
    *) return;;
esac


# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for details.
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000


# Append to the history file, don't overwrite it.
shopt -s histappend

# Check the window size after each command and, if necessary, update
# the values of LINES and COLUMNS.
shopt -s checkwinsize


# Trick to enable color support in some programs (Linux only).
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" \
       || eval "$(dircolors -b)"

  alias ls='ls --color=auto --group-directories-first'
  alias dir='dir --color=auto'
  alias grep='grep --color=auto'
fi


# Enable Bash auto completion on Linux and/or OS X.
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif which brew >/dev/null; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi

# Enable pip auto completion for Bash.
_pip_completion()
{
  COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                 COMP_CWORD=$COMP_CWORD \
                 PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip


# When open a new tab copy settings from the previous
# (current directory, and so on). Works on Linux systems.
if [ -f /etc/profile.d/vte.sh ]; then
  . /etc/profile.d/vte.sh
fi


#
# EXPORT DEFINITIONS
# ``````````````````

# Define UTF-8 based locale settings on OS X.
if [ `uname` == "Darwin" ]; then
  export LC_ALL=en_US.utf-8
  export LANG=en_US.utf-8
fi

# Add ~/.bin folder to $PATH environment. It's very convenient to keep
# user executables here.
export PATH=~/.bin:$PATH
export PATH=~/.local/bin:$PATH

export EDITOR=vim
export TERM=xterm-256color
export CC=clang
export CXX=clang++

# Don't generate *.pyc and *.pyo.
export PYTHONDONTWRITEBYTECODE=1
# Don't show active virtualenv in Bash prompt.
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Enable colors in some BSD tools (ls, etc).
export CLICOLOR=1


#
# SETUP BASH PROMPT
# `````````````````

function __extprompt {
  # show current vcs information
  if which vcprompt >/dev/null; then
    prompt=$' on \e[1m\e[34m%n\e[0m:\e[0m%b\e[0m\e[36m%m\e[0m'
    vcprompt -f "$prompt"
  fi

  # show current active virtualenv
  if [ x$VIRTUAL_ENV != x ]; then
    folder=`dirname "${VIRTUAL_ENV}"`
    ENV_NAME=`basename "$folder"`

    echo -n $' \033[00mworkon \033[1m\033[35m'
    echo -n $ENV_NAME
    echo -n $'\033[00m'
  fi
}


export BASEPROMPT="\e[1m\e[31m\u\e[0m "         # username > bold and red
export BASEPROMPT+="at \e[1m\e[33m\h\e[0m "     # hostname > bold and yellow
export BASEPROMPT+="in \e[1m\e[32m\w\e[0m"      # curr dir > bold and green

export BASEPROMPT=$BASEPROMPT'`__extprompt`'
export PS1="\n\[\e[G\]${BASEPROMPT}\n\$ "
