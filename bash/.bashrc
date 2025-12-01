# Check if inside Nix Flake and modify the prompt
if [[ -f "flake.nix" || -f ".dir-locals.nix" ]]; then
    export PS1='\[\033[1;34m\]nix \[\033[1;32m\][\u@\h:\w]\$ \[\033[0m\]'  # Light blue "nix", light green prompt
else
    export PS1='\[\033[1;32m\][\u@\h:\w]\$ \[\033[0m\]'  # Light green prompt
fi
