# source /etc/profile
[[ -r /etc/profile ]]    && source /etc/profile      || true

# source the default zprofile, especialy interisting in Gentoo Linux systems
[ -r /etc/zsh/zprofile ] && source /etc/zsh/zprofile || true
[ -r /etc/zprofile ]     && source /etc/zprofile     || true

# Mesg controls the access to your terminal by others. It's typically used to
# allow or disallow other users to write to your terminal (see write(1)).
[[ -x /usr/bin/mesg ]]   && /usr/bin/mesg n

# vim: filetype=zsh textwidth=80 foldmethod=marker
