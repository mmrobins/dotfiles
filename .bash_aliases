#alias sqlplus='env -u NLS_LANG sqlplus'
alias ls="ls -FC --color"
alias rm="rm -i"

# Rentrak specific
alias edev2="ssh edev2 "
alias db='rlwrap -i --remember rtk_database_login.pl'
alias dbl='rtk_database_login.pl --list'
alias retaildev='db -s retail -d'
alias retaillive='db -s retail -l'
alias hvedev='db -s hve -d'
alias hvelive='db -s hve -l'
alias comdev='db -s common -d'
alias comlive='db -s common -l'
alias cvsstat='cvs status |grep Status: Local'
alias rtk_console='perl -d ~/debugger_console.pl'

alias         ..='cd ..'
alias        ...='cd ../..'
alias       ....='cd ../../..'
alias      .....='cd ../../../..'
alias     ......='cd ../../../../..'
alias    .......='cd ../../../../../..'
alias   ........='cd ../../../../../../..'
alias  .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'

