{
  stdenv,
  lib,
  fetchFromGitHub,
  darwin,
  ncurses,
  libX11,
  libXt,
  python27,
  python39 ? (import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/24.05.tar.gz";
    sha256 = "1lr1h35prqkd1mkmzriwlpvxcb34kmhc9dnr48gkm8hh089hifmx";
  }) { system = stdenv.hostPlatform.system; }).python39,
  python3,
  # Configuration
  vimVersion ? "9.2",
  python2 ? false,
  gui ? false,
}: let
  # NOTE: pin Python to 3.9 for Vim < 8.2 (https://github.com/vim/vim/issues/6183)
  python =
    if python2
    then python27
    else if lib.versionOlder vimVersion "8.2"
    then python39
    else python3;
  patch = builtins.getAttr vimVersion (import ./versions.nix);
  vimVersionFull = "${vimVersion}.${patch.patch}";
in
  stdenv.mkDerivation {
    pname = "vim";
    version = "${vimVersionFull}-py${python.version}";

    src = fetchFromGitHub {
      owner = "vim";
      repo = "vim";
      rev = "v${vimVersionFull}";
      inherit (patch) sha256;
    };

    buildInputs =
      [ncurses libX11 libXt python]
      ++ lib.optionals stdenv.isDarwin [darwin.apple_sdk.frameworks.Cocoa];

    configureFlags =
      [
        "--with-features=huge"
        "--enable-cscope=yes"
        "--enable-multibyte=yes"

        "--enable-python${
          if python.isPy3
          then "3"
          else ""
        }interp=yes"
        "--with-python${
          if python.isPy3
          then "3"
          else ""
        }-config-dir=${python}/lib"
        "--disable-python${
          if python.isPy3
          then ""
          else "3"
        }interp"

        "--${
          if gui
          then "enable"
          else "disable"
        }-gui"

        "--enable-fail-if-missing"
      ]
      ++ lib.optionals (!stdenv.isDarwin) [
        "--with-x"
        "--x-includes=${libX11.dev}/include"
        "--x-libraries=${libX11.out}/lib"
      ];

    patches =
      if vimVersion == "7.4"
      then [./vim7.4-if_python3.patch]
      else null;

    enableParallelBuilding = true;
    hardeningDisable = ["fortify"];

    meta = with lib; {
      description = "The most popular clone of the VI editor";
      homepage = "http://www.vim.org";
      license = licenses.vim;
      platforms = platforms.unix;
    };
  }
