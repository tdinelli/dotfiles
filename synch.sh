MACOSX_HOME="/Users/tdinelli"
MACOSX_CONFIG_HOME="/Users/tdinelli/.config"
MACOSX_SSH_HOME="/Users/tdinelli/.ssh"
MACOSX_DOTFILES_DIR="$MACOSX_HOME/Documents/GitHub/dotfiles/"

stow --no-folding --dotfiles --target="$MACOSX_HOME" --dir="$MACOSX_DOTFILES_DIR" zshrc
stow --no-folding --dotfiles --target="$MACOSX_HOME" --dir="$MACOSX_DOTFILES_DIR" vim
stow --no-folding --dotfiles --target="$MACOSX_HOME" --dir="$MACOSX_DOTFILES_DIR" tmux
stow --no-folding --target="$MACOSX_CONFIG_HOME" --dir="$MACOSX_DOTFILES_DIR" neovim
stow --no-folding --target="$MACOSX_CONFIG_HOME" --dir="$MACOSX_DOTFILES_DIR" alacritty
stow --no-folding --target="$MACOSX_SSH_HOME" --dir="$MACOSX_DOTFILES_DIR" ssh
