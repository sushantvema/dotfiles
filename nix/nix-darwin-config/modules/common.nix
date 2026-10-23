{ pkgs, self, configName, ... }:
let
  # nixpkgs disables the SDK's component updater, so extra components must be
  # declared here to get e.g. gke-gcloud-auth-plugin on PATH.
  gcloud = pkgs.google-cloud-sdk.withExtraComponents [
    pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
  ];
in {
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
      pkgs.cargo
      pkgs.mactop
      pkgs.neovim
      pkgs.zoxide
      pkgs.lazygit
      pkgs.ollama
      pkgs.wezterm
      pkgs.ripgrep
      pkgs.gitleaks
      pkgs.starship
      pkgs.cdrtools
      pkgs.alacritty
      pkgs.nodejs_22
      pkgs.cursor-cli
      pkgs.typescript
      pkgs.fontconfig
      pkgs.vim-darwin
      pkgs.aerospace
      pkgs.awscli2
      gcloud
      pkgs.beam27Packages.elixir
      (pkgs.python3.withPackages (ps: [
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

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  environment.shells = [
    pkgs.zsh
  ];

  environment.extraInit = ''
    # Expand HOME in the shell; XDG paths must be absolute.
    export XDG_CONFIG_HOME="$HOME/.config"
    export PATH="$HOME/.local/bin:$PATH"
  '';

  programs.zsh.enable = true;

  programs.zsh.promptInit = "eval \"$(starship init zsh)\"";

  programs.zsh.interactiveShellInit = ''
    eval "$(zoxide init zsh)"
    eval "$(atuin init zsh)"

    # Live command runtime in the tmux status bar: publish the start time to a
    # per-pane tmux option, then clear it when the prompt returns.
    zmodload zsh/datetime 2>/dev/null
    autoload -Uz add-zsh-hook
    _tmux_cmd_start() {
      [[ -n $TMUX ]] && tmux set-option -p @cmd_start "''${EPOCHSECONDS:-$(date +%s)}" 2>/dev/null
    }
    _tmux_cmd_end() {
      [[ -n $TMUX ]] && tmux set-option -pu @cmd_start 2>/dev/null
    }
    add-zsh-hook preexec _tmux_cmd_start
    add-zsh-hook precmd _tmux_cmd_end
  '';

  environment.shellAliases = {
    lg = "lazygit";
    rebuild = "sudo darwin-rebuild switch --flake .#${configName}";
    v = "nvim";
    e = "exit";
    c = "clear";
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

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
    brews = [ "libomp" "qemu" ];
    casks = [ "docker-desktop" "dbeaver-community"];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    screencapture.location = "~/Pictures/screenshots";
  };

  system.defaults.NSGlobalDomain = { InitialKeyRepeat = 10; KeyRepeat = 1; ApplePressAndHoldEnabled = false; };

  system.keyboard.enableKeyMapping = true;

  system.keyboard.remapCapsLockToControl = true;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
