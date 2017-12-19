# .zshrc
#
# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Patrick MacArthur

typeset -U path
path=(~/bin $path)

# Set all of my functions to autoload on first call.
fpath=($fpath ~/.zsh/functions)
autoload -U ~/.zsh/functions/*(:t)

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
# End of lines configured by zsh-newuser-install

export KEYTIMEOUT=1
bindkey -v
bindkey "^[[1~" beginning-of-line
bindkey "^[[2~" vi-quoted-insert
bindkey "^[[3~" delete-char
bindkey "^[[4~" end-of-line
bindkey "^[[5~" history-search-backward
bindkey "^[[6~" history-search-forward
bindkey -a "^[[1~" beginning-of-line
bindkey -a "^[[2~" vi-quoted-insert
bindkey -a "^[[3~" delete-char
bindkey -a "^[[4~" end-of-line
bindkey -a "^[[5~" history-search-backward
bindkey -a "^[[6~" history-search-forward
bindkey '^R' vi-history-search-backward

# The following lines were added by compinstall
zstyle :compinstall filename '/home/patrick/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# The following is partially based on my prior .bashrc and partially based on
# an example .zshrc provided at http://people.freedesktop.org/~whot/zsh-setup
setopt appendhistory  #append to history
setopt inc_append_history # append immediately
setopt hist_expire_dups_first # expire duplicates in history first
setopt hist_ignore_all_dups # dont add dupes to history
setopt nobeep               # don't beep

autoload -Uz vcs_info
zstyle ':vcs_info:*' disable bzr cdv cvs darcs mtn p4 svk tla

# Commands to run before the command prompt (PS1) is displayed.
# We use this to display the current SVN or git branch if necessary and update
# the window title.
function precmd {
# Gets and echoes the current svn branch that we are under
vcs_info

# Set VCS branch
VCSBRANCH="$vcs_info_msg_0_"

# Set xterm/screen title
case $TERM in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|konsole*|interix|screen*)
		print -Pn "\e]0;%n@%m:$(dirs)\a" ;;
esac
}

# Sets the prompt.  Not necessary to segregate into a function but helps
# to organize things a bit.
setprompt() {
	setopt prompt_subst
	typeset happy sad c_stat c_pwd c_branch PR_COLOR PR_RESET

	# See if we can use colors. (source: http://aperiodic.net/phil/prompt/)
	zmodload zsh/terminfo
	autoload colors
	if [[ "$terminfo[colors]" -ge 8 ]]; then
		colors
	fi
	for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
		eval typeset PR_$color
		if [[ "$TERMBG" == "light" || "$TERMBG" == "solarized" ]]; then
			eval PR_$color='%{$fg[${(L)color}]%}'
		elif [[ "$TERMBG" == "dark" ]]; then
			eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
		fi
	done
	PR_RESET="%{$terminfo[sgr0]%}"

	# Color of the prompt: red for superuser, cyan for all other users
	PR_COLOR="%(!.$PR_RED.$PR_CYAN)"

	# Prompt component: status
	happy="$PR_GREEN:-)$PR_COLOR"
	sad="$PR_RED:-($PR_COLOR"
	c_stat=" %(?.$happy.$sad) "

	c_pwd="$PR_YELLOW%1~$PR_COLOR"
	c_branch="$PR_YELLOW\$VCSBRANCH$PR_COLOR"
	PS1="${PR_COLOR}[%!][%n@%m:${c_pwd}]${c_branch}${c_stat}%#$PR_RESET "
}

recolor() {
	export TERMBG

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
	elif [[ -n "$1" ]]; then
		echo "Usage: recolor [light|dark]" >&2
	fi

	setprompt

	if [[ $(tput colors) -ge 256 && -e $HOME/.dircolors.256color ]]; then
		eval `dircolors --sh $HOME/.dircolors.256color`
	elif [[ -e $HOME/.dircolors.$TERMBG ]]; then
		eval `dircolors --sh $HOME/.dircolors.$TERMBG`
	elif [[ -e $HOME/.dircolors ]]; then
		eval `dircolors --sh $HOME/.dircolors`
	fi
}

# Set background color
if [[ -z "$TERMBG" && -f $HOME/.termbg.$TERM ]]; then
	source $HOME/.termbg.$TERM
	export TERMBG
fi
recolor
export PS1

# Make an open like Mac OS X has
whence xdg-open &>/dev/null && alias open=xdg-open

# SVN functions
svnlog() { svn log $@ | less -R; }
svnhelp() { svn help $@ | less -R; }
svndiff() {
	typeset filter
	if whence colordiff &>/dev/null; then
		filter=colordiff
	else
		filter=cat
	fi
	svn diff --no-diff-deleted $@ | $filter | less -R;
}

# Make stuff
alias mk3="make -j3"

# Colorization and other support for colorization in GNU tools.  If we don't
# have GNU tools, use BSD or POSIX options that give us something close to what
# we want.
whence colordiff &>/dev/null && alias diff=colordiff
if [[ $OSTYPE == "linux" || $OSTYPE == "linux-gnu" ]]; then
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
elif [[ $(uname -s) == "FreeBSD" ]]; then
	alias ls='ls -G'
else
	alias ls='ls -F'
fi

alias head='head -n $(($LINES-5))'
alias tail='tail -n $(($LINES-5))'

export VISUAL=vim
export EDITOR=$VISUAL
export PAGER=less
export LESS=-XFQR

setbrowser

# cd without typing 'cd'
setopt autocd

# Ignore EOF
setopt ignoreeof

if [[ -f $HOME/.zshrc.local ]]; then
	source $HOME/.zshrc.local
fi

# vim: set filetype=zsh :