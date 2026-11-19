# CLAUDE.md

chezmoi source directory for an Arch/CachyOS + KDE Plasma (Wayland) desktop. Target is `$HOME`.
This repo is **public** (github.com/dodokr/dotfiles): never commit secrets, hostnames, IPs or emails.
Machine-private notes go in `CLAUDE.local.md` (git- and chezmoi-ignored).

## Workflow

- Edit files **here**, never in `$HOME` directly. If a target was changed in place, pull it back
  with `chezmoi re-add <target>` (plain files) or `chezmoi_modify_manager --smart-add <target>` (KDE ini files, see below).
- Preview before applying: `chezmoi diff`, `chezmoi status`, `chezmoi apply --dry-run --verbose`.
  `chezmoi apply` runs pending scripts, several of which use `sudo`.
- Every file in the repo root becomes a target unless listed in `.chezmoiignore`. Add any new
  repo-only file (docs, notes) there, or it lands in `~`.
- Commits: conventional commits, scoped where useful (`feat(nvim): …`, `chore(fish): …`, `chore: …`).

## Source naming

Standard chezmoi attributes: `dot_` → `.`, `private_` → mode 0600/0700, `executable_` → +x,
`symlink_<name>` → symlink whose target is the file content, `.tmpl` → Go template.
Scripts: plain `run_` runs on every apply, `run_once_` once per distinct rendered content, `run_onchange_` when
its content changes; `_after_` runs after files are written (default is before).

## KDE configs (chezmoi_modify_manager)

KDE rewrites its ini files constantly, so they are not tracked as plain files:
- `dot_config/<name>.src.ini`: the tracked content (ignored as a target via `**/*.src.ini`).
- `dot_config/modify_<name>`: a `#!/usr/bin/env chezmoi_modify_manager` script that merges the
  `.src.ini` into the live file. Add ignore/transform rules there for volatile keys.
- Update with `chezmoi_modify_manager --smart-add ~/.config/<name>`, not `chezmoi add`.
- Requires `chezmoi_modify_manager` (AUR) to be installed before `chezmoi apply`.
- `plasma-org.kde.plasma.desktop-appletsrc` holds one machine's desktop layout (containment and
  activity IDs differ per machine; `source auto` deletes sections missing from the source). Other
  machines opt out with `kde_desktop_layout = false` under `[data]` in `~/.config/chezmoi/chezmoi.toml`.

## Files outside $HOME

`root_files/` mirrors `/` and is chezmoi-ignored. Each file there needs a root-level
`run_onchange_after_*.sh.tmpl` script that copies it with `sudo` and embeds the file's hash so it
re-runs on change. Example: `run_onchange_after_configure-keyd.sh.tmpl` → `/etc/keyd/default.conf`.

## Packages

`.chezmoidata/packages.yaml` (`packages.arch.pacman`, `packages.arch.aur`) is rendered by
`run_once_install-packages.sh.tmpl`. Editing the list changes the script content, so it re-runs
on the next apply (full `pacman -Syu` included).

## Side projects

`dot_local/bin/symlink_claude-*` point into `~/Projects/side-projects/<repo>/`.
`run_once_after_clone-side-projects.sh` clones those repos on a fresh machine; add new ones there.

## Layout

- `dot_config/nvim/`: lazy.nvim config; own modules in `lua/jozefk/`, plugin specs in `lua/plugins/`. `lazy-lock.json` is not tracked.
- `dot_config/fish/`, `dot_config/tmux/`: shell and tmux (tpm installed by `run_once_after_tmux.sh`).
- `private_dot_claude/`: Claude Code `settings.json`, `keybindings.json`, statusline script.
- `TODO.md`: open tasks. `login-screen.md`: manual (non-automated) Plasma login-screen setup.
