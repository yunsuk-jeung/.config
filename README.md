# .config

Personal macOS config: aerospace, sketchybar, kitty, nvim, tmux, zsh.

## New machine

```sh
git clone https://github.com/yunsuk-jeung/.config.git ~/.config
~/.config/bootstrap.sh
```

`bootstrap.sh` is idempotent — re-run it any time. It installs Homebrew and
everything in `Brewfile`, sets up oh-my-zsh + powerlevel10k + zsh plugins,
symlinks `~/.zshrc` and `~/.p10k.zsh` into `zsh/`, installs tpm and the tmux
plugins, and patches the sketchybar whale glyph. It finishes by printing the
steps that cannot be scripted (Raycast alias, macOS permissions).

## Layout

| path | what |
| --- | --- |
| `Brewfile` | packages and casks, regenerate with `brew bundle dump --force` |
| `bootstrap.sh` | new-machine setup |
| `zsh/` | `zshrc` and `p10k.zsh`, symlinked into `$HOME` |
| `raycast/scripts/` | Raycast script commands (the rest of `raycast/` is ignored) |
| `sketchybar/helpers/whale-glyph/` | injects a NAVER Whale glyph into sketchybar-app-font |

`tmux/plugins/` is installed by tpm and deliberately untracked.

## Gotchas

**The whale glyph is a patched font.** `font-sketchybar-app-font` is a brew
cask, so `brew upgrade` restores the stock `.ttf` and the glyph disappears.
Re-run the patch and restart sketchybar — a `--reload` will not do, the font
cache only clears on restart:

```sh
python3 ~/.config/sketchybar/helpers/whale-glyph/build_whale_glyph.py
killall sketchybar
```

The script refuses to run twice against the same file; restore
`~/Library/Fonts/sketchybar-app-font.ttf.orig` first if you need to redo it.

**App icons in sketchybar** are looked up by the name aerospace reports, which
is not always the app's own name — NAVER Whale reports as `NAVER Whale`. Check
with `aerospace list-windows --all --format '%{app-name}'` before adding a
mapping to `sketchybar/helpers/app_icons.lua`. The font ships 559 glyphs and
only ~215 are mapped, so most additions need no new artwork.
