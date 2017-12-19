# .bashrc

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

set -o ignoreeof -o vi

# Put your fun stuff here.
alias whence_w="type -t"
if [ -f ~/.shrc ]; then
	. ~/.shrc
fi

# User specific aliases and functions
git_prompt_locations=(
	/usr/lib/git-core/git-sh-prompt
	/usr/libexec/git-core/git-sh-prompt
	/usr/share/git-core/contrib/completion/git-prompt.sh
)
if ! whence __git_ps1 &>/dev/null; then
	for git_prompt in "${git_prompt_locations[@]}"; do
		if [[ -f ${git_prompt} ]]; then
			GIT_PS1_SHOWDIRTYSTATE=1
			GIT_PS1_SHOWSTASHSTATE=1
			GIT_PS1_SHOWUNTRACKEDFILES=1
			GIT_PS1_SHOWUPSTREAM=auto
			. ${git_prompt}
		fi
	done
fi

prompt_cmd ()
{
	local gitstat val
	
	gitstat=
	type __git_ps1 >/dev/null 2>&1 && gitstat=$(__git_ps1)
	val="${LOGNAME}@${HOSTNAME%%.*}:$(dirs)${gitstat}"

	# Change the window title of X terminals
	case ${TERM} in
	screen*|tmux*|xterm*|rxvt*|Eterm|aterm|kterm|gnome*|konsole*|interix)
		printf '\033]2;%s\007' "${val}"
		;;
	esac
}

set_prompt ()
{
	local normal red green yellow blue purple cyan white
	local happy sad stat

	normal="\[$(tput sgr0)\]"
	red="\[$(tput setaf 1)\]"
	green="\[$(tput setaf 2)\]"
	yellow="\[$(tput setaf 3)\]"
	blue="\[$(tput setaf 4)\]"
	purple="\[$(tput setaf 5)\]"
	cyan="\[$(tput setaf 6)\]"
	white="\[$(tput setaf 7)\]"

	happy="$green:-)$normal"
	sad="$red:-($normal"
	stat="\`[[ \$? = 0 ]] && echo \"$happy\" || echo \"$sad\"\`"
	PS1="${green}\! \H $stat ${green}\$$normal "

	type prompt_cmd >/dev/null 2>&1 && PROMPT_COMMAND=prompt_cmd
}
set_prompt

HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=5000
HISTIGNORE="&:?:??:[bf]g:history:exit:pwd:clear:[ ]*"
shopt -s histappend

if ! shopt -oq posix; then
	# enable programmable completion features if present
	if [[ -f /usr/share/bash-completion/bash_completion ]]; then
		. /usr/share/bash-completion/bash_completion
	elif [[ -f /etc/bash_completion ]]; then
		. /etc/bash_completion
	fi
fi
