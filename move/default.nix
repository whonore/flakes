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
    rev = "6722242844d206d59f60c11cac13ead43a210ced";
    sha256 = "sha256-EKIaPqQ0ZEKaeIUTNHr2ses68nM3FHXpa9Vj7gtOu54=";
  };
  cargoSha256 = "sha256-uGYea/riCgXAKecfucWJo+ThVgkwxjZ5yRd7nZOHCW4=";

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
