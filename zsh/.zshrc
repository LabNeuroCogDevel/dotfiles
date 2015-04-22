# set xterm to colorful xterm
[[ "$TERM" = "xterm" ]] && export TERM="xterm-256color"

# use GRML's zsh config
localgrml="$HOME/.zshrc_grml"
grmlurl="http://git.grml.org/?p=grml-etc-core.git;a=blob_plain;f=etc/zsh/zshrc;hb=HEAD"
[ ! -r $localgrml -o ! -r /etc/zsh/zshrc ] && curl -L  "$grmlurl" > $localgrml
[  -r $localgrml ] && source $localgrml

## change the prompt

#get some colors
autoload -U colors; colors
colnum=$( (whoami;hostname) | ruby -ne 'puts $_.split("").map {|x| x.ord}.reduce(:+) % 256')

# style the prompt
zstyle ':prompt:grml:left:setup'      items   time host path vcs newline percent


#zstyle ':prompt:grml:*:items:percent' token  '» '          
zstyle ':prompt:grml:*:items:percent' token  "%{[48;5;${colnum}m%} %{[0m%}"
zstyle ':prompt:grml:*:items:time'    pre    "%{[38;5;${colnum}m%}# %{[38;5;197m%}"
zstyle ':prompt:grml:*:items:host'    pre    "%{[38;5;121m%}"
zstyle ':prompt:grml:*:items:host'    post   "%{[0m%}:"
zstyle ':prompt:grml:*:items:path'    pre    '%{[38;5;27m%}' 
zstyle ':prompt:grml:*:items:percent' pre    '%{[1;35m%}'    

# simplfy version control info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%{$fg[magenta]%}%b%{${reset_color}%} %{$fg[red]%}%u" 

