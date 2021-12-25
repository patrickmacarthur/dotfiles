# .bash_profile

# Source generic profile
. ~/.profile

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Show X11 display
if [ -n "$DISPLAY" ]; then
	echo X11 display is $DISPLAY
fi

# Show terminal type and setup terminal
echo "Terminal type is $TERM."
tset

# Let us know if we've got running screen sessions
if [[ -n $(type -t screen) ]]; then
	screen -ls
fi

# Display something witty :)
if [[ -n $(type -t fortune) ]]; then
	fortune
fi
if [ -e /home/patrick/.nix-profile/etc/profile.d/nix.sh ]; then . /home/patrick/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
