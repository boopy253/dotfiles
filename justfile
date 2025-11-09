# Use zsh for consistency with the existing scripts
set shell := ["zsh", "-c"]

# Helper to ensure commands run at repo root
dotfiles_dir := justfile_directory()

# Default target
default: help

help:
    @just --list --unsorted

# Install / Uninstall

install:
    @cd {{dotfiles_dir}} && ./install.sh

install-force:
    @cd {{dotfiles_dir}} && ./install.sh -f

install-dry:
    @cd {{dotfiles_dir}} && ./install.sh -n

install-interactive:
    @cd {{dotfiles_dir}} && ./install.sh -i

reinstall:
    @just uninstall
    @just install

uninstall:
    @cd {{dotfiles_dir}} && ./uninstall.sh

# Backup helpers

backup-list:
    @ls -1dt $HOME/.dotfiles_backup_* 2>/dev/null || echo "No backup directories found."

backup-clean:
    @find "$HOME" -maxdepth 1 -type d -name '.dotfiles_backup_*' -print -exec rm -rf {} \;

# Neovim tasks

nvim-sync:
    @command -v nvim >/dev/null || { printf 'Neovim not found. Please install it first.\n' >&2; exit 1; }
    @cd {{dotfiles_dir}}/.config/nvim && nvim --headless "+Lazy! sync" +qa

nvim-checkhealth:
    @command -v nvim >/dev/null || { printf 'Neovim not found. Please install it first.\n' >&2; exit 1; }
    @cd {{dotfiles_dir}}/.config/nvim && nvim --headless -c "checkhealth" -c "quit"

