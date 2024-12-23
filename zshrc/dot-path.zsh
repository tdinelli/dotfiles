# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Brew
export PATH="/opt/homebrew/bin:$PATH"

# Latex (I don't know why but in alacritty this is not automatically
# sourced maybe is not alacritty but me messing up some configurations)
export PATH="/Library/TeX/texbin/:$PATH"
