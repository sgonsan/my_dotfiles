# ---------------- Modern CLI: bat · eza · zoxide · Dracula ----------------
#  Bat → cat
if type -q bat
    alias cat="bat --paging=never --theme=Dracula"  # 256-colours OK en cualquier TTY
end

#  Eza → ls
if type -q eza
    # Genera LS_COLORS con vivid (Dracula) una sola vez y guárdalo en una variable
    if type -q vivid
        set -gx LS_COLORS (vivid generate dracula)  # hace que eza respete el tema Dracula :contentReference[oaicite:0]{index=0}
    end
    alias l="eza -lh --icons=auto --sort=name --group-directories-first --git"
    alias ls="eza --icons=auto --git"
    alias ll="eza -lah --header --icons=auto --sort=name --group-directories-first --git"
    alias lt="eza -lhaT --icons=auto"
end

#  Zoxide → cd  (alias corto: c)
if type -q zoxide
    zoxide init fish | source
    alias c="z"   # “c foo” navega instantáneamente a cualquier dir
end

#  Dracula para el prompt y sintaxis de fish
#  (instala la theme oficial – una línea y listo)
fish_config theme choose "Dracula"  # :contentReference[oaicite:0]{index=1}
