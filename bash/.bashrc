export LANG=en_US.UTF-8

# for lower core counts
export OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1 MKL_NUM_THREADS=1
# ht condor for fsl_sub
export FSLPARALLEL=condor
## compress outputs in fsl and afni
export FSLOUTPUTTYPE=NIFTI_GZ
export AFNI_COMPRESSOR="GZIP"

### Neurodebian paths ###
test -r /etc/afni/afni.sh  && source $_
source /opt/ni_tools/dotfiles/bash/.paths.bash
export AFNI_PLUGINPATH="$(dirname $(which afni))"
ppf_afni_warps(){
   [ $# -ne 0 -a -d "$1" ] && cd "$1"
   local files=(template_brain.nii* func_to_template.nii.gz mprage_bet.nii.gz func_to_struct.nii.gz mc_target.nii.gz mc_target_brain.nii.gz)
   for f in "${files[@]}"; do [ ! -r "$f" ] && echo "# $f ($(pwd)) DNE!? is this a functional preproc directory?" && return 1; done
   local actual_underlay=$(basename $(readlink -f template_brain.nii*))
   afni "${files[@]}" -com 'SET_OVERLAY func_to_template.nii.gz' -com "SET_UNDERLAY $actual_underlay"
}

#test -r /etc/fsl/5.0/fsl.sh;&& source $_
export FSLDIR="/opt/ni_tools/fsl_6/"
export PATH="$FSLDIR/bin:$PATH"
source /opt/ni_tools/fsl_6/etc/fslconf/fsl.sh


## perl5 libraries with cpanm
# eval "$(perl -I/opt/ni_tools/perl5 -Mlocal::lib)
export PERL_LOCAL_LIB_ROOT="/opt/ni_tools/perl5"
export PERL_MB_OPT="--install_base \"$PERL_LOCAL_LIB_ROOT\""
export PERL_MM_OPT="INSTALL_BASE=$PERL_LOCAL_LIB_ROOT"
export PERL5LIB="$PERL5LIB:$PERL_LOCAL_LIB_ROOT:$PERL_LOCAL_LIB_ROOT/lib/perl5"
export PATH="$PATH:$PERL_LOCAL_LIB_ROOT/bin"



# pyenv
export PYENV_ROOT=/opt/ni_tools/pyenv
export PATH="$PYENV_ROOT/bin:$PATH"

#fast simple node manager
export FNM_DIR="/opt/ni_tools/fnm/installs"
export PATH="/opt/ni_tools/fnm/bin:$PATH"

# If not running interactively, don't do anything
alias wfkt='ssh foranw@reese -t ssh -MNf kt'
[[ $- != *i* ]] && return


#ahdir=`apsearch -afni_help_dir`
test -f "/opt/ni_tools/afni/afni_help/all_progs.COMP.bash" && . $_
fsdir="/opt/ni_tools/freesurfer"
if [ -d $fsdir  ]; then
  export FREESURFER_HOME="$fsdir"
  source /opt/ni_tools/freesurfer/FreeSurferEnv.sh
fi

# 20210423 shell reports "/bin/bash" on rhea
if [ "$SHELL" = bash -o "$SHELL" = "/bin/bash" ]; then
  test -r /opt/ni_tools/connectir-docker/connectir.src.bash && source $_
  test -r /etc/bash_completion && source $_
  # anything user wants
  # N.B. only loaded in interactive mode
  [ -r $HOME/.mybashrc ] && source $HOME/.mybashrc

  test -r /opt/ni_tools/connectir-docker/connectir.src.bash && source $_
  ## 20180712 -- insert arguments by searching for them
  source /opt/ni_tools/fuzzy_arg/fuzzy_arg.bash
  source /opt/ni_tools/fuzzy_arg/fuzzy_new_complete.bash

  ###
  # set title
  set_title(){
    printf "\e]0;$@\007"
  }
  pre_cmd(){
    [ -z $UNSETPROMPTCOMMAND ] &&
    set_title "${USER}@${HOSTNAME%%.*}: ${PWD/$HOME/~}"
  }
  export PROMPT_COMMAND=pre_cmd
  #####HISTORY####
  #store lots of history
  export HISTSIZE=10000
  # avoid duplicates
  export HISTCONTROL=ignoredups:erasedups  
  # append history entries
  shopt -s histappend
  shopt -s checkwinsize
  ##Tab complete##
  #complete hosts in host file for ssh
  complete -W "$(
                 perl -nle 'if(m/Host (.+)$/){$hosts=$1; print $& while $hosts=~m/\w+/g }' \
                  $HOME/.ssh/config 
               )" ssh
  # disable beep 
  set -b
  ###

  ## MNE
  export MNE_ROOT='/opt/ni_tools/MNE-2.7.0-3106-Linux-x86_64/'
  export MATLAB_ROOT='/opt/ni_tools/MATLAB/R2015b/'
  source $MNE_ROOT/bin/mne_setup_sh

  # fzf: interface for ctrl+r (history), ctrl+alt+t (file), alt+c (cd)
  PATH="$PATH:/opt/ni_tools/utils/fzf/bin"
  source /opt/ni_tools/utils/fzf/shell/key-bindings.bash
  source /opt/ni_tools/utils/fzf/shell/completion.bash
fi
# claim xterm and fbterm are xterm with full color
[[ "$TERM" =~ xterm ]] && export TERM="xterm-256color"
[ -n "$TMUX" ] && export TERM=screen-256color-bce




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
alias G=git # also e.g. git --global alias.d "diff"
alias g='grep -P --color=auto'

#alias ccat='pygmentize -f terminal256 -g'

alias matlab='matlab -nodesktop -nosplash'

alias notes='vim ~/notes/$(date +%F)'
alias sshmaster='ssh -MNf' #create ControlMaster
alias ']'='/opt/ni_tools/fsh'

alias dt='sudo dmesg|tail'
alias t=tmux
alias ta='tmux attach -t'

### ssh
function s {
 [ -z "$1" ] && echo "need a host" >&2 && return 0
 shell="bash" # forces skynet and arnold to load .bashrc
 ssh $1 -AYt $shell
}
alias s7t='sshpass  -p "@lubamoda" ssh 7t'
# logon with sshpass using creds
sp() { sshpass -f ~/.ssh/creds/$1.cred ssh -o StrictHostKeyChecking=no $@; }


n() { ls -tlc $@|head; }
whichd() { dirname $(which $1);}
# cd to program directory
cdpd() { d=$(whichd $1); [ -n "$d" ] && cd $d; }
alias x=xargs
alias wh=which


#^c-x ^c-e -->vim
export EDITOR=vim



## bind forward search to M-S-R instead of C-s (which locks)
# could also remove XON/OFF block/locking with
#   stty -ixon
#bind '"\eR":forward-search-history'




########################
###live inside screen###
########################
#screen -D  -R

#############
### color ###
#############

####pretty prompt
# transform hostname into a "unique" color
colnum=$(echo $(whoami)$(hostname) | ruby -ne 'puts $_.split("").map {|x| x.ord}.reduce(:+) % 256')
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

if [ "$TERM" = "linux" ]; then
  blue="\[[1;34m\]"
  pink="\[[1;31m\]"
 green="\[[1;32m\]"
fi
oldPS1="$PS1"
#PS1="$yellow$(jobs|wc -l|sed -e '/^0$/d;s/$/ /')$pink$(date +%H:%M) $green\h$nocol:\[\e[3m\]$blue\w$nocol\n$purple»$nocol "
#PS1="$pink\t $green\h$nocol:\[\e[3m\]$blue\w$nocol\n$purple»$nocol "
PS1="$hostcoi#$pink\t ${green}$(hostname|cut -d. -f1 )$nocol:\[\e[3m\]$blue\w$nocol\n$hostco $nocol"

# are we trying to use tramp mode in emacs (see org-bable :dir )
[ -n "$INSIDE_EMACS" -o $TERM = "dumb" ] && PS1="$oldPS1" && pre_cmd() { PS1="\t \w\n\$ "; }

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

# fasd: provide z alias
export PATH="$PATH:$HOME/bin"
eval "$(fasd --init auto)"
unalias s
unalias a
alias a='afni ~/standard/mni_icbm152_nlin_asym_09c/mni_icbm152_t1_tal_nlin_asym_09c.nii'
# up
source /opt/ni_tools/utils/up/up.sh
# fzy (better fzf for enhancd)
export PATH="/opt/ni_tools/utils/fzy:$PATH"

# # enhanced cd as 'c'
# source /opt/ni_tools/utils/enhancd/init.sh
# export ENHANCD_COMMAND=c

# go to the directory of a file, or if arg is a dir, go there
# like cd, no input is same as 'cd ~'. cd - explicitly passed through
c() {
   [ $# -eq 0 ] && cd && return
   [[ "$1" != "-" && ( -f "$1" || ! -e "$1" || ! -d "$(readlink -f "$1")" ) ]] &&
      cd "$(dirname "$1")" ||
      cd "$1";
}
mcd() { [ ! -d "$1" ] && mkdir -p "$1"; cd "$1"; }

# diff so fancy
export PATH="$PATH:/opt/ni_tools/diff-so-fancy"

# noti for notifcations on slack when process finishes
PATH="$PATH:/opt/ni_tools/noti"
export NOTI_SLACK_TOK=
export NOTI_SLACK_DEST="#notification"

#ROBEX
# export PATH="$PATH:/opt/ni_tools/robex_1.12"
# packaged and installed
# lunaid lookup with fzf bound to c-x c-l
eval "$(selld8 init)"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

# broot ls/launcher/fuzzy search
export PATH="$PATH:/opt/ni_tools/broot"
source /opt/ni_tools/broot/config/launcher/bash/br

