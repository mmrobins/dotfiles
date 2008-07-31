# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/bin:$PATH

export PATH
export SQLPATH=$HOME/sql
unset USERNAME
if [ -z "$PERL5LIB" ]
then
    # If PERL5LIB wasn't previously defined, set it...
    PERL5LIB=~/myperl/lib
else
    # ...otherwise, extend it.
    PERL5LIB=$PERL5LIB:~/myperl/lib
fi

MANPATH=$MANPATH:~/myperl/man

export PERL5LIB MANPATH

