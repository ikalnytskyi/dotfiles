if status is-interactive; and type -q lsd
  function lsd --wraps='lsd --color=auto --group-directories-first' --description 'alias lsd=lsd --color=auto --group-directories-first'
    command lsd --group-directories-first $argv;
  end
end
