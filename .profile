# ~/.profile

if [ x${PS1} != x ] && [ x${HOME} = x ] ; then
	printf '.profile: \$HOME is not defined! Not continuing.' >&2
	return
fi

# Set XDG configuration variables to defaults, so we can always just
# use their values
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"

if [ -d "$HOME/.local/bin" ]; then
	PATH=$HOME/.local/bin:$PATH
fi
if [ -d "$HOME/bin" ]; then
	PATH=$HOME/bin:$PATH
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

export GOBIN="${HOME}/.local/bin"
export CCACHE_DIR="${XDG_CACHE_HOME}/ccache"
export PYTHON_EGG_CACHE="${XDG_CACHE_HOME}/python-eggs"
export TASKDATA="${XDG_DATA_HOME}/taskwarrior"
export TASKRC="${XDG_CONFIG_HOME}/taskwarrior/taskrc"

export ALTERNATE_EDITOR=''
export EDITOR=emacsclient
export LESS='FXRQ'
export PAGER=less
export VISUAL=${EDITOR}

if [ -f ~/.profile.local ]; then
	. ~/.profile.local
fi
