# set xterm to colorful xterm
[[ "$TERM" = "xterm" ]] && export TERM="xterm-256color"



## Settings
autoload -U colors zsh-mime-setup select-word-style
colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
HISTSIZE=10000

## PROMPT
colnum=$(hostname | ruby -ne 'puts $_.split("").map {|x| x.ord}.reduce(:+) % 256')
zstyle ':prompt:grml:left:setup'      items   time host path vcs newline percent
#zstyle ':prompt:grml:*:items:percent' token  '» '          
zstyle ':prompt:grml:*:items:percent' token  "%{[48;5;${colnum}m%} %{[0m%}"
zstyle ':prompt:grml:*:items:time'    pre    "%{[38;5;${colnum}m%}# %{[38;5;197m%}"
zstyle ':prompt:grml:*:items:host'    pre    "%{[38;5;121m%}"
zstyle ':prompt:grml:*:items:host'    post   "%{[0m%}:"
zstyle ':prompt:grml:*:items:path'    pre    '%{[38;5;27m%}' 
zstyle ':prompt:grml:*:items:percent' pre    '%{[1;35m%}'    


## Bindings
bindkey '\e[3~'   delete-char             # Del
