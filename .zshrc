source ~/.sh_aliases
source ~/.shrc
autoload -U colors && colors
zmodload -i zsh/complist
zstyle ':completion:*' add-space true
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 1
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"

zstyle ':completion:*:*:git:*:aliases' list-colors "=(#b)(*)  #-- alias for *=$color[none]=$color[green]"
zstyle ':completion:*:*:git:*:commands' list-colors "=(#b)(*)  #-- *=$color[none]=$color[blue]"

zstyle ':completion:*:*:git-branch:*:branch-names' list-colors "=(#b)((master)#|(origin)(/)(master)#(*)|(*))=$color[blue]=$color[none]=$color[cyan]=$color[green]=$color[none]=$color[cyan]=$color[blue]=$color[blue]"

zstyle ':completion:*:*:git-branch:*:heads' list-colors "=(#b)((master)#|(origin)(/)(master)#(*)|(*))=$color[blue]=$color[none]=$color[cyan]=$color[green]=$color[none]=$color[cyan]=$color[blue]=$color[blue]"
zstyle ':completion:*:*:git-checkout:*:heads' list-colors "=(#b)((master)#|(origin)(/)(master)#(*)|(*))=$color[blue]=$color[none]=$color[cyan]=$color[green]=$color[none]=$color[cyan]=$color[blue]=$color[blue]"
zstyle ':completion:*:*:git-cherry:*:heads' list-colors "=(#b)((master)#|(origin)(/)(master)#(*)|(*))=$color[blue]=$color[none]=$color[cyan]=$color[green]=$color[none]=$color[cyan]=$color[blue]=$color[blue]"
zstyle ':completion:*:*:git-cherry-pick:*:heads' list-colors "=(#b)((master)#|(origin)(/)(master)#(*)|(*))=$color[blue]=$color[none]=$color[cyan]=$color[green]=$color[none]=$color[cyan]=$color[blue]=$color[blue]"
zstyle ':completion:*:*:git-push:*:heads' list-colors "=(#b)((master)#|(origin)(/)(master)#(*)|(*))=$color[blue]=$color[none]=$color[cyan]=$color[green]=$color[none]=$color[cyan]=$color[blue]=$color[blue]"
zstyle ':completion:*:*:git-rebase:*:heads' list-colors "=(#b)((master)#|(origin)(/)(master)#(*)|(*))=$color[blue]=$color[none]=$color[cyan]=$color[green]=$color[none]=$color[cyan]=$color[blue]=$color[blue]"
zstyle ':completion:*:*:git-reset:*:heads' list-colors "=(#b)((master)#|(origin)(/)(master)#(*)|(*))=$color[blue]=$color[none]=$color[cyan]=$color[green]=$color[none]=$color[cyan]=$color[blue]=$color[blue]"

zstyle ':completion:*:*:git-branch:*:tags' list-colors "=*=$color[yellow]"
zstyle ':completion:*:*:git-checkout:*:tags' list-colors "=*=$color[yellow]"
zstyle ':completion:*:*:git-cherry-pick:*:tags' list-colors "=*=$color[yellow]"
zstyle ':completion:*:*:git-cherry:*:tags' list-colors "=*=$color[yellow]"
zstyle ':completion:*:*:git-push:*:tags' list-colors "=*=$color[yellow]"
zstyle ':completion:*:*:git-rebase:*:tags' list-colors "=*=$color[yellow]"
zstyle ':completion:*:*:git-reset:*:tags' list-colors "=*=$color[yellow]"

zstyle ':completion:*:*:git-fetch:*:remotes' list-colors "=*=$color[green]"
zstyle ':completion:*:*:git-push:*:remotes' list-colors "=*=$color[green]"

zstyle ':completion:*:*:git-add:*:modified-files' list-colors "=*=$color[red]"
zstyle ':completion:*:*:git-add:*:other-files' list-colors "=*=$color[magenta]"

zstyle ':completion:*:default' list-colors 'no=0:fi=0:di=34:ln=36:pi=33:so=35:bd=33:cd=33:or=37;41:su=2;37;41:sg=2;30;43:tw=1;30;42:ow=30;42:st=37:ex=1;32'
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %l \(%p\): Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+r:|[._-]=** r:|=**' '+l:|=* r:|=*'
zstyle ':completion:*' match-original both
zstyle ':completion:*' max-errors 3 numeric
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' prompt 'Correct %e errors'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %l \(%p\)%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always

# With commands like `rm' it's annoying if one gets offered the same filename
# again even if it is already on the command line. To avoid that:
zstyle ':completion:*:rm:*' ignore-line yes

## Use cache
# Some functions, like _apt and _dpkg, are very slow. You can use a cache in
# order to proxy the list of results (like the list of available debian
# packages)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${HOME}/.zsh_cache

zstyle :compinstall filename '/home/jhelwig/.zshrc'

autoload -Uz compinit zrecompile

zsh_cache=${HOME}/.zsh_cache
mkdir -p $zsh_cache

if [ $UID -eq 0 ]; then
    compinit
else
    compinit -d $zsh_cache/zcomp-$HOST

    for f in ~/.zshrc $zsh_cache/zcomp-$HOST; do
        zrecompile -p $f && rm -f $f.zwc.old
    done
fi

HISTFILE=$HOME/.histfile
HISTSIZE=1000000
SAVEHIST=50000
setopt inc_append_history share_history extended_history beep extended_glob notify transient_rprompt short_loops local_options multios complete_aliases complete_in_word list_ambiguous
unsetopt autocd nomatch clobber

for zshrc_snipplet in ~/.zsh.d/S[0-9][0-9]*[^~] ; do
#   source $zshrc_snipplet
done

### Be all creepy.
## Watch for logins and logouts from all accounts including mine.
watch=all
## Watch every 30 seconds
logcheck=30
## Change the watch format to something more informative
# %n = username, %M = hostname, %a = action, %l = tty, %T = time,
# %W = date
WATCHFMT="%n from %M has %a tty%l at %T %W"

autoload -U zmv zargs

#eval `keychain -q --eval id_rsa id_rsa_new jhe jhe_monitor.dsa rentrak_id_dsa`

# zgitinit and prompt_wunjo_setup must be somewhere in your $fpath, see README for more.
setopt promptsubst
# Load the prompt theme system
autoload -U promptinit
promptinit
# Use the wunjo prompt theme
prompt wunjo

bindkey -e
bindkey "^U" backward-kill-line
bindkey "^[^?" vi-backward-kill-word
bindkey "^[k" kill-region
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

autoload -U   edit-command-line
zle -N        edit-command-line
bindkey '\ee' edit-command-line

bindkey -M menuselect '\e^M' accept-and-menu-complete

# export PS1="%~ %T"
# color yellow time color lightblue user@host : path (git branch) end color
P_TIME="%T"
P_COLOR1="%{\033[31m%}"
P_END_COLOR="%{\033[0m%}"
P_COLOR2="\[\e[36;1m\]"
P_USER="%n@%m"
P_PATH="%~"
#GITBRANCH=`if which git &> /dev/null; then echo '$(__git_ps1 "(%s)")'; else echo ''; fi`
GITBRANCH=''
%m

#export PS1="$P_COLOR1  $P_TIME $P_COLOR2 $P_USER : $P_PATH $GITBRANCH\n >$P_END_COLOR"
PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

# Colorful basic prompt option 1
export PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
export RPS1="%{$fg[cyan]%}<%T%{$reset_color%}"
export PS2="%_> "

# Colorful basic prompt option 2 { Better than option 1 }
#export PS1=$'%{\e[1;32m%}%n%{\e[0m%}%{\e[1;34m%}@%{\e[1;31m%}%m %{\e[1;34m%}%~ %{\e[0m%}%% '
#export RPS1=$'%{\e[1;30m%}<%T%{\e[0m%}'
#export PS2=$'%{\e[0;37m%} %_>%{\e[0m%} '
