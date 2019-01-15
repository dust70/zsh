ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHARE = ${HOME}/.cache/zsh

PLUGIN_DIRECTORY = plugin

.PHONE: install

clean:
	rm -f ${HOME}/.zcompdump
	rm -f ${HOME}/.zlogin
	rm -f ${HOME}/.zlogout
	rm -f ${HOME}/.zprofile
	rm -f ${HOME}/.zshenv
	rm -f ${HOME}/.zshrc
	rm -fr ${SHARE}
	rm -fr plugin

install: | install_repos
	ln -snf ${ROOT_DIR}/zlogin ${HOME}/.zlogin
	ln -snf ${ROOT_DIR}/zlogout ${HOME}/.zlogout
	ln -snf ${ROOT_DIR}/zprofile ${HOME}/.zprofile
	ln -snf ${ROOT_DIR}/zshenv ${HOME}/.zshenv
	ln -snf ${ROOT_DIR}/zshrc ${HOME}/.zshrc
	mkdir -p ${SHARE}

update: install_repos
	git --work-tree=$(PLUGIN_DIRECTORY)/autosuggestions checkout -f
	git --work-tree=$(PLUGIN_DIRECTORY)/autosuggestions pull
	git --work-tree=$(PLUGIN_DIRECTORY)/completions checkout -f
	git --work-tree=$(PLUGIN_DIRECTORY)/completions pull
	git --work-tree=$(PLUGIN_DIRECTORY)/fuzzy-search checkout -f
	git --work-tree=$(PLUGIN_DIRECTORY)/fuzzy-search pull

install_repos: | $(PLUGIN_DIRECTORY)/autosuggestions $(PLUGIN_DIRECTORY)/completions $(PLUGIN_DIRECTORY)/fuzzy-search

$(PLUGIN_DIRECTORY)/autosuggestions:
	git clone git://github.com/zsh-users/zsh-autosuggestions $(PLUGIN_DIRECTORY)/autosuggestions

$(PLUGIN_DIRECTORY)/completions:
	git clone git://github.com/zsh-users/zsh-completions.git $(PLUGIN_DIRECTORY)/completions

$(PLUGIN_DIRECTORY)/fuzzy-search:
	git clone git://github.com/junegunn/fzf.git $(PLUGIN_DIRECTORY)/fuzzy-search
