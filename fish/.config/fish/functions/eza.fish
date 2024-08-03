if status is-interactive; and type -q eza
  function eza --wraps='eza --group-directories-first --group' --description 'alias eza=eza --group-directories-first --group'
    command eza --group-directories-first --group $argv;
  end
end
