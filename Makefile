ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHARE = ${HOME}/.cache/zsh

clean:
	rm -f ${HOME}/.zcompdump
	rm -f ${HOME}/.zlogin
	rm -f ${HOME}/.zlogout
	rm -f ${HOME}/.zprofile
	rm -f ${HOME}/.zshenv
	rm -f ${HOME}/.zshrc
	rm -fr ${SHARE}
	rm -fr plugin

install: plugin/autosuggestions plugin/completions
	ln -snf ${ROOT_DIR}/zlogin ${HOME}/.zlogin
	ln -snf ${ROOT_DIR}/zlogout ${HOME}/.zlogout
	ln -snf ${ROOT_DIR}/zprofile ${HOME}/.zprofile
	ln -snf ${ROOT_DIR}/zshenv ${HOME}/.zshenv
	ln -snf ${ROOT_DIR}/zshrc ${HOME}/.zshrc
	mkdir -p ${SHARE}

install_repos:
	git clone git://github.com/zsh-users/zsh-autosuggestions plugin/autosuggestions
	git clone git://github.com/zsh-users/zsh-completions.git plugin/completions

update:
	git --work-tree=plugin/autosuggestions checkout -f
	git --work-tree=plugin/autosuggestions pull
	git --work-tree=plugin/completions checkout -f
	git --work-tree=plugin/completions pull
