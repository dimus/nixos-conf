#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./desktop OR ./laptop OR ./vm
#            ├─ ./default.nix
#            └─ ./home.nix 
#

{ lib, inputs, nixpkgs, user, location, ... }:

let
  system = "x86_64-linux";                             	    # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  gnlap = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = { inherit inputs user location; };        # Pass flake variable
    modules = [                                             # Modules that are used.
      ./gnlap
      ./configuration.nix
    ];
  };
}
