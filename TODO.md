# TODO

## Fish

* [ ] Add fish functions and completions (if I create custom ones later?)
* [ ] Drop `source /usr/share/cachyos-fish-config/cachyos-config.fish` from config.fish, replace with config

 
* [ ] I had this claude discussion about automatic saving (or readding) to chezmoi. Where is it? (somewhere in chat with ai)
* [ ] chezmoi managed --include=files | xargs -I {} chezmoi_modify_manager --smart-add ~/{}

## Claude Code

* [ ] Publish `tmux-claude-sessions` (`~/Projects/side-projects/tmux-claude-sessions` has no git remote yet), then add it to `run_once_after_clone-side-projects.sh` so the `~/.local/bin/claude-sessions` symlink and its SessionEnd hook work on a fresh machine. It also needs `python` in `.chezmoidata/packages.yaml`.

## keyd

* [ ] AirPods double-tap to pause/play doesn't work. Tried excluding the device from keyd with
  `-004c:2027` under `[ids]` in `root_files/etc/keyd/default.conf` (004c = Apple vendor ID), didn't help.
  Investigate where the AVRCP/media key events get lost (bluez/wireplumber vs keyd) before re-adding it.
