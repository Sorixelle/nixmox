{ pkgs }:

{
  import-image = pkgs.callPackage ./import-image.nix { };
}
