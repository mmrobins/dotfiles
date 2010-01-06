#alias sqlplus='env -u NLS_LANG sqlplus'
alias ls="ls -FC --color"
alias lt="ls -ltr"
alias ll="ls -la"
alias rm="rm -i"
#alias splitmp3="mp3splt -a -t 5.0 -d split_files -o @n_@f"
alias splitmp3="mp3splt -a -t 5.0 -o @f/@n"
alias ack="ack-grep --all --ignore-dir data --ignore-dir images"


# Version Control
alias sdl='if [ -d .svn ]; then svn_diff_less; else git diff trunk --no-prefix | diff_painter.pl | less -R; fi'
alias sst='if [ -d .svn ]; then svn status; else git diff trunk --name-status; fi'
alias gdl='git diff --no-prefix HEAD~ | diff_painter.pl | less -R'
alias gst='git status'
alias gsr='git svn rebase'
alias viall='vi `sst | perl -pne "s/^\S\s+//"`';


# Git
alias gco='git checkout'

# Show most used commands that might be good candidates for aliases
alias mu='history | cut -d " " -f3 | sort | uniq -c | sort -nr | head -50'

# Compress the cd, ls -l series of commands.
alias lc='cl'
function cl () {
   if [ $# = 0 ]; then
      cd && ll
   else
      cd "$*" && ll
   fi
}
# Rentrak specific
alias edev2='ssh -t edev2 screen -R'
alias db='rlwrap --remember --histsize 10000 rtk_database_login.pl -x'
alias dbl='rtk_database_login.pl --list'
alias buall='/home/msw/bin/bu `slnu`'
alias testhere='dt=`date +%y%m%d_%H_%M`; proj=`pwd | sed "s/.*RTK\///"`; rtk_appropriate_perl_for_directory -S rtk_test -thc > ${proj}_test_output_$dt &'

alias retailtest='db -s retail -t'
alias retaildev='db -s retail -d'
alias retaillive='db -s retail -l'
alias hvetest='db -s hve -t'
alias hvedev='db -s hve -d'
alias hvelive='db -s hve -l'
alias comtest='db -s common -t'
alias comdev='db -s common -d'
alias comlive='db -s common -l'
#alias addev='rtk_database_login.pl -s ad_monitor -d'
#alias adlive='rtk_database_login.pl -s ad_monitor -l'
#alias adtest='rtk_database_login.pl -s ad_monitor -t'
alias addev='cd ~/sql/psql; db -s ad_monitor -d'
alias adlive='db -s ad_monitor -l'
alias adtest='db -s ad_monitor -t'
alias cvsstat='cvs status |grep Status: Local'
alias rtk_console='perl -d ~/debugger_console.pl'

# Change directory up
alias         ..='cd ..'
alias        ...='cd ../..'
alias       ....='cd ../../..'
alias      .....='cd ../../../..'
alias     ......='cd ../../../../..'
alias    .......='cd ../../../../../..'
alias   ........='cd ../../../../../../..'
alias  .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'

# change to project directories
alias retg='cd ~/work/retail_git'
alias retc='cd ~/work/retail_clean'
alias hveg='cd ~/work/hve_git'
alias hvec='cd ~/work/hve_clean'
alias adg='cd ~/work/admon_git'
alias adc='cd ~/work/admon_clean'
alias retgp='cd ~/work/retail_git/perl_lib/RTK/Retail'
alias retcp='cd ~/work/retail_clean/perl_lib/RTK/Retail'
alias hvegp='cd ~/work/hve_git/perl_lib/RTK/Homevideo'
alias hvecp='cd ~/work/hve_clean/perl_lib/RTK/Homevideo'
alias adgp='cd ~/work/admon_git/perl_lib/RTK/AdMonitor'
alias adpc='cd ~/work/admon_clean/perl_lib/RTK/AdMonitor'

# dir sizes summarized and sorted
alias dus='du -s * | sort -n'
