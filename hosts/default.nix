{ lib, inputs, nixpkgs, user, location, ... }:

let
  system = "x86_64-linux"; # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  gnlap = lib.nixosSystem {
    # Desktop profile
    inherit system;
    specialArgs = { inherit inputs user location; }; # Pass flake variable
    modules = [
      # Modules that are used.
      ./gnlap
      ./configuration.nix
    ];
  };
}
