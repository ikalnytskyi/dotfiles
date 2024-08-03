if status is-interactive; and type -q tree
  function tree --wraps='tree --dirsfirst -C' --description 'alias tree=tree --dirsfirst -C'
    command tree --dirsfirst -C $argv
  end
end
