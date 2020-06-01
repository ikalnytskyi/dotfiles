function ip --wraps='ip --color=auto' --description 'alias ip=ip --color=auto'
  command ip --color=auto $argv;
end
