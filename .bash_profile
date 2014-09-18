dir=$(dirname ~/$(readlink ~/.bash_profile))

# History
shopt -s histappend
shopt -s cmdhist
HISTSIZE=500000
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth"
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"
HISTTIMEFORMAT='%F %T '

# Python
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PYTHONDONTWRITEBYTECODE=1

# Misc
export PS1="\\n\\w\\n\\$ "
export PATH=/usr/local/bin:~/Executables:$PATH
export PROMPT_COMMAND='update_terminal_cwd; history -a; echo -ne "\033]0; ${PWD##*/}\007"'
export EDITOR=nvim
export VISUAL=nvim

# Aliases
alias m="./manage.py"
alias r=". ~/.bash_profile"
alias dog="pygmentize -g"
alias gs="git status -sb"
alias gd="git diff"
alias gl="git log"
alias glg="git log --oneline --graph --decorate"
alias glgl="git log --graph --decorate"
alias ga="git add"
alias gb="git branch"
alias gcm="git checkout master"
alias gcb="git checkout -b"
alias gc-="git checkout -"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gpfo="git pull --ff-only"
alias grom="git rebase origin/master"
alias gpoh="git push origin HEAD"

cov() {
    coverage run manage.py test --with-progressive $1
    coverage html --include="apps/$1/*"
}

# Readline Bindings
bind '"\C-xa":alias-expand-line'

# Git Completion
. ~/Projects/dotfiles/git-completion.bash

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


if [[ -a ~/.bash_profile.local ]]
then
    source ~/.bash_profile.local
fi
