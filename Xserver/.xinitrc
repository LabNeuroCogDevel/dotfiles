# use notifcations (doesn't work)
export LANG=en_US.UTF-8
export PATH="$PATH:/home/foranw/bin/"
dbus-launch /usr/lib/notification-daemon-1.0/notification-daemon &
xrandr --output DVI-0 --mode 1920x1200 --output VGA-0 --left-of DVI-0 --mode 1600x1200 &

# get dbus (redudant with above) -- way too many dbus-laucnhes
 . /etc/X11/xinit/xinitrc.d/30-dbus.sh
### see launchwithX
### xbindkeys &
### dbus-launch dropboxd &
### davmail & # ldap via exchange
### pidgin &
### thunderbird &
### emacs &
### #yeahconsole &
### #dbus-launch zim &
### #awsetbg -l &
### nitrogen --restore &
### #xterm -e "screen -x lncdbot || screen -S lncdbot /home/foranw/src/other/bot/runBot.sh" &
### urxvt -e ~/.starttmux.bash  &
#exec awesome
exec dbus-launch i3 

# http://blog.xkcd.com/2007/08/14/mirrorboard-a-one-handed-keyboard-layout-for-the-lazy/
# xkbcomp ~/.config/mirrorboard.xkb $DISPLAY & 2>/dev/null
# setxkbmap us # reset
