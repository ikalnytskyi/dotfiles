function ls --wraps='ls --color=auto' --description 'alias ls=ls --color=auto'
  command ls --color=auto $argv;
end
