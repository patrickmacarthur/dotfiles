# Makefile
# 
# Installs all of my dot files, and creates empty local files if they do
# not already exist.
#
# vim: set noet:

SOURCES="tmux.conf vimrc zshrc"

.PHONY : install

install:
	for i in ${SOURCES}; do
		ln -sf _$i ${HOME}/.$i
		touch ${HOME}/.$i.local
	done

