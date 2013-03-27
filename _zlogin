# .zlogin
#
# .zlogin is sourced in login shells.  It should
# contain commands that should be executed only in
# login shells.  It should be used to set the terminal
# type and run a series of external commands (fortune,
# msgs, from, etc).
#
# Author: Patrick MacArthur
# (based on my bash_profile)

if [[ ! -o interactive ]]; then
	return
fi

if [[ -n "$DISPLAY" ]]; then
	echo X11 display is $DISPLAY
fi

# Show terminal type and setup terminal
echo "Terminal type is $TERM."
tset

# Set background color
if [[ -z "$TERMBG" && -f $HOME/.termbg.$TERM ]]; then
	source $HOME/.termbg.$TERM
fi
if [[ "z$TERMBG" == "zdark" || "z$TERMBG" == "zlight" || "z$TERMBG" == "zsolarized" ]]; then
	echo "Terminal background is $TERMBG."
else
	echo "Please set TERMBG=light or TERMBG=dark and run recolor."
fi
export TERMBG

# Let us know if we've got running screen sessions
if whence screen &>/dev/null; then
	screen -ls
fi

# Display something witty :)
if whence fortune &>/dev/null; then
	fortune
fi

# Do anything else we should do for just this system
if [[ -f ~/.zlogin.local ]]; then
	source ~/.zlogin.local
fi
