# Running `nix-shell` on this file puts you in an environment where all the
# dependencies needed to work on `zenchor` are available.
#
# Running `nix-build` builds the `zenchor` code.

{ pkgs ? import nix/pkgs.nix }:

pkgs.stdenv.mkDerivation {
  name = "testenv";
  src = ./.;
  buildInputs = [
    pkgs.jq # nix updater script
    pkgs.awscli
    # cmds.py
    # pkgs.python27Full
    # pkgs.python27Packages.pip
    # pkgs.python27Packages.argh
    pkgs.leiningen # Clojure
    # TODO doe we need to set the node version?
    pkgs.yarn
    pkgs.openjdk8
    pkgs.nodejs-8_x
    pkgs.docker
    pkgs.docker_compose
  ];
}

