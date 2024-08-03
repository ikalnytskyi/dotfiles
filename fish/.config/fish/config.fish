set fish_greeting

set --export --global VISUAL nvim
set --export --global EDITOR nvim
set --export --global BROWSER firefox
set --export --global TERMINAL foot
set --export --global CLICOLOR 1
set --export --global GPG_TTY (tty)
set --export --global LESS "FRX"

fish_add_path --global ~/.local/bin           # executables installed by pip/pipx
fish_add_path --global ~/.cargo/bin           # executables installed by cargo


# Starship is the minimal, fast, and  customizable prompt for any shell.
if status is-interactive; and type -q starship
  starship init fish | source
end


# Source per-host configurations as well as localhost overrides.
if status is-interactive
  for name in config.{$hostname,local}.fish
    if test -e $__fish_config_dir/$name
      source $__fish_config_dir/$name
    end
  end
end
