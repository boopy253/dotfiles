#!/usr/bin/env zsh

autoload -U colors && colors

# Get script directory
DOTFILES_DIR="${0:A:h}"

# Array of all symlink targets
typeset -a SYMLINKS
SYMLINKS=(
    # Root level
    "$HOME/.editorconfig"
    "$HOME/.fzf.zsh"
    "$HOME/.gitconfig"
    "$HOME/.gitignore_global"
    "$HOME/.gitmessage"
    "$HOME/.p10k.zsh"
    "$HOME/.vimrc"
    "$HOME/.zprofile"
    "$HOME/.zshenv"
    "$HOME/.zshrc"
    # Config directories
    "$HOME/.config/bat"
    "$HOME/.config/ghostty"
    "$HOME/.config/lazygit"
    "$HOME/.config/lsd"
    "$HOME/.config/nvim"
    "$HOME/.config/wezterm"
)

print -P "%B%F{red}Removing dotfile symlinks...%f%b"
print

for link in $SYMLINKS; do
    if [[ -L "$link" ]]; then
        rm "$link"
        print -P "%F{green}✓ Removed: ${link#$HOME/}%f"
    elif [[ -e "$link" ]]; then
        print -P "%F{yellow}⚠ Not a symlink: ${link#$HOME/}%f"
    fi
done

print
print -P "%F{green}✨ Cleanup completed!%f"
