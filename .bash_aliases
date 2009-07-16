#alias sqlplus='env -u NLS_LANG sqlplus'
alias ls="ls -FC --color"
alias lt="ls -ltr"
alias ll="ls -l"
alias rm="rm -i"
alias splitmp3="mp3splt -a -t 5.0 -d split_files -o @n_@f"
alias ack="ack-grep --ignore-dir data --ignore-dir images"


# Version Control
alias sdl="if [ -d .svn ]; then svn_diff_less; else git diff trunk --no-prefix | diff_painter.pl | less -R; fi"
alias sst="if [ -d .svn ]; then svn status; else git diff trunk --name-status; fi"
alias gdl="git diff";
alias gst="git status";

# Git
alias gco="git checkout"

# Show most used commands that might be good candidates for aliases
alias mu='history | cut -d " " -f3 | sort | uniq -c | sort -nr | head -50'

# Compress the cd, ls -l series of commands.
alias lc="cl"
function cl () {
   if [ $# = 0 ]; then
      cd && ll
   else
      cd "$*" && ll
   fi
}
# Rentrak specific
alias edev2="ssh edev2 "
alias db='rlwrap --remember rtk_database_login.pl'
alias dbl='rtk_database_login.pl --list'
alias buall='/home/msw/bin/bu `slnu`'
alias testhere='dt=`date +%y%m%d_%H_%M`; proj=`pwd | sed "s/.*RTK\///"`; rtk_appropriate_perl_for_directory -S rtk_test -thc > ${proj}_test_output_$dt &'

alias retailtest='db -s retail -t'
alias retaildev='db -s retail -d'
alias retaillive='db -s retail -l'
alias hvetest='db -s hve -t'
alias hvedev='db -s hve -d'
alias hvelive='db -s hve -l'
alias comdev='db -s common -d'
alias comlive='db -s common -l'
#alias addev='rtk_database_login.pl -s ad_monitor -d'
#alias adlive='rtk_database_login.pl -s ad_monitor -l'
#alias adtest='rtk_database_login.pl -s ad_monitor -t'
alias addev='db -s ad_monitor -d'
alias adlive='db -s ad_monitor -l'
alias adtest='db -s ad_monitor -t'
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
