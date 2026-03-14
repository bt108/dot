if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_add_path ~/.local/bin/
    alias rmi "rm -i"
    set -g fish_key_bindings fish_vi_key_bindings
end
