# Enable colors
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
export GREP_OPTIONS='--color=auto'
export TERM="xterm-256color"
# export TERM = "screen-256color"
# export TERM = "tmux-256color"

# Load required modules
autoload -Uz vcs_info
autoload -U colors && colors

# Configure version control information
setopt prompt_subst
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git cvs svn

# Add status indicators for git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' ✗'
zstyle ':vcs_info:git:*' stagedstr ' ✓'
zstyle ':vcs_info:git:*' formats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{yellow}%u%c%F{5}]%f '

# Configure prompt to update vcs_info before each prompt
precmd() { vcs_info }

# Set prompt with git info on the right side of first line
PS1=$'%F{green}%n%f: %F{blue}%~%f\n%F{3}❯%f '
RPROMPT='${vcs_info_msg_0_}'
PS2=$'%F{3}❯%f '

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
