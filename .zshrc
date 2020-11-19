source ~/.shrc
# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# Completion
unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

WORDCHARS=''

autoload -U compinit
compinit -i

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history
bindkey \^U backward-kill-line

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# Load known hosts file for auto-completion with ssh and scp commands
if [ -f ~/.ssh/known_hosts ]; then
  zstyle ':completion:*' hosts $( sed 's/[, ].*$//' $HOME/.ssh/known_hosts )
  zstyle ':completion:*:*:(ssh|scp):*:*' hosts `sed 's/^\([^ ,]*\).*$/\1/' ~/.ssh/known_hosts`
fi

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

source ~/.sh_aliases

if [ -f ~/.sh_work_aliases ]; then
  source ~/.sh_work_aliases
fi

if [ -f ~/.sh_work_env ]; then
  source ~/.sh_work_env
fi

## Command history configuration
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt hist_ignore_dups # ignore duplication command history list

setopt hist_verify
#setopt share_history # share command history data # use fc -IR to share. exclusive from inc_append_history_time
setopt inc_append_history_time
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space

# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function ruby_version()
{
    if which rbenv &> /dev/null; then
      rbenv version | sed -e "s/ (set.*$//"
    fi
}
# parse_git_dirty () {
#   if [[ -n $(git status -s 2> /dev/null) ]]; then
#     echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
#   else
#     echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
#   fi
# }

# Setup the prompt with pretty colors
setopt prompt_subst
# ls colors
autoload colors; colors;
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# PROMPT PS1
local red_op="%{$fg[red]%}[%{$reset_color%}"
local red_cp="%{$fg[red]%}]%{$reset_color%}"
local path_p="${red_op}%{$fg[green]%}%~${red_cp}"
local user_host="${red_op}%{$fg[cyan]%}%n@%m${red_cp}"
local date_time="${red_op}%{$fg[green]%}%D{%Y%m%d} - %*${red_cp}"
PROMPT='╭─${path_p}─${user_host}─${date_time}-$(git_prompt_info)-$(ruby_version)
╰─ [%?]%# '
local cur_cmd="${red_op}%_${red_cp}"
PROMPT2="${cur_cmd}> "
# git theming default: Variables for theming the git info prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"              # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=""               # Text to display if the branch is clean

# Setup the prompt with pretty colors
setopt prompt_subst

# helper for writing my own completions
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# setting EDITOR to vim causes zsh to auto set keybindings on command line to vim style
# i DONT like vim style on the command line so set command line back to emacs style
bindkey -e

fpath=(/usr/local/share/zsh-completions $fpath)
fpath=($HOME/config-files/zsh-completion $fpath)

#PARENTCOMMAND=$(ps -p $(ps -p ${1:-$$} -o ppid=) -o command=)
#if [[ $PARENTCOMMAND != *ttyrec* ]]; then
#  TTYRECFILE=~/.ttyrec/`date +"%Y%m%d_%H_%M_%S"`
#  echo "Recording at $TTYRECFILE"
#  ttyrec $TTYRECFILE
#  echo "Done with $TTYRECFILE"
#fi
#
#alias ttylast=ttyplay ~/.ttyrec/$(ls -1tr ~/.ttyrec | tail -1)

#PARENTCOMMAND=$(ps -p $(ps -p ${1:-$$} -o ppid=) -o command=)
#if [[ -z $TTYREC_ACTIVE  ]]; then
#  export TTYREC_ACTIVE=1
#  TTYRECFILE=~/.ttyrec/`date +"%Y%m%d_%H_%M_%S"`
#  echo "Recording at $TTYRECFILE"
#  # If I exec I don't need 2 exits...
#  ttyrec $TTYRECFILE
#  # but if I don't exec I can run stuff after it's done
#  # like maybe compress and encrypt
#  echo "Done with $TTYRECFILE"
#fi

# so that rake arguments work http://robots.thoughtbot.com/how-to-use-arguments-in-a-rake-task
unsetopt nomatch

# Report CPU usage for commands running longer than 10 seconds
export REPORTTIME=10
#source /usr/local/share/zsh/site-functions/_aws
source $HOME/config-files/per-directory-history.zsh

# only really useful on linux
if type keychain > /dev/null 2>&1; then
  eval `keychain --eval id_rsa`
fi

# https://superuser.com/questions/847838/zsh-backward-delete-word-does-not-recognize-character
# change characters considered when moving forward and back words
local WORDCHARS='*?_[]~=&;!#$%^(){}<>.'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true
