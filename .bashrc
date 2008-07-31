# .bashrc

# User specific aliases and functions

# Source global definitionslias definitions.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
export CVSROOT=:ext:cvsuser@rtkcvs:/cvs_repositories/corp_dev
#source ~/.bashrc_sources/cvswork.sh   # first
export CVSWORK="${HOME}/work/current/perl_lib"
export CVS_BASE_DIR="${HOME}/work/current"
export CVS_RSH=ssh
export SERVER_PORT=8080

export COLOR_TESTS=1
export DIFF_COLOR_DO_HORIZONTAL=1
export EDITOR='/usr/bin/vim'
export RLWRAP_HOME="${HOME}/.rlwrap_home"

if [ "$PS1" ]; then

    #eval `dircolors`
    LS_COLORS='';
    export LS_COLORS

    case $TERM in
    xterm*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
    rxvt*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
    *)
        ;;
    esac
    #export PS1="\n\u@\h:\w\n$ "
    export PS1="\n[$?:\h:\w]\n$ "
    export PS2='> '
fi
if [ "$PS1" ]
then
    cpc=$PROMPT_COLOR
    xt='\[\e]0;\H (\u) \w\a\]'
    export PS1=$C7'      \@  \u'$C16'@'$cpc'\H'$C16':'$C10'\w'$cpc'\n'$C16$EMOTICON_COLOR$EMOTICON$C16"  ; "$P
    case $TERM in xterm*) export PS1=$xt$PS1 ;; esac
    unset xt cpc
fi

umask 0002
alias         ..='cd ..'
alias        ...='cd ../..'
alias       ....='cd ../../..'
alias      .....='cd ../../../..'
alias     ......='cd ../../../../..'
alias    .......='cd ../../../../../..'
alias   ........='cd ../../../../../../..'
alias  .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'

