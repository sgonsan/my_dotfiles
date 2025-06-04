# ~/.bashrc: executed by bash(1) for non-login shells.

# Exit if not interactive shell
case $- in
    *i*) ;;
      *) return;;
esac

# Avoid duplicate entries and lines starting with a space in history
HISTCONTROL=ignoreboth

# Append to the history file instead of overwriting it
shopt -s histappend

# Set history size limits
HISTSIZE=1000
HISTFILESIZE=2000

# Automatically update terminal size
shopt -s checkwinsize

# Preprocess non-text files for 'less'
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set chroot name (used in prompt if applicable)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Enable color prompt if terminal supports it
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Check if tput works and force color prompt
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Function: show incoming/outgoing git changes with icons
git_sync_status() {
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local status branch parts=()
  status=$(git status -sb 2>/dev/null)
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "(detached)")

  parts+=("git:$branch")

  [[ $status =~ behind\ ([0-9]+) ]] && parts+=("↓")
  [[ $status =~ ahead\ ([0-9]+) ]] && parts+=("↑")

  # Add ✱ if there are unstaged, staged, or untracked changes
  if ! git diff --quiet --ignore-submodules -- || ! git diff --cached --quiet --ignore-submodules -- || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    parts+=("✱")
  fi

  printf " [%s]" "$(IFS=, ; echo "${parts[*]}")"
}

# Set custom PS1 prompt with colors, working dir, and git sync status
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\e[1;35m\]\u\[\e[0m\] \[\e[1;32m\]\w\[\e[0m\]\[\e[1;34m\]$(git_sync_status)\[\e[0m\] \$ '
else
    PS1='\u \w$(git_sync_status) \$ '
fi
unset color_prompt force_color_prompt

# Set terminal window title to user@host:dir (for xterm, rxvt)
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable colored output for common tools
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Load extra aliases from ~/.bash_aliases if present
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --- Custom configuration below ---

# Alias: full system upgrade and cleanup
alias aptup='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y'

# Add ~/.console-ninja/.bin to PATH
PATH=~/.console-ninja/.bin:$PATH

# PulseAudio for WSL or remote GUI apps
export PULSE_SERVER=unix:/run/pulse/native
export PULSE_LATENCY_MSEC=60

# Apply Dracula theme to LS_COLORS using vivid
eval "$(vivid generate dracula | sed 's/^/export LS_COLORS="/;s/$/"/')"

# Aliases for eza (modern ls replacement) with icons and Git status
alias ls='eza --icons=auto --git'
alias l='eza -lh --icons=auto --sort=name --group-directories-first --git'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first --git'
alias lt='eza -lhaT --icons=auto'

# Replace cat with batcat (syntax highlighting, themes)
alias cat='batcat --theme=Dracula --paging=never --color=always'

# Enable fzf keybindings (Ctrl+R, etc.)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Initialize zoxide (smart directory jumping)
eval "$(zoxide init bash)"

# Alias for zoxide
alias c='z'
alias ci='zi'

# Alias for Yazi (terminal file manager)
alias y='yazi'

# Enable thefuck (fix previous mistyped command)
eval "$(thefuck --alias)"

# Use fzf with file preview using batcat
alias fzf="fzf --preview 'batcat --theme=Dracula --paging=never --color=always {}'"

# Additional fzf keybindings (Ctrl+R, Ctrl+T, Alt+C)
source /usr/share/doc/fzf/examples/key-bindings.bash

