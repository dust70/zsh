SOURCE = ${HOME}/.dotfiles/zsh
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

install:
	git clone git://github.com/zsh-users/zsh-autosuggestions plugin/autosuggestions
	git clone git://github.com/zsh-users/zsh-completions.git plugin/completions
	ln -snf ${SOURCE} ${HOME}/.zsh
	ln -snf ${SOURCE}/zlogin ${HOME}/.zlogin
	ln -snf ${SOURCE}/zlogout ${HOME}/.zlogout
	ln -snf ${SOURCE}/zshenv ${HOME}/.zshenv
	ln -snf ${SOURCE}/zshrc ${HOME}/.zshrc
	mkdir -p ${SHARE}
