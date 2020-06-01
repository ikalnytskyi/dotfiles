function runhttp --wraps='python3 -m http.server' --description 'alias runhttp=python3 -m http.server'
  python3 -m http.server $argv;
end
