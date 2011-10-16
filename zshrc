# {{{ OVERVIEW
###############################################################################
# Because zsh contains many features, the zsh manual has been split into a
# number of sections. This manual page includes all the separate manual pages in
# the following order:
#
#   zshroadmap	Informal introduction to the manual
#   zshmisc	Anything not fitting into the other sections
#   zshexpn	Zsh command and parameter expansion
#   zshparam	Zsh parameters
#   zshoptions	Zsh options
#   zshbuiltins	Zsh built-in functions
#   zshzle	Zsh command line editing
#   zshcompwid	Zsh completion widgets
#   zshcompsys	Zsh completion system
#   zshcompctl	Zsh completion control
#   zshmodules	Zsh loadable modules
#   zshcalsys	Zsh built-in calendar functions
#   zshtcpsys	Zsh built-in TCP functions
#   zshzftpsys	Zsh built-in FTP client
#   zshcontrib	Additional zsh functions and utilities
###############################################################################

# Test for an interactive shell. There is no need to set anything past this
# point for scp and rcp, and it is important to refrain from outputting anything
# in those cases.
if [[ $- != *i* ]]; then
    # Shell is non-interactive. Be done now
    return
fi

# source the default .zshrc, especialy interisting in Gentoo Linux systems
[[ -r /etc/profile ]]   && source /etc/profile   || true
[[ -r /etc/zsh/zshrc ]] && source /etc/zsh/zshrc || true
[[ -r /etc/zshrc ]]     && source /etc/zshrc     || true

# clear screen once
clear #}}}

# {{{ CONDITIONAL EXPRESSIONS
###############################################################################
# A conditional expression is used with the [[ compound command to test
# attributes of files and to compare strings. Each expression can be constructed
# from one or more of the following unary or binary expressions:
#
#   -a file
#	true if file exists.
#
#   -b file
#	true if file exists and is a block special file.
#
#   -c file
#	true if file exists and is a character special file.
#
#   -d file
#	true if file exists and is a directory.
#
#   -e file
#	true if file exists.
#
#   -f file
#	true if file exists and is a regular file.
#
#   -g file
#	true if file exists and has its setgid bit set.
#
#   -h file
#	true if file exists and is a symbolic link.
#
#   -k file
#	true if file exists and has its sticky bit set.
#
#   -n string
#	true if length of string is non-zero.
#
#   -o option
#	true if option named option is on. option may be a single character, in
#	which case it is a single letter option name. (See the section
#	`Specifying Options'.)
#
#   -p file
#	true if file exists and is a FIFO special file (named pipe).
#
#   -r file
#	true if file exists and is readable by current process.
#
#   -s file
#	true if file exists and has size greater than zero.
#
#   -t fd
#	true if file descriptor number fd is open and associated with a terminal
#	device. (note: fd is not optional)
#
#   -u file
#	true if file exists and has its setuid bit set.
#
#   -w file
#	true if file exists and is writable by current process.
#
#   -x file
#	true if file exists and is executable by current process. If file exists
#	and is a directory, then the current process has permission to search in
#	the directory.
#
#   -z string
#	true if length of string is zero.
#
#   -L file
#	true if file exists and is a symbolic link.
#
#   -O file
#	true if file exists and is owned by the effective user ID of this
#	process.
#
#   -G file
#	true if file exists and its group matches the effective group ID of this
#	process.
#
#   -S file
#	true if file exists and is a socket.
#
#   -N file
#	true if file exists and its access time is not newer than its
#	modification time.
#
#   file1 -nt file2
#	true if file1 exists and is newer than file2.
#
#   file1 -ot file2
#	true if file1 exists and is older than file2.
#
#   file1 -ef file2
#	true if file1 and file2 exist and refer to the same file.
#
#   string = pattern
#   string == pattern
#	true if string matches pattern. The `==' form is the preferred one. The
#	`=' form is for backward compatibility and should be considered
#	obsolete.
#
#   string != pattern
#	true if string does not match pattern.
#
#   string =~ regexp
#	true if string matches the regular expression regexp. If the option
#	RE_MATCH_PCRE is set regexp is tested as a PCRE regular expression using
#	the zsh/pcre module, else it is tested as a POSIX extended regular
#	expression using the zsh/regex module. If the option BASH_REMATCH is set
#	the array BASH_REMATCH is set to the substring that matched the pattern
#	followed by the substrings that matched parenthesised subexpressions
#	within the pattern; otherwise, the scalar parameter MATCH is set to the
#	substring that matched the pattern and and the array match to the
#	substrings that matched parenthesised subexpressions.
#
#   string1 < string2
#	true if string1 comes before string2 based on ASCII value of their
#	characters.
#
#   string1 > string2
#	true if string1 comes after string2 based on ASCII value of their
#	characters.
#
#   exp1 -eq exp2
#	true if exp1 is numerically equal to exp2.
#
#   exp1 -ne exp2
#	true if exp1 is numerically not equal to exp2.
#
#   exp1 -lt exp2
#	true if exp1 is numerically less than exp2.
#
#   exp1 -gt exp2
#	true if exp1 is numerically greater than exp2.
#
#   exp1 -le exp2
#	true if exp1 is numerically less than or equal to exp2.
#
#   exp1 -ge exp2
#	true if exp1 is numerically greater than or equal to exp2.
#
#   ( exp )
#	true if exp is true.
#
#   ! exp
#	true if exp is false.
#
#   exp1 && exp2
#	true if exp1 and exp2 are both true.
#
#   exp1 || exp2
#	true if either exp1 or exp2 is true.
# Normal shell expansion is performed on the file, string and pattern arguments,
# but the result of each expansion is constrained to be a single word, similar
# to the effect of double quotes. However, pattern metacharacters are active for
# the pattern arguments; the patterns are the same as those used for filename
# generation, see zshexpn(1), but there is no special behaviour of `/' nor
# initial dots, and no glob qualifiers are allowed.
#
# In each of the above expressions, if file is of the form `/dev/fd/n', where n
# is an integer, then the test applied to the open file whose descriptor number
# is n, even if the underlying system does not support the /dev/fd directory.
#
# In the forms which do numeric comparison, the expressions exp undergo
# arithmetic expansion as if they were enclosed in $((...)).
#
# For example, the following:
#
#   [[ ( -f foo || -f bar ) && $report = y* ]] && print File exists.
#
# tests if either file foo or file bar exists, and if so, if the value of the
# parameter report begins with `y'; if the complete condition is true, the
# message `File exists.' is printed.
#}}}

# {{{ Parameters Used By The Shell
###############################################################################
# In cases where there are two parameters with an upper- and lowercase form of
# the same name, such as path and PATH, the lowercase form is an array and the
# uppercase form is a scalar with the elements of the array joined together by
# colons. These are similar to tied parameters created via `typeset -T'. The
# normal use for the colon-separated form is for exporting to the environment,
# while the array form is easier to manipulate within the shell. Note that
# unsetting either of the pair will unset the other; they retain their special
# properties when recreated, and recreating one of the pair will recreate the
# other.

# ARGV0
# If exported, its value is used as the argv[0] of external commands. Usually
# used in constructs like `ARGV0=emacs nethack'.

# BAUD
# The baud rate of the current connection. Used by the line editor update
# mechanism to compensate for a slow terminal by delaying updates until
# necessary. This may be profitably set to a lower value in some circumstances,
# e.g. for slow modems dialing into a communications server which is connected
# to a host via a fast link; in this case, this variable would be set by default
# to the speed of the fast link, and not the modem. This parameter should be set
# to the baud rate of the slowest part of the link for best performance. The
# compensation mechanism can be turned off by setting the variable to zero.

# cdpath <S> <Z> (CDPATH <S>)
# An array (colon-separated list) of directories specifying the search path for
# the cd command.
export CDPATH=".:~:/"

# COLUMNS <S>
# The number of columns for this terminal session. Used for printing select
# lists and for the line editor.

# DIRSTACKSIZE
# The maximum size of the directory stack. If the stack gets larger than this,
# it will be truncated automatically. This is useful with the AUTO_PUSHD option.
export DIRSTACKSIZE="32"

# ENV
# If the ENV environment variable is set when zsh is invoked as sh or ksh, ${ENV}
# is sourced after the profile scripts. The value of ENV is subjected to
# parameter expansion, command substitution, and arithmetic expansion before
# being interpreted as a pathname. Note that ENV is not used unless zsh is
# emulating sh or ksh.

# FCEDIT
# The default editor for the fc builtin.
if [[ -x /usr/bin/vim ]]; then
    export FCEDIT="vim"
elif [[ -x /usr/bin/vi ]]; then
    export FCEDIT="vi"
fi

# fignore <S> <Z> (FIGNORE <S>)
# An array (colon separated list) containing the suffixes of files to be ignored
# during filename completion. However, if completion only generates files with
# suffixes in this list, then these files are completed anyway.

# fpath <S> <Z> (FPATH <S>)
# An array (colon separated list) of directories specifying the search path for
# function definitions. This path is searched when a function with the -u
# attribute is referenced. If an executable file is found, then it is read and
# executed in the current environment.

# histchars <S>
# Three characters used by the shell's history and lexical analysis mechanism.
# The first character signals the start of a history expansion (default `!').
# The second character signals the start of a quick history substitution
# (default `^'). The third character is the comment character (default `#').

# HISTFILE
# The file to save the history in when an interactive shell exits. If unset, the
# history is not saved.
export HISTFILE=~/.zsh_history

# HISTSIZE <S>
# The maximum number of events stored in the internal history list. If you use
# the HIST_EXPIRE_DUPS_FIRST option, setting this value larger than the SAVEHIST
# size will give you the difference as a cushion for saving duplicated history
# events.
export HISTSIZE="1024"

# HOME <S>
# The default argument for the cd command.

# IFS <S>
# Internal field separators (by default space, tab, newline and NUL), that are
# used to separate words which result from command or parameter expansion and
# words read by the read builtin. Any characters from the set space, tab and
# newline that appear in the IFS are called IFS white space. One or more IFS
# white space characters or one non-IFS white space character together with any
# adjacent IFS white space character delimit a field. If an IFS white space
# character appears twice consecutively in the IFS, this character is treated as
# if it were not an IFS white space character.

# KEYTIMEOUT
# The time the shell waits, in hundredths of seconds, for another key to be
# pressed when reading bound multi-character sequences.
export KEYTIMEOUT="400"

# LANG <S>
# This variable determines the locale category for any category not specifically
# selected via a variable starting with `LC_'.
export LANG="en_US.UTF-8"

# LC_ALL <S>
# This variable overrides the value of the `LANG' variable and the value of any
# of the other variables starting with `LC_'.
unset LC_ALL

# LC_COLLATE <S>
# This variable determines the locale category for character collation
# information within ranges in glob brackets and for sorting.
export LC_COLLATE="en_US.UTF-8"

# LC_CTYPE <S>
# This variable determines the locale category for character handling functions.
export LC_CTYPE="en_US.UTF-8"

# LC_MESSAGES <S>
# This variable determines the language in which messages should be written.
# Note that zsh does not use message catalogs.
export LC_MESSAGES="en_US.UTF-8"

# LC_NUMERIC <S>
# This variable affects the decimal point character and thousands separator
# character for the formatted input/output functions and string conversion
# functions. Note that zsh ignores this setting when parsing floating point
# mathematical expressions.
export LC_NUMERIC="de_DE.UTF-8"

# LC_TIME <S>
# This variable determines the locale category for date and time formatting in
# prompt escape sequences.
export LC_TIME="de_DE.UTF-8"

# LINES <S>
# The number of lines for this terminal session. Used for printing select lists
# and for the line editor.
export LINES="32"

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

# manpath <S> <Z> (MANPATH <S> <Z>)
# An array (colon-separated list) whose value is not used by the shell. The
# manpath array can be useful, however, since setting it also sets MANPATH, and
# vice versa.

# module_path <S> <Z> (MODULE_PATH <S>)
# An array (colon-separated list) of directories that zmodload searches for
# dynamically loadable modules. This is initialized to a standard pathname,
# usually `/usr/local/lib/zsh/${ZSH_VERSION}'. (The `/usr/local/lib' part varies
# from installation to installation.) For security reasons, any value set in the
# environment when the shell is started will be ignored.
#
# These parameters only exist if the installation supports dynamic module
# loading.

# NULLCMD <S>
# The command name to assume if a redirection is specified with no command.
# Defaults to cat. For sh/ksh behavior, change this to :. For csh-like behavior,
# unset this parameter; the shell will print an error message if null commands
# are entered.

# POSTEDIT <S>
# This string is output whenever the line editor exits. It usually contains
# termcap strings to reset the terminal.

# PROMPT <S> <Z>
# prompt <S> <Z>
# PS1 <S>
# The primary prompt string, printed before a command is read. the default is
# `%m%# '. It undergoes a special form of expansion before being displayed; see
# 12. Prompt Expansion.
PROMPT="%(!.${BOLD_RED}.${BOLD_BLUE})%n${NO_COLOR} ${BOLD_YELLOW}(%M)${NO_COLOR} ${BOLD_CYAN}%(3~.%3~.%~)${NO_COLOR} ${BOLD_GREY}[%D{%Y-%m-%d %H:%M}]${NO_COLOR} Jobs: ${BOLD_WHITE}%j${NO_COLOR} | Exitstatus: %(?.${BOLD_GREEN}%?.${BOLD_RED}%?)${NO_COLOR}
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

# psvar <S> <Z> (PSVAR <S>)
# An array (colon-separated list) whose first nine values can be used in PROMPT
# strings. Setting psvar also sets PSVAR, and vice versa.

# READNULLCMD <S>
# The command name to assume if a single input redirection is specified with no
# command. Defaults to more.

# REPORTTIME
# If nonnegative, commands whose combined user and system execution times
# (measured in seconds) are greater than this value have timing statistics
# printed for them.
export REPORTTIME="300"

# REPLY
# This parameter is reserved by convention to pass string values between shell
# scripts and shell builtins in situations where a function call or redirection
# are impossible or undesirable. The read builtin and the select complex command
# may set REPLY, and filename generation both sets and examines its value when
# evaluating certain expressions. Some modules also employ REPLY for similar
# purposes.

# reply
# As REPLY, but for array values rather than strings.

# RPROMPT <S>
# RPS1 <S>
# This prompt is displayed on the right-hand side of the screen when the primary
# prompt is being displayed on the left. This does not work if the SINGLELINEZLE
# option is set. It is expanded in the same way as PS1.
export RPROMPT

# RPROMPT2 <S>
# RPS2 <S>
# This prompt is displayed on the right-hand side of the screen when the
# secondary prompt is being displayed on the left. This does not work if the
# SINGLELINEZLE option is set. It is expanded in the same way as PS2.

# SAVEHIST
# The maximum number of history events to save in the history file.
export SAVEHIST="10240"

# SPROMPT <S>
# The prompt used for spelling correction. The sequence `%R' expands to the
# string which presumably needs spelling correction, and `%r' expands to the
# proposed correction. All other prompt escapes are also allowed.
export SPROMPT="correct '%R' to '%r' [nyae]?"

# STTY
# If this parameter is set in a command's environment, the shell runs the stty
# command with the value of this parameter as arguments in order to set up the
# terminal before executing the command. The modes apply only to the command,
# and are reset when it finishes or is suspended. If the command is suspended
# and continued later with the fg or wait builtins it will see the modes
# specified by STTY, as if it were not suspended. This (intentionally) does not
# apply if the command is continued via `kill -CONT'. STTY is ignored if the
# command is run in the background, or if it is in the environment of the shell
# but not explicitly assigned to in the input line. This avoids running stty at
# every external command by accidentally exporting it. Also note that STTY
# should not be used for window size specifications; these will not be local to
# the command.

# TERM <S>
# The type of terminal in use. This is used when looking up termcap sequences.
# An assignment to TERM causes zsh to re-initialize the terminal, even if the
# value does not change (e.g., `TERM=${TERM}'). It is necessary to make such an
# assignment upon any change to the terminal definition database or terminal
# type in order for the new settings to take effect.

# TIMEFMT
# The format of process time reports with the time keyword. The default is
# `%E real %U user %S system %P %J'. Recognizes the following escape sequences:
#   %% - A `%'.
#   %U - CPU seconds spent in user mode.
#   %S - CPU seconds spent in kernel mode.
#   %E - Elapsed time in seconds.
#   %P - The CPU percentage, computed as (%U+%S)/%E.
#   %J - The name of this job.
#
# A star may be inserted between the percent sign and flags printing time. This
# cause the time to be printed in `hh:mm:ss.ttt' format (hours and minutes are
# only printed if they are not zero).
export TIMEFMT="%*U user %S system %P cpu %*E total '%J'"

# TMOUT
# If this parameter is nonzero, the shell will receive an ALRM signal if a
# command is not entered within the specified number of seconds after issuing a
# prompt. If there is a trap on SIGALRM, it will be executed and a new alarm is
# scheduled using the value of the TMOUT parameter after executing the trap. If
# no trap is set, and the idle time of the terminal is not less than the value
# of the TMOUT parameter, zsh terminates. Otherwise a new alarm is scheduled to
# TMOUT seconds after the last keypress.
if [[ ${TERM} = screen* ]]; then
    unset TMOUT
else
    export TMOUT="3600"
fi

# TMPPREFIX
# A pathname prefix which the shell will use for all temporary files. Note that
# this should include an initial part for the file name as well as any directory
# names. The default is `/tmp/zsh'.

# watch <S> <Z> (WATCH <S>)
# An array (colon-separated list) of login/logout events to report. If it
# contains the single word `all', then all login/logout events are reported. If
# it contains the single word `notme', then all events are reported as with
# `all' except ${USERNAME}. An entry in this list may consist of a username, an
# `@' followed by a remote hostname, and a `%' followed by a line (tty). Any or
# all of these components may be present in an entry; if a login/logout event
# matches all of them, it is reported.
watch=(notme root)

# WATCHFMT
# The format of login/logout reports if the watch parameter is set. Default is
# `%n has %a %l from %m'. Recognizes the following escape sequences:
#   %n	- The name of the user that logged in/out.
#   %a	- The observed action, i.e. "logged on" or "logged off".
#   %l	- The line (tty) the user is logged in on.
#   %M	- The full hostname of the remote host.
#   %m	- The hostname up to the first `.'. If only the IP address is
#	  available or the utmp field contains the name of an X-windows display,
#	  the whole name is printed.
#
#	  NOTE: The `%m' and `%M' escapes will work only if there is a host name
#	  field in the utmp on your machine. Otherwise they are treated as
#	  ordinary strings.
#   %S (%s) - Start (stop) standout mode.
#   %U (%u) - Start (stop) underline mode.
#   %B (%b) - Start (stop) boldface mode.
#   %t %@   - The time, in 12-hour, am/pm format.
#   %T      - The time, in 24-hour format.
#   %w      - The date in `day-dd' format.
#   %W      - The date in `mm/dd/yy' format.
#   %D      - The date in `yy-mm-dd' format.
#   %(x:true-text:false-text)
#	    - Specifies a ternary expression. The character following the x is
#	      arbitrary; the same character is used to separate the text for the
#	      "true" result from that for the "false" result. Both the separator
#	      and the right parenthesis may be escaped with a backslash. Ternary
#	      expressions may be nested.
#
#	      The test character x may be any one of `l', `n', `m' or `M', which
#	      indicate a `true' result if the corresponding escape sequence
#	      would return a non-empty value; or it may be `a', which indicates
#	      a `true' result if the watched user has logged in, or `false' if
#	      he has logged out. Other characters evaluate to neither true nor
#	      false; the entire expression is omitted in this case.
#
#	      If the result is `true', then the true-text is formatted according
#	      to the rules above and printed, and the false-text is skipped. If
#	      `false', the true-text is skipped and the false-text is formatted
#	      and printed. Either or both of the branches may be empty, but both
#	      separators must be present in any case.

# WORDCHARS <S>
# A list of non-alphanumeric characters considered part of a word by the line
# editor.

# ZBEEP
# If set, this gives a string of characters, which can use all the same codes as
# the bindkey command as described in 21.26 The zsh/zle Module, that will be
# output to the terminal instead of beeping. This may have a visible instead of
# an audible effect; for example, the string `\e[?5h\e[?5l' on a vt100 or xterm
# will have the effect of flashing reverse video on and off (if you usually use
# reverse video, you should use the string `\e[?5l\e[?5h' instead). This takes
# precedence over the NOBEEP option.

# ZDOTDIR
# The directory to search for shell startup files (.zshrc, etc), if not ${HOME}.
#}}}

# {{{ Description of Options
###############################################################################
# In the following list, options set by default in all emulations are marked
# <D>; those set by default only in csh, ksh, sh, or zsh emulations are marked
# <C>, <K>, <S>, <Z> as appropriate. When listing options (by `setopt',
# `unsetopt', `set -o' or `set +o'), those turned on by default appear in the
# list prefixed with `no'. Hence (unless KSH_OPTION_PRINT is set), `setopt'
# shows all options whose settings are changed from the default.

# {{{ Changing Directories
################################################################################
# {{{ AUTO_CD (-J)
# If a command is issued that can"t be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd #}}}

# {{{ AUTO_PUSHD (-N)
# Make cd push the old directory onto the directory stack.
setopt auto_pushd #}}}

# {{{ CDABLE_VARS (-T)
# If the argument to a cd command (or an implied cd with the AUTO_CD option set)
# is not a directory, and does not begin with a slash, try to expand the
# expression as if it were preceded by a "~" (see the section "Filename
# Expansion").
setopt cdable_vars #}}}

# {{{ CHASE_DOTS
# When changing to a directory containing a path segment ".." which would
# otherwise be treated as canceling the previous segment in the path (in other
# words, "foo/.." would be removed from the path, or if ".." is the first part
# of the path, the last part of ${PWD} would be deleted), instead resolve the path
# to the physical directory. This option is overridden by CHASE_LINKS.
#
# For example, suppose /foo/bar is a link to the directory /alt/rod. Without
# this option set, "cd /foo/bar/.." changes to /foo; with it set, it changes to
# /alt. The same applies if the current directory is /foo/bar and "cd .." is
# used. Note that all other sym‐ bolic links in the path will also be resolved.
#}}}

# {{{ CHASE_LINKS (-w)
# Resolve symbolic links to their true values when changing directory. This also
# has the effect of CHASE_DOTS, i.e. a ".." path segment will be treated as
# referring to the physical parent, even if the preceding path segment is a
# symbolic link.
#}}}

# {{{ PUSHD_IGNORE_DUPS
# Don"t push multiple copies of the same directory onto the directory stack.
setopt pushd_ignore_dups #}}}

# {{{ PUSHD_MINUS
# Exchanges the meanings of "+" and "-" when used with a number to specify a
# directory in the stack.
#}}}

# {{{ PUSHD_SILENT (-E)
# Do not print the directory stack after pushd or popd.
#}}}

# {{{ PUSHD_TO_HOME (-D)
# Have pushd with no arguments act like "pushd ${HOME}".
#}}}
#}}}

# {{{ Completion
################################################################################
# {{{ ALWAYS_LAST_PROMPT <D>
# If unset, key functions that list completions try to return to the last prompt
# if given a numeric argument. If set these functions try to return to the last
# prompt if given no numeric argument.
#}}}

# {{{ ALWAYS_TO_END
# If a completion is performed with the cursor within a word, and a full
# completion is inserted, the cursor is moved to the end of the word. That is,
# the cursor is moved to the end of the word if either a single match is
# inserted or menu completion is performed.
#}}}

# {{{ AUTO_LIST (-) <D>
# Automatically list choices on an ambiguous completion.
#}}}

# {{{ AUTO_MENU <D>
# Automatically use menu completion after the second consecutive request for
# completion, for example by pressing the tab key repeatedly. This option is
# overridden by MENU_COMPLETE.
#}}}

# {{{ AUTO_NAME_DIRS
# Any parameter that is set to the absolute name of a directory immediately
# becomes a name for that directory, that will be used by the "%~" and related
# prompt sequences, and will be available when completion is performed on a word
# starting with "~". (Otherwise, the parameter must be used in the form "~param"
# first.)
#}}}

# {{{ AUTO_PARAM_KEYS <D>
# If a parameter name was completed and a following character (normally a space)
# automatically inserted, and the next character typed is one of those that have
# to come directly after the name (like "}", ":", etc.), the automatically added
# character is deleted, so that the character typed comes immediately after the
# parameter name. Completion in a brace expansion is affected similarly: the
# added character is a ",", which will be removed if "}" is typed next.
#}}}

# {{{ AUTO_PARAM_SLASH <D>
# If a parameter is completed whose content is the name of a directory, then add
# a trailing slash instead of a space.
#}}}

# {{{ AUTO_REMOVE_SLASH <D>
# When the last character resulting from a completion is a slash and the next
# character typed is a word delimiter, a slash, or a character that ends a
# command (such as a semicolon or an ampersand), remove the slash.
#}}}

# {{{ BASH_AUTO_LIST
# On an ambiguous completion, automatically list choices when the completion
# function is called twice in succession. This takes precedence over AUTO_LIST.
# The setting of LIST_AMBIGUOUS is respected. If AUTO_MENU is set, the menu
# behaviour will then start with the third press. Note that this will not work
# with MENU_COMPLETE, since repeated completion calls immediately cycle through
# the list in that case.
#}}}

# {{{ COMPLETE_ALIASES
# Prevents aliases on the command line from being internally substituted before
# completion is attempted. The effect is to make the alias a distinct command
# for completion purposes.
#}}}

# {{{ COMPLETE_IN_WORD
# If unset, the cursor is set to the end of the word if completion is started.
# Otherwise it stays there and completion is done from both ends.
setopt complete_in_word #}}}

# {{{ GLOB_COMPLETE
# When the current word has a glob pattern, do not insert all the words
# resulting from the expansion but generate matches as for completion and cycle
# through them like MENU_COMPLETE. The matches are generated as if a "*" was
# added to the end of the word, or inserted at the cursor when COMPLETE_IN_WORD
# is set. This actually uses pattern matching, not globbing, so it works not
# only for files but for any completion, such as options, user names, etc.
#
# Note that when the pattern matcher is used, matching control (for example,
# case-insensitive or anchored matching) cannot be used. This limitation only
# applies when the current word contains a pattern; simply turning on the
# GLOB_COMPLETE option does not have this effect.
#}}}

# {{{ HASH_LIST_ALL <D>
# Whenever a command completion is attempted, make sure the entire command path
# is hashed first. This makes the first completion slower.
#}}}

# {{{ LIST_AMBIGUOUS <D>
# This option works when AUTO_LIST or BASH_AUTO_LIST is also set. If there is an
# unambiguous prefix to insert on the command line, that is done without a
# completion list being displayed; in other words, auto-listing behaviour only
# takes place when nothing would be inserted. In the case of BASH_AUTO_LIST,
# this means that the list will be delayed to the third call of the function.
#}}}

# {{{ LIST_BEEP <D>
# Beep on an ambiguous completion. More accurately, this forces the completion
# widgets to return status 1 on an ambiguous completion, which causes the shell
# to beep if the option BEEP is also set; this may be modified if completion is
# called from a user-defined widget.
setopt no_list_beep #}}}

# {{{ LIST_PACKED
# Try to make the completion list smaller (occupying less lines) by printing the
# matches in columns with different widths.
setopt list_packed #}}}

# {{{ LIST_ROWS_FIRST
# Lay out the matches in completion lists sorted horizontally, that is, the
# second match is to the right of the first one, not under it as usual.
#}}}

# {{{ LIST_TYPES (-X) <D>
# When listing files that are possible completions, show the type of each file
# with a trailing identifying mark.
#}}}

# {{{ MENU_COMPLETE (-Y)
# On an ambiguous completion, instead of listing possibilities or beeping,
# insert the first match immediately. Then when completion is requested again,
# remove the first match and insert the second match, etc. When there are no
# more matches, go back to the first one again. reverse-menu-complete may be
# used to loop through the list in the other direction. This option overrides
# AUTO_MENU.
#}}}

# {{{ REC_EXACT (-S)
# In completion, recognize exact matches even if they are ambiguous.
#}}}
#}}}

# {{{ Expansion and Globbing
################################################################################
# {{{ BAD_PATTERN (+) <C> <Z>
# If a pattern for filename generation is badly formed, print an error message.
# (If this option is unset, the pattern will be left unchanged.)
#}}}

# {{{ BARE_GLOB_QUAL <Z>
# In a glob pattern, treat a trailing set of parentheses as a qualifier list, if
# it contains no "|", "(" or (if special) "~" characters. See the section
# "Filename Generation".
#}}}

# {{{ BRACE_CCL
# Expand expressions in braces which would not otherwise undergo brace expansion
# to a lexically ordered list of all the characters. See the section "Brace
# Expansion".
#}}}

# {{{ CASE_GLOB <D>
# Make globbing (filename generation) sensitive to case. Note that other uses of
# patterns are always sensitive to case. If the option is unset, the presence of
# any character which is special to filename generation will cause
# case-insensitive matching. For example, cvs(/) can match the directory CVS
# owing to the presence of the globbing flag (unless the option BARE_GLOB_QUAL
# is unset).
setopt no_case_glob #}}}

# {{{ CASE_MATCH <D>
# Make regular expressions using the zsh/regex module (including matches with
# =~) sensitive to case.
#}}}

# {{{ CSH_NULL_GLOB <C>
# If a pattern for filename generation has no matches, delete the pattern from
# the argument list; do not report an error unless all the patterns in a command
# have no matches. Overrides NOMATCH.
#}}}

# {{{ EQUALS <Z>
# Perform = filename expansion. (See the section "Filename Expansion".)
#}}}

# {{{ EXTENDED_GLOB
# Treat the "#", "~" and "^" characters as part of patterns for filename
# generation, etc. (An initial unquoted "~" always produces named directory
# expansion.)
setopt extended_glob #}}}

# {{{ GLOB (+F, ksh: +f) <D>
# Perform filename generation (globbing). (See the section "Filename
# Generation".)
#}}}

# {{{ GLOB_ASSIGN <C>
# If this option is set, filename generation (globbing) is performed on the
# right hand side of scalar parameter assignments of the form "name=pattern
# (e.g. "foo=*"). If the result has more than one word the parameter will become
# an array with those words as arguments. This option is provided for backwards
# compatibility only: globbing is always performed on the right hand side of
# array assignments of the form "name=(value)" (e.g. "foo=(*)") and this form is
# recommended for clarity; with this option set, it is not possible to predict
# whether the result will be an array or a scalar.
#}}}

# {{{ GLOB_DOTS (-)
# Do not require a leading "." in a filename to be matched explicitly.
#}}}

# {{{ GLOB_SUBST <C> <K> <S>
# Treat any characters resulting from parameter expansion as being eligible for
# file expansion and filename generation, and any characters resulting from
# command substitution as being eligible for filename generation. Braces (and
# commas in between) do not become eligible for expansion.
#}}}

# {{{ HIST_SUBST_PATTERN
# Substitutions using the :s and :& history modifiers are performed with pattern
# matching instead of string matching. This occurs wherever history modifiers
# are valid, including glob qualifiers and parameters. See the section Modifiers
# in zshexp(1).
#}}}

# {{{ IGNORE_BRACES (-I) <S>
# Do not perform brace expansion.
#}}}

# {{{ KSH_GLOB <K>
# In pattern matching, the interpretation of parentheses is affected by a
# preceding "@", "*", "+", "?" or "!". See the section "File‐ name Generation".
#}}}

# {{{ MAGIC_EQUAL_SUBST
# All unquoted arguments of the form "anything=expression" appearing after the
# command name have filename expansion (that is, where expression has a leading
# "~" or "=") performed on expression as if it were a parameter assignment. The
# argument is not otherwise treated specially; it is passed to the command as a
# single argument, and not used as an actual parameter assignment. For example,
# in echo foo=~/bar:~/rod, both occurrences of ~ would be replaced. Note that
# this happens anyway with typeset and similar statements.
#
# This option respects the setting of the KSH_TYPESET option. In other words, if
# both options are in effect, arguments looking like assignments will not
# undergo word splitting.
#}}}

# {{{ MARK_DIRS (-, ksh: -X)
# Append a trailing "/" to all directory names resulting from filename
# generation (globbing).
setopt mark_dirs #}}}

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
setopt no_multibyte #}}}

# {{{ NOMATCH (+) <C> <Z>
# If a pattern for filename generation has no matches, print an error, instead
# of leaving it unchanged in the argument list. This also applies to file
# expansion of an initial "~" or "=".
setopt nonomatch #}}}

# {{{ NULL_GLOB (-G)
# If a pattern for filename generation has no matches, delete the pattern from
# the argument list instead of reporting an error. Overrides NOMATCH.
#}}}

# {{{ NUMERIC_GLOB_SORT
# If numeric filenames are matched by a filename generation pattern, sort the
# filenames numerically rather than lexicographically.
#}}}

# {{{ RC_EXPAND_PARAM (-P)
# Array expansions of the form "foo${xx}bar", where the parameter xx is set to
# (a b c), are substituted with "fooabar foobbar foocbar" instead of the default
# "fooa b cbar".
#}}}

# {{{ REMATCH_PCRE <Z>
# If set, regular expression matching with the =~ operator will use
# Perl-Compatible Regular Expressions from the PCRE library, if available. If
# not set, regular expressions will use the extended regexp syntax provided by
# the system libraries.
#}}}

# {{{ SH_GLOB <K> <S>
# Disables the special meaning of "(", "|", ")" and "<" for globbing the result
# of parameter and command substitutions, and in some other places where the
# shell accepts patterns. This option is set by default if zsh is invoked as sh
# or ksh.
#}}}

# {{{ UNSET (+u, ksh: +u) <K> <S> <Z>
# Treat unset parameters as if they were empty when substituting. Otherwise they
# are treated as an error.
#}}}

# {{{ WARN_CREATE_GLOBAL
# Print a warning message when a global parameter is created in a function by an
# assignment. This often indicates that a parameter has not been declared local
# when it should have been. Parameters explicitly declared global from within a
# function using typeset -g do not cause a warning. Note that there is no
# warning when a local parameter is assigned to in a nested function, which may
# also indicate an error.
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
setopt append_history #}}}

# {{{ BANG_HIST (+K) <C> <Z>
# Perform textual history expansion, csh-style, treating the character "!"
# specially.
#}}}

# {{{ EXTENDED_HISTORY <C>
# Save each command"s beginning timestamp (in seconds since the epoch) and the
# duration (in seconds) to the history file. The format of this prefixed data
# is:
#
#   ":<beginning time>:<elapsed seconds>:<command>".
setopt extended_history #}}}

# {{{ HIST_ALLOW_CLOBBER
# Add "|" to output redirections in the history. This allows history references
# to clobber files even when CLOBBER is unset.
#}}}

# {{{ HIST_BEEP <D>
# Beep when an attempt is made to access a history entry which isn"t there.
setopt no_hist_beep #}}}

# {{{ HIST_EXPIRE_DUPS_FIRST
# If the internal history needs to be trimmed to add the current command line,
# setting this option will cause the oldest history event that has a duplicate
# to be lost before losing a unique event from the list. You should be sure to
# set the value of HISTSIZE to a larger number than SAVEHIST in order to give
# you some room for the duplicated events, otherwise this option will behave
# just like HIST_IGNORE_ALL_DUPS once the history fills up with unique events.
setopt hist_expire_dups_first #}}}

# {{{ HIST_FIND_NO_DUPS
# When searching for history entries in the line editor, do not display
# duplicates of a line previously found, even if the duplicates are not
# contiguous.
setopt hist_find_no_dups #}}}

# {{{ HIST_IGNORE_ALL_DUPS
# If a new command line being added to the history list duplicates an older one,
# the older command is removed from the list (even if it is not the previous
# event).
setopt hist_ignore_all_dups #}}}

# {{{ HIST_IGNORE_DUPS (-h)
# Do not enter command lines into the history list if they are duplicates of the
# previous event.
setopt hist_ignore_dups #}}}

# {{{ HIST_IGNORE_SPACE (-g)
# Remove command lines from the history list when the first character on the
# line is a space, or when one of the expanded aliases contains a leading space.
# Note that the command lingers in the internal history until the next command
# is entered before it vanishes, allowing you to briefly reuse or edit the line.
# If you want to make it vanish right away without entering another command,
# type a space and press return.
setopt hist_ignore_space #}}}

# {{{ HIST_NO_FUNCTIONS
# Remove function definitions from the history list. Note that the function
# lingers in the internal history until the next command is entered before it
# vanishes, allowing you to briefly reuse or edit the definition.
setopt hist_no_functions #}}}

# {{{ HIST_NO_STORE
# Remove the history (fc -l) command from the history list when invoked. Note
# that the command lingers in the internal history until the next command is
# entered before it vanishes, allowing you to briefly reuse or edit the line.
setopt hist_no_store #}}}

# {{{ HIST_REDUCE_BLANKS
# Remove superfluous blanks from each command line being added to the history
# list.
setopt hist_reduce_blanks #}}}

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
setopt hist_save_by_copy #}}}

# {{{ HIST_SAVE_NO_DUPS
# When writing out the history file, older commands that duplicate newer ones
# are omitted.
setopt hist_save_no_dups #}}}

# {{{ HIST_VERIFY
# Whenever the user enters a line with history expansion, don't execute the line
# directly; instead, perform history expansion and reload the line into the
# editing buffer.
setopt hist_verify #}}}

# {{{ INC_APPEND_HISTORY
# This options works like APPEND_HISTORY except that new history lines are added
# to the ${HISTFILE} incrementally (as soon as they are entered), rather than
# waiting until the shell exits. The file will still be periodically re-written
# to trim it when the number of lines grows 20% beyond the value specified by
# ${SAVEHIST} (see also the HIST_SAVE_BY_COPY option).
#}}}

# {{{ SHARE_HISTORY <K>
# This option both imports new commands from the history file, and also causes
# your typed commands to be appended to the history file (the latter is like
# specifying INC_APPEND_HISTORY). The history lines are also output with
# timestamps ala EXTENDED_HISTORY (which makes it easier to find the spot where
# we left off reading the file after it gets re-written).
#
# By default, history movement commands visit the imported lines as well as the
# local lines, but you can toggle this on and off with the set-local-history zle
# binding. It is also possible to create a zle widget that will make some
# commands ignore imported commands, and some include them.
#
# If you find that you want more control over when commands get imported, you
# may wish to turn SHARE_HISTORY off, INC_APPEND_HISTORY on, and then manually
# import commands whenever you need them using "fc -RI".
#}}}
#}}}

# {{{ Initialisation
################################################################################
# {{{ ALL_EXPORT (-a, ksh: -a)
# All parameters subsequently defined are automatically exported.
#}}}

# {{{ GLOBAL_EXPORT (<Z>)
# If this option is set, passing the -x flag to the builtins declare, float,
# integer, readonly and typeset (but not local) will also set the -g flag; hence
# parameters exported to the environment will not be made local to the enclosing
# function, unless they were already or the flag +g is given explicitly. If the
# option is unset, exported parameters will be made local in just the same way
# as any other parameter.
#
# This option is set by default for backward compatibility; it is not
# recommended that its behaviour be relied upon. Note that the builtin export
# always sets both the -x and -g flags, and hence its effect extends beyond the
# scope of the enclosing function; this is the most portable way to achieve this
# behaviour.
#}}}

# {{{ GLOBAL_RCS (-d) <D>
# If this option is unset, the startup files /etc/zprofile, /etc/zshrc,
# /etc/zlogin and /etc/zlogout will not be run. It can be disabled and
# re-enabled at any time, including inside local startup files (.zshrc, etc.).
#}}}

# {{{ RCS (+f) <D>
# After /etc/zshenv is sourced on startup, source the .zshenv, /etc/zprofile,
# .zprofile, /etc/zshrc, .zshrc, /etc/zlogin, .zlogin, and .zlogout files, as
# described in the section "Files". If this option is unset, the /etc/zshenv
# file is still sourced, but any of the others will not be; it can be set at any
# time to prevent the remaining startup files after the currently executing one
# from being sourced.
#}}}
#}}}

# {{{ Input/Output
################################################################################
# {{{ ALIASES <D>
# Expand aliases.
#}}}

# {{{ CLOBBER (+C, ksh: +C) <D>
# Allows ">" redirection to truncate existing files, and ">>" to create files.
# Otherwise ">!" or ">|" must be used to truncate a file, and ">>!" or ">>|" to
# create a file.
#}}}

# {{{ CORRECT (-)
# Try to correct the spelling of commands. Note that, when the HASH_LIST_ALL
# option is not set or when some directories in the path are not readable, this
# may falsely report spelling errors the first time some commands are used.
setopt correct #}}}

# {{{ CORRECT_ALL (-O)
# Try to correct the spelling of all arguments in a line.
#}}}

# {{{ DVORAK
# Use the Dvorak keyboard instead of the standard qwerty keyboard as a basis for
# examining spelling mistakes for the CORRECT and CORRECT_ALL options and the
# spell-word editor command.
#}}}

# {{{ FLOW_CONTROL <D>
# If this option is unset, output flow control via start/stop characters
# (usually assigned to ^S/^Q) is disabled in the shell"s editor.
#}}}

# {{{ IGNORE_EOF (-)
# Do not exit on end-of-file. Require the use of exit or logout instead.
# However, ten consecutive EOFs will cause the shell to exit anyway, to avoid
# the shell hanging if its tty goes away.
#
# Also, if this option is set and the Zsh Line Editor is used, widgets
# implemented by shell functions can be bound to EOF (normally Control-D)
# without printing the normal warning message. This works only for normal
# widgets, not for completion widgets.
#}}}

# {{{ INTERACTIVE_COMMENTS (-k) <K> <S>
# Allow comments even in interactive shells.
#}}}

# {{{ HASH_CMDS <D>
# Note the location of each command the first time it is executed. Subsequent
# invocations of the same command will use the saved location, avoiding a path
# search. If this option is unset, no path hashing is done at all. However, when
# CORRECT is set, commands whose names do not appear in the functions or aliases
# hash tables are hashed in order to avoid reporting them as spelling errors.
setopt hash_cmds #}}}

# {{{ HASH_DIRS <D>
# Whenever a command name is hashed, hash the directory containing it, as well
# as all directories that occur earlier in the path. Has no effect if neither
# HASH_CMDS nor CORRECT is set.
setopt hash_dirs #}}}

# {{{ MAIL_WARNING (-U)
# Print a warning message if a mail file has been accessed since the shell last
# checked.
setopt no_mail_warning #}}}

# {{{ PATH_DIRS (-Q)
# Perform a path search even on command names with slashes in them. Thus if
# "/usr/local/bin" is in the user"s path, and he or she types "X11/xinit", the
# command "/usr/local/bin/X11/xinit" will be executed (assuming it exists).
# Commands explicitly beginning with "/", "./" or "../" are not subject to the
# path search. This also applies to the . builtin.
#
# Note that subdirectories of the current directory are always searched for
# executables specified in this form. This takes place before any search
# indicated by this option, and regardless of whether "." or the current
# directory appear in the command search path.
setopt path_dirs #}}}

# {{{ PRINT_EIGHT_BIT
# Print eight bit characters literally in completion lists, etc. This option is
# not necessary if your system correctly returns the printability of eight bit
# characters (see ctype(3)).
#}}}

# {{{ PRINT_EXIT_VALUE (-)
# Print the exit value of programs with non-zero exit status.
#}}}

# {{{ RC_QUOTES
# Allow the character sequence """" to signify a single quote within singly
# quoted strings. Note this does not apply in quoted strings using the format
# $"...", where a backslashed single quote can be used.
#}}}

# {{{ RM_STAR_SILENT (-H) <K> <S>
# Do not query the user before executing "rm *" or "rm path/*".
setopt rm_star_silent #}}}

# {{{ RM_STAR_WAIT
# If querying the user before executing "rm *" or "rm path/*", first wait ten
# seconds and ignore anything typed in that time. This avoids the problem of
# reflexively answering "yes" to the query when one didn"t really mean it. The
# wait and query can always be avoided by expanding the "*" in ZLE (with tab).
#}}}

# {{{ SHORT_LOOPS <C> <Z>
# Allow the short forms of for, repeat, select, if, and function constructs.
setopt short_loops #}}}

# {{{ SUN_KEYBOARD_HACK (-L)
# If a line ends with a backquote, and there are an odd number of backquotes on
# the line, ignore the trailing backquote. This is useful on some keyboards
# where the return key is too small, and the backquote key lies annoyingly close
# to it.
#}}}
#}}}

# {{{ Job Control
################################################################################
# {{{ AUTO_CONTINUE
# With this option set, stopped jobs that are removed from the job table with
# the disown builtin command are automatically sent a CONT signal to make them
# running.
setopt auto_continue #}}}

# {{{ AUTO_RESUME (-W)
# Treat single word simple commands without redirection as candidates for
# resumption of an existing job.
#}}}

# {{{ BG_NICE (-) <C> <Z>
# Run all background jobs at a lower priority. This option is set by default.
setopt bg_nice #}}}

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
setopt no_check_jobs #}}}

# {{{ HUP <Z>
# Send the HUP signal to running jobs when the shell exits.
setopt no_hup #}}}

# {{{ LONG_LIST_JOBS (-R)
# List jobs in the long format by default.
setopt long_list_jobs #}}}

# {{{ MONITOR (-m, ksh: -m)
# Allow job control. Set by default in interactive shells.
setopt monitor #}}}

# {{{ NOTIFY (-, ksh: -b) <Z>
# Report the status of background jobs immediately, rather than waiting until
# just before printing a prompt.
setopt notify #}}}
#}}}

# {{{ Prompting
################################################################################
# {{{ PROMPT_BANG <K>
# If set, "!" is treated specially in prompt expansion. See the section "Prompt
# Expansion".
#}}}

# {{{ PROMPT_CR (+V) <D>
# Print a carriage return just before printing a prompt in the line editor. This
# is on by default as multi-line editing is only possible if the editor knows
# where the start of the line appears.
#}}}

# {{{ PROMPT_SP <D>
# Attempt to preserve a partial line (i.e. a line that did not end with a
# newline) that would otherwise be covered up by the command prompt due to the
# PROMPT_CR option. This works by outputting some cursor-control characters,
# including a series of spaces, that should make the terminal wrap to the next
# line when a partial line is present (note that this is only successful if your
# terminal has automatic margins, which is typical).
#
# When a partial line is preserved, you will see an inverse+bold character at
# the end of the partial line: a "%" for a normal user or a "#" for root.
#
# NOTE: if the PROMPT_CR option is not set, enabling this option will have no
#	effect. This option is on by default.
#}}}

# {{{ PROMPT_PERCENT <C> <Z>
# If set, "%" is treated specially in prompt expansion. See the section "Prompt
# Expansion".
#}}}

# {{{ PROMPT_SUBST <K>
# If set, parameter expansion, command substitution and arithmetic expansion are
# performed in prompts. Substitutions within prompts do not affect the command
# status.
#}}}

# {{{ TRANSIENT_RPROMPT
# Remove any right prompt from display when accepting a command line. This may
# be useful with terminals with other cut/paste methods.
# }}}
#}}}

# {{{ Scripts and Functions
################################################################################
# {{{ C_BASES
# Output hexadecimal numbers in the standard C format, for example "0xFF"
# instead of the usual "16#FF". If the option OCTAL_ZEROES is also set (it is
# not by default), octal numbers will be treated similarly and hence appear as
# "" instead of "8#". This option has no effect on the choice of the output
# base, nor on the output of bases other than hexadecimal and octal. Note that
# these formats will be understood on input irrespective of the setting of
# C_BASES.
#}}}

# {{{ DEBUG_BEFORE_CMD
# Run the DEBUG trap before each command; otherwise it is run after each
# command. Setting this option mimics the behaviour of ksh 93; with the option
# unset the behaviour is that of ksh 88.
#}}}

# {{{ ERR_EXIT (-e, ksh: -e)
# If a command has a non-zero exit status, execute the ZERR trap, if set, and
# exit. This is disabled while running initialization scripts.
#}}}

# {{{ ERR_RETURN
# If a command has a non-zero exit status, return immediately from the enclosing
# function. The logic is identical to that for ERR_EXIT, except that an implicit
# return statement is executed instead of an exit. This will trigger an exit at
# the outermost level of a non-interactive script.
#}}}

# {{{ EVAL_LINENO <Z>
# If set, line numbers of expressions evaluated using the builtin eval are
# tracked separately of the enclosing environment. This applies both to the
# parameter LINENO and the line number output by the prompt escape %i. If the
# option is set, the prompt escape %N will output the string "(eval)" instead of
# the script or function name as an indication. (The two prompt escapes are
# typically used in the parameter PS4 to be output when the option XTRACE is
# set.) If EVAL_LINENO is unset, the line number of the surrounding script or
# function is retained during the evaluation.
#}}}

# {{{ EXEC (+n, ksh: +n) <D>
# Do execute commands. Without this option, commands are read and checked for
# syntax errors, but not executed. This option cannot be turned off in an
# interactive shell, except when "-n" is supplied to the shell at startup.
#}}}

# {{{ FUNCTION_ARGZERO <C> <Z>
# When executing a shell function or sourcing a script, set ${0} temporarily to
# the name of the function/script.
#}}}

# {{{ LOCAL_OPTIONS <K>
# If this option is set at the point of return from a shell function, all the
# options (including this one) which were in force upon entry to the function
# are restored. Otherwise, only this option and the XTRACE and PRINT_EXIT_VALUE
# options are restored. Hence if this is explicitly unset by a shell function
# the other options in force at the point of return will remain so. A shell
# function can also guarantee itself a known shell configuration with a
# formulation like "emulate -L zsh"; the -L activates LOCAL_OPTIONS.
#}}}

# {{{ LOCAL_TRAPS <K>
# If this option is set when a signal trap is set inside a function, then the
# previous status of the trap for that signal will be restored when the function
# exits. Note that this option must be set prior to altering the trap behaviour
# in a function; unlike LOCAL_OPTIONS, the value on exit from the function is
# irrelevant. However, it does not need to be set before any global trap for
# that to be correctly restored by a function. For example,
#
#   unsetopt localtraps
#   trap - INT
#   fn() { setopt localtraps; trap "" INT; sleep 3; }
#
# will restore normally handling of SIGINT after the function exits.
#}}}

# {{{ MULTIOS <Z>
# Perform implicit tees or cats when multiple redirections are attempted (see
# the section "Redirection").
setopt multios #}}}

# {{{ OCTAL_ZEROES <S>
# Interpret any integer constant beginning with a 0 as octal, per IEEE Std
# 1003.2-1992 (ISO 9945-2:1993). This is not enabled by default as it causes
# problems with parsing of, for example, date and time strings with leading
# zeroes.
#
# Sequences of digits indicating a numeric base such as the "" component in
# "08#" are always interpreted as decimal, regardless of leading zeroes.
#}}}

# {{{ TYPESET_SILENT
# If this is unset, executing any of the "typeset" family of commands with no
# options and a list of parameters that have no values to be assigned but
# already exist will display the value of the parameter. If the option is set,
# they will only be shown when parameters are selected with the "-m" option. The
# option "-p" is available whether or not the option is set.
#}}}

# {{{ VERBOSE (-v, ksh: -v)
# Print shell input lines as they are read.
#}}}

# {{{ XTRACE (-x, ksh: -x)
# Print commands and their arguments as they are executed.
#}}}
#}}}

# {{{ Shell Emulation
################################################################################
# {{{ BASH_REMATCH
# When set, matches performed with the =~ operator will set the BASH_REMATCH
# array variable, instead of the default MATCH and match variables. The first
# element of the BASH_REMATCH array will contain the entire matched text and
# subsequent elements will contain extracted substrings. This option makes more
# sense when KSH_ARRAYS is also set, so that the entire matched portion is
# stored at index 0 and the first substring is at index 1. Without this option,
# the MATCH variable contains the entire matched text and the match array
# variable contains substrings.
#}}}

# {{{ BSD_ECHO <S>
# Make the echo builtin compatible with the BSD echo(1) command. This disables
# backslashed escape sequences in echo strings unless the -e option is
# specified.
setopt bsd_echo #}}}

# {{{ CSH_JUNKIE_HISTORY <C>
# A history reference without an event specifier will always refer to the
# previous command. Without this option, such a history reference refers to the
# same event as the previous history reference, defaulting to the previous
# command.
#}}}

# {{{ CSH_JUNKIE_LOOPS <C>
# Allow loop bodies to take the form "list; end" instead of "do list; done".
#}}}

# {{{ CSH_JUNKIE_QUOTES <C>
# Changes the rules for single- and double-quoted text to match that of csh.
# These require that embedded newlines be preceded by a backslash; unescaped
# newlines will cause an error message. In double-quoted strings, it is made
# impossible to escape "$", """ or """ (and "\" itself no longer needs
# escaping). Command substitutions are only expanded once, and cannot be nested.
#}}}

# {{{ CSH_NULLCMD <C>
# Do not use the values of NULLCMD and READNULLCMD when running redirections
# with no command. This make such redirections fail (see the section
# "Redirection").
#}}}

# {{{ KSH_ARRAYS <K> <S>
# Emulate ksh array handling as closely as possible. If this option is set,
# array elements are numbered from zero, an array parameter without subscript
# refers to the first element instead of the whole array, and braces are
# required to delimit a subscript ("${path[2]}" rather than just "$path[2]").
#}}}

# {{{ KSH_AUTOLOAD <K> <S>
# Emulate ksh function autoloading. This means that when a function is
# autoloaded, the corresponding file is merely executed, and must define the
# function itself. (By default, the function is defined to the contents of the
# file. However, the most common ksh-style case - of the file containing only a
# simple definition of the function - is always handled in the ksh-compatible
# manner.)
#}}}

# {{{ KSH_OPTION_PRINT <K>
# Alters the way options settings are printed: instead of separate lists of set
# and unset options, all options are shown, marked "on" if they are in the
# non-default state, "off" otherwise.
#}}}

# {{{ KSH_TYPESET <K>
# Alters the way arguments to the typeset family of commands, including declare,
# export, float, integer, local and readonly, are processed. Without this
# option, zsh will perform normal word splitting after command and parameter
# expansion in arguments of an assignment; with it, word splitting does not take
# place in those cases.
#}}}

# {{{ KSH_ZERO_SUBSCRIPT
# Treat use of a subscript of value zero in array or string expressions as a
# reference to the first element, i.e. the element that usually has the
# subscript 1. Ignored if KSH_ARRAYS is also set.
#
# If neither this option nor KSH_ARRAYS is set, accesses to an element of an
# array or string with subscript zero return an empty element or string, while
# attempts to set element zero of an array or string are treated as an error.
# However, attempts to set an otherwise valid subscript range that includes zero
# will succeed. For example, if KSH_ZERO_SUBSCRIPT is not set,
#
#   array[0]=(element)
#
# is an error, while
#
#   array[0,1]=(element)
#
# is not and will replace the first element of the array.
#
# This option is for compatibility with older versions of the shell and is not
# recommended in new code.
#}}}

# {{{ POSIX_BUILTINS <K> <S>
# When this option is set the command builtin can be used to execute shell
# builtin commands. Parameter assignments specified before shell functions and
# special builtins are kept after the command completes unless the special
# builtin is prefixed with the command builtin. Special builtins are ., :,
# break, continue, declare, eval, exit, export, integer, local, readonly,
# return, set, shift, source, times, trap and unset.
setopt posix_builtins #}}}

# {{{ POSIX_IDENTIFIERS <K> <S>
# When this option is set, only the ASCII characters a to z, A to Z, 0 to 9 and
# _ may be used in identifiers (names of shell parameters and modules).
#
# When the option is unset and multibyte character support is enabled (i.e. it
# is compiled in and the option MULTIBYTE is set), then additionally any
# alphanumeric characters in the local character set may be used in identifiers.
# Note that scripts and functions written with this feature are not portable,
# and also that both options must be set before the script or function is
# parsed; setting them during execution is not sufficient as the syntax
# variable=value has already been parsed as a command rather than an assignment.
#
# If multibyte character support is not compiled into the shell this option is
# ignored; all octets with the top bit set may be used in identifiers. This is
# non-standard but is the traditional zsh behaviour.
setopt posix_identifiers #}}}

# {{{ SH_FILE_EXPANSION <K> <S>
# Perform filename expansion (e.g., ~ expansion) before parameter expansion,
# command substitution, arithmetic expansion and brace expansion. If this option
# is unset, it is performed after brace expansion, so things like "~${USERNAME}"
# and "~{pfalstad,rc}" will work.
#}}}

# {{{ SH_NULLCMD <K> <S>
# Do not use the values of NULLCMD and READNULLCMD when doing redirections, use
# ":" instead (see the section "Redirection").
#}}}

# {{{ SH_OPTION_LETTERS <K> <S>
# If this option is set the shell tries to interpret single letter options
# (which are used with set and setopt) like ksh does. This also affects the
# value of the - special parameter.
#}}}

# {{{ SH_WORD_SPLIT (-y) <K> <S>
# Causes field splitting to be performed on unquoted parameter expansions. Note
# that this option has nothing to do with word splitting. (See the section
# "Parameter Expansion".)
#}}}

# {{{ TRAPS_ASYNC
# While waiting for a program to exit, handle signals and run traps immediately.
# Otherwise the trap is run after a child process has exited. Note this does not
# affect the point at which traps are run for any case other than when the shell
# is waiting for a child process.
#}}}
#}}}

# {{{ Shell State
################################################################################
# {{{ INTERACTIVE (-i, ksh: -i)
# This is an interactive shell. This option is set upon initialisation if the
# standard input is a tty and commands are being read from standard input. (See
# the discussion of SHIN_STDIN.) This heuristic may be overridden by specifying
# a state for this option on the command line. The value of this option cannot
# be changed anywhere other than the command line.
#}}}

# {{{ LOGIN (-l, ksh: -l)
# This is a login shell. If this option is not explicitly set, the shell is a
# login shell if the first character of the argv[0] passed to the shell is a
# "-".
setopt LOGIN #}}}

# {{{ PRIVILEGED (-p, ksh: -p)
# Turn on privileged mode. This is enabled automatically on startup if the
# effective user (group) ID is not equal to the real user (group) ID. Turning
# this option off causes the effective user and group IDs to be set to the real
# user and group IDs. This option disables sourcing user startup files. If zsh
# is invoked as "sh" or "ksh" with this option set, /etc/suid_profile is sourced
# (after /etc/profile on interactive shells). Sourcing ~/.profile is disabled
# and the contents of the ENV variable is ignored. This option cannot be changed
# using the -m option of setopt and unsetopt, and changing it inside a function
# always changes it globally regardless of the LOCAL_OPTIONS option.
#}}}

# {{{ RESTRICTED (-r)
# Enables restricted mode. This option cannot be changed using unsetopt, and
# setting it inside a function always changes it globally regardless of the
# LOCAL_OPTIONS option. See the section "Restricted Shell".
#}}}

# {{{ SHIN_STDIN (-s, ksh: -s)
# Commands are being read from the standard input. Commands are read from
# standard input if no command is specified with -c and no file of commands is
# specified. If SHIN_STDIN is set explicitly on the command line, any argument
# that would otherwise have been taken as a file to run will instead be treated
# as a normal positional parameter. Note that setting or unsetting this option
# on the command line does not necessarily affect the state the option will have
# while the shell is running - that is purely an indicator of whether on not
# commands are actually being read from standard input. The value of this option
# cannot be changed anywhere other than the command line.
#}}}

# {{{ SINGLE_COMMAND (-t, ksh: -t)
# If the shell is reading from standard input, it exits after a single command
# has been executed. This also makes the shell non-interactive, unless the
# INTERACTIVE option is explicitly set on the command line. The value of this
# option cannot be changed anywhere other than the command line.
#}}}
#}}}

# {{{ Zle
################################################################################
# {{{ BEEP (+B) <D>
# Beep on error in ZLE.
setopt nobeep #}}}

# {{{ EMACS
# If ZLE is loaded, turning on this option has the equivalent effect of "bindkey
# -e". In addition, the VI option is unset. Turning it off has no effect. The
# option setting is not guaranteed to reflect the current keymap. This option is
# provided for compatibility; bindkey is the recommended interface.
setopt no_emacs #}}}

# {{{ OVERSTRIKE
# Start up the line editor in overstrike mode.
#}}}

# {{{ SINGLE_LINE_ZLE (-M) <K>
# Use single-line command line editing instead of multi-line.
#}}}

# {{{ VI
# If ZLE is loaded, turning on this option has the equivalent effect of "bindkey
# -v". In addition, the EMACS option is unset. Turning it off has no effect. The
# option setting is not guaranteed to reflect the current keymap. This option is
# provided for compatibility; bindkey is the recommended interface.
setopt vi #}}}

# {{{ PromptSubst
setopt promptsubst #}}}

# {{{ ZLE (-Z)
# Use the zsh line editor. Set by default in interactive shells connected to a
# terminal.
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

[[ -d /usr/share/doc ]] && hash -d doc=/usr/share/doc
[[ -d /usr/src ]]       && hash -d src=/usr/src
[[ -d /var/log ]]       && hash -d log=/var/log

[[ -L /lib/modules/$(uname -r)/build ]] && \
    hash -d linux=/lib/modules/$(command uname -r)/build/

[[ -d ~/repositories ]] && hash -d repoSitories=~/repositories \
    && for i in ~/repositories/*(/); do
    hash -d "repo$(basename ${(C)i})"="${i}"
done

[[ -d ~/.dotfiles ]] && hash -d dotFiles=~/.dotfiles && \
    for i in ~/.dotfiles/*(/); do
    hash -d "dot$(basename ${(C)i})"="${i}"
done
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
alias -g N='&> /dev/null'

[[ -x /bin/egrep ]]    && alias -g G='|& egrep --ignore-case'
[[ -x /usr/bin/view ]] && alias -g V='|& ${PAGER} -'

# remap the buildin commads
alias which='whence -vas'
alias where='whence -cas'

# display full history
alias history='fc -l 1'

# search an specific alias
alias aliasgrep='alias G'

# no spell correction for cp, mv, rm, mkdir, rmdir and adding default options
alias cp='nocorrect cp --verbose'
alias mv='nocorrect mv --verbose'
alias ln='nocorrect ln --verbose'
alias mkdir='nocorrect mkdir --verbose'
#}}}

# {{{ function
###############################################################################
#unhash -mf "*"

# reload configuration
function reload(){
    while (( $# )); do
        unfunction $1
        autoload -U $1
        shift
    done

    [[ -r ~/.profile ]]	 && source ~/.profile
    [[ -r ~/.zshenv ]]	 && source ~/.zshenv
    [[ -r ~/.zprofile ]] && source ~/.zprofile
    [[ -r ~/.zshrc ]]    && source ~/.zshrc
    return 0
}

# Provides useful information on globbing
function zsh-help() {
echo -e "
/	directories
.	plain files
@	symbolic links
=	sockets
p	named pipes (FIFOs)
*	executable plain files (0100)
%	device files (character or block special)
%b	block special files
%c	character special files
r	owner-readable files (0400)
w	owner-writable files (0200)
x	owner-executable files (0100)
A	group-readable files (0040)
I	group-writable files (0020)
E	group-executable files (0010)
R	world-readable files (0004)
W	world-writable files (0002)
X	world-executable files (0001)
s	setuid files (04000)
S	setgid files (02000)
t	files with the sticky bit (01000)

print *(m-1)			# Files modified up to a day ago
print *(a1)			# Files accessed a day ago
print *(@)			# Just symlinks
print *(Lk+50)			# Files bigger than 50 kilobytes
print *(Lk-50)			# Files smaller than 50 kilobytes
print **/*.c			# All *.c files recursively starting in \${PWD}
print **/*.c~file.c		# Same as above, but excluding 'file.c'
print (foo|bar).*		# Files starting with 'foo' or 'bar'
print *~*.*			# All Files that do not contain a dot
chmod 644 *(.^x)		# make all plain non-executable files publically readable
print -l *(.c|.h)		# Lists *.c and *.h
print **/*(g:users:)		# Recursively match all files that are owned by group 'users'
echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print ${1}}'<"
}

# setting the windowtitle
function title(){
    case ${TERM} in
        *term*|*screen*)
            # Use this one instead for XTerms:
            print -nR $'\033]0;'$*$'\a'
            ;;
        *)
            ;;
    esac
}

# Executed before each prompt. Note that precommand functions are not reexecuted
# simply because the command line is redrawn, as happens, for example, when a
# notification about an exiting job is displayed.
function precmd(){
    [[ $ZSH_VERSION == 4.3.<10->* || $ZSH_VERSION == 4.<4->* || $ZSH_VERSION == <5->* ]] && vcs_info prompt
    if [[ -n ${vcs_info_msg_0_} ]]; then
        RPROMPT="${vcs_info_msg_0_} "
    else
        RPROMPT=""
    fi
    title ${TERM%-*} ${PWD//~/"~"}
}

# Executed just after a command has been read and is about to be executed. If
# the history mechanism is active (and the line was not discarded from the
# history buffer), the string that the user typed is passed as the first
# argument, otherwise it is an empty string. The actual command that will be
# executed (including expanded aliases) is passed in two different forms: the
# second argument is a single-line, size-limited version of the command (with
# things like function bodies elided); the third argument contains the full text
# that is being executed.
function preexec(){
    emulate -L zsh
    local -a cmd; cmd=(${(z)1})
    title $cmd[1]:t $cmd[2,-1]
}

# Clean up directory - remove well known tempfiles
function purge() {
    emulate -L zsh
    setopt HIST_SUBST_PATTERN
    local -a TEXTEMPFILES GHCTEMPFILES PYTEMPFILES FILES
    TEXTEMPFILES=(*.tex(N:s/%tex/'(log|toc|aux|nav|snm|out|tex.backup|bbl|blg|bib.backup|vrb|lof|lot|hd|idx)(N)'/))
    GHCTEMPFILES=(*.(hs|lhs)(N:r:s/%/'.(hi|hc|(p|u|s)_(o|hi))(N)'/))
    PYTEMPFILES=(*.py(N:s/%py/'(pyc|pyo)(N)'/))
    LONELY_MOOD_FILES=((*.mood)(NDe:'local -a AF;AF=( ${${REPLY#.}%mood}(mp3|flac|ogg|asf|wmv|aac)(N) ); [[ -z "$AF" ]]':))
    FILES=(*~(.N) \#*\#(.N) *.o(.N) a.out(.N) (*.|)core(.N) *.cmo(.N) *.cmi(.N) .*.swp(.N) *.(orig|rej)(.DN) *.dpkg-(old|dist|new)(DN) ._(cfg|mrg)[0-9][0-9][0-9][0-9]_*(N) ${~TEXTEMPFILES} ${~GHCTEMPFILES} ${~PYTEMPFILES} ${LONELY_MOOD_FILES})
    local NBFILES=${#FILES}
    local CURDIRSUDO=""
    [[ ! -w ./ ]] && CURDIRSUDO=$SUDO
    if [[ $NBFILES > 0 ]]; then
        print -l $FILES
        local ans
        echo -n "Remove these files? [y/n] "
        read -q ans
        if [[ $ans == "y" ]]; then
            $CURDIRSUDO rm ${FILES}
            echo ">> $PWD purged, $NBFILES files removed"
        else
            echo "Ok. .. then not.."
        fi
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
# A keymap in ZLE contains a set of bindings between key sequences and ZLE
# commands. The empty key sequence cannot be bound.
#
# There can be any number of keymaps at any time, and each keymap has one or
# more names. If all of a keymap's names are deleted, it disappears. bindkey can
# be used to manipulate keymap names.
#
# Initially, there are four keymaps:
#   emacs   - EMACS emulation
#   viins   - vi emulation - insert mode
#   vicmd   - vi emulation - command mode
#   .safe   - fallback keymap
#
# The `.safe' keymap is special. It can never be altered, and the name can never
# be removed. However, it can be linked to other names, which can be removed. In
# the future other special keymaps may be added; users should avoid using names
# beginning with `.' for their own keymaps.
#
# In addition to these four names, either `emacs' or `viins' is also linked to
# the name `main'. If one of the VISUAL or EDITOR environment variables contain
# the string `vi' when the shell starts up then it will be `viins', otherwise it
# will be `emacs'. bindkey's -e and -v options provide a convenient way to
# override this default choice.
#
# When the editor starts up, it will select the `main' keymap. If that keymap
# doesn't exist, it will use `.safe' instead.
#
# In the `.safe' keymap, each single key is bound to self-insert, except for ^J
# (line feed) and ^M (return) which are bound to accept-line. This is
# deliberately not pleasant to use; if you are using it, it means you deleted
# the main keymap, and you should put it back.
#
# The ZLE module contains three related builtin commands. The bindkey command
# manipulates keymaps and key bindings; the vared command invokes ZLE on the
# value of a shell parameter; and the zle command manipulates editing widgets
# and allows command line access to ZLE commands from within shell functions.
# bindkey [ options ] -l
# bindkey [ options ] -d
# bindkey [ options ] -D keymap ...
# bindkey [ options ] -A old-keymap new-keymap
# bindkey [ options ] -N new-keymap [ old-keymap ]
# bindkey [ options ] -m
# bindkey [ options ] -r in-string ...
# bindkey [ options ] -s in-string out-string ...
# bindkey [ options ] in-string command ...
# bindkey [ options ] [ in-string ]
#
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
#
#   For either in-string or out-string, the following escape sequences are
#   recognised:
#
#       \a     bell character
#       \b     backspace
#       \e, \E escape
#       \f     form feed
#       \n     linefeed (newline)
#       \r     carriage return
#       \t     horizontal tab
#       \v     vertical tab
#       \NNN   character code in octal
#       \xNN   character code in hexadecimal
#       \M[-]X character with meta bit set
#       \C[-]X control character
#       ^X     control character
#
#   In all other cases, `\' escapes the following character. Delete is written
#   as `^?'. Note that `\M^?' and `^\M?' are not the same, and that (unlike
#   emacs), the bindings `\M-X' and `\eX' are entirely distinct, although they
#   are initialized to the same bindings by `bindkey -m'.
#
bindkey -v
# add builtin meta-keys bindigs (and surpress warning message)
# bindkey -m &> /dev/null
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
# You may read this file into your .zshrc or another  startup  file  with the
# `source' or `.' commands, then reference the key parameter in bindkey
# commands, like this:
#
#   source ${ZDOTDIR:-~}/.zkbd/${TERM-}${VENDOR-}${OSTYPE}
#   [[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
#   [[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
#   # etc.
#
# Note that in order for `autoload zkbd' to work, the zkdb file  must  be in
# one of the directories named in your fpath array (see zshparam(1)). This
# should already be the case if you have a  standard  zsh  installation;  if  it
# is not, copy Functions/Misc/zkbd to an appropriate directory.
#autoload -Uz zkbd

if [[ "$TERM" != emacs ]]; then
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M emacs "$terminfo[kdch1]" delete-char
    [[ -z "$terminfo[khome]" ]] || bindkey -M emacs "$terminfo[khome]" beginning-of-line
    [[ -z "$terminfo[kend]"  ]] || bindkey -M emacs "$terminfo[kend]"  end-of-line
    [[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
    [[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
    [[ -z "$terminfo[kend]"  ]] || bindkey -M vicmd "$terminfo[kend]"  vi-end-of-line
    [[ -z "$terminfo[cuu1]"  ]] || bindkey -M viins "$terminfo[cuu1]"  vi-up-line-or-history
    [[ -z "$terminfo[cuf1]"  ]] || bindkey -M viins "$terminfo[cuf1]"  vi-forward-char
    [[ -z "$terminfo[kcuu1]" ]] || bindkey -M viins "$terminfo[kcuu1]" vi-up-line-or-history
    [[ -z "$terminfo[kcud1]" ]] || bindkey -M viins "$terminfo[kcud1]" vi-down-line-or-history
    [[ -z "$terminfo[kcuf1]" ]] || bindkey -M viins "$terminfo[kcuf1]" vi-forward-char
    [[ -z "$terminfo[kcub1]" ]] || bindkey -M viins "$terminfo[kcub1]" vi-backward-char

    # k Shift-tab Perform backwards menu completion
    if [[ -n "$terminfo[kcbt]" ]]; then
        bindkey -M viins "$terminfo[kcbt]" reverse-menu-complete
    elif [[ -n "$terminfo[cbt]" ]]; then
        bindkey -M viins "$terminfo[cbt]"  reverse-menu-complete
    fi

    # ncurses stuff:
    [[ "$terminfo[kcuu1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuu1]/O/[}" vi-up-line-or-history
    [[ "$terminfo[kcud1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcud1]/O/[}" vi-down-line-or-history
    [[ "$terminfo[kcuf1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcuf1]/O/[}" vi-forward-char
    [[ "$terminfo[kcub1]" == $'\eO'* ]] && bindkey -M viins "${terminfo[kcub1]/O/[}" vi-backward-char
    [[ "$terminfo[khome]" == $'\eO'* ]] && bindkey -M viins "${terminfo[khome]/O/[}" beginning-of-line
    [[ "$terminfo[kend]"  == $'\eO'* ]] && bindkey -M viins "${terminfo[kend]/O/[}"  end-of-line
    [[ "$terminfo[khome]" == $'\eO'* ]] && bindkey -M emacs "${terminfo[khome]/O/[}" beginning-of-line
    [[ "$terminfo[kend]"  == $'\eO'* ]] && bindkey -M emacs "${terminfo[kend]/O/[}"  end-of-line
fi

bindkey '\e[1~' beginning-of-line	# home
bindkey '\e[4~' end-of-line		# end
bindkey '\e[A'  up-line-or-search	# cursor up
bindkey '\e[B'  down-line-or-search	# <ESC>-

bindkey '^xp'   history-beginning-search-backward
bindkey '^xP'   history-beginning-search-forward

# if terminal type is set to 'rxvt':
bindkey '\e[7~' beginning-of-line	# home
bindkey '\e[8~' end-of-line		# end

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
#
# If called from a function by the zle command with arguments, the first
# argument is taken as the string for which to search, rather than the first
# word in the buffer.
[[ -n "${key[Up]}" ]] && bindkey "${key[Up]}" up-line-or-search

# down-line-or-search
# Move down a line in the buffer, or if already at the bottom line, search
# forward in the history for a line beginning with the first word in the buffer.
#
# If called from a function by the zle command with arguments, the first
# argument is taken as the string for which to search, rather than the first
# word in the buffer.
[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-search

# history-incremental-search-backward (^R ^Xr) (unbound) (unbound)
# Search backward incrementally for a specified string. The search is
# case-insensitive if the search string does not have uppercase letters and no
# numeric argument was given. The string may begin with "^" to anchor the search
# to the beginning of the line.
#
# A restricted set of editing functions is available in the mini-buffer. An
# interrupt signal, as defined by the stty setting, will stop the search and go
# back to the original line. An undefined key will have the same effect. The
# supported functions are: backward-delete-char, vi-backward-delete-char,
# clear-screen, redisplay, quoted-insert, vi-quoted-insert, accept-and-hold,
# accept-and-infer-next-history, accept-line and accept-line-and-down-history.
#
# magic-space just inserts a space. vi-cmd-mode toggles between the "main" and
# "vicmd" keymaps; the "main" keymap (insert mode) will be selected initially.
# history-incremental-search-backward will get the next occurrence of the
# contents of the mini-buffer. history-incremental-search-forward inverts the
# sense of the search. vi-repeat-search and vi-rev-repeat-search are similarly
# supported. The direction of the search is indicated in the mini-buffer.
#
# Any multi-character string that is not bound to one of the above functions
# will beep and interrupt the search, leaving the last found line in the buffer.
# Any single character that is not bound to one of the above functions, or
# self-insert or self-insert-unmeta, will have the same effect but the function
# will be executed.
#
# When called from a widget function by the zle command, the incremental search
# commands can take a string argument. This will be treated as a string of keys,
# as for arguments to the bindkey command, and used as initial input for the
# command. Any characters in the string which are unused by the incremental
# search will be silently ignored. For example,
#
#   zle history-incremental-search-backward forceps
#
# will search backwards for forceps, leaving the minibuffer containing the
# string "forceps".
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
#
# This section describes the use of compinit to initialize completion for the
# current session when called directly; if you have run compinstall it will be
# called automatically from your .zshrc.
#
# To initialize the system, the function compinit should be in a directory
# mentioned in the fpath parameter, and should be autoloaded (`autoload -U
# compinit' is recommended), and then run simply as `compinit'. This will define
# a few utility functions, arrange for all the necessary shell functions to be
# autoloaded, and will then re-define all widgets that do completion to use the
# new system. If you use the menu-select widget, which is part of the
# zsh/complist module, you should make sure that that module is loaded before
# the call to compinit so that that widget is also re-defined. If completion
# styles (see below) are set up to perform expansion as well as completion by
# default, and the TAB key is bound to expand-or-complete, compinit will rebind
# it to complete-word; this is necessary to use the correct form of expansion.
#
# Should you need to use the original completion commands, you can still bind
# keys to the old widgets by putting a `.' in front of the widget name, e.g.
# `.expand-or-complete'.
# To speed up the running of compinit, it can be made to produce a dumped
# configuration that will be read in on future invocations; this is the default,
# but can be turned off by calling compinit with the option -D. The dumped file
# is .zcompdump in the same directory as the startup files (i.e. ${ZDOTDIR} or
# ${HOME}); alternatively, an explicit file name can be given by `compinit -d
# dumpfile'. The next invocation of compinit will read the dumped file instead
# of performing a full initialization.
#
# If the number of completion files changes, compinit will recognise this and
# produce a new dump file. However, if the name of a function or the arguments
# in the first line of a #compdef function (as described below) change, it is
# easiest to delete the dump file by hand so that compinit will re-create it the
# next time it is run. The check performed to see if there are new functions can
# be omitted by giving the option -C. In this case the dump file will only be
# created if there isn't one already.
#
# The dumping is actually done by another function, compdump, but you will only
# need to run this yourself if you change the configuration (e.g. using compdef)
# and then want to dump the new one. The name of the old dumped file will be
# remembered for this purpose.
#
# If the parameter _compdir is set, compinit uses it as a directory where
# completion functions can be found; this is only necessary if they are not
# already in the function search path.
#
# For security reasons compinit also checks if the completion system would use
# files not owned by root or by the current user, or files in directories that
# are world- or group-writable or that are not owned by root or by the current
# user. If such files or directories are found, compinit will ask if the
# completion system should really be used. To avoid these tests and make all
# files found be used without asking, use the option -u, and to make compinit
# silently ignore all insecure files and directories use the option -i. This
# security check is skipped entirely when the -C option is given.
#
# The security check can be retried at any time by running the function
# compaudit. This is the same check used by compinit, but when it is executed
# directly any changes to fpath are made local to the function so they do not
# persist. The directories to be checked may be passed as arguments; if none are
# given, compaudit uses fpath and _compdir to find completion system
# directories, adding missing ones to fpath as necessary. To force a check of
# exactly the directories currently named in fpath, set _compdir to an empty
# string before calling compaudit or compinit.
autoload -Uz compinit
compinit

compdef _functions edfunc
compdef _aliases edalias

# A newly added command will may not be found or will cause false
# correction attempts, if you got auto-correction set. By setting the
# following style, we force accept-line() to rehash, if it cannot
# find the first word on the command line in the $command[] hash.
zstyle ':acceptline:*' rehash true

# allow one error for every three characters typed in approximate completer
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true

# activate color-completion
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

# format on completion
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
# zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false

# activate menu
zstyle ':completion:*:history-words'   menu yes

# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''

# if there are more than 5 options allow selecting from a menu
zstyle ':completion:*'               menu select=5

zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'

# describe options in full
zstyle ':completion:*:options'         description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# provide verbose completion information
zstyle ':completion:*'                 verbose true

# recent (as of Dec 2007) zsh versions are able to provide descriptions
# for commands (read: 1st word in the line) that it will list for the user
# to choose from. The following disables that, because it's not exactly fast.
zstyle ':completion:*:-command-:*:'    verbose false

# set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# complete manual by their section
zstyle ':completion:*:manuals'          separate-sections true
zstyle ':completion:*:manuals.*'        insert-sections   true
zstyle ':completion:*:man:*'            menu yes select

# provide .. as a completion
zstyle ':completion:*'                  special-dirs ..

# run rehash on completion so new installed program are found automatically:
_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1
}

## correction
# try to be smart about when to use what completer...
zstyle -e ':completion:*' completer '
if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]]; then
    _last_try="$HISTNO$BUFFER$CURSOR"
    reply=(_complete _match _ignored _prefix _files)
else
    if [[ $words[1] == (rm|mv) ]]; then
        reply=(_complete _files)
    else
        reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
    fi
fi'

# caching
[[ -d $ZSHDIR/cache ]] && zstyle ':completion:*' use-cache yes && \
    zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

# host completion /* add brackets as vim can't parse zsh's complex cmdlines 8-) {{{ */
[[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=($(hostname) "$_ssh_hosts[@]" "$_etc_hosts[@]" localhost)
zstyle ':completion:*:hosts'        hosts $hosts

# use generic completion system for programs not yet defined; (_gnu_generic works
# with commands that provide a --help option with "standard" gnu-like output.)
for compcom in cp df feh head mv tail uname; do
    [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
done; unset compcom

# see upgrade function in this file
compdef _hosts upgrade
#}}}

# {{{ Completion Using compctl
################################################################################
# THE ZSH/COMPCTL MODULE
# The zsh/compctl module makes available two builtin commands. compctl, is the
# old, deprecated way to control completions for ZLE. See zshcompctl(1). The
# other builtin command, compcall can be used in user-defined completion
# widgets, see zshcompwid(1).
autoload -Uz zsh/compctl
#}}}

# {{{ Zsh Modules
################################################################################
# THE ZSH/COMPLETE MODULE
# The zsh/complete module makes available several builtin commands which can be
# used in user-defined completion widgets, see zshcompwid(1).
autoload -Uz zsh/complete

# THE ZSH/DATETIME MODULE
# The zsh/datetime module makes available one builtin command:
#
# strftime [ -s scalar ] format epochtime
# strftime -r [ -q ] [ -s scalar ] format timestring
#   Output the date denoted by epochtime in the format specified.
#
#   With the option -r (reverse), use the format format to parse the input
#   string timestring and output the number of seconds since the epoch at which
#   the time occurred. If no timezone is parsed, the current timezone is used;
#   other parameters are set to zero if not present. If timestring does not
#   match format the command returns status 1; it will additionally print an
#   error message unless the option -q (quiet) is given. If timestring matches
#   format but not all characters in timestring were used, the conversion
#   succeeds; however, a warning is issued unless the option -q is given. The
#   matching is implemented by the system function strptime; see strptime(3).
#   This means that zsh format extensions are not available, however for reverse
#   lookup they are not required. If the function is not implemented, the
#   command returns status 2 and (unless -q is given) prints a message.
#
#   If -s scalar is given, assign the date string (or epoch time in seconds if
#   -r is given) to scalar instead of printing it.
#
# The zsh/datetime module makes available one parameter:
# EPOCHSECONDS
#   An integer value representing the number of seconds since the epoch.
#autoload -Uz zsh/datetime

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

# THE ZSH/TERMINFO MODULE
# The zsh/terminfo module makes available one builtin command:
#
# echoti cap [ arg ]
#   Output the terminfo value corresponding to the capability cap, instantiated
#   with arg if applicable.
#
# The zsh/terminfo module makes available one parameter:
# terminfo
#   An associative array that maps terminfo capability names to their values.
#autoload -Uz zsh/terminfo

# THE ZSH/ZUTIL MODULE
# The zsh/zutil module only adds some builtins:
#
# zstyle [ -L [ pattern [ style ] ] ]
# zstyle [ -e | - | -- ] pattern style strings ...
# zstyle -d [ pattern [ styles ... ] ]
# zstyle -g name [ pattern [ style ] ]
# zstyle -abs context style name [ sep ]
# zstyle -Tt context style [ strings ...]
# zstyle -m context style pattern
#   This builtin command is used to define and lookup styles. Styles are pairs
#   of names and values, where the values consist of any number of strings. They
#   are stored together with patterns and lookup is done by giving a string,
#   called the `context', which is compared to the patterns. The definition
#   stored for the first matching pattern will be returned.
#
#   For ordering of comparisons, patterns are searched from most specific to
#   least specific, and patterns that are equally specific keep the order in
#   which they were defined. A pattern is considered to be more specific than
#   another if it contains more components (substrings separated by colons) or
#   if the patterns for the components are more specific, where simple strings
#   are considered to be more specific than patterns and complex patterns are
#   considered to be more specific than the pattern `*'.
#
#   The first form (without arguments) lists the definitions. Styles are shown
#   in alphabetic order and patterns are shown in the order zstyle will test
#   them.
#
#   If the -L option is given, listing is done in the form of calls to zstyle.
#   The optional first argument is a pattern which will be matched against the
#   string supplied as the pattern for the context; note that this means, for
#   example, `zstyle -L ":completion:*"' will match any supplied pattern
#   beginning `:completion:', not just ":completion:*": use ":completion:\*" to
#   match that. The optional second argument limits the output to a specific
#   style (not a pattern). -L is not compatible with any other options.
#
#   The other forms are the following:
#
#   zstyle [ - | -- | -e ] pattern style strings ...
#       Defines the given style for the pattern with the strings as the value.
#       If the -e option is given, the strings will be concatenated (separated
#       by spaces) and the resulting string will be evaluated (in the same way
#       as it is done by the eval builtin command) when the style is looked up.
#       In this case the parameter `reply' must be assigned to set the strings
#       returned after the evaluation. Before evaluating the value, reply is
#       unset, and if it is still unset after the evaluation, the style is
#       treated as if it were not set.
#
#   zstyle -d [ pattern [ styles ... ] ]
#       Delete style definitions. Without arguments all definitions are deleted,
#       with a pattern all definitions for that pattern are deleted and if any
#       styles are given, then only those styles are deleted for the pattern.
#
#   zstyle -g name [ pattern [ style ] ]
#       Retrieve a style definition. The name is used as the name of an array in
#       which the results are stored. Without any further arguments, all
#       patterns defined are returned. With a pattern the styles defined for
#       that pattern are returned and with both a pattern and a style, the value
#       strings of that combination is returned.
#
#   The other forms can be used to look up or test patterns.
#
#   zstyle -s context style name [ sep ]
#       The parameter name is set to the value of the style interpreted as a
#       string. If the value contains several strings they are concatenated with
#       spaces (or with the sep string if that is given) between them.
#
#   zstyle -b context style name
#       The value is stored in name as a boolean, i.e. as the string `yes' if
#       the value has only one string and that string is equal to one of `yes',
#       `true', `on', or `1'. If the value is any other string or has more than
#       one string, the parameter is set to `no'.
#
#   zstyle -a context style name
#       The value is stored in name as an array. If name is declared as an
#       associative array, the first, third, etc. strings are used as the keys
#       and the other strings are used as the values.
#
#   zstyle -t context style [ strings ...]
#   zstyle -T context style [ strings ...]
#       Test the value of a style, i.e. the -t option only returns a status
#       (sets $?). Without any strings the return status is zero if the style is
#       defined for at least one matching pattern, has only one string in its
#       value, and that is equal to one of `true', `yes', `on' or `1'. If any
#       strings are given the status is zero if and only if at least one of the
#       strings is equal to at least one of the strings in the value. If the
#       style is not defined, the status is 2.
#
#       The -T option tests the values of the style like -t, but it returns
#       status zero (rather than 2) if the style is not defined for any matching
#       pattern.
#
#   zstyle -m context style pattern
#       Match a value. Returns status zero if the pattern matches at least one
#       of the strings in the value.
#
# zformat -f param format specs ...
# zformat -a array sep specs ...
#   This builtin provides two different forms of formatting. The first form is
#   selected with the -f option. In this case the format string will be modified
#   by replacing sequences starting with a percent sign in it with strings from
#   the specs. Each spec should be of the form `char:string' which will cause
#   every appearance of the sequence `%char' in format to be replaced by the
#   string. The `%' sequence may also contain optional minimum and maximum field
#   width specifications between the `%' and the `char' in the form `%min.maxc',
#   i.e. the minimum field width is given first and if the maximum field width
#   is used, it has to be preceded by a dot. Specifying a minimum field width
#   makes the result be padded with spaces to the right if the string is shorter
#   than the requested width. Padding to the left can be achieved by giving a
#   negative minimum field width. If a maximum field width is specified, the
#   string will be truncated after that many characters. After all `%' sequences
#   for the given specs have been processed, the resulting string is stored in
#   the parameter param.
#
#   The %-escapes also understand ternary expressions in the form used by
#   prompts. The % is followed by a `(' and then an ordinary format specifier
#   character as described above. There may be a set of digits either before or
#   after the `('; these specify a test number, which defaults to zero. Negative
#   numbers are also allowed. An arbitrary delimiter character follows the
#   format specifier, which is followed by a piece of `true' text, the delimiter
#   character again, a piece of `false' text, and a closing parenthesis. The
#   complete expression (without the digits) thus looks like `%(X.text1.text2)',
#   except that the `.' character is arbitrary. The value given for the format
#   specifier in the char:string expressions is evaluated as a mathematical
#   expression, and compared with the test number. If they are the same, text1
#   is output, else text2 is output. A parenthesis may be escaped in text2 as
#   %). Either of text1 or text2 may contain nested %-escapes.
#
#   For example:
#       zformat -f REPLY "The answer is '%3(c.yes.no)'." c:3
#   outputs "The answer is 'yes'." to REPLY since the value for the format
#   specifier c is 3, agreeing with the digit argument to the ternary
#   expression.
#
#   The second form, using the -a option, can be used for aligning strings.
#   Here, the specs are of the form `left:right' where `left' and `right' are
#   arbitrary strings. These strings are modified by replacing the colons by the
#   sep string and padding the left strings with spaces to the right so that the
#   sep strings in the result (and hence the right strings after them) are all
#   aligned if the strings are printed below each other. All strings without a
#   colon are left unchanged and all strings with an empty right string have the
#   trailing colon removed. In both cases the lengths of the strings are not
#   used to determine how the other strings are to be aligned. The resulting
#   strings are stored in the array.
#
# zregexparse
#   This implements some internals of the _regex_arguments function.
#
# zparseopts [ -D ] [ -K ] [ -E ] [ -a array ] [ -A assoc ] specs
#   This builtin simplifies the parsing of options in positional parameters,
#   i.e. the set of arguments given by $*. Each spec describes one option and
#   must be of the form `opt[=array]'. If an option described by opt is found in
#   the positional parameters it is copied into the array specified with the -a
#   option; if the optional `=array' is given, it is instead copied into that
#   array.
#
#   Note that it is an error to give any spec without an `=array' unless one of
#   the -a or -A options is used.
#
#   Unless the -E option is given, parsing stops at the first string that isn't
#   described by one of the specs. Even with -E, parsing always stops at a
#   positional parameter equal to `-' or `--'.
#
#   The opt description must be one of the following. Any of the special
#   characters can appear in the option name provided it is preceded by a
#   backslash.
#
#       name
#       name+ The name is the name of the option without the leading `-'. To
#             specify a GNU-style long option, one of the usual two leading `-'
#             must be included in name; for example, a `--file' option is
#             represented by a name of `-file'.
#
#             If a `+' appears after name, the option is appended to array each
#             time it is found in the positional parameters; without the `+'
#             only the last occurrence of the option is preserved.
#
#             If one of these forms is used, the option takes no argument, so
#             parsing stops if the next positional parameter does not also begin
#             with `-' (unless the -E option is used).
#
#       name:
#       name:-
#       name:: If one or two colons are given, the option takes an argument;
#              with one colon, the argument is mandatory and with two colons it
#              is optional. The argument is appended to the array after the
#              option itself.
#
#              An optional argument is put into the same array element as the
#              option name (note that this makes empty strings as arguments
#              indistinguishable). A mandatory argument is added as a separate
#              element unless the `:-' form is used, in which case the argument
#              is put into the same element.
#
#              A `+' as described above may appear between the name and the
#              first colon.
#
#   The options of zparseopts itself are:
#   -a array
#       As described above, this names the default array in which to store the
#       recognised options.
#
#   -A assoc
#       If this is given, the options and their values are also put into an
#       associative array with the option names as keys and the arguments (if
#       any) as the values.
#
#   -D
#       If this option is given, all options found are removed from the
#       positional parameters of the calling shell or shell function, up to but
#       not including any not described by the specs. This is similar to using
#       the shift builtin.
#
#   -K
#       With this option, the arrays specified with the -a and -A options and
#       with the `=array' forms are kept unchanged when none of the specs for
#       them is used. This allows assignment of default values to them before
#       calling zparseopts.
#
#   -E
#       This changes the parsing rules to not stop at the first string that
#       isn't described by one of the specs. It can be used to test for or (if
#       used together with -D) extract options and their arguments, ignoring all
#       other options and arguments that may be in the positional parameters.
#
#   For example,
#       set -- -a -bx -c y -cz baz -cend
#       zparseopts a=foo b:=bar c+:=bar
#   will have the effect of
#       foo=(-a)
#       bar=(-b x -c y -c z)
#   The arguments from `baz' on will not be used.
#
#   As an example for the -E option, consider:
#       set -- -a x -b y -c z arg1 arg2
#       zparseopts -E -D b:=bar
#   will have the effect of
#       bar=(-b y)
#       set -- -a x -c z arg1 arg2
#   I.e., the option -b and its arguments are taken from the positional
#   parameters and put into the array bar.
autoload -Uz zsh/zutil
#}}}

# {{{ Prompt Themes
################################################################################
# You should make sure all the functions from the Functions/Prompts directory of
# the source distribution are available; they all begin with the string
# `prompt_' except for the special function`promptinit'. You also need the
# `colors' function from Functions/Misc. All of these functions may already have
# been installed on your system; if not, you will need to find them and copy
# them. The directory should appear as one of the elements of the fpath array
# (this should already be the case if they were installed), and at least the
# function promptinit should be autoloaded; it will autoload the rest. Finally,
# to initialize the use of the system you need to call the promptinit function.
# The following code in your .zshrc will arrange for this; assume the functions
# are stored in the directory ~/myfns:
#
#   fpath=(~/myfns $fpath)
#   autoload -U promptinit
#   promptinit
#autoload -Uz promptinit
#}}}

# {{{ ZMV
################################################################################
# Move (usually, rename) files matching the pattern srcpat to corresponding
# files having names of the form given by dest, where srcpat contains
# parentheses surrounding patterns which will be replaced in turn by $1, $2, ...
# in dest. For example,
#   zmv '(*).lis' '$1.txt'
# renames `foo.lis' to `foo.txt', `my.old.stuff.lis' to `my.old.stuff.txt', and
# so on.
#
# The pattern is always treated as an EXTENDED_GLOB pattern. Any file whose name
# is not changed by the substitution is simply ignored. Any error (a
# substitution resulted in an empty string, two substitutions gave the same
# result, the destination was an existing regular file and -f was not given)
# causes the entire function to abort without doing anything.
autoload -Uz zmv
#}}}

# {{{ Other Functions
################################################################################
# colors
#   This function initializes several associative arrays to map color names to
#   (and from) the ANSI standard eight-color terminal codes. These are used by
#   the prompt theme system (24.3 Prompt Themes). You seldom should need to run
#   colors more than once.
#
#   The eight base colors are: black, red, green, yellow, blue, magenta, cyan,
#   and white. Each of these has codes for foreground and background. In
#   addition there are eight intensity attributes: bold, faint, standout,
#   underline, blink, reverse, and conceal. Finally, there are six codes used to
#   negate attributes: none (reset all attributes to the defaults), normal
#   (neither bold nor faint), no-standout, no-underline, no-blink, and
#   no-reverse.
#   Some terminals do not support all combinations of colors and intensities.
#
#   The associative arrays are:
#   color
#   colour
#       Map all the color names to their integer codes, and integer codes to the
#       color names. The eight base names map to the foreground color codes, as
#       do names prefixed with `fg-', such as `fg-red'. Names prefixed with
#       `bg-', such as `bg-blue', refer to the background codes. The reverse
#       mapping from code to color yields base name for foreground codes and the
#       bg- form for backgrounds.
#
#       Although it is a misnomer to call them `colors', these arrays also map
#       the other fourteen attributes from names to codes and codes to names.
#   fg
#   fg_bold
#   fg_no_bold
#       Map the eight basic color names to ANSI terminal escape sequences that
#       set the corresponding foreground text properties. The fg sequences
#       change the color without changing the eight intensity attributes.
#
#   bg
#   bg_bold
#   bg_no_bold
#       Map the eight basic color names to ANSI terminal escape sequences that
#       set the corresponding background properties. The bg sequences change the
#       color without changing the eight intensity attributes.
#
#   In addition, the scalar parameters reset_color and bold_color are set to the
#   ANSI terminal escapes that turn off all attributes and turn on bold
#   intensity, respectively.
#autoload -Uz colors

# zsh-mime-setup [-flv]
# zsh-mime-handler
# These two functions use the files ~/.mime.types and /etc/mime.types, which
# associate types and extensions, as well as ~/.mailcap and /etc/mailcap files,
# which associate types and the programs that handle them. These are provided on
# many systems with the Multimedia Internet Mail Extensions.
#
# To enable the system, the function zsh-mime-setup should be autoloaded and
# run. This allows files with extensions to be treated as executable; such files
# be completed by the function completion system. The function zsh-mime-handler
# should not need to be called by the user.
#
# The system works by setting up suffix aliases with `alias -s'. Suffix aliases
# already installed by the user will not be overwritten.
#
# Repeated calls to zsh-mime-setup do not override the existing mapping between
# suffixes and executable files unless the option -f is given. Note, however,
# that this does not override existing suffix aliases assigned to handlers other
# than zsh-mime-handler. Calling zsh-mime-setup with the option -l lists the
# existing mapping without altering it. Calling zsh-mime-setup with the option
# -v causes verbose output to be shown during the setup operation.
#
# The system respects the mailcap flags needsterminal and copiousoutput, see man
# page mailcap(4).
#
# The functions use the following styles, which are defined with the zstyle
# builtin command (21.31 The zsh/zutil Module). They should be defined before
# zsh-mime-setup is run. The contexts used all start with :mime:, with
# additional components in some cases. It is recommended that a trailing *
# (suitably quoted) be appended to style patterns in case the system is extended
# in future. Some examples are given below.
#
# mime-types
#   A list of files in the format of ~/.mime.types and /etc/mime.types to be
#   read during setup, replacing the default list which consists of those two
#   files. The context is :mime:.
#
# mailcap
#   A list of files in the format of ~/.mailcap and /etc/mailcap to be read
#   during setup, replacing the default list which consists of those two files.
#   The context is :mime:.
#
# handler
#   Specifies a handler for a suffix; the suffix is given by the context as
#   :mime:.suffix:, and the format of the handler is exactly that in mailcap.
#   Note in particular the `.' and trailing colon to distinguish this use of the
#   context. This overrides any handler specified by the mailcap files. If the
#   handler requires a terminal, the flags style should be set to include the
#   word needsterminal, or if the output is to be displayed through a pager (but
#   not if the handler is itself a pager), it should include copiousoutput.
#
# flags
#   Defines flags to go with a handler; the context is as for the handler style,
#   and the format is as for the flags in mailcap.
#
# pager
#   If set, will be used instead of ${PAGER} or more to handle suffixes where the
#   copiousoutput flag is set. The context is as for handler, i.e.
#   :mime:.suffix: for handling a file with the given suffix.
#
# Examples:
#   zstyle ':mime:*' mailcap ~/.mailcap /usr/local/etc/mailcap
#   zstyle ':mime:.txt' handler less %s
#   zstyle ':mime:.txt' flags needsterminal
#
# When zsh-mime-setup is subsequently run, it will look for mailcap entries in
# the two files given. Files of suffix .txt will be handled by running `less
# file.txt'. The flag needsterminal is set to show that this program must run
# attached to a terminal.
#
# As there are several steps to dispatching a command, the following should be
# checked if attempting to execute a file by extension .ext does not have the
# expected effect. starteit() eit()( The command `alias -s ext' should show
# `ps=zsh-mime-handler'. If it shows something else, another suffix alias was
# already installed and was not overwritten. If it shows nothing, no handler was
# installed: this is most likely because no handler was found in the .mime.types
# and mailcap combination for .ext files. In that case, appropriate handling
# should be added to ~/.mime.types and mailcap. ) eit()( If the extension is
# handled by zsh-mime-handler but the file is not opened correctly, either the
# handler defined for the type is incorrect, or the flags associated with it are
# in appropriate. Running zsh-mime-setup -l will show the handler and, if there
# are any, the flags. A %s in the handler is replaced by the file (suitably
# quoted if necessary). Check that the handler program listed lists and can be
# run in the way shown. Also check that the flags needsterminal or copiousoutput
# are set if the handler needs to be run under a terminal; the second flag is
# used if the output should be sent to a pager. An example of a suitable mailcap
# entry for such a program is:
#
# text/html; /usr/bin/lynx '%s'; needsterminal
#autoload Uz zsh-mime-setup
#zsh-mime-setup
#zstyle ':mime:*' mailcap ~/.mailcap /etc/mailcap

# pick-web-browser
# This function is separate from the two MIME functions described above and can
# be assigned directly to a suffix:
#   autoload -U pick-web-browser
#   alias -s html=pick-web-browser
#
# It is provided as an intelligent front end to dispatch a web browser. It will
# check if an X Windows display is available, and if so if there is already a
# browser running which can accept a remote connection. In that case, the file
# will be displayed in that browser; you should check explicitly if it has
# appeared in the running browser's window. Otherwise, it will start a new
# browser according to a builtin set of preferences.
#
# Alternatively, pick-web-browser can be run as a zsh script.
#
# Two styles are available to customize the choice of browsers: x-browsers when
# running under the X Windows System, and tty-browsers otherwise. These are
# arrays in decreasing order of preference consiting of the command name under
# which to start the browser. They are looked up in the context :mime: (which
# may be extended in future, so appending `*' is recommended). For example,
#   zstyle ':mime:*' x-browsers opera konqueror netscape
# specifies that pick-web-browser should first look for a runing instance of
# Opera, Konqueror or Netscape, in that order, and if it fails to find any
# should attempt to start Opera.
#autoload -Uz pick-web-browser
#zstyle ':mime:*' x-browsers firefox iceweasel chromium chrome
#zstyle ':mime:*' tty-browsers w3m links elinks

# vcs_info
# In a lot of cases, it is nice to automatically retrieve information from
# version control systems (VCSs), such as subversion, CVS or git, to be able to
# provide it to the user; possibly in the user's prompt. So that you can
# instantly tell on which branch you are currently on, for example
autoload -Uz vcs_info

zstyle ':vcs_info:*:prompt:*' disable           ALL
zstyle ':vcs_info:*:prompt:*' enable            git svn
zstyle ':vcs_info:*:prompt:*' max-exports       2

zstyle ':vcs_info:*:prompt:*' actionformats     "(${BOLD_BLACK}%s${NO_COLOR}) [ ${BOLD_CYAN}%b${NO_COLOR}|${BOLD_YELLOW}%a${NO_COLOR} ] "
zstyle ':vcs_info:*:prompt:*' branchformat      "${BOLD_CYAN}%b${NO_COLOR}: ${BOLD_GREEN}%r"
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' formats           "%u%c${NO_COLOR} (${BOLD_BLACK}%s${NO_COLOR}) [${BOLD_CYAN}%b${NO_COLOR}] ${MAGENTA}%12.12i${NO_COLOR}"
zstyle ':vcs_info:*:prompt:*' get-revision      true
zstyle ':vcs_info:*:prompt:*' stagedstr         "${BOLD_GREEN}*"
zstyle ':vcs_info:*:prompt:*' unstagedstr       "${BOLD_YELLOW}*"
#}}}

# {{{ change to HOME directory
cd #}}}

# {{{ load resources
# load none ZSH components and/or configurations for all shells but jump to HOME
# before
for sh in ~/.shell/*.sh; do
    [[ -r "${sh}" ]] && source "${sh}" || true
done #}}}

# vim: filetype=zsh textwidth=80 foldmethod=marker
