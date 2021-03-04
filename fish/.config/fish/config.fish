# setting fish as default shell: `chsh -s /usr/bin/fish`

# only run tmux in alacritty and if tmux is not yet running
if status is-interactive && test $TERM = 'alacritty' && not tmux info &> /dev/null
    exec tmux
end

# rename first window of first session
if test -n "$TMUX" && test (tmux display-message -p '#{session_id}#{window_index}#{pane_index}') = '$000'
    tmux rename-window chaos
end

function append_path
    for path in $argv
        contains $path $PATH || set -xa PATH $path
    end
end

set -x GOPATH $HOME/dev/go
append_path $HOME/bin $GOPATH $GOPATH/bin $HOME/.cargo/bin $HOME/.node_modules/bin
set -x EDITOR nvim
set -x VISUAL nvim
set -x MANPAGER "nvim +Man!"
set -x DIFFPROG "nvim -d"

# https://github.com/0rax/fish-bd
set -x BD_OPT 'insensitive'

# https://github.com/junegunn/fzf
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git/'

# https://github.com/jethrokuan/fzf
set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_FIND_FILE_COMMAND 'fd --type f --hidden --exclude .git/ . $dir'
set -x FZF_CD_COMMAND 'fd --type d --exclude .git/ . $dir'
set -x FZF_CD_WITH_HIDDEN_COMMAND 'fd --type d --hidden --exclude .git/ . $dir'
set -x FZF_OPEN_COMMAND 'fd --hidden --exclude .git/ . $dir'

# https://github.com/sharkdp/bat
set -x BAT_THEME 'gruvbox-dark'

alias ls='exa --group-directories-first --time-style=long-iso'
alias ll='ls -l'
alias la='ls -la'
alias lt='ls -lT'
alias o=open
alias n=nvim
alias nup='nvim +PlugUpgrade +PlugUpdate'
alias nn='nvim +Notes!'
alias nng='nvim +RgNotes!'
alias c='xclip -sel clip'
alias pwdc='pwd | head -c -1 | c'
alias se=sudoedit
alias ip='ip --color=auto'
alias gnutime='command time -p'
alias cal='cal -mw'
alias ncmpcpp='ncmpcpp --quiet'
alias qr='qrencode -t ANSIUTF8 -o -'
alias history_copy='history | fzf --no-sort --height 40% | read -l x && echo "$x" | c'
alias history_del='history | fzf --no-sort --height 40% | read -l x && history delete --case-sensitive --prefix "$x"'
alias cd_hist='echo $dirprev | tr \' \' \'\n\' | fzf --tac --no-sort --height 20% | read -l x && cd "$x"'
alias mpc_songs='mpc playlist -f \'%position%\t[[%artist% - ][%album% - ]%title%|%file%]\' | fzf --height 40% | awk \'{print $1}\' | read -l x && mpc play "$x"'

function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
    # use `fish_key_reader -c` or `showkey -a` to get keys

    fish_hybrid_key_bindings

    # \e\r = alt+enter; ctrl+enter is mapped to \e\r in alacritty.yml
    bind -M insert \e\r accept-autosuggestion execute

    bind -M insert \cc "commandline -f cancel && commandline '' && commandline -f repaint"
    bind -M default -m insert \cc "commandline -f cancel && commandline '' && commandline -f repaint"

    # conclicts with binding for `__fish_man_page` (open man page for word at cursor)
    bind -M default \eh "history_copy; commandline -f repaint"
    bind -M insert \eh "history_copy; commandline -f repaint"

    bind -M default \ek fzf_kill
    bind -M insert \ek fzf_kill

    bind -M default \eg fzf_git_log_copy
    bind -M insert \eg fzf_git_log_copy

    bind -M default \eb "cd_hist; commandline -f repaint"
    bind -M insert \eb "cd_hist; commandline -f repaint"

    bind -M default \em "mpc_songs; commandline -f repaint"
    bind -M insert \em "mpc_songs; commandline -f repaint"
end
set -g fish_key_bindings hybrid_bindings

function fish_greeting
    if test -z "$TMUX" || test (tmux display-message -p '#{session_id}#{window_index}#{pane_index}') = '$000'
        set -l FILE (dirname (status --current-filename))/greeting.md
        test -e $FILE && bat -p $FILE
    end
end

function rg
    # if it's in a tty (not piped,...), use --pretty and a pager
    if isatty 1
        command rg -Sp $argv | less -XFR
    else
        command rg -S $argv
    end
end

function tldr
    # tealdeer needs `--color`
    command tldr $argv --color always | less -XFR
end

function cht
    curl "https://cht.sh/$argv" --no-progress-meter | less -XFR
end

# always start agent (one time, without running it multiple times)???
function start_ssh_agent
    eval (ssh-agent -c)
    ssh-add -k ~/.ssh/id_rsa
end

function myip
    dig myip.opendns.com @resolver1.opendns.com a +short -4
    dig myip.opendns.com @resolver1.opendns.com aaaa +short -6
end

function weather
    curl "https://wttr.in/$argv"
end

function bak
    for file in $argv
        set -l f (string trim --right --chars='/' $file)
        mv --interactive --verbose "$f"{,.bak}
    end
end

function unbak
    for file in $argv
        set -l f (string trim --right --chars='/' $file)
        set -l file_parts (string split --right --max=1 . $f)

        if test "$file_parts[2]" = "bak"
            mv --interactive --verbose "$file_parts[1]"{.bak,}
        end
    end
end

function fzf_kill
    # args statt comm -> full command
    set -l process (ps -eo pid,euser,%cpu,etime,comm --sort -pid --no-headers | fzf --height 40%)
    if test -n "$process"
        set -l pid (echo $process | awk '{print $1}')
        set -l comm (echo $process | awk '{print $5}')
        commandline -r " kill -9 $pid #$comm" # space before the command -> will not be added to the history
    end
    commandline -f repaint
end

function fzf_git_log_copy
    set -l git_dir (git rev-parse --is-inside-work-tree 2>/dev/null)
    if test "$git_dir" != 'true'
        return
    end

    set -l sel (git log --pretty=format:'%h - %s (%cr) <%an>' | fzf --no-sort --height 40% --expect=alt-m,alt-a)
    if test -n "$sel"
        set -l hash (echo "$sel[2]" | awk '{print $1}')
        set -l res ''

        switch "$sel[1]"
        case "alt-m"
            set res (git show -s --format=%s "$hash")
        case "alt-a"
            set res "$sel[2]"
        case '*'
            set res "$hash"
        end

        echo -n $res | c
    end
    commandline -f repaint
end

if status is-interactive
    # https://github.com/Jomik/fish-gruvbox
    # issue with fzf.vim: https://github.com/Jomik/fish-gruvbox/issues/2
    theme_gruvbox dark medium

    # see https://github.com/tomyun/base16-fish/blob/master/functions/base16-gruvbox-dark-medium.fish#L99
    set -g fish_color_autosuggestion 504945
    set -g fish_color_cancel -r
    set -g fish_color_command green #white
    set -g fish_color_comment 504945
    set -g fish_color_cwd green
    set -g fish_color_cwd_root red
    set -g fish_color_end brblack #blue
    set -g fish_color_error red
    set -g fish_color_escape yellow #green
    set -g fish_color_history_current --bold
    set -g fish_color_host normal
    set -g fish_color_match --background=brblue
    set -g fish_color_normal normal
    set -g fish_color_operator blue #green
    set -g fish_color_param bdae93
    set -g fish_color_quote yellow #brblack
    set -g fish_color_redirection cyan
    set -g fish_color_search_match bryellow --background=504945
    set -g fish_color_selection white --bold --background=504945
    set -g fish_color_status red
    set -g fish_color_user brgreen
    set -g fish_color_valid_path --underline
    set -g fish_pager_color_completion normal
    set -g fish_pager_color_description yellow --dim
    set -g fish_pager_color_prefix white --bold #--underline
    set -g fish_pager_color_progress brwhite --background=cyan
end

starship init fish | source

# Start graphical environment at login on vtnr 1
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty # see .xinitrc
        # exec startplasma-wayland
        # exec sway
    end
end
