#
# DESCRIPTION: My awesome bash prompt with additional information.
#      AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
#

#
# GENERAL SETTINGS
#

# If not running interactively, don't do anything.
case $- in
  *i*) ;;
    *) return;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize

# Enable color support in some programs by default (Linux only).
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" \
       || eval "$(dircolors -b)"
fi

# Enable Bash auto completion.
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif which brew >/dev/null; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi
_pip_completion()
{
  COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                 COMP_CWORD=$COMP_CWORD \
                 PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip


#
# ALIASES
#

alias runhttp='python -m SimpleHTTPServer'
alias tree='tree --dirsfirst -C'

if [ `uname` == "Linux" ]; then
  alias ls='ls --color=auto --group-directories-first'
  alias dir='dir --color=auto'
  alias grep='grep --color=auto'
fi


#
# EXPORT DEFINITIONS
#

# Default OS X locale is incompatible with Linux, because it doesn't have
# encoding part. It breaks some things when you deal with remote Linux
# machine using SSH - SSH client passes wrong locale to remote machine,
# and some programs fail to use it.
if [ `uname` == "Darwin" ]; then
  export LC_ALL=en_US.utf-8
  export LANG=en_US.utf-8
fi

# Add local bin folders to $PATH. It's very convenient to keep
# manually built or locally installed executable here.
export PATH=~/.bin:~/.local/bin:$PATH

export EDITOR=vim                   # prefer vim as default editor
export TERM=xterm-256color          # yep, we have 256color compatible terminal
export CC=clang                     # use clang as default C compiler
export CXX=clang++                  # use clang as default C++ compiler

export PYTHONDONTWRITEBYTECODE=1    # do not produce .pyc/.pyo files
export CLICOLOR=1                   # turn on colors for some BSD tools


#
# SETUP BASH PROMPT WITH BLACKJACK AND HOOKERS
#

function __setup_prompt {
  # ANSI CODES - SEPARATE MULTIPLE VALUES WITH ;
  #
  #  0  reset          4  underline
  #  1  bold           7  inverse
  #
  # FG  BG  COLOR     FG  BG  COLOR
  # 30  40  black     34  44  blue
  # 31  41  red       35  45  magenta
  # 32  42  green     36  46  cyan
  # 33  43  yellow    37  47  white

  # show username and cwd
  local BASEPROMPT='\n\e[1;31m\u\e[0m \e[1;33m@\h\e[0m \e[1;32m\w\e[0m'

  # show current vcs information if any
  if which vcprompt >/dev/null; then
    local prompt=" \e[1;34m%n:\e[0m%b\e[34m%m\e[0m"
    BASEPROMPT+=$(vcprompt -f "$prompt")
  fi

  # show active virtualenv if any
  if [ x$VIRTUAL_ENV != x ]; then
    local ENV_NAME=$(basename `dirname "$VIRTUAL_ENV"`)
    BASEPROMPT+=" \e[1;35mvenv:\e[0m$ENV_NAME"
  fi

  # show prompt on a new line
  BASEPROMPT+='\n\e[1;34m→\e[0m '
  export PS1=$BASEPROMPT
}
PROMPT_COMMAND="${PROMPT_COMMAND:-true}; __setup_prompt"
