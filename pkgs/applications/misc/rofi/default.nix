{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxkbcommon, pango, which, git
, cairo, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
, bison, flex, librsvg, check, ninja, meson, doxygen, uncrustify, cppcheck, ronn,
  fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "rofi-unwrapped-${version}";
  version = "1.5.2b";

  src = fetchFromGitHub {
    owner = "hnefatl";
    repo = "rofi";
    rev = "3d777e18ae3d413d7eade4d06e7116cd59cb7ab4";
    sha256 = "0qhz7ya709pav7rl384a624vccnax2b37lb2f7bh1rh54v6bs04r";
    fetchSubmodules= true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libxkbcommon pango cairo git bison flex librsvg check
    libstartup_notification libxcb xcbutil xcbutilwm xcbutilxrm which
    doxygen uncrustify cppcheck ronn ninja meson
  ];

  configurePhase = "meson setup build --prefix=\"$out\"";

  buildPhase = "ninja -C build";

  installPhase = "ninja -C build install";

  meta = with stdenv.lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = https://github.com/davatorium/rofi;
    license = licenses.mit;
    maintainers = with maintainers; [ mbakke garbas ma27 ];
    platforms = with platforms; linux;
  };
}
