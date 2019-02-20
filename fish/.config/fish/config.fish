# first setting env vars
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH $GOPATH/bin $HOME/bin $HOME/.yarn/bin
set -x EDITOR nvim
set -x VISUAL nvim

# automatically start tmux, if shell is interactive and tmux is not started yet
if status is-interactive
    if not set -q TMUX
        exec tmux
    end

    # when this is reached, tmux is started -> rename first window
    if test (tmux display-message -p '#I') = '0'
        tmux rename-window chaos
    end
end

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

alias ag='ag -S --pager="less -XFR"'
alias a=atom
alias o=open
alias n=nvim
alias c='xsel -b'
alias pwdc='pwd | head -c -1 | c'
alias se=sudoedit
alias time='time -p'

function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
    fish_hybrid_key_bindings
    bind -M insert \cn accept-autosuggestion execute
    bind -M insert \cc kill-whole-line force-repaint
    bind -M default -m insert \cc kill-whole-line force-repaint
end
set -g fish_key_bindings hybrid_bindings

function fish_greeting
    echo 'f8 + f9/f10 + z + unimpaired [space, [b, [e' \n
end

function ls
    #command ls -hF --color=auto --group-directories-first $argv
    exa --group-directories-first $argv
end

function ll
  ls -l $argv
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
    command tldr --color $argv | less -XFR
end

function oni
    command oni $argv &
end

function start_ssh_agent
    eval (ssh-agent -c)
    ssh-add -k ~/.ssh/id_rsa
end

function weather
  curl "wttr.in/$argv"
end

# 2018-12-11: overwrite fish_DEFAULT_mode_prompt, because it's used by pure prompt
# function fish_mode_prompt --description 'Displays the current mode'
function fish_default_mode_prompt --description 'Displays the current mode'
  # Do nothing if not in vi mode
  if test "$fish_key_bindings" = "fish_hybrid_key_bindings"
    switch $fish_bind_mode
      case default
        set_color --bold red
      case insert
        set_color --bold green
      case replace-one
        set_color --bold yellow
      case visual
        set_color --bold magenta
    end
  echo ' …'
  set_color normal
  end
end

set pure_command_max_exec_time 3
