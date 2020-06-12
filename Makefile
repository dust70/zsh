ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

SHARE            = ${HOME}/.cache/zsh
PLUGIN_DIRECTORY = $(ROOT_DIR)/plugin
FZF              = ${PLUGIN_DIRECTORY}/fzf

clean:
	rm -fr ${HOME}/.antigen
	rm -f ${HOME}/.zcompdump
	rm -f ${HOME}/.zlogin
	rm -f ${HOME}/.zlogout
	rm -f ${HOME}/.zprofile
	rm -f ${HOME}/.zshenv
	rm -f ${HOME}/.zshrc
	rm -fr $(PLUGIN_DIRECTORY)
	rm -fr $(SHARE)

install: | ${HOME}/.zsh antigen ${FZF}
	mkdir -p $(SHARE)
	#
	ln -snf ${ROOT_DIR}/zlogin ${HOME}/.zlogin
	ln -snf ${ROOT_DIR}/zlogout ${HOME}/.zlogout
	ln -snf ${ROOT_DIR}/zprofile ${HOME}/.zprofile
	ln -snf ${ROOT_DIR}/zshenv ${HOME}/.zshenv
	ln -snf ${ROOT_DIR}/zshrc ${HOME}/.zshrc

antigen: | ${HOME}/.zsh ${PLUGIN_DIRECTORY}/antigen.zsh

${PLUGIN_DIRECTORY}/antigen.zsh:
	mkdir -p ${PLUGIN_DIRECTORY}
	#
	curl --silent --location git.io/antigen --output ${PLUGIN_DIRECTORY}/antigen.zsh

${FZF}:
	git clone --quiet git://github.com/junegunn/fzf.git ${FZF}
	#
	${FZF}/install --completion --key-bindings --no-bash --no-fish --no-update-rc

${HOME}/.zsh:
	ln -snf $(ROOT_DIR) ${HOME}/.zsh

.PHONY: install
