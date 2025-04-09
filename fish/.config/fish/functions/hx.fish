# ArchLinux uses the binary name 'helix' instead of 'hx' in order to avoid
# collision with the binary name 'hx' provided by the 'hex' package.
if status is-interactive; and type -q helix; and not type -q hx
    function hx --wraps='helix' --description 'alias hx=helix'
        command helix $argv
    end
end
