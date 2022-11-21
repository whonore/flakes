{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "coq.ctags";
  version = "0.0.0";
  src = fetchFromGitHub {
    owner = "tomtomjhj";
    repo = pname;
    rev = "a566b8fd1da5ab527ae82951237b56dc8952e231";
    sha256 = "sha256-/dMQVqqiIOYIKThPF5OvPLZ/jrc+4bCXQzTXSnV5OVY=";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    runHook preInstall

    install -Dm644 coq.ctags "$out/share/ctags.d/optlib/coq.ctags"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Universal Ctags optlib parser for Coq";
    homepage = "https://github.com/tomtomjhj/coq.ctags";
    platforms = platforms.unix;
  };
}
