# ~/.profile

if [ -d "$HOME/bin" ]; then
	PATH=$PATH:$HOME/bin
fi
if [ -d "$HOME/.local/bin" ]; then
	PATH=$PATH:$HOME/.local/bin
fi

# Find a suitable Web browser
browsers="elinks links lynx"
if [ x != x$DISPLAY ]; then
	browsers="firefox chromium chrome $browsers"
fi
for b in $browsers; do
	if type $b >/dev/null 2>&1; then
		BROWSER=$b
	fi
done
if [ x != x$BROWSER ]; then
	export BROWSER
fi

export EDITOR=vim
export LESS='FXRQ'
export PAGER=less
export VISUAL=${EDITOR}

if [ -f ~/.profile.local ]; then
	. ~/.profile.local
fi
