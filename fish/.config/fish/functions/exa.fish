function exa --wraps='exa --group-directories-first --group' --description 'alias exa=exa --group-directories-first --group'
  command exa --group-directories-first --group $argv;
end
