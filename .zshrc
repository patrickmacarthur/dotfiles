# .zshrc
#
# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.

# This is partially based on my prior .bashrc and partially based on
# an example .zshrc provided at http://people.freedesktop.org/~whot/zsh-setup
#
# Patrick MacArthur

whence_w () {
	whence -w "$@" | cut -d: -f2 | tr -d ' '
}
[[ -f ~/.shrc ]] && . ~/.shrc

# Set all of my functions to autoload on first call.
fpath=($fpath ~/.zsh/functions)
autoload -Uz ~/.zsh/functions/*(:t) vcs_info
zstyle ':vcs_info:*' disable bzr cdv cvs darcs mtn p4 svk tla

do_bindkeys
setprompt

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory inc_append_history hist_ignore_all_dups
setopt autocd nobeep ignoreeof

zmodload -i zsh/complist
# The following lines were added by compinstall
zstyle :compinstall filename "${HOME}/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Commands to run before the command prompt (PS1) is displayed.
# We use this to display the current SVN or git branch if necessary and update
# the window title.
precmd () {
	# Gets and echoes the current svn branch that we are under
	vcs_info

	# Set xterm/screen title
	case $TERM in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|konsole*|interix|screen*|tmux*)
		print -Pn "\e]2;%n@%m:$(dirs)${vcs_info_msg_0}\a" ;;
	esac
}

# vim: set filetype=zsh :
