# .bashrc

source ~/.sh_aliases

if `which brew &> /dev/null` && [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# the up and down arrows and function keys weren't working in screen only on MAC
export TERM=linux
export PUPPET_ENABLE_ASSERTIONS=true

# Keep more history
export HISTSIZE=1000000
export HISTFILESIZE=1000000

# Use vim key bindings
# Not liking this.  Might take some getting used to...
# set -o vi
# set -o emacs

# enable bash completion in interactive shells
# Source global definitions and alias definitions.
# source user specific definitions
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f ~/.sh_shared ]; then
    . ~/.sh_shared
fi

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f ~/.bash_specific_to_local ]; then
    . ~/.bash_specific_to_local
fi

if [ -f ~/.shrc ]; then
    . ~/.shrc
fi

export RLWRAP_HOME="${HOME}/.rlwrap_home"

# Needed for edit to work in sqlplus
export EDITOR=`which vim`

# color yellow time color lightblue user@host : path (git branch) end color
P_TIME="\@"
P_COLOR1="\[\e[32;1m\]"
P_END_COLOR="\[\e[0m\]"
P_COLOR2="\[\e[36;1m\]"
P_USER="\u@\H"
P_PATH="\w"

if [ -f /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash ]; then
    . /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
fi
source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
GITBRANCH=`if which git &> /dev/null; then echo '$(__git_ps1 "(%s)")'; else echo ''; fi`
PS1="$P_COLOR1  $P_TIME $P_COLOR2 $P_USER : $P_PATH $GITBRANCH\n >$P_END_COLOR"
umask 022

# Rentrak specific settings
# export CVSROOT=:ext:cvsuser@rtkcvs:/cvs_repositories/corp_dev
export CVS_RSH=ssh
export SERVER_PORT=8080
export COLOR_TESTS=1
export DIFF_COLOR_DO_HORIZONTAL=1
export CAG_RSH=ssh
export TEST_FLUSH="but_of_course"

export PSQL_EDITOR='vim -c "set ft=sql"'

# git
#if [ -f ~/.git-completion.sh ]; then
#    source ~/.git-completion.sh # command line completion for git if the system doesn't already have it installed
#    complete -o default -o nospace -F _git_checkout gco # so that autocomplete works with gco alias
#fi
#GIT_PS1_SHOWDIRTYSTATE=1 # puts + and * to show the state of files in branch but is slow when changing to directory

export SQLPATH=$HOME/sql
unset USERNAME

function bgh ()
{
    history | grep "$1" | perl -pwe 's/^.{6}//;' | sort -u | tail -50
}

function cdtt ()
{
    `pwd` =~ '(.*/(work|bonobos))/.*'
    cd ${BASH_REMATCH[1]}
}

complete -C ~/.completion/brew_completion.rb -o default brew
#complete -C ~/.completion/puppet_completion.rb -o default puppet

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
