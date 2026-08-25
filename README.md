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

### Nix Darwin
Now with Nix installed, we have all of the nix shell commands (`nix develop` and `nix shell`) and can now build and run (`nix build` and `nix run`) projects. 

However, we don't want to run `nix profile install ...` on every mac host - this would not be better than classical papackage management solutions. Also we won't be able to manage configurations and services on macOS using `nix profile install`. 

Instead we want one big configuration file(s) which we can deploy with one single command. `nix-darwin` brings us a declaritive system approach to macOS. 

In order to bootstrap, we can initialize a new `nix-darwin` configuration file. 

```bash
mkdir nix-darwin-config
cd nix-darwin-config
nix flake init -t nix-darwin
```

Note: the `-t` flag means a template.

This will simply create a `flake.nix` file as so:

```nix
{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Auto upgrade nix package
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."simple".pkgs;
  }; 
}
```

There are a lot of sections here, but don't be overwhelmed. I'm going to change 2 things:

1. `nixpgs.hostPlatform` will be `aarch64-darwin` since I'm running Apple Silicon. 
2. `simple` in the bottom of the file under `darwinConfigurations."simple"` will be renamed to my host machine (tbd). This allows us to not have to provide the host name explicitly every time we build or rebuild the system configuration. 

Now we can boostrap as follows:
`nix run nix-darwin --switch --flake .` from the directory of the flake. 

Note that if we didn't rename the host name attribute, the last parameter needs to be `--flake .#simple`

The installation process will warn of files which could be destructively overwritten. If necessary you can back them up or just delete them yourself. Once you're ready you can run the script again. 

Now we should have `nix-darwin` on our system which provides a `darwin-rebuild` command allowing us to run `darwin-rebuild switch --flake .` anytime. 

Note that this is similar to `nixos-rebuild` command in NixOS. 
