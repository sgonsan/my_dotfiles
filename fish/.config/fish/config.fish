# ===================================================================
# 🐟 FISH CONFIG
# ===================================================================

# -------------------- Basic setup --------------------
set -g fish_greeting    # Disable default greeting

if status is-interactive
    starship init fish | source
end

# Default editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# -------------------- Modern CLI tools --------------------
# BAT as CAT (Dracula theme)
if type -q bat
    alias cat="bat --paging=never --theme=Dracula"
end

# EZA instead of ls
if type -q eza
    if type -q vivid
        set -gx LS_COLORS (vivid generate dracula)
    end
    alias l='eza -lh --icons=auto --sort=name --group-directories-first --git'
    alias ls='eza --icons=auto --git'
    alias ll='eza -lah --header --icons=auto --sort=name --group-directories-first --git'
    alias lt='eza -lhaT --icons=auto'
end

# Zoxide as cd replacement
if type -q zoxide
    zoxide init fish | source
    alias c='z'
end

# Dracula theme for fish syntax
fish_config theme choose "Dracula"

# -------------------- Handy aliases --------------------
alias pacup='sudo pacman -Syyu'
alias yayup='yay -Syyu --noconfirm'
alias yayrm='yay -Scc --noconfirm ; yay -Yc --noconfirm'
alias n='nvim'
alias fast='fastfetch'
alias diff='difft'
thefuck --alias | source

# -------------------- Directory abbreviations --------------------
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'
abbr mkdir 'mkdir -p'

# -------------------- Yazi wrapper --------------------
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

