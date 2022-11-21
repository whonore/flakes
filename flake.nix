{
  description = "My flakes";

  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in let
      coq-ctags = pkgs.callPackage ./coq-ctags {};
      move = pkgs.callPackage ./move {};
      universal-ctags = pkgs.callPackage ./universal-ctags {};
    in {
      packages = {
        inherit coq-ctags move universal-ctags;
      };
      devShells = {
        move = pkgs.callPackage ./move/shell.nix {inherit move;};
      };
    });
}
