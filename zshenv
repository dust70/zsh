# language settings (read in /etc/environment before /etc/default/locale as
# the latter one is the default on Debian nowadays)
# no xsource() here because it's only created in zshrc! (which is good)
[[ -r /etc/environment ]] && source /etc/environment || true

# source the default .zshenv, especialy interisting in Gentoo Linux systems
[[ -r /etc/zsh/zshenv ]]  && source /etc/zsh/zshenv  || true
[[ -r /etc/zshenv ]]      && source /etc/zshenv      || true
[[ -r ~/.shell/exports ]] && source ~/.shell/exports || true

if [[ $- = *i* ]]; then
    autoload -Uz colors zsh/terminfo
    [[ $terminfo[colors] -ge 8 ]] && colors

    NO_COLOR=%{$reset_color%}

    BLINK=%{$terminfo[blink]%}
    INVERSE=%{$terminfo[inverse]%}
    UNDERLINE=%{$terminfo[underline]%}
    BOLD=%{$bold_color%}

    for color in BLACK BLUE CYAN DEFAULT GREEN GREY MAGENTA RED WHITE YELLOW
    do
	builtin eval ${color}=%{$fg[${(L)color}]%}
	builtin eval BACK_${color}=%{$bg[${(L)color}]%}

	builtin eval BOLD_${color}=%{${BOLD}$fg[${(L)color}]%}
	builtin eval BACKBOLD${color}=%{${BOLD}$bg[${(L)color}]%}
    done

    # colors for ls, etc.
    if [[ -x /usr/bin/dircolors ]]; then
	builtin eval $(dircolors -b)
    fi
fi

# TODO: remove this when all distribition add the new terminfo entry for
#       rxvt-unicode-256color to their package
export TERM=${TERM/-unicode}

# language variables
export LANG=en_US
export LC_CTYPE=en_US.utf8
export LC_NUMERIC=en_US.utf8
export LC_TIME=de_DE.utf8
export LC_COLLATE=en_US.utf8
export LC_MONETARY=en_US.utf8
export LC_MESSAGES=en_US.utf8
export LC_PAPER=de_DE.utf8
export LC_NAME=en_US.utf8
export LC_ADDRESS=en_US.utf8
export LC_TELEPHONE=en_US.utf8
export LC_MEASUREMENT=en_US.utf8
export LC_IDENTIFICATION=en_US.utf8
export LC_ALL=

export HOSTNAME=${HOST:-`uname -n 2>/dev/null || echo unknown`}

# vim: filetype=zsh textwidth=80 foldmethod=marker
