# .bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
alias lt-gdb="libtool --mode=execute gdb"
alias lt-valgrind="libtool --mode=execute valgrind"

if ! type __git_ps1 &>/dev/null; then
	for git_prompt in \
			/usr/share/doc/git-*/contrib/completion/git-completion.bash \
			/usr/share/git{-core,}/contrib/completion/git-prompt.sh; do
		if [[ -f ${git_prompt} ]]; then
			GIT_PS1_SHOWDIRTYSTATE=1
			GIT_PS1_SHOWSTASHSTATE=1
			GIT_PS1_SHOWUNTRACKEDFILES=1
			GIT_PS1_SHOWUPSTREAM=auto
			source ${git_prompt}
		fi
	done
fi
if ! type __git_ps1 &>/dev/null; then
	alias __git_ps1=:
fi

# Run a command repeatedly until it fails
function repeatedly ()
{
	while "$@"; do :; done
	return $?
}

# Prompt
function recolor()
{
	local normal red green yellow blue purple cyan white
	local happy sad stat

	if [[ "$1" == "dark" || "$1" == "light" || "$1" == "solarized" ]]; then
		TERMBG="$1"
	elif [[ -e "$HOME/.termbg.$TERM" ]]; then
		source $HOME/.termbg.$TERM
	elif [[ -e "$HOME/.termbg" ]]; then
		source $HOME/.termbg
	elif [[ -n "$COLORFGBG" ]]; then
		bgcolor=$(cut -d\; -f3 <<<"$COLORFGBG")
		if [[ -z "$bgcolor" ]]; then
			bgcolor=$(cut -d\; -f2 <<<"$COLORFGBG")
		fi
		if [[ -n "$bgcolor" && "$bgcolor" != "default"
				&& "$bgcolor" -ge 0
				&& "$bgcolor" -le 8
				&& "$bgcolor" -ne 7 ]]
		then
			TERMBG="dark"
		else
			TERMBG="light"
		fi
		unset bgcolor
	fi

	if [[ "$TERMBG" == "dark" ]]; then
		normal='\[\e[0m\]'
		red='\[\e[31;1m\]'
		green='\[\e[32;1m\]'
		yellow='\[\e[33;1m\]'
		blue='\[\e[34;1m\]'
		purple='\[\e[35;1m\]'
		cyan='\[\e[36;1m\]'
		white='\[\e[37;1m\]'
	elif [[ "$TERMBG" == "light" || "$TERMBG" == "solarized" ]]; then
		normal='\[\e[0m\]'
		red='\[\e[31m\]'
		green='\[\e[32m\]'
		yellow='\[\e[33m\]'
		blue='\[\e[34m\]'
		purple='\[\e[35m\]'
		cyan='\[\e[36m\]'
		white='\[\e[37m\]'
	fi

	happy="$cyan:-)$normal"
	sad="$red:-($normal"
	stat="\`[[ \$? = 0 ]] && echo \"$happy\" || echo \"$sad\"\`"
	XTERM_TITLE='\[\e]0;\u@\H:$(dirs)$(__git_ps1 " (%s)")\a\]'
	PS1="${cyan}\! \H $stat $cyan\$$normal ${XTERM_TITLE}"

	if [[ $(tput colors) -ge 256 && -e $HOME/.dircolors.256color ]]; then
		eval `dircolors --sh $HOME/.dircolors.256color`
	elif [[ -e $HOME/.dircolors.$TERMBG ]]; then
		eval `dircolors --sh $HOME/.dircolors.$TERMBG`
	elif [[ -e $HOME/.dircolors ]]; then
		eval `dircolors --sh $HOME/.dircolors`
	fi
}

# Set background color
recolor
export PS1 TERMBG

# Change the window title of X terminals 
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|konsole*|interix)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:$(dirs)\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:$(dirs)\033\\"'
		;;
esac

# Colorization and other support for colorization in GNU tools.  If we don't
# have GNU tools, use POSIX options that give us something close to what we
# want.
[[ -n "$(type -t colordiff)" ]] && alias diff=colordiff
if [ $OSTYPE == "linux" -o $OSTYPE == "linux-gnu" ]; then
	alias ls="ls --color=auto"
	export GREP_OPTIONS="$GREP_OPTIONS --color=auto -n"
elif [[ $(uname -s) == "FreeBSD" ]]; then
	alias ls='ls -G'
else
	alias ls='ls -F'
fi

# Make an open like Mac OS X has
[[ -n "$(type -t xdg-open)" ]] && alias open=xdg-open

export VISUAL=vim
export EDITOR=$VISUAL
export PAGER=less
export LESS=-FQR

HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=5000
HISTIGNORE="&:?:??:[bf]g:history:exit:pwd:clear:[ \t]*"
shopt -s histappend

[[ -f "${HOME}/.bashrc.local" ]] && . ${HOME}/.bashrc.local

# This is needed on Gentoo to enable bash completion, since the script is not
# sourced for non-interactive login shells.
if [ -f /etc/profile.d/bash-completion.sh ]; then
  source /etc/profile.d/bash-completion.sh
fi