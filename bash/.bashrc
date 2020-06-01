#
# GENERAL SETTINGS
#

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Preserve the current working directory in new tabs in VTE based terminal
# emulators.
if [ -x /etc/profile.d/vte.sh ]; then
  . /etc/profile.d/vte.sh
fi

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

if which invoke &>/dev/null; then
  source <(invoke --print-completion-script bash)
fi

#
# ALIASES
#

alias runhttp='python3 -m http.server'
alias tree='tree --dirsfirst -C'

if [ `uname` == "Linux" ]; then
  # pretty colorful output of popular tools
  alias ls='ls --color=auto --group-directories-first'
  alias dir='dir --color=auto'
  alias grep='grep --color=auto'
  alias ip='ip --color=auto'
fi

if [ `uname` == "Darwin" ]; then
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
  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8

  # By default, pip on OS X installs binaries here. So we need to add
  # those paths to PATH in order to make available installed scripts
  # from shell.
  export PATH=~/Library/Python/2.7/bin:~/Library/Python/3.7/bin:$PATH

  # Homebrew's sbin path is unusual for *nix systems so it got to be
  # added explicitly.
  export PATH=/usr/local/sbin:$PATH
fi

export PATH=~/.local/bin:$PATH      # scripts installed by pip (python)
export PATH=~/.cargo/bin:$PATH      # binaries installed by cargo (rust)
export PATH=~/.go/bin:$PATH         # binaries built by go (golang)

export EDITOR=nvim                  # prefer neovim as default editor
export BROWSER=firefox              # prefer firefox as default browser
export TERMINAL=tilix               # preder tilix as default terminal
export PYTHONDONTWRITEBYTECODE=1    # do not produce .pyc/.pyo files
export CLICOLOR=1                   # turn on colors for some BSD tools
export GPG_TTY=`tty`                # setup tty for gpg2's pinetry
export GOPATH=~/.go

if which clang &>/dev/null; then
  export CC=clang                   # use clang as default C compiler
fi

if which clang++ &>/dev/null; then
  export CXX=clang++                # use clang as default C++ compiler
fi


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
    local vcs=$(vcstatus -q -f "\[\e[0;34m\]%n:\[\e[0m\]%b\[\e[34m\]%m\[\e[0m\]")
  fi

  # retrieve virtualenv information if available
  if [ ! -z $VIRTUAL_ENV ]; then
    local venv=$(basename `dirname "$VIRTUAL_ENV"`)

    # special case: show tox venvs as 'tox/venv' instead of '.tox'
    if [ $venv == '.tox' ]; then
      local venv="tox/`basename $VIRTUAL_ENV`"
    fi

    local venv="\[\e[1;35m\]venv:\[\e[0m\]$venv"
  fi

  local STATUSLINE=(
    '\[\e[0;31m\]\u\[\e[0m\]'           # username, bold & red
    '\[\e[0;33m\]@\h\[\e[0m\]'          # hostname, bold & yellow
    '\[\e[0;32m\]\w\[\e[0m\]'           # curr dir, bold & green
    $vcs                                # vcs:branch(+dirty), bold & blue
    $venv                               # active virtualenv, bold & maroon
  )

  PS1="\n${STATUSLINE[*]}"              # show status line on first line
  PS1+='\n\[\e[0;34m\]$\[\e[0m\] '      # show prompt on second one
}
PROMPT_COMMAND="${PROMPT_COMMAND:-:}; __setup_prompt"
