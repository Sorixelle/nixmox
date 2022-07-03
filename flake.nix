{
  description = "Utilities for creating GTK+ themes with Themix project tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: {
    overlay = import ./overlay.nix;
  } // (flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ self.overlay ];
    };
  in {
    packages = {
      inherit (pkgs) oomox;
    };
  }));
}
