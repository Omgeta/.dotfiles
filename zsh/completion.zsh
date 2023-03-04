##       ##
# General #
##       ##

# Load more completions
if [ -f $DOTFILES/zsh/plugins/zsh-completions/src ]; then
	fpath=($DOTFILES/zsh/plugins/zsh-completions/src $fpath)
fi

# Needs to be called before compinit
zmodload zsh/complist

# Use hjlk in menu selection (during completion)
# Doesn't work well with interactive mode
bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xi' vi-insert                      # Insert
bindkey -M menuselect '^xh' accept-and-hold                # Hold
bindkey -M menuselect '^xn' accept-and-infer-next-history  # Next
bindkey -M menuselect '^xu' undo                           # Undo

autoload -U compinit; compinit
_comp_options+=(globdots) # With hidden files

# Only work with the Zsh function vman
compdef vman="man"


##       ##
# Zstyles #
##       ##

# Choose completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Use cache for faster completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true
zle -C alias-expansion complete-word _generic
bindkey '^Xa' alias-expansion
zstyle ':completion:alias-expansion:*' completer _expand_alias

# Allow menu selection for completion
zstyle ':completion:*' menu select

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true

zstyle ':completion:*' file-sort modification

# Formatting completion results
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}[! %d (errors: %e) !]%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}[ %D %d ]%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple}[ %d ]%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}[! No matches !]%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases

# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''

zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' keep-prefix true

# Formatting for connections
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
