# .zshenv - Sourced by all zsh shells (login, interactive, scripts)
# This file is sourced before .zprofile and .zshrc

# Set ZDOTDIR early to control where dotfiles are loaded from
export ZDOTDIR="$HOME"

# Essential exports that should be available everywhere
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# XDG Base Directory specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
