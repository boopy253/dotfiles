#!/usr/bin/env zsh

# Enable extended globbing and null_glob
setopt EXTENDED_GLOB NULL_GLOB

# Colors
autoload -U colors && colors

# Get script directory
DOTFILES_DIR="${0:A:h}"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Configuration
typeset -A dotfiles_map
dotfiles_map=(
    # Root level dotfiles
    ".editorconfig"         "$HOME/.editorconfig"
    ".fzf.zsh"             "$HOME/.fzf.zsh"
    ".gitconfig"           "$HOME/.gitconfig"
    ".gitignore_global"    "$HOME/.gitignore_global"
    ".gitmessage"          "$HOME/.gitmessage"
    ".p10k.zsh"            "$HOME/.p10k.zsh"
    ".vimrc"               "$HOME/.vimrc"
    ".zprofile"            "$HOME/.zprofile"
    ".zshenv"              "$HOME/.zshenv"
    ".zshrc"               "$HOME/.zshrc"
    # Config directories
    ".config/bat"          "$HOME/.config/bat"
    ".config/ghostty"      "$HOME/.config/ghostty"
    ".config/lazygit"      "$HOME/.config/lazygit"
    ".config/lsd"          "$HOME/.config/lsd"
    ".config/nvim"         "$HOME/.config/nvim"
    ".config/wezterm"      "$HOME/.config/wezterm"
)

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local force=${3:-false}

    # Check if source exists
    if [[ ! -e "$source" ]]; then
        print -P "%F{red}✗ Source doesn't exist: $source%f"
        return 1
    fi

    # If target exists and is not a symlink
    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
        if [[ $force == true ]]; then
            # Create backup directory structure
            local backup_path="$BACKUP_DIR/${target#$HOME/}"
            mkdir -p "${backup_path:h}"
            mv "$target" "$backup_path"
            print -P "%F{yellow}↻ Backed up: $target%f"
        else
            print -P "%F{yellow}⚠ File exists: $target (use -f to force)%f"
            return 1
        fi
    fi

    # Remove existing symlink if it exists
    [[ -L "$target" ]] && rm "$target"

    # Create parent directory if needed
    mkdir -p "${target:h}"

    # Create symlink
    ln -s "$source" "$target"
    print -P "%F{green}✓ Linked: ${target} -> ${source}%f"
}

# Parse arguments
local force=false
local dry_run=false
local interactive=false

while getopts "fdin" opt; do
    case $opt in
        f) force=true ;;
        d) dry_run=true ;;
        i) interactive=true ;;
        n) dry_run=true ;;  # alias for dry-run
        *) print "Usage: $0 [-f] [-d] [-i]" >&2; exit 1 ;;
    esac
done

# Header
print -P "%B%F{blue}Dotfiles Installation%f%b"
print -P "Directory: %F{cyan}$DOTFILES_DIR%f"
[[ $dry_run == true ]] && print -P "%F{yellow}DRY RUN MODE%f"
[[ $force == true ]] && print -P "%F{yellow}FORCE MODE%f"
print

# Process dotfiles
for source target in ${(kv)dotfiles_map}; do
    local full_source="$DOTFILES_DIR/$source"

    if [[ $interactive == true ]]; then
        print -P "%F{cyan}Link ${source}? [Y/n]:%f "
        read -q response || { print; continue }
        print
    fi

    if [[ $dry_run == true ]]; then
        print -P "%F{blue}Would link: $target -> $full_source%f"
    else
        create_symlink "$full_source" "$target" $force
    fi
done

# Summary
if [[ -d "$BACKUP_DIR" ]] && [[ $dry_run == false ]]; then
    print
    print -P "%F{yellow}📁 Backups saved to: $BACKUP_DIR%f"
fi

print
[[ $dry_run == true ]] && print -P "%F{blue}Dry run completed!%f" || print -P "%F{green}✨ Dotfiles installed!%f"
