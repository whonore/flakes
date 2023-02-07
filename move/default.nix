{
  darwin,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "move";
  version = "0.0.0";
  src = fetchFromGitHub {
    owner = "move-language";
    repo = "move";
    rev = "4901410d1f510601ca7fb982989e02c00756cac6";
    sha256 = "sha256-eikJUrqePHd+gev+1VCLOEJygXj6ix5TFmAcazNJBEg=";
  };
  cargoSha256 = "sha256-aMYLj6T0BrM8xEF6ButTaguaYC5N26ifaRnuICZjL98=";

  buildInputs =
    if stdenv.isDarwin
    then with darwin.apple_sdk.frameworks; [SystemConfiguration]
    else [];

  doCheck = false;

  meta = with lib; {
    description = "The Move smart contract language";
    homepage = "https://github.com/move-language/move";
    license = with licenses; [asl20];
  };
}
