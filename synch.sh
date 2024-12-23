XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"
MACOSX_DOTFILES_DIR="$HOME/Documents/GitHub/dotfiles/"

stow --no-folding --dotfiles --target="$XDG_CONFIG_HOME/zsh" --dir="$MACOSX_DOTFILES_DIR" zshrc
stow --no-folding --target="$XDG_CONFIG_HOME/tmux" --dir="$MACOSX_DOTFILES_DIR" tmux
stow --no-folding --target="$XDG_CONFIG_HOME/nvim" --dir="$MACOSX_DOTFILES_DIR" neovim
stow --no-folding --target="$XDG_CONFIG_HOME/alacritty" --dir="$MACOSX_DOTFILES_DIR" alacritty
stow --no-folding --target="$HOME" --dir="$MACOSX_DOTFILES_DIR" ssh
