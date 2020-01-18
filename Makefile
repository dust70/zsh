ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

SHARE = ${HOME}/.cache/zsh
PLUGIN_DIRECTORY = plugin

clean:
	rm -f ${HOME}/.zcompdump
	rm -f ${HOME}/.zlogin
	rm -f ${HOME}/.zlogout
	rm -f ${HOME}/.zprofile
	rm -f ${HOME}/.zshenv
	rm -f ${HOME}/.zshrc
	rm -fr $(SHARE)
	rm -fr $(PLUGIN_DIRECTORY)

install: | ${HOME}/.zsh install_repos
	mkdir -p $(SHARE)
	#
	ln -snf ${ROOT_DIR}/zlogin ${HOME}/.zlogin
	ln -snf ${ROOT_DIR}/zlogout ${HOME}/.zlogout
	ln -snf ${ROOT_DIR}/zprofile ${HOME}/.zprofile
	ln -snf ${ROOT_DIR}/zshenv ${HOME}/.zshenv
	ln -snf ${ROOT_DIR}/zshrc ${HOME}/.zshrc

update: install_repos
	git --work-tree=$(PLUGIN_DIRECTORY)/autosuggestions checkout -f
	git --work-tree=$(PLUGIN_DIRECTORY)/autosuggestions pull
	#
	git --work-tree=$(PLUGIN_DIRECTORY)/completions checkout -f
	git --work-tree=$(PLUGIN_DIRECTORY)/completions pull
	#
	git --work-tree=$(PLUGIN_DIRECTORY)/fuzzy-search checkout -f
	git --work-tree=$(PLUGIN_DIRECTORY)/fuzzy-search pull
	$(PLUGIN_DIRECTORY)/fuzzy-search/install --64 --completion --key-bindings --no-bash --no-fish --no-update-rc

$(PLUGIN_DIRECTORY)/autosuggestions:
	git clone git://github.com/zsh-users/zsh-autosuggestions $(PLUGIN_DIRECTORY)/autosuggestions

$(PLUGIN_DIRECTORY)/completions:
	git clone git://github.com/zsh-users/zsh-completions.git $(PLUGIN_DIRECTORY)/completions

$(PLUGIN_DIRECTORY)/fuzzy-search:
	git clone git://github.com/junegunn/fzf.git $(PLUGIN_DIRECTORY)/fuzzy-search
	$(PLUGIN_DIRECTORY)/fuzzy-search/install --64 --completion --key-bindings --no-bash --no-fish --no-update-rc

${HOME}/.zsh:
	ln -snf $(ROOT_DIR) ${HOME}/.zsh

install_repos: | $(PLUGIN_DIRECTORY)/autosuggestions $(PLUGIN_DIRECTORY)/completions $(PLUGIN_DIRECTORY)/fuzzy-search

.PHONY: install_repos
