# .bash_logout

# The individual login shell cleanup file, executed when a login shell exits

if [[ -f ${HOME}/.bash_logout.local ]]; then
	source ${HOME}/.bash_logout.local
fi
