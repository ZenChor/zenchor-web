# This makes sure that our nix packages are locked to a specific commit
# of the nix channels
let
  bootstrap = import <nixpkgs> { };

  versions = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  src = bootstrap.fetchFromGitHub {
    owner = "NixOS";
    repo  = "nixpkgs";
    inherit (versions.nixpkgs) rev sha256;
  };

in

import src { }
