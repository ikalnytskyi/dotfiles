set fish_greeting

#
# ENVIRONMENT VARIABLES
#

set -xp PATH ~/.local/bin            # executables installed by pip/pipx
set -xp PATH ~/.cargo/bin            # executables installed by cargo

set -xg EDITOR nvim                  # promote editor of choice
set -xg BROWSER firefox              # promote browser of choice
set -xg TERMINAL foot                # promote terminal of choice
set -xg PYTHONDONTWRITEBYTECODE 1    # do not produce .pyc/.pyo files
set -xg CLICOLOR 1                   # turn on colors for some BSD tools
set -xg GPG_TTY (tty)                # setup tty for gpg2's pinetry

if type -q clang
  set -xg CC clang                   # use clang as default C compiler
end

if type -q clang++
  set -xg CXX clang++                # use clang as default C++ compiler
end

#
# SETUP PROMPT WITH BLACKJACK AND HOOKERS
#

if status is-interactive; and type -q starship
  starship init fish | source
end

#
# SOURCE EXTRA CONFIGURATIONS
#

if status is-interactive
  for name in config.{$hostname,local}.fish
    if test -e $__fish_config_dir/$name
      source $__fish_config_dir/$name
    end
  end
end
