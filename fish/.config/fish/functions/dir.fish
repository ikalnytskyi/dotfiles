if status is-interactive; and type -q dir
  function dir --wraps='dir --color=auto' --description 'alias dir=dir --color=auto'
    command dir --color=auto $argv;
  end
end
