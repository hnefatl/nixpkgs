{ stdenv, fetchurl, autoreconfHook, pkgconfig, libxkbcommon, pango, which, git
, cairo, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
, bison, flex, librsvg, check, ninja, meson, doxygen, uncrustify, cppcheck, ronn,
  fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "rofi-unwrapped-${version}";
  version = "1.5.2b";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi";
    rev = "a1362010c32ce97d166db2e2b3d8497d4d16d409";
    sha256 = "05nar2lcs82rxdx9dv2ik4mpxxxyp8xx2lj2iid3x5rha6jkai4y";
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
