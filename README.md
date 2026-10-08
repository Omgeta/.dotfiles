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

Config linking does not install packages, download plugins, or change your login
shell. To also install the Ubuntu packages and clone the Tmux plugin manager:

```sh
./bootstrap.sh
```

The bootstrap script requires `sudo`, APT, Git, and network access. Set your login shell
separately with `chsh -s "$(command -v zsh)"` if desired. Inside Tmux, press
`Ctrl-a` followed by `Shift-I` to install plugins. Neovim downloads its plugins
on first launch; use a version that supports `vim.lsp.config` and `vim.lsp.enable`
(Neovim 0.11 or newer). Ubuntu's packaged version may be older.

For LaTeX support, install `latexmk`, `zathura`, and the TeX Live packages you need.
UltiSnips also needs the Python Neovim provider (`pynvim`) in the Python environment
used by Neovim.

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
