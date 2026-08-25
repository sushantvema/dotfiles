# Dotfiles

My configuration for primarily MacOS machines. Working on getting this setup with nix (using nix-darwin). Will contain as much of my productivity tooling as possible including but not limited to:

- Developer apps (terminal emulator, docker, etc)
- quality of life apps (tiling window manager, etc)
- macOS native configuration (typing speed, dock config, ...)
- packages

and more. Maybe in the future will also include home-manager although I hear it's a pain in the ass. 

## TODO List (migrating over from an Apple Note

- [x] Install Homebrew via `brew.sh`
- [x] Install GitHub CLI since password-based authentication is deprecated in git. Install with brew
- [x] Purchase and install TabTap (https://tabtabapp.net) for convenient tab and window switching.
- [x] Install Homerow (https://www.homerow.app) for keyboard-based UI navigation
- [ ] Install Nix onto my main Macbook Pro
- [ ] Setup nix-darwin as a flake, checked into github
- [ ] Install neovim eventually as well as my developer dependencies
  - [ ] fzf
  - [ ] zoxide
  - [ ] lazygit
- [ ] Remap caps lock to control somehow (ideally using nix-darwin config) for better productivity in the terminal
- [ ] Decrease the latency between keystrokes as much as possible using nix-darwin
- [ ] Install Wezterm, migrate from Alacritty

## Why Use Nix on a Mac?
- [Nixpkgs](https://search.nixos.org/packages) is allegedly the "biggest and freshest open-source package repository in the world". According to automated analysis by [Repology](https://repology.org/repositories/graphs)
- Better than homebrew (pseudo-native Mac package manager) by a longshot
- *Same packages cross platform*. A nix package on macos will be the same as debian, fedora, etc, at the very least in terms of versions. 
- "per project toolchain management". Apparently `nix develop` allows develops and administrators to easily manage toolchains and potentially avoid docker if they really wanted to. 
- `nix-darwin`. A nix module that allows declarative config of nearly all macOS system settings. As well as packages/apps, and some of their configuration. Integration with `launchd` (not sure the implications there). 

## Nix Installation
While the simplest way to install nix, say, on a random linux machine is to use another package manager to install it using another package manager, that is not recommended at all.

Note that one primary resource I'm using here is [Setting up Nix on macOS](https://nixcademy.com/posts/nix-on-macos/) from Nixcademy.

There are 3 ways to install nix on macOS which are known to work pretty well. 
1. Official Nix installer from `nixos.org`
2. New yet-unofficial Nix Installer from `nixos.org` (stable, and seems to be preferred. also allows for Nix Flakes to be enabled which I will get to later). 
3. Determinate System's Nix Installer. Determinate Nix is a downstream distribution of nix with other features. Deviates from vanilla - we will probably stick with vanilla nix for now. 

We're going to use the new-but-stable unofficial installer. Snippet here:

```bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

We are going to choose the multi-user installation option rather than single-user.

After some basic installation ack's as well as a shell restart, we can use `nix run` to ephemerally test whether the installation can run the GNU Hello package from Nixpgs. 

```bash
nix run nixpkgs#hello
```

Note that there is a Nix (and NixOS) [cheatsheet](https://nixcademy.com/cheatsheet/) which can be used as a reference for common commands. 
