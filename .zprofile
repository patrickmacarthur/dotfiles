# vim: set ft=zsh :
#
# /etc/zprofile and ~/.zprofile are run for login shells
#

if [[ -f ~/.profile ]]; then
	. ~/.profile
fi

if [[ -x /usr/bin/task ]]; then
	/usr/bin/task next
fi
