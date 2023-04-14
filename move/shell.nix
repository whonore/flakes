{
  boogie,
  cvc5,
  fetchFromGitHub,
  mkShell,
  move,
  z3,
}: let
  boogie' = boogie.overrideAttrs (
    orig: rec {
      version = "2.15.8";
      src = fetchFromGitHub {
        owner = "boogie-org";
        repo = "boogie";
        rev = "v${version}";
        sha256 = "sha256-1ApDy8tKeVQ66hAzLKg62zZW1YsoG+IP+KYQHWoIItQ=";
      };
    }
  );
  z3' = z3.overrideAttrs (
    orig: rec {
      version = "4.11.0";
      src = fetchFromGitHub {
        owner = "Z3Prover";
        repo = "z3";
        rev = "z3-${version}";
        sha256 = "sha256-ItmtZHDhCeLAVtN7K80dqyAh20o7TM4xk2sTb9QgHvk=";
      };
    }
  );
in
  mkShell {
    packages = [move boogie' z3' cvc5];
    shellHook = ''
      export BOOGIE_EXE=${boogie'}/bin/boogie
      export Z3_EXE=${z3'}/bin/z3
      export CVC5_EXE=${cvc5}/bin/cvc5
    '';
  }
