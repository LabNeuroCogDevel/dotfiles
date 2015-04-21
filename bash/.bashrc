export LANG=en_US.UTF-8
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# claim xterm and fbterm are xterm with full color
[[ "$TERM" =~ xterm|fbterm ]] && export TERM="xterm-256color"
[ -n "$TMUX" ] && export TERM=screen-256color-bce

# disable beep 
set -b

###########################
###Personal and Funcs######
###########################
fundir=$HOME/.config/shellfuncs/ 
if [ -d "$fundir" ]; then
 for sh_f in $fundir/*sh; do
   source $sh_f
 done
fi

##################
###Shortcuts######
##################

#ask before overwriting
alias mv='mv -i'
alias cp='cp -i'

# save some key strokes
alias v='vim'
alias p='perl -slane'
if [ -n "$(which ls++ 2>/dev/null)" ]; then 
  alias l='ls++' 
else
  alias l='ls' 
fi
alias ls='ls --color=auto'
alias lst='ls -ltc --color=auto'
alias newf='ls -c|sed 10q'

alias ccat='pygmentize -f terminal256 -g'

alias matlab='matlab -nodesktop -nosplash'

alias notes='vim ~/notes/$(date +%F)'
alias sshmaster='ssh -MNf' #create ControlMaster

#^c-x ^c-e -->vim
export EDITOR=vim


#####HISTORY####
#store lots of history
export HISTSIZE=10000
# avoid duplicates
export HISTCONTROL=ignoredups:erasedups  
# append history entries
shopt -s histappend


## bind forward search to M-S-R instead of C-s (which locks)
# could also remove XON/OFF block/locking with
#   stty -ixon
#bind '"\eR":forward-search-history'


##Tab complete##
#complete hosts in host file for ssh
complete -W "$(
               perl -nle 'if(m/Host (.+)$/){$hosts=$1; print $& while $hosts=~m/\w+/g }' \
                $HOME/.ssh/config 
             )" ssh


########################
###live inside screen###
########################
#screen -D  -R

#############
### color ###
#############

####pretty prompt
# transform hostname into a "unique" color
colnum=$(hostname | ruby -ne 'puts $_.split("").map {|x| x.ord}.reduce(:+) % 256')
# info on one line
  blue="\[[38;5;27m\]"
  pink="\[[38;5;197m\]"
 green="\[[38;5;121m\]"
purple="\[\e[1;35m\]"
yellow="\[[1;33m\]"
invert="\[\e[7m\]"
 nocol="\[[0m\]"
hostco="\[\e[48;5;${colnum}m\]"
hostcoi="\[\e[38;5;${colnum}m\]"

# reset color after pushing enter
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt#Tips_and_tricks
#trap 'echo -ne "\e[0m"' DEBUG

if [ "$TERM" == "linux" ]; then
  blue="\[[1;34m\]"
  pink="\[[1;31m\]"
 green="\[[1;32m\]"
fi
#PS1="$yellow$(jobs|wc -l|sed -e '/^0$/d;s/$/ /')$pink$(date +%H:%M) $green\h$nocol:\[\e[3m\]$blue\w$nocol\n$purple»$nocol "
#PS1="$pink\t $green\h$nocol:\[\e[3m\]$blue\w$nocol\n$purple»$nocol "
PS1="$hostcoi#$pink\t ${green}$(hostname|cut -d- -f1 )$nocol:\[\e[3m\]$blue\w$nocol\n$hostco $nocol"

###################
#grep
#export GREP_OPTIONS='--color=auto'
#export GREP_COLOR='1;32' #bright green instead of red
# GREP OPTIONS is deprecated
unset GREP_OPTIONS

alias cgrep='grep --color=yes'
alias  grep='grep --color=auto'

#less 
export LESS='-R' #take color codes to be raw
#man page color in less
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
#export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box -- also highlight color
export LESS_TERMCAP_so='' 
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
export PAGER=less


