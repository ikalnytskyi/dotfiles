function docker --wraps='sudo docker' --description 'alias docker=sudo docker'
  command sudo docker $argv
end
