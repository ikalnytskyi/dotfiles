function ls --wraps='ls --color=auto --group-directories-first' --description 'alias ls=ls --color=auto --group-directories-first'
  switch (uname)
    case "Linux"
      command ls --color=auto --group-directories-first $argv;
    case "Darwin"
      if type -q exa
        command exa --group-directories-first --group $argv;
      else
        command ls $argv;
      end
  end
end
