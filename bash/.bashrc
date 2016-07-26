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

if [ `uname` == "Darwin" ]; then
  # By default, OS X locale is incompatible with Linux since it doesn't
  # have encoding part (e.g. "en_US"). It breaks some programs when we
  # SSH to Linux machine via OS X, since wrong locale will be passed.
  # So let's setup locale in compatible way.
  export LC_ALL=en_US.utf-8
  export LANG=en_US.utf-8

  # By default, pip on OS X installs binaries here. So we need to add
  # those paths to PATH in order to make available installed scripts
  # from shell.
  export PATH=~/Library/Python/2.7/bin:~/Library/Python/3.5/bin:$PATH
fi

export PATH=~/.local/bin:$PATH      # scripts installed by pip (python)
export PATH=~/.cargo/bin:$PATH      # binaries installed by cargo (rust)

export EDITOR=vim                   # prefer vim as default editor
export CC=clang                     # use clang as default C compiler
export CXX=clang++                  # use clang as default C++ compiler
export PYTHONSTARTUP=~/.pythonrc    # enable python shell auto completion
export PYTHONDONTWRITEBYTECODE=1    # do not produce .pyc/.pyo files
export CLICOLOR=1                   # turn on colors for some BSD tools
export GPG_TTY=`tty`                # setup tty for gpg2's pinetry


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

  # retrieve vcs information if available
  if which vcstatus &>/dev/null; then
    local vcs=$(vcstatus -q -f "\[\e[1;34m\]%n:\[\e[0m\]%b\[\e[34m\]%m\[\e[0m\]")
  fi

  # retrieve virtualenv information if available
  if [ x$VIRTUAL_ENV != x ]; then
    local venv=$(basename `dirname "$VIRTUAL_ENV"`)
    venv="\[\e[1;35m\]venv:\[\e[0m\]$venv"
  fi

  local STATUSLINE=(
    '\[\e[1;31m\]\u\[\e[0m\]'           # username, bold & red
    '\[\e[1;33m\]@\h\[\e[0m\]'          # hostname, bold & yellow
    '\[\e[1;32m\]\w\[\e[0m\]'           # curr dir, bold & green
    $vcs                                # vcs:branch(+dirty), bold & blue
    $venv                               # active virtualenv, bold & maroon
  )

  PS1="\n${STATUSLINE[*]}"              # show status line on first line
  PS1+='\n\[\e[1;34m\]→\[\e[0m\] '      # show prompt on second one
}
PROMPT_COMMAND="${PROMPT_COMMAND:-:}; __setup_prompt"
