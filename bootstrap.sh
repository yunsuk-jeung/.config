#!/usr/bin/env bash
# Set up this config on a fresh macOS machine.
#
#   git clone https://github.com/yunsuk-jeung/.config.git ~/.config
#   ~/.config/bootstrap.sh
#
# Safe to re-run: every step checks before it acts.

set -uo pipefail

CONFIG="$HOME/.config"
ZSH_CUSTOM_DIR="$HOME/.oh-my-zsh/custom"
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
skip() { printf '  \033[90m·\033[0m %s\n' "$1"; }
step() { printf '\n\033[1m==> %s\033[0m\n' "$1"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$1"; }

[[ "$(uname -s)" == "Darwin" ]] || { echo "macOS only"; exit 1; }

# ── homebrew ──────────────────────────────────────────────────────────────
step "Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ok "installed"
else
  skip "already installed"
fi

step "Packages (Brewfile)"
brew bundle --file="$CONFIG/Brewfile" && ok "brew bundle done"

# ── oh-my-zsh + theme + plugins ───────────────────────────────────────────
step "oh-my-zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ok "installed"
else
  skip "already installed"
fi

clone_if_missing() {  # <repo-url> <dest> <label>
  if [[ -d "$2" ]]; then skip "$3"; else git clone -q --depth 1 "$1" "$2" && ok "$3"; fi
}
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k" "powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions \
                 "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" "zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting \
                 "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" "zsh-syntax-highlighting"

# ── dotfile symlinks ──────────────────────────────────────────────────────
step "Symlinks"
link() {  # <src-in-repo> <dest-in-home>
  if [[ -L "$2" && "$(readlink "$2")" == "$1" ]]; then skip "$(basename "$2")"; return; fi
  [[ -e "$2" && ! -L "$2" ]] && mv "$2" "$2.backup.$(date +%s)" && warn "backed up existing $(basename "$2")"
  ln -sfn "$1" "$2" && ok "$(basename "$2") -> ${1/#$HOME/\~}"
}
link "$CONFIG/zsh/zshrc"    "$HOME/.zshrc"
link "$CONFIG/zsh/p10k.zsh" "$HOME/.p10k.zsh"

# ── tmux ──────────────────────────────────────────────────────────────────
step "tmux plugins"
clone_if_missing https://github.com/tmux-plugins/tpm "$CONFIG/tmux/plugins/tpm" "tpm"
# install_plugins needs a server that has already sourced the config, otherwise
# it dies with "unknown variable: TMUX_PLUGIN_MANAGER_PATH"
if tmux start-server \; source-file "$CONFIG/tmux/tmux.conf" 2>/dev/null; then
  "$CONFIG/tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 && ok "plugins installed"
else
  warn "could not reach a tmux server -- run: tmux, then prefix + I"
fi

# ── sketchybar whale glyph ────────────────────────────────────────────────
step "sketchybar whale glyph"
# font-sketchybar-app-font is a brew cask, so `brew upgrade` restores the stock
# .ttf and drops the patch. Re-run this step whenever that happens.
if python3 -c 'import fontTools, PIL' 2>/dev/null; then skip "fonttools + pillow present"
else pip3 install --quiet --user fonttools pillow && ok "installed fonttools + pillow"; fi
if [[ -d /Applications/Whale.app ]]; then
  python3 "$CONFIG/sketchybar/helpers/whale-glyph/build_whale_glyph.py" 2>&1 | grep -v 'extra bytes' || true
else
  warn "Whale.app not installed -- skipping glyph patch"
fi

# ── manual steps ──────────────────────────────────────────────────────────
cat <<'MANUAL'

==> Left to do by hand (cannot be scripted)

  Raycast   Settings > Extensions > + > Add Script Directory
            -> ~/.config/raycast/scripts
            then set the alias "nk" on "New Kitty Window".
            (Raycast keeps directories and aliases in its own SQLite db.)

  Permissions
            System Settings > Privacy & Security
              Accessibility     -> AeroSpace, kanata
              Screen Recording  -> whatever captures the screen

  Apps not in the Brewfile
            NAVER Whale (needed for the sketchybar whale glyph)

  Then      chsh -s /bin/zsh   (if zsh is not already the login shell)
            exec zsh

MANUAL
