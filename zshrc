# {{{ pre requirements
# Test for an interactive shell. There is no need to set anything past this
# point for scp and rcp, and it is important to refrain from outputting anything
# in those cases.
if [[ $- != *i* ]]; then
    # Shell is non-interactive. Be done now
    return
fi

# load /etc/profile.d files
source ~/.shell/load-profile
#}}}

# {{{ Parameters Used By The Shell
###############################################################################
# cdpath <S> <Z> (CDPATH <S>)
# An array (colon-separated list) of directories specifying the search path for
# the cd command.
export CDPATH=".:~"

# DIRSTACKSIZE
# The maximum size of the directory stack. If the stack gets larger than this,
# it will be truncated automatically. This is useful with the AUTO_PUSHD option.
export DIRSTACKSIZE="32"

# FCEDIT
# The default editor for the fc builtin.
if [[ -x /usr/bin/vim ]]; then
    export FCEDIT="vim"
elif [[ -x /usr/bin/vi ]]; then
    export FCEDIT="vi"
fi

# HISTFILE
# The file to save the history in when an interactive shell exits. If unset, the
# history is not saved.
export HISTFILE=~/.zsh/history

# HISTSIZE <S>
# The maximum number of events stored in the internal history list. If you use
# the HIST_EXPIRE_DUPS_FIRST option, setting this value larger than the SAVEHIST
# size will give you the difference as a cushion for saving duplicated history
# events.
export HISTSIZE="10000"

# LINES <S>
# The number of lines for this terminal session. Used for printing select lists
# and for the line editor.
export LINES="200"

# LISTMAX
# In the line editor, the number of matches to list without asking first. If the
# value is negative, the list will be shown if it spans at most as many lines as
# given by the absolute value. If set to zero, the shell asks only if the top of
# the listing would scroll off the screen.
export LISTMAX="200"

# LOGCHECK
# The interval in seconds between checks for login/logout activity using the
# watch parameter.
unset LOGCHECK

# MAIL
# If this parameter is set and mailpath is not set, the shell looks for mail in
# the specified file.
unset MAIL

# MAILCHECK
# The interval in seconds between checks for new mail.
unset MAILCHECK

# mailpath <S> <Z> (MAILPATH <S>)
# An array (colon-separated list) of filenames to check for new mail. Each
# filename can be followed by a `?' and a message that will be printed. The
# message will undergo parameter expansion, command substitution and arithmetic
# expansion with the variable $_ defined as the name of the file that has
# changed. The default message is `You have new mail'. If an element is a
# directory instead of a file the shell will recursively check every file in
# every subdirectory of the element.
unset MAILPATH

# PROMPT <S> <Z>
# prompt <S> <Z>
# PS1 <S>
# The primary prompt string, printed before a command is read. the default is
# `%m%# '. It undergoes a special form of expansion before being displayed; see
# 12. Prompt Expansion.
PROMPT="%(!.${BOLD_RED}.${BOLD_BLUE})%n${NO_COLOR} ${BOLD_YELLOW}(%m)${NO_COLOR} ${BOLD_CYAN}%(3~.%3~.%~)${NO_COLOR} ${BOLD_GREY}[%D{%Y-%m-%d %H:%M}]${NO_COLOR} Exitstatus: %(?.${BOLD_GREEN}%?.${BOLD_RED}%?)${NO_COLOR}
${BOLD_MAGENTA}%(!.#.$)${NO_COLOR}:> "

[[ -n ${SSH_CLIENT} ]] && PROMPT="${WHITE}${BACK_RED}REMOTE${NO_COLOR} ${PROMPT}"
export PROMPT

# PROMPT2 <S> <Z>
# PS2 <S>
# The secondary prompt, printed when the shell needs more information to
# complete a command. It is expanded in the same way as PS1. The default is `%_>
# ', which displays any shell constructs or quotation marks which are currently
# being processed.
export PROMPT2="${BOLD_RED}%_${NO_COLOR}> "

# PROMPT3 <S> <Z>
# PS3 <S>
# Selection prompt used within a select loop. It is expanded in the same way as
# PS1. The default is `?# '.
export PROMPT3="${BOLD_RED}?#${NO_COLOR}> "

# PROMPT4 <S> <Z>
# PS4 <S>
# The execution trace prompt. Default is `+%N:%i> ', which displays the name of
# the current shell structure and the line number within it. In sh or ksh
# emulation, the default is `+ '.
export PROMPT4="${BOLD_YELLOW}+%N:%i${NO_COLOR}> "

# REPORTTIME
# If nonnegative, commands whose combined user and system execution times
# (measured in seconds) are greater than this value have timing statistics
# printed for them.
export REPORTTIME="300"

# RPROMPT <S>
# RPS1 <S>
# This prompt is displayed on the right-hand side of the screen when the primary
# prompt is being displayed on the left. This does not work if the SINGLELINEZLE
# option is set. It is expanded in the same way as PS1.
export RPROMPT

# SAVEHIST
# The maximum number of history events to save in the history file.
export SAVEHIST="10000"

# SPROMPT <S>
# The prompt used for spelling correction. The sequence `%R' expands to the
# string which presumably needs spelling correction, and `%r' expands to the
# proposed correction. All other prompt escapes are also allowed.
export SPROMPT="correct '%R' to '%r' [nyae]?"

# TERM <S>
# The type of terminal in use. This is used when looking up termcap sequences.
# An assignment to TERM causes zsh to re-initialize the terminal, even if the
# value does not change (e.g., `TERM=${TERM}'). It is necessary to make such an
# assignment upon any change to the terminal definition database or terminal
# type in order for the new settings to take effect.
case "${TERM}" in
    xterm*)
        export TERM=xterm-256color
        ;;
esac

# watch <S> <Z> (WATCH <S>)
# An array (colon-separated list) of login/logout events to report. If it
# contains the single word `all', then all login/logout events are reported. If
# it contains the single word `notme', then all events are reported as with
# `all' except ${USERNAME}. An entry in this list may consist of a username, an
# `@' followed by a remote hostname, and a `%' followed by a line (tty). Any or
# all of these components may be present in an entry; if a login/logout event
# matches all of them, it is reported.
watch=(notme root)
#}}}

# {{{ Description of Options
###############################################################################
# {{{ Changing Directories
################################################################################
# {{{ AUTO_CD (-J)
# If a command is issued that can"t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd
#}}}

# {{{ AUTO_PUSHD (-N)
# Make cd push the old directory onto the directory stack.
setopt auto_pushd
#}}}

# {{{ CDABLE_VARS (-T)
# If the argument to a cd command (or an implied cd with the AUTO_CD option set)
# is not a directory, and does not begin with a slash, try to expand the
# expression as if it were preceded by a "~" (see the section "Filename
# Expansion").
setopt cdable_vars
#}}}

# {{{ PUSHD_IGNORE_DUPS
# Don"t push multiple copies of the same directory onto the directory stack.
setopt pushd_ignore_dups
#}}}

# {{{ Completion
################################################################################
# {{{ LIST_BEEP <D>
# Beep on an ambiguous completion. More accurately, this forces the completion
# widgets to return status 1 on an ambiguous completion, which causes the shell
# to beep if the option BEEP is also set; this may be modified if completion is
# called from a user-defined widget.
setopt no_list_beep
#}}}

# {{{ LIST_PACKED
# Try to make the completion list smaller (occupying less lines) by printing the
# matches in columns with different widths.
setopt list_packed
#}}}
#}}}

# {{{ Expansion and Globbing
################################################################################
# {{{ CASE_GLOB <D>
# Make globbing (filename generation) sensitive to case. Note that other uses of
# patterns are always sensitive to case. If the option is unset, the presence of
# any character which is special to filename generation will cause
# case-insensitive matching. For example, cvs(/) can match the directory CVS
# owing to the presence of the globbing flag (unless the option BARE_GLOB_QUAL
# is unset).
setopt no_case_glob
#}}}

# {{{ EXTENDED_GLOB
# Treat the "#", "~" and "^" characters as part of patterns for filename
# generation, etc. (An initial unquoted "~" always produces named directory
# expansion.)
setopt extended_glob
#}}}

# {{{ MARK_DIRS (-, ksh: -X)
# Append a trailing "/" to all directory names resulting from filename
# generation (globbing).
setopt mark_dirs
#}}}

# {{{ MULTIBYTE <C> <K> <Z>
# Respect multibyte characters when found in strings. When this option is set,
# strings are examined using the system library to determine how many bytes form
# a character, depending on the current locale. This affects the way characters
# are counted in pattern matching, parameter values and various delimiters.
#
# The option is on by default if the shell was compiled with MULTIBYTE_SUPPORT
# except in sh emulation; otherwise it is off by default and has no effect if
# turned on. The mode is off in sh emulation for compatibility but for
# interative use may need to be turned on if the terminal interprets multibyte
# characters.
#
# If the option is off a single byte is always treated as a single character.
# This setting is designed purely for examining strings known to contain raw
# bytes or other values that may not be characters in the current locale. It is
# not necessary to unset the option merely because the character set for the
# current locale does not contain multibyte characters.
#
# The option does not affect the shell"s editor, which always uses the locale to
# determine multibyte characters. This is because the character set displayed by
# the terminal emulator is independent of shell settings.
setopt no_multibyte
#}}}

# {{{ NOMATCH (+) <C> <Z>
# If a pattern for filename generation has no matches, print an error, instead
# of leaving it unchanged in the argument list. This also applies to file
# expansion of an initial "~" or "=".
setopt nonomatch
#}}}
#}}}

# {{{ History
################################################################################
# {{{ APPEND_HISTORY <D>
# If this is set, zsh sessions will append their history list to the history
# file, rather than replace it. Thus, multiple parallel zsh sessions will all
# have the new entries from their history lists added to the history file, in
# the order that they exit. The file will still be periodically re-written to
# trim it when the number of lines grows 20% beyond the value specified by
# ${SAVEHIST} (see also the HIST_SAVE_BY_COPY option).
setopt append_history
#}}}

# {{{ HIST_BEEP <D>
# Beep when an attempt is made to access a history entry which isn"t there.
setopt no_hist_beep
#}}}

# {{{ HIST_EXPIRE_DUPS_FIRST
# If the internal history needs to be trimmed to add the current command line,
# setting this option will cause the oldest history event that has a duplicate
# to be lost before losing a unique event from the list. You should be sure to
# set the value of HISTSIZE to a larger number than SAVEHIST in order to give
# you some room for the duplicated events, otherwise this option will behave
# just like HIST_IGNORE_ALL_DUPS once the history fills up with unique events.
setopt hist_expire_dups_first
#}}}

# {{{ HIST_FIND_NO_DUPS
# When searching for history entries in the line editor, do not display
# duplicates of a line previously found, even if the duplicates are not
# contiguous.
setopt hist_find_no_dups
#}}}

# {{{ HIST_IGNORE_ALL_DUPS
# If a new command line being added to the history list duplicates an older one,
# the older command is removed from the list (even if it is not the previous
# event).
setopt hist_ignore_all_dups
#}}}

# {{{ HIST_IGNORE_DUPS (-h)
# Do not enter command lines into the history list if they are duplicates of the
# previous event.
setopt hist_ignore_dups
#}}}

# {{{ HIST_IGNORE_SPACE (-g)
# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading space.
# Note that the command lingers in the internal history until the next command
# is entered before it vanishes, allowing you to briefly reuse or edit the line.
# If you want to make it vanish right away without entering another command,
# type a space and press return.
setopt hist_ignore_space
#}}}

# {{{ HIST_NO_FUNCTIONS
# Remove function definitions from the history list. Note that the function
# lingers in the internal history until the next command is entered before it
# vanishes, allowing you to briefly reuse or edit the definition.
setopt hist_no_functions
#}}}

# {{{ HIST_NO_STORE
# Remove the history (fc -l) command from the history list when invoked. Note
# that the command lingers in the internal history until the next command is
# entered before it vanishes, allowing you to briefly reuse or edit the line.
setopt hist_no_store
#}}}

# {{{ HIST_REDUCE_BLANKS
# Remove superfluous blanks from each command line being added to the history
# list.
setopt hist_reduce_blanks
#}}}

# {{{ HIST_SAVE_BY_COPY <D>
# When the history file is re-written, we normally write out a copy of the file
# named ${HISTFILE}.new and then rename it over the old one. However, if this
# option is unset, we instead truncate the old history file and write out the
# new version in-place. If one of the history-appending options is enabled, this
# option only has an effect when the enlarged history file needs to be
# re-written to trim it down to size. Disable this only if you have special
# needs, as doing so makes it possible to lose history entries if zsh gets
# interrupted during the save.
#
# When writing out a copy of the history file, zsh preserves the old file"s
# permissions and group information, but will refuse to write out a new file if
# it would change the history file"s owner.
setopt hist_save_by_copy
#}}}

# {{{ HIST_SAVE_NO_DUPS
# When writing out the history file, older commands that duplicate newer ones
# are omitted.
setopt hist_save_no_dups
#}}}

# {{{ HIST_VERIFY
# Whenever the user enters a line with history expansion, don't execute the line
# directly; instead, perform history expansion and reload the line into the
# editing buffer.
setopt hist_verify
#}}}
#}}}

# {{{ Input/Output
################################################################################
# {{{ CORRECT (-)
# Try to correct the spelling of commands. Note that, when the HASH_LIST_ALL
# option is not set or when some directories in the path are not readable, this
# may falsely report spelling errors the first time some commands are used.
setopt correct
#}}}

# {{{ MAIL_WARNING (-U)
# Print a warning message if a mail file has been accessed since the shell last
# checked.
setopt no_mail_warning
#}}}

# {{{ SHORT_LOOPS <C> <Z>
# Allow the short forms of for, repeat, select, if, and function constructs.
setopt short_loops
#}}}
#}}}

# {{{ Job Control
################################################################################
# {{{ AUTO_CONTINUE
# With this option set, stopped jobs that are removed from the job table with
# the disown builtin command are automatically sent a CONT signal to make them
# running.
setopt auto_continue
#}}}

# {{{ CHECK_JOBS <Z>
# Report the status of background and suspended jobs before exiting a shell with
# job control; a second attempt to exit the shell will succeed. NO_CHECK_JOBS is
# best used only in combination with NO_HUP, else such jobs will be killed
# automatically.
#
# The check is omitted if the commands run from the previous command line
# included a "jobs" command, since it is assumed the user is aware that there
# are background or suspended jobs. A "jobs" command run from one of the hook
# functions defined in the section SPECIAL FUNCTIONS in zshmisc(1) is not
# counted for this purpose.
setopt no_check_jobs
#}}}

# {{{ LONG_LIST_JOBS (-R)
# List jobs in the long format by default.
setopt long_list_jobs
#}}}

# {{{ MONITOR (-m, ksh: -m)
# Allow job control. Set by default in interactive shells.
setopt monitor
#}}}

# {{{ NOTIFY (-, ksh: -b) <Z>
# Report the status of background jobs immediately, rather than waiting until
# just before printing a prompt.
setopt notify
#}}}
#}}}

# {{{ Scripts and Functions
################################################################################
# {{{ MULTIOS <Z>
# Perform implicit tees or cats when multiple redirections are attempted (see
# the section "Redirection").
setopt multios
#}}}
#}}}

# {{{ Shell Emulation
################################################################################
# {{{ POSIX_BUILTINS <K> <S>
# When this option is set the command builtin can be used to execute shell
# builtin commands. Parameter assignments specified before shell functions and
# special builtins are kept after the command completes unless the special
# builtin is prefixed with the command builtin. Special builtins are ., :,
# break, continue, declare, eval, exit, export, integer, local, readonly,
# return, set, shift, source, times, trap and unset.
setopt posix_builtins
#}}}
#}}}

# {{{ Zle
################################################################################
# {{{ BEEP (+B) <D>
# Beep on error in ZLE.
setopt nobeep
#}}}

# {{{ EMACS
# If ZLE is loaded, turning on this option has the equivalent effect of "bindkey
# -e". In addition, the VI option is unset. Turning it off has no effect. The
# option setting is not guaranteed to reflect the current keymap. This option is
# provided for compatibility; bindkey is the recommended interface.
setopt no_emacs
#}}}

# {{{ VI
# If ZLE is loaded, turning on this option has the equivalent effect of "bindkey
# -v". In addition, the EMACS option is unset. Turning it off has no effect. The
# option setting is not guaranteed to reflect the current keymap. This option is
# provided for compatibility; bindkey is the recommended interface.
setopt vi
#}}}

# {{{ PromptSubst
setopt promptsubst
#}}}
#}}}
#}}}

# {{{ Hashes
################################################################################
# hash [ -Ldfmrv ] [ name[=value] ] ...
#
# hash can be used to directly modify the contents of the command hash table,
# and the named directory hash table. Normally one would modify these tables by
# modifying one's PATH (for the command hash table) or by creating appropriate
# shell parameters (for the named directory hash table). The choice of hash
# table to work on is determined by the -d option; without the option the
# command hash table is used, and with the option the named directory hash table
# is used.
#
# Given no arguments, and neither the -r or -f options, the selected hash table
# will be listed in full.
#
# The -r option causes the selected hash table to be emptied. It will be
# subsequently rebuilt in the normal fashion. The -f option causes the selected
# hash table to be fully rebuilt immediately. For the command hash table this
# hashes all the absolute directories in the PATH, and for the named directory
# hash table this adds all users' home directories. These two options cannot be
# used with any arguments.
#
# The -m option causes the arguments to be taken as patterns (which should be
# quoted) and the elements of the hash table matching those patterns are
# printed. This is the only way to display a limited selection of hash table
# elements.
#
# For each name with a corresponding value, put `name' in the selected hash
# table, associating it with the pathname `value'. In the command hash table,
# this means that whenever `name' is used as a command argument, the shell will
# try to execute the file given by `value'. In the named directory hash table,
# this means that `value' may be referred to as `~name'.
#
# For each name with no corresponding value, attempt to add name to the hash
# table, checking what the appropriate value is in the normal manner for that
# hash table. If an appropriate value can't be found, then the hash table will
# be unchanged.
#
# The -v option causes hash table entries to be listed as they are added by
# explicit specification. If has no effect if used with -f.
#
# If the -L flag is present, then each hash table entry is printed in the form
# of a call to hash.
unhash -dm "*"

if [[ -d ~/.dotfiles ]]; then
    hash -d dotfiles=~/.dotfiles
    for i in ~/.dotfiles/*(/); do
        hash -d "dot$(basename ${i})"="${i}"
    done
fi

if [[ -d ~/repositories ]]; then
    for i in ~/repositories/*(/); do
        hash -d "repo$(basename ${i})"="${i}"
    done
fi

if [[ -d ~/git ]]; then
    for i in ~/git; do
        hash -d "git$(basename ${i})"="${i}"
    done
fi
#}}}

# {{{ Aliases
################################################################################
# alias [ {+|-}gmrsL ] [ name[=value] ... ]
# For each name with a corresponding value, define an alias with that value. A
# trailing space in value causes the next word to be checked for alias
# expansion. If the -g flag is present, define a global alias; global aliases
# are expanded even if they do not occur in command position.
#
# If the -s flags is present, define a suffix alias: if the command word on a
# command line is in the form `text.name', where text is any non-empty string,
# it is replaced by the text `value text.name'. Note that name is treated as a
# literal string, not a pattern. A trailing space in value is not special in
# this case. For example,
#
#   alias -s ps=gv
#
# will cause the command `*.ps' to be expanded to `gv *.ps'. As alias expansion
# is carried out earlier than globbing, the `*.ps' will then be expanded. Suffix
# aliases constitute a different name space from other aliases (so in the above
# example it is still possible to create an alias for the command ps) and the
# two sets are never listed together.
#
# For each name with no value, print the value of name, if any. With no
# arguments, print all currently defined aliases other than suffix aliases. If
# the -m flag is given the arguments are taken as patterns (they should be
# quoted to preserve them from being interpreted as glob patterns), and the
# aliases matching these patterns are printed. When printing aliases and one of
# the -g, -r or -s flags is present, restrict the printing to global, regular or
# suffix aliases, respectively; a regular alias is one which is neither a global
# nor a suffix alias. Using `+' instead of `-', or ending the option list with a
# single `+', prevents the values of the aliases from being printed.
#
# If the -L flag is present, then print each alias in a manner suitable for
# putting in a startup script. The exit status is nonzero if a name (with no
# value) is given for which no alias has been defined.

# resetting aliases
unhash -ma "*"
unhash -ms "*"

# Global aliases
alias -g G='|& egrep --ignore-case'
alias -g N='&> /dev/null'

# remap the buildin commads
alias which='whence -vas'
alias where='whence -cas'

# search an specific alias
alias aliasgrep='alias G'

# no spell correction for cp, mv, rm, mkdir, rmdir and adding default options
alias cp='nocorrect cp -v'
alias mv='nocorrect mv -v'
alias ln='nocorrect ln -v'
alias mkdir='nocorrect mkdir -v'
#}}}

# {{{ function
###############################################################################
#unhash -mf "*"

# Provides useful information on globbing
function zsh_help() {
echo -e "
/       directories
.       plain files
@       symbolic links
=       sockets
p       named pipes (FIFOs)
*       executable plain files (0100)
%       device files (character or block special)
%b      block special files
%c      character special files
r       owner-readable files (0400)
w       owner-writable files (0200)
x       owner-executable files (0100)
A       group-readable files (0040)
I       group-writable files (0020)
E       group-executable files (0010)
R       world-readable files (0004)
W       world-writable files (0002)
X       world-executable files (0001)
s       setuid files (04000)
S       setgid files (02000)
t       files with the sticky bit (01000)

print *(m-1)                    # Files modified up to a day ago
print *(a1)                     # Files accessed a day ago
print *(@)                      # Just symlinks
print *(Lk+50)                  # Files bigger than 50 kilobytes
print *(Lk-50)                  # Files smaller than 50 kilobytes
print **/*.c                    # All *.c files recursively starting in \${PWD}
print **/*.c~file.c             # Same as above, but excluding 'file.c'
print (foo|bar).*               # Files starting with 'foo' or 'bar'
print *~*.*                     # All Files that do not contain a dot
chmod 644 *(.^x)                # make all plain non-executable files publically readable
print -l *(.c|.h)               # Lists *.c and *.h
print **/*(g:users:)            # Recursively match all files that are owned by group 'users'
echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print ${1}}'<"
}

# setting the windowtitle
function title() {
    case ${TERM} in
        *rxvt*|*screen*|*term*)
            # Use this one instead for XTerms:
            print -nR $'\033]0;'$*$'\a'
            ;;
        *)
            ;;
    esac
}

# setting title once
title Shell ${USER}@${HOST}

# Executed before each prompt. Note that precommand functions are not reexecuted
# simply because the command line is redrawn, as happens, for example, when a
# notification about an exiting job is displayed.
function precmd() {
    vcs_info prompt
    if [[ -n ${vcs_info_msg_0_} ]]; then
        RPROMPT="${vcs_info_msg_0_} "
    else
        RPROMPT=""
    fi
}
#}}}

# {{{ ulimit
###############################################################################
# ulimit [ -SHacdflmnpstv [ limit ] ... ]
# Set or display resource limits of the shell and the processes started by the
# shell. The value of limit can be a number in the unit specified below or the
# value `unlimited'. By default, only soft limits are manipulated. If the -H
# flag is given use hard limits instead of soft limits. If the -S flag is given
# together with the -H flag set both hard and soft limits. If no options are
# used, the file size limit (-f) is assumed. If limit is omitted the current
# value of the specified resources are printed. When more than one resource
# values are printed the limit name and unit is printed before each value.
#   -a
#       Lists all of the current resource limits.
#   -c
#       512-byte blocks on the size of core dumps.
#   -d
#       K-bytes on the size of the data segment.
#   -f
#       512-byte blocks on the size of files written.
#   -l
#       K-bytes on the size of locked-in memory.
#   -m
#       K-bytes on the size of physical memory.
#   -n
#       open file descriptors.
#   -s
#       K-bytes on the size of the stack.
#   -t
#       CPU seconds to be used.
#   -u
#       processes available to the user.
#   -v
#       K-bytes on the size of virtual memory. On some systems this refers to
#       the limit called `address space'.
unlimit
limit stack 8192
limit core 0
limit -s
#}}}

# {{{ umask
###############################################################################
# umask [ -S ] [ mask ]
# The umask is set to mask. mask can be either an octal number or a symbolic
# value as described in man page chmod(1). If mask is omitted, the current value
# is printed. The -S option causes the mask to be printed as a symbolic value.
# Otherwise, the mask is printed as an octal number. Note that in the symbolic
# form the permissions you specify are those which are to be allowed (not
# denied) to the users specified.
umask 077
#}}}

# {{{ Keymaps
###############################################################################
# bindkey's options can be divided into three categories: keymap selection,
# operation selection, and others. The keymap selection options are:
#   -e          - Selects keymap `emacs', and also links it to `main'.
#   -v          - Selects keymap `viins', and also links it to `main'.
#   -a          - Selects keymap `vicmd'.
#   -M keymap   - The keymap specifies a keymap name.
#
#   If a keymap selection is required and none of the options above are used,
#   the `main' keymap is used. Some operations do not permit a keymap to be
#   selected, namely:
#   -l          - List all existing keymap names. If the -L option is also used,
#                 list in the form of bindkey commands to create the keymaps.
#   -d          - Delete all existing keymaps and reset to the default state.
#   -D keymap ...
#                 Delete the named keymaps.
#   -A old-keymap new-keymap
#                 Make the new-keymap name an alias for old-keymap, so that both
#                 names refer to the same keymap. The names have equal standing;
#                 if either is deleted, the other remains. If there is already a
#                 keymap with the new-keymap name, it is deleted.
#   -N new-keymap [ old-keymap ]
#                 Create a new keymap, named new-keymap. If a keymap already has
#                 that name, it is deleted. If an old-keymap name is given, the
#                 new keymap is initialized to be a duplicate of it, otherwise
#                 the new keymap will be empty.
#
#   To use a newly created keymap, it should be linked to main. Hence the
#   sequence of commands to create and use a new keymap `mymap' initialized from
#   the emacs keymap (which remains unchanged) is:
#
#       bindkey -N mymap emacs
#       bindkey -A mymap main
#
#   Note that while `bindkey -A newmap main' will work when newmap is emacs or
#   viins, it will not work for vicmd, as switching from vi insert to command
#   mode becomes impossible.
#
#   The following operations act on the `main' keymap if no keymap selection
#   option was given:
#   -m  Add the built-in set of meta-key bindings to the selected keymap. Only
#       keys that are unbound or bound to self-insert are affected.
#
#   -r in-string ...
#       Unbind the specified in-strings in the selected keymap. This is exactly
#       equivalent to binding the strings to undefined-key.
#
#       When -R is also used, interpret the in-strings as ranges.
#
#       When -p is also used, the in-strings specify prefixes. Any binding that
#       has the given in-string as a prefix, not including the binding for the
#       in-string itself, if any, will be removed. For example,
#
#           bindkey -rpM viins '^['
#
#       will remove all bindings in the vi-insert keymap beginning with an
#       escape character (probably cursor keys), but leave the binding for the
#       escape character itself (probably vi-cmd-mode). This is incompatible
#       with the option -R.
#
#   -s in-string out-string ...
#       Bind each in-string to each out-string. When in-string is typed,
#       out-string will be pushed back and treated as input to the line editor.
#       When -R is also used, interpret the in-strings as ranges.
#
#   in-string command ...
#       Bind each in-string to each command. When -R is used, interpret the
#       in-strings as ranges.
#
#   [ in-string ]
#       List key bindings. If an in-string is specified, the binding of that
#       string in the selected keymap is displayed. Otherwise, all key bindings
#       in the selected keymap are displayed. (As a special case, if the -e or
#       -v option is used alone, the keymap is not displayed - the implicit
#       linking of keymaps is the only thing that happens.)
#
#       When the option -p is used, the in-string must be present. The listing
#       shows all bindings which have the given key sequence as a prefix, not
#       including any bindings for the key sequence itself.
#
#       When the -L option is used, the list is in the form of bindkey commands
#       to create the key bindings.
#
#   When the -R option is used as noted above, a valid range consists of two
#   characters, with an optional `-' between them. All characters between the
#   two specified, inclusive, are bound as specified.
bindkey -v
#}}}

# {{{ Keyboard Definition
###############################################################################
# The large number of possible combinations of keyboards, workstations,
# terminals, emulators, and window systems makes it impossible for zsh to have
# builtin key bindings for every situation. The zkbd utility, found in
# Functions/Misc, can help you quickly create key bindings for your
# configuration.
#
# Run zkbd either as an autoloaded function, or as a shell script:
#
#   zsh -f ~/zsh-4.3.6/Functions/Misc/zkbd
#
# When you run zkbd, it first asks you to enter your terminal type; if the
# default it offers is correct, just press return. It then asks you to press a
# number of different keys to determine characteristics of your keyboard and
# terminal; zkbd warns you if it finds anything out of the ordinary, such as a
# Delete key that sends neither ^H nor ^?.
#
# The keystrokes read by zkbd are recorded as a definition for an associative
# array named key, written to a file in the subdirectory .zkbd within either
# your HOME or ZDOTDIR directory. The name of the file is composed from the
# TERM, VENDOR and OSTYPE parameters, joined by hyphens.
#
# You may read this file into your .zshrc or another startup file with the
# `source' or `.' commands, then reference the key parameter in bindkey
# commands, like this:
#
#   source ${ZDOTDIR:-~}/.zkbd/${TERM-}${VENDOR-}${OSTYPE}
#   [[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
#   [[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
#   # etc.
#
# Note that in order for `autoload zkbd' to work, the zkdb file must be in
# one of the directories named in your fpath array (see zshparam(1)). This
# should already be the case if you have a standard zsh installation; if it
# is not, copy Functions/Misc/zkbd to an appropriate directory.
autoload -Uz zkbd

if [[ "$TERM" != emacs ]]; then
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
    [[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
    [[ -z "$terminfo[kend]" ]] || bindkey -M vicmd "$terminfo[kend]" vi-end-of-line
    [[ -z "$terminfo[cuu1]" ]] || bindkey -M viins "$terminfo[cuu1]" vi-up-line-or-history
    [[ -z "$terminfo[cuf1]" ]] || bindkey -M viins "$terminfo[cuf1]" vi-forward-char
    [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" vi-up-line-or-history
    [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" vi-down-line-or-history
    [[ -z "$terminfo[kcuf1]" ]] || bindkey -M viins "$terminfo[kcuf1]" vi-forward-char
    [[ -z "$terminfo[kcub1]" ]] || bindkey -M viins "$terminfo[kcub1]" vi-backward-char

    # k Shift-tab Perform backwards menu completion
    if [[ -n "$terminfo[kcbt]" ]]; then
        bindkey -M viins "$terminfo[kcbt]" reverse-menu-complete
    elif [[ -n "$terminfo[cbt]" ]]; then
        bindkey -M viins "$terminfo[cbt]" reverse-menu-complete
    fi

    # ncurses stuff:
    [[ "$terminfo[kcuu1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" vi-up-line-or-history
    [[ "$terminfo[kcud1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" vi-down-line-or-history
    [[ "$terminfo[kcuf1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuf1]/O/[}" vi-forward-char
    [[ "$terminfo[kcub1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcub1]/O/[}" vi-backward-char
    [[ "$terminfo[khome]" == $'\eO'* ]] && bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
    [[ "$terminfo[kend]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kend]/O/[}" end-of-line
fi

bindkey '\e[1~' beginning-of-line       # home
bindkey '\e[4~' end-of-line             # end
bindkey '\e[A' up-line-or-search        # cursor up
bindkey '\e[B' down-line-or-search      # <ESC>-

bindkey '^xp' history-beginning-search-backward
bindkey '^xP' history-beginning-search-forward

# beginning-of-line (^A) (unbound) (unbound)
# Move to the beginning of the line. If already at the beginning of the line,
# move to the beginning of the previous line, if any.
if [[ -n "${key[Home]}" ]]; then
    bindkey "${key[Home]}" beginning-of-line
    bindkey -M vicmd "${key[Home]}" vi-beginning-of-line
    bindkey -M viins "${key[Home]}" vi-beginning-of-line
fi

# end-of-line (^E) (unbound) (unbound)
# Move to the end of the line. If already at the end of the line, move to the
# end of the next line, if any.
if [[ -n "${key[End]}" ]]; then
    bindkey "${key[End]}" end-of-line
    bindkey -M vicmd "${key[End]}" vi-end-of-line
    bindkey -M viins "${key[End]}" vi-end-of-line
fi

# vi-delete-char (unbound) (x) (unbound)
# Delete the character under the cursor, without going past the end of the line.
if [[ -n "${key[Delete]}" ]]; then
    bindkey "${key[Delete]}" delete-char
    bindkey -M vicmd "${key[Delete]}" vi-delete-char
    bindkey -M viins "${key[Delete]}" vi-delete-char
fi

# backward-delete-char (^H ^?) (unbound) (unbound)
# Delete the character behind the cursor.
if [[ -n "${key[Backspace]}" ]]; then
    bindkey "${key[Backspace]}" backward-delete-char
    bindkey -M viins "${key[Backspace]}" backward-delete-char
    #bindkey -M vicmd "${key[Backspace]}" backward-delete-char
fi

# overwrite-mode (^X^O) (unbound) (unbound)
# Toggle between overwrite mode and insert mode.
if [[ -n "${key[Insert]}" ]]; then
    bindkey -M viins "${key[Insert]}" overwrite-mode
    bindkey -M emacs "${key[Insert]}" overwrite-mode
fi

# up-line-or-search
# Move up a line in the buffer, or if already at the top line, search backward
# in the history for a line beginning with the first word in the buffer.
[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" up-line-or-search

# down-line-or-search
# Move down a line in the buffer, or if already at the bottom line, search
# forward in the history for a line beginning with the first word in the buffer.
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-search

# history-incremental-search-backward (^R ^Xr) (unbound) (unbound)
# Search backward incrementally for a specified string. The search is
# case-insensitive if the search string does not have uppercase letters and no
# numeric argument was given. The string may begin with "^" to anchor the search
# to the beginning of the line.
bindkey -M vicmd "\C-r" history-incremental-search-backward
bindkey -M viins "\C-r" history-incremental-search-backward

# history-incremental-search-forward (^S ^Xs) (unbound) (unbound)
# Search forward incrementally for a specified string. The search is
# case-insensitive if the search string does not have uppercase letters and no
# numeric argument was given. The string may begin with "^" to anchor the search
# to the beginning of the line. The functions available in the mini-buffer are
# the same as for history-incremental-search-backward.
bindkey -M vicmd "\C-s" history-incremental-search-forward
bindkey -M viins "\C-s" history-incremental-search-forward

# The zsh/complist Module
# The zsh/complist module offers three extensions to completion listings: the
# ability to highlight matches in such a list, the ability to scroll through
# long lists and a different style of menu completion.
autoload -Uz zsh/complist
zmodload -i zsh/complist

# accept-and-menu-complete
# In a menu completion, insert the current completion into the buffer, and
# advance to the next possible completion.
bindkey -M menuselect '\e^M' accept-and-menu-complete
#}}}

# {{{ Completion System
################################################################################
# This section describes the use of compinit to initialize completion for the
# current session when called directly; if you have run compinstall it will be
# called automatically from your .zshrc.
zstyle ':completion:*' completer _complete _ignored _approximate

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:corrections' format \
    $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*' original true

# activate color-completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# format on completion
zstyle ':completion:*:descriptions' format \
    $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:history-words' list false

# activate menu
zstyle ':completion:*:history-words' menu yes

# ignore duplicate entries
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' stop yes

# match uppercase from lowercase
zstyle ':completion:*' matcher-list \
    'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# separate matches into groups
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''

# if there are more than 3 options allow selecting from a menu
zstyle ':completion:*' menu select=3

zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:options' auto-description '%d'

# describe options in full
zstyle ':completion:*:options' description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command \
    'ps c -u ${USER} -o command | uniq'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# set format for warnings
zstyle ':completion:*:warnings' format \
    $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:' prompt 'correct to: %e'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# complete manual by their section
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true
zstyle ':completion:*:man:*' menu yes select

# host completion
zstyle -e ':completion:*:hosts' hosts 'reply=(
    ${${${${${(f)"$(<${HOME}/.ssh/known_hosts)"//\[/}//\]:/ }:#[\|]*}%%\*}%%,*}
    ${${${(@M)${(f)"$(<${HOME}/.ssh/config)"}:#Host *}#Host }:#*[*?]*}
    ${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}#*[[:blank:]]}}
)'
zstyle ':completion:*:*:*:hosts' ignored-patterns 'ip6*' 'localhost*'
zstyle -e ':completion:*:*:ssh:*:my-accounts' users-hosts \
    '[[ -f ~/.ssh/config && $key = hosts ]] && key=my_hosts reply=()'

# completion order for git push
zstyle ':completion:*:git-push:*' tag-order remotes '*'

autoload -Uz compinit
compinit -u

# vcs_info
# In a lot of cases, it is nice to automatically retrieve information from
# version control systems (VCSs), such as subversion, CVS or git, to be able to
# provide it to the user; possibly in the user's prompt. So that you can
# instantly tell on which branch you are currently on, for example
autoload -Uz vcs_info

zstyle ':vcs_info:*' disable ALL
zstyle ':vcs_info:*' enable git

zstyle ':vcs_info:*:prompt:*' actionformats "(${BOLD_BLACK}%s${NO_COLOR}) [ ${BOLD_CYAN}%b${NO_COLOR}|${BOLD_YELLOW}%a${NO_COLOR} ] "
zstyle ':vcs_info:*:prompt:*' branchformat "${BOLD_CYAN}%b${NO_COLOR}: ${BOLD_GREEN}%r"
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' formats "%u%c${NO_COLOR} (${BOLD_BLACK}%s${NO_COLOR}) [${BOLD_CYAN}%b${NO_COLOR}] ${MAGENTA}%7.7i${NO_COLOR}"
zstyle ':vcs_info:*:prompt:*' get-revision true
zstyle ':vcs_info:*:prompt:*' stagedstr "${BOLD_GREEN}*"
zstyle ':vcs_info:*:prompt:*' unstagedstr "${BOLD_YELLOW}*"
#}}}
#}}}

# # {{{ ZSh Modules
################################################################################
# THE ZSH/COMPLETE MODULE
# The zsh/complete module makes available several builtin commands which can be
# used in user-defined completion widgets, see zshcompwid(1).
autoload -Uz zsh/complete

# THE ZSH/TERMCAP MODULE
# The zsh/termcap module makes available one builtin command:
#
# echotc cap [ arg ... ]
#   Output the termcap value corresponding to the capability cap, with optional
#   arguments.
#
# The zsh/termcap module makes available one parameter:
# termcap
#   An associative array that maps termcap capability codes to their values.
autoload -Uz zsh/termcap
#}}}

# {{{ Load Resources
# load none ZSH components and/or configurations for all shells but jump to HOME
# before
for sh in ~/.shell/*.sh; do
    [[ -r "${sh}" ]] && source "${sh}" || true
done
#}}}

# vim: filetype=zsh textwidth=80 foldmethod=marker
