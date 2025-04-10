# setting fish as default shell: `chsh -s /usr/bin/fish`

# only run tmux in foot and if tmux is not yet running
if status is-interactive && test $TERM = foot && not tmux info &>/dev/null
    exec tmux new -As0
end

# rename first window of first session
if test -n "$TMUX" && test (tmux display-message -p '#{session_id}#{window_index}#{pane_index}') = '$000'
    tmux rename-window chaos
end

set -x GOPATH $HOME/dev/go
fish_add_path -g $HOME/bin $HOME/.local/bin $GOPATH $GOPATH/bin $HOME/.cargo/bin $HOME/.npm-packages/bin

set -g fish_greeting # remove greeting
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER less
set -x MANPAGER "nvim +Man!"
set -x DIFFPROG "nvim -d"
set -x LESS --ignore-case

set -x DOTNET_CLI_TELEMETRY_OPTOUT 1

# https://github.com/0rax/fish-bd
set -x BD_OPT insensitive

# https://github.com/junegunn/fzf
set -x FZF_DEFAULT_OPTS '--color=bg+:#3c3836,bg:-1,spinner:#fb4934,hl:#928374,fg:-1,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git/'
set -x FZF_CTRL_T_COMMAND 'fd --type f --type d --hidden --exclude .git/ . $dir'
set -x FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git/ . $dir'

# https://github.com/sharkdp/bat
set -x BAT_THEME gruvbox-dark

set -x LS_COLORS "$(vivid generate gruvbox-dark)"
set -x EZA_COLORS "uu=90:gu=90:uR=33:gR=33:un=33:gn=33:da=90" # man eza_colors

alias ls='eza --group-directories-first --time-style=long-iso --icons=auto'
alias ll='ls -l'
alias la='ls -la'
alias lt='ls -lT'
alias wtf='wtf -o'
alias o='open 2> /dev/null'
alias n=nvim
alias nup='nvim -c "lua require(\'lazy\').sync({wait = true})"'
alias nn='nvim +Notes'
alias nng='nvim +NotesGrep'
alias c='wl-copy --trim-newline'
alias p='wl-paste --no-newline'
alias pwdc='pwd | head -c -1 | c'
alias se=sudoedit
alias ip='ip --color=auto'
alias gnutime='command time -p'
alias cal='cal -mw'
alias ncmpcpp='ncmpcpp --quiet'
alias qr='qrencode -t ANSIUTF8 -o -'
alias cd_hist='echo $dirprev | tr \' \' \'\n\' | fzf --tac --no-sort --height 20% | read -l x && cd "$x"'
alias mpc_songs='mpc playlist -f \'%position%\t[[%artist% - ][%album% - ]%title%|%file%]\' | fzf --height 40% | awk \'{print $1}\' | read -l x && mpc play "$x"'
#alias stopwatch='command time --format="%E" fish -c \'function fish_mode_prompt ; end ; read --prompt-str="..."\''
alias stopwatch='command time --format="%E" bash -c \'read -p "..."\'' # faster than fish (see above)
alias img='chafa --format sixel'
alias bell="printf '\a'"

# aliases to review git commits
alias rvw-log='FZF_DEFAULT_COMMAND="git lg" fzf --ansi --no-sort --select-1 --exit-0 --height 40% | awk \'{print $1}\' | read -l x && git show --patch-with-stat "$x"'
alias rvw-branch='fzf_git_review'

set FZF_CTRL_R_COPY '--bind=\'ctrl-y:execute-silent(echo -n {} | perl -pe "s/^\d*\t//" | fish_clipboard_copy)+cancel\''
set FZF_CTRL_R_DELETE '--bind=\'ctrl-x:execute-silent(echo -n {} | perl -pe "s/^\d*\t//" | history delete --exact --case-sensitive)+cancel\''
set -x FZF_CTRL_R_OPTS "$FZF_CTRL_R_COPY $FZF_CTRL_R_DELETE"

function key_bindings
    # use `fish_key_reader -c` or `showkey -a` to get keys

    fish_default_key_bindings
    fzf_key_bindings

    bind alt-enter accept-autosuggestion execute
    bind alt-k fzf_kill
    bind alt-g fzf_git_log_copy
    bind alt-f fzf_git_files
    bind alt-b fzf_git_branches
    bind alt-z "cd_hist; commandline -f repaint"
    bind alt-m "mpc_songs; commandline -f repaint"
end
set -g fish_key_bindings key_bindings

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
        set --erase --global --universal SSH_AUTH_SOCK
        set --erase --global --universal SSH_AGENT_PID
    end
end
erase_ssh_agent_vars

# always start agent (one time, without running it multiple times)???
function start_ssh_agent
    if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c)

        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID

        grep -slR PRIVATE ~/.ssh/ | xargs ssh-add
    end
end

function ip-public
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

        if test "$file_parts[2]" = bak
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
    if test "$git_dir" != true
        return
    end

    set -l sel (git log --pretty=format:'%h - %s (%cI) <%an>' | fzf --no-sort --height 40% --expect=alt-m,alt-a)
    if test -n "$sel"
        set -l hash (echo "$sel[2]" | awk '{print $1}')
        set -l res ''

        switch "$sel[1]"
            case alt-m
                set res (git show -s --format=%s "$hash")
            case alt-a
                set res "$sel[2]"
            case '*'
                set res "$hash"
        end

        echo -n $res | c
    end
    commandline -f repaint
end

function fzf_git_files
    # -> filenames with whitespaces don't work
    set -l files (git -c color.status=false status --short | awk '{print $2}' | fzf --multi --height 40%)
    if test -n "$files"
        for file in $files
            commandline -it -- (string escape $file)
            commandline -it -- ' '
        end
    end
    commandline -f repaint
end

function fzf_git_branches
    set -l branches (git branch --format='%(refname:short)' | fzf --multi --height 40%)
    if test -n "$branches"
        for branch in $branches
            commandline -it -- (string escape $branch)
            commandline -it -- ' '
        end
    end
    commandline -f repaint
end

function fzf_git_review
    set -l branch $argv
    test -z "$argv" && set -l branch develop
    git lg "$branch".. | rvw-log
end

if status is-interactive
    theme_gruvbox
    set -g hydro_multiline true
    set -g hydro_symbol_start "\n"

    set -g hydro_symbol_git_dirty " •"
    set -g hydro_symbol_git_ahead "↑ "
    set -g hydro_symbol_git_behind "↓ "

    set -g hydro_color_pwd brblue
    set -g hydro_color_prompt brpurple

    zoxide init fish | source
end

# Start graphical environment at login on vtnr 1
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec /usr/lib/plasma-dbus-run-session-if-needed /usr/bin/startplasma-wayland
    end
end
