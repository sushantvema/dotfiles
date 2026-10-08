{
  description = "Mimic MacBook Pro Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
	  pkgs.jq
	  pkgs.fd
	  pkgs.gh
      pkgs.go
      pkgs.uv
      pkgs.git
	  pkgs.fzf
      pkgs.prek
	  pkgs.stow
	  pkgs.tmux
      pkgs.just
      pkgs.pnpm
      pkgs.tree
      pkgs.mise
      pkgs.atuin
      pkgs.cmake
      pkgs.nodejs_22
      pkgs.cargo
      pkgs.mactop
      pkgs.neovim
      pkgs.zoxide 
      pkgs.lazygit
      pkgs.ollama
      pkgs.ripgrep
      pkgs.gitleaks
      pkgs.starship
      pkgs.wezterm
      pkgs.alacritty
      pkgs.cursor-cli
      pkgs.typescript
      pkgs.fontconfig
	  pkgs.vim-darwin
      pkgs.aerospace
      pkgs.awscli2
      (pkgs.python312.withPackages (ps: [
        ps.tkinter
        ps.nltk
        ps.boto3
        ps.black
      ]))
        ];

      environment.variables = {
          EDITOR = "nvim";
          VISUAL = "nvim"; 

      };

      environment.shells = [
        pkgs.zsh
      ];

      environment.extraInit = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';

      programs.zsh.enable = true;

      programs.zsh.promptInit = "eval \"$(starship init zsh)\"";

      programs.zsh.interactiveShellInit= ''
      eval "$(zoxide init zsh)"
      eval "$(atuin init zsh)"
      '';
 
      environment.shellAliases = {
          lg = "lazygit";
          rebuild = "sudo darwin-rebuild switch --flake .";
          v = "nvim";
          e = "exit";
          c = "clear";
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      nixpkgs.config.allowUnfree = true;

      homebrew = {
        enable = true;
        brews = [ "libomp" ];
        casks = [ "docker-desktop" "gcloud-cli" ];
      };

      system.primaryUser = "sushant.vema";
      
      security.pam.services.sudo_local.touchIdAuth = true;

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        screencapture.location = "~/Pictures/screenshots";
      };

      system.defaults.NSGlobalDomain = { InitialKeyRepeat = 10; KeyRepeat = 1; ApplePressAndHoldEnabled = false;};

      system.keyboard.enableKeyMapping = true;

      system.keyboard.remapCapsLockToControl = true;

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."Sushants-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
