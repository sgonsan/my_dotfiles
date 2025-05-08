set -g fish_greeting
set -x LANG en_US.UTF-8

if status is-interactive
    starship init fish | source
end

eval "$(vivid generate dracula | sed 's/^/export LS_COLORS="/;s/$/"/')"

# List Directory
# alias l='eza -lh --icons=auto --sort=name --group-directories-first' # long list
# alias ls='eza --icons=auto' # short list
# alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
# alias lt='eza -lhaT --icons=auto' # list folder as tree

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

alias pacup='sudo pacman -Syyu'
alias yayup='yay -Syyu'

thefuck --alias | source
