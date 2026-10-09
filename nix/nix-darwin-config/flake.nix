{
  description = "nix-darwin system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    mkDarwin = hostModule: nix-darwin.lib.darwinSystem {
      specialArgs = { inherit self; };
      modules = [ ./modules/common.nix hostModule ];
    };
  in
  {
    # Attribute names must match each machine's `scutil --get LocalHostName`
    # so `darwin-rebuild switch --flake .` selects the right one.
    darwinConfigurations = {
      sushantBook = mkDarwin ./hosts/sushantBook.nix;
      work = mkDarwin ./hosts/work.nix;
      studio = mkDarwin ./hosts/studio.nix;
    };
  };
}
