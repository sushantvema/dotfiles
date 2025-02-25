#
# ~/.bashrc

# Set to superior editing mode
set -o vi

# keybinds
bind -x '"\C-l":clear'
# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~

export VISUAL=nvim
export EDITOR=nvim
export v=nvim

# config
export BROWSER="safari"

# directories
export REPOS="$HOME/Repos"
export GITUSER="sushantvema"
export GHREPOS="$REPOS/github.com/$GITUSER"
export DOTFILES="$HOME/dotfiles"
export SCRIPTS="$DOTFILES/scripts"
export ICLOUD="$HOME/icloud"
export SECOND_BRAIN="$HOME/quartz/content"

# projects
export SAND="$GHREPOS"/"sandmining"

# Go related. In general all executables and scripts go in .local/bin
# export GOBIN="$HOME/.local/bin"
# export GOPRIVATE="github.com/$GITUSER/*,gitlab.com/$GITUSER/*"
# export GOPATH="$HOME/.local/share/go"
# export GOPATH="$HOME/go/"

# dotnet
# export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"

# ~~~~~~~~~~~~~~~ Path configuration ~~~~~~~~~~~~~~~~~~~~~~~~
# function from Arch Wiki, to prevent adding directories multiple times

# set_path(){
#
#     # Check if user id is 1000 or higher
#     [ "$(id -u)" -ge 1000 ] || return
#
#     for i in "$@";
#     do
#         # Check if the directory exists
#         [ -d "$i" ] || continue
#
#         # Check if it is not already in your $PATH.
#         echo "$PATH" | grep -Eq "(^|:)$i(:|$)" && continue
#
#         # Then append it to $PATH and export it
#         export PATH="${PATH}:$i"
#     done
# }
#
# set_path "$HOME"/git/lab/bash "$HOME"/.local/bin

# https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path
# PATH="${PATH:+${PATH}:}~/opt/bin"   # appending
# PATH="~/opt/bin${PATH:+:${PATH}}"   # prepending

# Commands also provided by macOS and the commands dir, dircolors, vdir have been installed with the prefix "g".
# If you need to use these commands with their normal names, you can add a "gnubin" directory to your PATH with:
#  PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# PATH="${PATH:+${PATH}:}"$SCRIPTS":/opt/homebrew/opt/dotnet@6/bin:/opt/homebrew/opt/dotnet/bin:"$HOME"/.local/bin:"$HOME"/.dotnet/tools" # appending

# export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# ~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~

export HISTFILE=~/.histfile
export HISTSIZE=25000
export SAVEHIST=25000
export HISTCONTROL=ignorespace

# ~~~~~~~~~~~~~~~ Functions ~~~~~~~~~~~~~~~~~~~~~~~~

# This function is stolen from rwxrob

clone() {
  local repo="$1" user
  local repo="${repo#https://github.com/}"
  local repo="${repo#git@github.com:}"
  if [[ $repo =~ / ]]; then
    user="${repo%%/*}"
  else
    user="$GITUSER"
    [[ -z "$user" ]] && user="$USER"
  fi
  local name="${repo##*/}"
  local userd="$REPOS/github.com/$user"
  local path="$userd/$name"
  [[ -d "$path" ]] && cd "$path" && return
  mkdir -p "$userd"
  cd "$userd"
  echo gh repo clone "$user/$name" -- --recurse-submodule
  gh repo clone "$user/$name" -- --recurse-submodule
  cd "$name"
} && export -f clone

# ~~~~~~~~~~~~~~~ SSH ~~~~~~~~~~~~~~~~~~~~~~~~
# SSH Script from arch wiki

# if ! pgrep -u "$USER" ssh-agent >/dev/null; then
# 	ssh-agent >"$XDG_RUNTIME_DIR/ssh-agent.env"
# fi
# if [[ ! "$SSH_AUTH_SOCK" ]]; then
# 	source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
# fi

# ~~~~~~~~~~~~~~~ Prompt ~~~~~~~~~~~~~~~~~~~~~~~~

# Moved to starship 20-03-2024 for all my prompt needs.

eval "$(starship init bash)"

# ~~~~~~~~~~~~~~~ Tmux ~~~~~~~~~~~~~~~~~~~~~~~~~~
alias att="tmux a -t"
alias panedown="tmux resize-pane -D 15"
alias paneup="tmux resize-pane -U 15"
# Move a newly-created window to a certain index.
ins-move() {
  for ((i = $1; i < $2 - 1; i++)); do
    tmux swap-window -s :$i -t :$((i + 1))
  done
}

# ~~~~~~~~~~~~~~~ Taskwarrior aliases ~~~~~~~~~~~~~~~~~~~~~~~~~~
alias tps="task project:sandmining"
alias tpl="task project:LifeOS"

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~

alias v=nvim
alias pip=pip3
alias python=python3
alias lg=lazygit

# cd
alias sv='cd $REPOS/github.com/sushantvema/'
alias sand='cd $SAND'
alias ..="cd .."
alias scripts='cd $SCRIPTS'
alias dot='cd $GHREPOS/dotfiles'
alias repos='cd $REPOS'
alias rwdot='cd $REPOS/github.com/sushantvema/dotfiles'
alias c="clear"
alias icloud="cd \$ICLOUD"

# ls
alias ls='ls --color=auto'
alias ll='ls -la'
# alias la='exa -laghm@ --all --icons --git --color=always'
alias la='ls -lathr'

# finds all files recursively and sorts by last modification, ignore hidden files
alias last='find . -type f -not -path "*/\.*" -exec ls -lrt {} +'

alias t='tmux'
alias e='exit'

# git
alias gp='git pull'
alias gs='git status'
alias lg='lazygit'

# python virtual environments
alias ve='python -m venv ./venv'
alias vir='pip install -r requirements.txt'
alias dotsync='rsync -a dotfiles/ ~/.config/'

# ricing
alias ebrc='v ~/.bashrc'
alias sbrc='source ~/.bashrc'
alias svba='source .venv/bin/activate'
alias task='clear && /usr/local/bin/task'

# vim & second brain
alias sb="cd \$SECOND_BRAIN"
alias in="cd \$SECOND_BRAIN/0 Inbox/"

# useful scripts for zettelkasten
alias day="bash \$SCRIPTS/day"
alias zet="bash \$SCRIPTS/zet"

# fzf aliases
# use fp to do a fzf search and preview the files
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
# search for a file with fzf and open it in vim
alias vf='v $(fp)'

# taskell aliases
alias school="taskell $DOTFILES/school.md"
alias work="taskell $DOTFILES/work.md"
alias dev="taskell $DOTFILES/ide.md"
alias personal="taskell $DOTFILES/personal.md"

# goread alias to update config
alias goread-update="cat dotfiles/goread/urls.yml > ~/Library/Application\ Support/goread/urls.yml"

# sourcing
# source "$HOME/.privaterc"

# if [[ "$OSTYPE" == "darwin"* ]]; then
# 	source "$HOME/.fzf.bash"
# 	# echo "I'm on Mac!"
#
# 	# brew bash completion
# 	[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
# else
# 	#	source /usr/share/fzf/key-bindings.bash
# 	#	source /usr/share/fzf/completion.bash
# 	[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
# export PATH="/Users/mischa/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Only needed for npm install on WSL
# export NVM_DIR="$HOME/.config/nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(zoxide init bash)"
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

export IS_BASH_INIT="TRUE"
