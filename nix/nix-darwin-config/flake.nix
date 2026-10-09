{
  description = "nix-darwin system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    mkDarwin = configName: nix-darwin.lib.darwinSystem {
      specialArgs = { inherit self configName; };
      modules = [ ./modules/common.nix ./hosts/${configName}.nix ];
    };
  in
  {
    # Each name needs a matching hosts/<name>.nix.
    darwinConfigurations = nixpkgs.lib.genAttrs [
      "sushantBook"
      "work"
      "studio"
    ] mkDarwin;
  };
}
