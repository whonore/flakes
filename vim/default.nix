{
  stdenv,
  lib,
  fetchFromGitHub,
  darwin,
  ncurses,
  xorg,
  python27,
  python39,
  python3,
  # Configuration
  vimVersion ? "9.0",
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
      [ncurses xorg.libX11 xorg.libXt python]
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
        "--x-includes=${xorg.libX11.dev}/include"
        "--x-libraries=${xorg.libX11.out}/lib"
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
