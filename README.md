# Dotfiles

Personal development configuration for Ubuntu on WSL, Windows Terminal, Zsh,
Tmux, Neovim, and Git.

## Install

Clone with submodules so Zsh completion and syntax highlighting are available:

```sh
git clone --recurse-submodules https://github.com/Omgeta/.dotfiles.git "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
./install.sh
```

For an existing checkout, run `git submodule update --init --recursive`.
The installer works from any directory. It links configs into the XDG config
directory, preserves existing files and directories as adjacent
`*.backup-<timestamp>-<pid>` backups, and leaves correct links alone on subsequent
runs. Use `./install.sh -y` to skip confirmation.

`install.sh` only links configs, with backups. For a fresh machine or the
Neovim upgrade, run:

```sh
~/.dotfiles/bootstrap.sh
exec zsh
nvim --version
```

Bootstrap installs Ubuntu packages (including the Python Neovim provider),
Neovim 0.12.5 from the official Linux archive, the recorded Zsh submodules,
the Tmux plugin manager, and your config links. It requires `sudo`, APT, and
network access. Run it as your normal user, without `sudo` in front of the script.
Both scripts work from any directory and can be run again.

Neovim releases live under `$XDG_DATA_HOME/nvim/releases` (default
`~/.local/share/nvim/releases`). The installer validates the downloaded executable
before switching `~/.local/bin/nvim`; existing releases and system installations
are preserved. Zsh places `~/.local/bin` first on PATH. In Bash, run
`export PATH="$HOME/.local/bin:$PATH"` and `hash -r` to use this installation.
For future upgrades, change `version` in `install/bootstrap-neovim.sh` and rerun
bootstrap. The version is pinned so repeat runs use the same release.

Inside Neovim, run `:Lazy sync`, `:TSUpdate`, and `:checkhealth` after upgrading.
Missing plugins install on first launch; existing plugins update with `:Lazy sync`.
Treesitter stays on its compatible `master` branch until its configuration is
migrated to the new API. Inside Tmux, press `Ctrl-a` then `Shift-I` to install
plugins. Set your login shell separately with `chsh -s "$(command -v zsh)"`.

For LaTeX support, install `latexmk`, `zathura`, and the TeX Live packages you need.

## Layout

- `install.sh` and `install/`: config links and optional package setup.
- `zsh/`: environment, aliases, prompt, completion, and plugin submodules.
- `nvim/`: Lua configuration and LaTeX snippets.
- `tmux/` and `git/`: application configuration.

The installer respects `XDG_CONFIG_HOME`, `ZDOTDIR`, and `VIMCONFIG`.
Zsh also respects `XDG_DATA_HOME` and `XDG_CACHE_HOME`. Zsh defaults `DOTFILES` to `$HOME/.dotfiles`; export
`DOTFILES` before starting Zsh if you keep the checkout elsewhere. Optional
language managers are loaded only when installed. NVM initializes on the first
`nvm`, `node`, `npm`, or `npx` command; run `nvm use default` before launching
applications that need Node on their inherited PATH. Conda initializes on the
first `conda` command; activate environments explicitly with `conda activate`.
Set `CONDA_HOME` if Anaconda is installed outside `/opt/anaconda3`.
The WSL runtime fallback preserves an existing private session directory.
