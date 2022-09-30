# setting fish as default shell: `chsh -s /usr/bin/fish`

# only run tmux in alacritty and if tmux is not yet running
if status is-interactive && test $TERM = 'alacritty' -o $TERM = 'xterm-kitty' -o $TERM = 'foot' && not tmux info &> /dev/null
    exec tmux new -As0
end

# rename first window of first session
if test -n "$TMUX" && test (tmux display-message -p '#{session_id}#{window_index}#{pane_index}') = '$000'
    tmux rename-window chaos
end

# TODO: remove, once fish 3.2 (with `fish_add_path`) is used "everywhere"
function append_path
    for path in $argv
        contains $path $PATH || set -xa PATH $path
    end
end

set -x GOPATH $HOME/dev/go

if type -q fish_add_path
    fish_add_path -g $HOME/bin $GOPATH $GOPATH/bin $HOME/.cargo/bin $HOME/.npm-packages/bin
else
    append_path $HOME/bin $GOPATH $GOPATH/bin $HOME/.cargo/bin $HOME/.npm-packages/bin
end

set -x EDITOR nvim
set -x VISUAL nvim
set -x MANPAGER "nvim +Man!"
set -x DIFFPROG "nvim -d"
set -x LESS '--ignore-case'

set -x MOZ_ENABLE_WAYLAND 1
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1

# https://github.com/0rax/fish-bd
set -x BD_OPT 'insensitive'

# https://github.com/junegunn/fzf
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git/'
set -x FZF_CTRL_T_COMMAND 'fd --type f --type d --hidden --exclude .git/ . $dir'
set -x FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git/ . $dir'

# https://github.com/sharkdp/bat
set -x BAT_THEME 'gruvbox-dark'

alias ls='exa --group-directories-first --time-style=long-iso'
alias ll='ls -l'
alias la='ls -la'
alias lt='ls -lT'
alias wtf='wtf -o'
alias o=wsl-open
alias n=nvim
alias nup='nvim +PackerSync'
alias nn='nvim +Notes'
alias nng='nvim +NotesGrep'
alias c='wl-copy --trim-newline'
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
#alias stopwatch='command time --format="%E" fish -c \'function fish_mode_prompt ; end ; read --prompt-str="..."\''
alias stopwatch='command time --format="%E" bash -c \'read -p "..."\'' # faster than fish (see above)

# aliases to review git commits
alias rvw-log='FZF_DEFAULT_COMMAND="git lg" fzf --ansi --no-sort --select-1 --exit-0 --height 40% | awk \'{print $1}\' | read -l x && git show --patch-with-stat "$x"'
alias rvw-branch='fzf_git_review'

function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
    # use `fish_key_reader -c` or `showkey -a` to get keys

    fish_hybrid_key_bindings
    fzf_key_bindings

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

    bind -M default \eb fzf_git_branches
    bind -M insert \eb fzf_git_branches

    bind -M default \ez "cd_hist; commandline -f repaint"
    bind -M insert \ez "cd_hist; commandline -f repaint"

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

function erase_ssh_agent_vars
    # workaround, see:
    # * https://github.com/fish-shell/fish-shell/issues/5258
    # * https://github.com/fish-shell/fish-shell/issues/5258#issuecomment-439568175
    #
    # because this happens in tmux if ssh var is Ux
    # ~> set -Ux foo foo
    # ~> exec fish
    # ~> set -Ux foo bar
    # ~> echo $foo
    # foo
    #
    # another workaround:
    # https://github.com/fish-shell/fish-shell/issues/5258#issuecomment-433160282

    if test -z (pgrep ssh-agent | string collect)
        set --erase --global SSH_AUTH_SOCK
        set --erase --universal SSH_AUTH_SOCK
        set --erase --global SSH_AGENT_PID
        set --erase --universal SSH_AGENT_PID
    end
end
erase_ssh_agent_vars

# always start agent (one time, without running it multiple times)???
function start_ssh_agent
    if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c)

        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID

        grep -slR "PRIVATE" ~/.ssh/ | xargs ssh-add
    end
 end

function ip-public
    dig myip.opendns.com @resolver1.opendns.com a +short -4
    dig myip.opendns.com @resolver1.opendns.com aaaa +short -6
end

function weather
    curl "https://v2.wttr.in/$argv"
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

function diff
    if isatty 1
        command diff -u --color=always $argv | diff-so-fancy | less --tabs=4 -XFR
    else
        command diff $argv
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

function fzf_git_branches
    set -l branch (git branch --format='%(refname:short)' | fzf --height 40%)
    if test -n "$branch"
        commandline -i $branch
    end
    commandline -f repaint
end

function fzf_git_review
    set -l branch $argv
    test -z "$argv" && set -l branch 'develop'
    git lg "$branch".. | rvw-log
end

if status is-interactive
    theme_gruvbox

    if command -s starship > /dev/null
        starship init fish | source
    end
end

# Start graphical environment at login on vtnr 1
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startplasma-wayland
        # exec sway
    end
end
