# .bash_profile

# Red Hat does this in ~/.bash_profile, I am going to trust them and do path
# changes here
if [ -d "$HOME/bin" ] && [[ ":$PATH:" !=  *":$!:"* ]]; then
	PATH=$PATH:$HOME/bin
	export PATH
fi


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

# Ensure that we are using the correct TERM value.  Just using xterm is apparently bad.
# This code is borrowed from: http://vim.wikia.com/wiki/256_colors_in_vim
if [ "$TERM" = "xterm" ] ; then
	if [ -z "$COLORTERM" ] ; then
		if [ -z "$XTERM_VERSION" ] ; then
			echo "Warning: Terminal wrongly calling itself 'xterm'."
		else
			case "$XTERM_VERSION" in
			"XTerm(256)") TERM="xterm-256color" ;;
			"XTerm(88)") TERM="xterm-88color" ;;
			"XTerm") ;;
			*)
				echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
				;;
			esac
		fi
	else
		case "$COLORTERM" in
		gnome-terminal)
			# Those crafty Gnome folks require you to check COLORTERM,
			# but don't allow you to just *favor* the setting over TERM.
			# Instead you need to compare it and perform some guesses
			# based upon the value. This is, perhaps, too simplistic.
			TERM="gnome-256color"
			;;
		*)
			echo "Warning: Unrecognized COLORTERM: $COLORTERM"
			;;
		esac
	fi
fi

# Make sure that our terminal is supported
SCREEN_COLORS=$(tput colors 2>/dev/null)
if [ -z "$SCREEN_COLORS" ] ; then
        TERMOLD=$TERM
        TERM=${TERM%-*}
        SCREEN_COLORS=$(tput colors 2>/dev/null)
        while [[ "$TERM" == "*-*" && -z "$SCREEN_COLORS" ]]; do
                TERM=${TERM%-*}
        done

        if [[ -n "$SCREEN_COLORS" ]]; then
                echo "Unknown terminal $TERMOLD. Falling back to '$TERM'."
        fi
        unset TERMOLD
fi

if [ -z "$SCREEN_COLORS" ] ; then
	case "$TERM" in
	screen-*color-bce)
		echo "Unknown terminal $TERM. Falling back to 'screen-bce'."
		export TERM=screen-bce
		;;
	*-88color)
		echo "Unknown terminal $TERM. Falling back to 'xterm-88color'."
		export TERM=xterm-88color
		;;
	*-256color)
		echo "Unknown terminal $TERM. Falling back to 'xterm-256color'."
		export TERM=xterm-256color
		;;
	esac
	SCREEN_COLORS=$(tput colors 2>/dev/null)
fi
if [ -z "$SCREEN_COLORS" ] ; then
	case "$TERM" in
	gnome*|xterm*|konsole*|aterm|[Ee]term)
		echo "Unknown terminal $TERM. Falling back to 'xterm'."
		export TERM=xterm
		;;
	rxvt*)
		echo "Unknown terminal $TERM. Falling back to 'rxvt'."
		export TERM=rxvt
		;;
	screen*)
		echo "Unknown terminal $TERM. Falling back to 'screen'."
		export TERM=screen
		;;
	esac
	SCREEN_COLORS=$(tput colors 2>/dev/null)
fi

# Show terminal type and setup terminal
echo "Terminal type is $TERM."
tset

if [[ "$TERMBG" == "dark" || "$TERMBG" == "light" || "$TERMBG" == "solarized" ]]
then
	echo "Terminal background is $TERMBG."
else
	echo "Please set TERMBG=light or TERMBG=dark and run recolor."
fi
export TERMBG

# Let us know if we've got running screen sessions
if [[ -n $(type -t screen) ]]; then
	screen -ls
fi

# Display something witty :)
if [[ -n $(type -t fortune) ]]; then
	fortune
fi

[[ -f ~/.bash_profile.local ]] && . ~/.bash_profile.local

