# TODO

## Fish

* [ ] Add fish functions and completions (if I create custom ones later?)
* [ ] Drop `source /usr/share/cachyos-fish-config/cachyos-config.fish` from config.fish, replace with config

 
* [ ] I had this claude discussion about automatic saving (or readding) to chezmoi. Where is it? (somewhere in chat with ai)
* [ ] chezmoi managed --include=files | xargs -I {} chezmoi_modify_manager --smart-add ~/{}

## Claude Code

* [ ] Publish `claude-sessions` (`~/Projects/side-projects/claude-sessions` has no git remote yet), then add it to `run_once_after_clone-side-projects.sh` so the `~/.local/bin/claude-sessions` symlink and its SessionEnd hook work on a fresh machine. It also needs `python` in `.chezmoidata/packages.yaml`.
