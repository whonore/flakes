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
      vims = pkgs.lib.listToAttrs (
        map (
          {
            vimVersion,
            python2,
          }:
            pkgs.lib.nameValuePair "vim_${builtins.replaceStrings ["."] ["_"] vimVersion}${
              if python2
              then "-py2"
              else ""
            }"
            (pkgs.callPackage ./vim {inherit vimVersion python2;})
        )
        (pkgs.lib.cartesianProductOfSets {
          vimVersion = builtins.attrNames (import ./vim/versions.nix);
          python2 = [false true];
        })
      );
      vim = vims.vim_9_0;
    in {
      packages =
        {
          inherit coq-ctags move universal-ctags vim;
        }
        // vims;
      devShells = {
        move = pkgs.callPackage ./move/shell.nix {inherit move;};
      };
    });
}
