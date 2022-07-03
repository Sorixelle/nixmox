{
  description = "Utilities for creating GTK+ themes with Themix project tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks, ... }: {
    overlay = import ./overlay.nix;
  } // (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
    in
    {
      packages = {
        inherit (pkgs) oomox oomoxFull oomoxPlugins;
      };

      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = builtins.path {
            path = ./.;
            name = "nixmox";
          };
          hooks = {
            nixpkgs-fmt.enable = true;
            statix.enable = true;
          };
        };
      };

      devShell = pkgs.mkShell {
        name = "nixmox-devshell";
        nativeBuildInputs = with pkgs; [
          rnix-lsp
        ];
        shellHook = ''
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };
    }));
}
