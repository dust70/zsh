# source default configuration
[[ -r /etc/zsh/zlogin ]]	&& source /etc/zsh/zlogin
[[ -r /etc/zlogin ]]		&& source /etc/zlogin

cd

# load none ZSH components and/or configurations for all shells but jump to HOME
# before
for sh in .shell/*.sh ; do
    [[ -r "${sh}" ]] && source "${sh}"
done

# vim: filetype=zsh textwidth=80 foldmethod=marker
