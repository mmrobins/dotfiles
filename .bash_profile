# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/bin:$PATH
ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
PATH=$PATH:$ORACLE_HOME/bin
PATH=$PATH:/usr/lib/oracle/xe/app/oracle/product/10.2.0/client/lib/
export ORACLE_HOME
export ORACLE_SID=XE

export PATH
export SQLPATH=$HOME/sql
unset USERNAME
