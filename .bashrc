# .bashrc

# User specific aliases and functions

# Source global definitionslias definitions.
# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Rentrak specific settings
export CVSROOT=:ext:cvsuser@rtkcvs:/cvs_repositories/corp_dev
#source ~/.bashrc_sources/cvswork.sh   # first
export CVSWORK="${HOME}/work/current/perl_lib"
export CVS_BASE_DIR="${HOME}/work/current"
export CVS_RSH=ssh
export SERVER_PORT=8080
export COLOR_TESTS=1
export DIFF_COLOR_DO_HORIZONTAL=1
export RLWRAP_HOME="${HOME}/.rlwrap_home"

# Needed for edit to work in sqlplus
export EDITOR=`which vim`

# color yellow time color lightblue user@host : path end color
P_TIME="\@"
P_COLOR1="\[\e[32;1m\]"
P_END_COLOR="\[\e[0m\]"
P_COLOR2="\[\e[36;1m\]"
P_USER="\u@\H"
P_PATH="\w"
PS1="$P_COLOR1  $P_TIME $P_COLOR2 $P_USER : $P_PATH\n >$P_END_COLOR"
umask 0002

