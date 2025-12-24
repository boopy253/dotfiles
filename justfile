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

# Measure shell startup time
profile-shell:
    @echo "Testing shell startup time (3 iterations)..."
    @time zsh -i -c exit
    @time zsh -i -c exit
    @time zsh -i -c exit

# Validate installation
validate:
    @echo "Checking symlinks..."
    @links=(\
        "{{env_var('HOME')}}/.zshrc" \
        "{{env_var('HOME')}}/.vimrc" \
        "{{env_var('HOME')}}/.gitconfig" \
        "{{env_var('HOME')}}/.config/nvim" \
    ); \
    for link in "${links[@]}"; do \
        if [ -L "$link" ]; then \
            echo "✓ $link"; \
        else \
            echo "✗ $link (not symlinked)"; \
        fi; \
    done

# Update all package managers and tools
update-all:
    @echo "Updating Homebrew..."
    brew update && brew upgrade
    @echo "Updating Neovim plugins..."
    @cd {{dotfiles_dir}} && just nvim-sync
    @echo "✨ All updates completed!"

# Create a compressed backup of dotfiles
backup-create:
    @backup_file="${HOME}/dotfiles-backup-$(date +%Y%m%d_%H%M%S).tar.gz"
    @tar -czf "$backup_file" -C {{dotfiles_dir}} . && echo "✓ Backup created: $backup_file" || echo "✗ Backup failed"

# Reload shell configuration
reload:
    @exec zsh

# Show help for commonly used commands
tips:
    @echo "Common commands:"
    @echo ""
    @echo "Shell & Setup:"
    @echo "  just install              Install all dotfiles"
    @echo "  just install-dry          Preview changes"
    @echo "  just install-force        Force overwrite existing files"
    @echo "  just reinstall            Clean reinstall"
    @echo "  just reload               Reload shell config"
    @echo ""
    @echo "Neovim:"
    @echo "  just nvim-sync            Update plugins"
    @echo "  just nvim-checkhealth     Check Neovim health"
    @echo ""
    @echo "Backups:"
    @echo "  just backup-list          List backup directories"
    @echo "  just backup-clean         Remove old backups"
    @echo "  just backup-create        Create new backup"
    @echo ""
    @echo "Validation & Monitoring:"
    @echo "  just validate             Check symlinks"
    @echo "  just profile-shell        Measure startup time"
    @echo "  just update-all           Update all tools"

