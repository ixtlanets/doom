# Doom Emacs Config

Personal Doom Emacs private configuration for machines managed by `~/nix-config`.

This repository is only the Doom private config, normally checked out at:

```sh
~/.config/doom
```

The Emacs binary, fonts, native build dependencies, language tooling, and common CLI tools are expected to come from `~/nix-config`. On Linux and WSL this is mainly through `modules/home-manager/emacs.nix` and `modules/home-manager/common.nix`; on macOS, some GUI tools are provided through the nix-darwin/Homebrew setup.

## New Machine Setup

### 1. Apply `~/nix-config`

Clone and activate the machine configuration first.

For NixOS:

```sh
git clone git@github.com:ixtlanets/nix-config.git ~/nix-config
cd ~/nix-config
sudo nixos-rebuild switch --flake .#<host>
```

For standalone Home Manager, for example WSL:

```sh
git clone git@github.com:ixtlanets/nix-config.git ~/nix-config
cd ~/nix-config
home-manager switch --flake .#nik@wsl
```

For macOS with nix-darwin:

```sh
git clone git@github.com:ixtlanets/nix-config.git ~/nix-config
cd ~/nix-config
darwin-rebuild switch --flake .#<host>
```

Use the host names and bootstrap details from `~/nix-config/README.md`.

After this step, the machine should have Emacs and the dependencies this Doom config expects, including:

- `emacs`
- Nerd fonts, including Hack Nerd Font
- `ripgrep`, `sqlite`, `graphviz`, `wordnet`
- `nil` for Nix LSP
- `libvterm` on Linux
- `codex` from the shared package set on Linux/WSL, or Homebrew on macOS

### 2. Install Doom Emacs

If Doom itself is not already present at `~/.config/emacs`, clone it:

```sh
git clone --depth 1 --recurse-submodules https://github.com/doomemacs/doomemacs ~/.config/emacs
```

The Doom CLI should then be available at:

```sh
~/.config/emacs/bin/doom
```

If Doom was already cloned without submodules, initialize them before running `doom sync`:

```sh
git -C ~/.config/emacs submodule update --init --recursive
```

### 3. Install this private config

Clone this repository as Doom's private config:

```sh
git clone git@github.com:ixtlanets/doom.git ~/.config/doom
```

If `~/.config/doom` already exists, move it aside first and then clone this repo.

### 4. Sync Doom

Install Doom packages and generate autoloads:

```sh
~/.config/emacs/bin/doom sync
```

Then start or restart Emacs:

```sh
emacs
```

## Post-Install Checks

Check that Doom sees the config:

```sh
~/.config/emacs/bin/doom doctor
```

Open Emacs and verify:

- `SPC h r r` reloads the Doom config
- `SPC p p` can find projects under `~/pro/`
- `M-x org-agenda` sees files under `~/org/`
- `M-x vterm` starts correctly

## Codex IDE

This config installs `codex-ide` for using Codex inside Emacs.

Keybindings:

- `C-c C-;` opens the Codex IDE menu
- `SPC o c` starts a Codex session
- `SPC o C` opens the Codex IDE menu

The `codex` CLI is provided by `~/nix-config`, but authentication is per-machine. On a new machine run:

```sh
codex login
```

## Local Expectations

This config assumes a few personal paths exist:

- `~/org/` for Org files and agenda files
- `~/pro/` for Projectile project discovery
- mail accounts named `gmail` and `zencar` for `mu4e`

If these are not present yet, Emacs may still start, but the related workflows will need their data or services restored separately.

## Updating

After changing `init.el` or `packages.el`, run:

```sh
~/.config/emacs/bin/doom sync
```

After changing only `config.el`, usually reload Doom from Emacs with `SPC h r r` or restart Emacs.

To update packages:

```sh
~/.config/emacs/bin/doom upgrade
~/.config/emacs/bin/doom sync
```
