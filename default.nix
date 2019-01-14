# Running `nix-shell` on this file puts you in an environment where all the
# dependencies needed to work on `zenchor` are available.
#
# Running `nix-build` builds the `zenchor` code.

{ pkgs ? import nix/pkgs.nix }:

pkgs.stdenv.mkDerivation {
  name = "testenv";
  src = ./.;
  buildInputs = [
    # development only
    # - nix
    pkgs.jq
    # nix-env -f '<nixpkgs>' -iA nodePackages.node2nix

    # - build tool
    pkgs.leiningen

    # - deployment
    pkgs.awscli

    # other
    # - platforms
    pkgs.openjdk8
    pkgs.nodejs-8_x

    pkgs.nodejs-8_x

    pkgs.docker
    pkgs.docker_compose
  ];
}

