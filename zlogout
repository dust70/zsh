# source the default .zlogout, especially interesting in Gentoo Linux systems
[[ -r /etc/zsh/zlogout ]] && source /etc/zsh/zlogout
[[ -r /etc/zlogout ]]     && source /etc/zlogout

# finally run commands
setopt null_glob
[[ -r ~/.shell/logout ]]  && source ~/.shell/logout

# vim: filetype=zsh textwidth=80 foldmethod=marker
