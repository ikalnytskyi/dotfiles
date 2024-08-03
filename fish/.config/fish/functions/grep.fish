if status is-interactive; and type -q grep
  function grep --wraps='grep --color=auto' --description 'alias grep=grep --color=auto'
    command grep --color=auto $argv;
  end
end
