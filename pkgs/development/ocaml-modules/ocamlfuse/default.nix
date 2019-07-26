{ stdenv, fetchFromGitHub, pkgconfig, dune, ocaml, camlidl, fuse, findlib }:

stdenv.mkDerivation rec {
  name = "ocamlfuse-${version}";
  version = "2.7.1_cvs6";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "ocamlfuse";
    #rev = "v${version}";
    # The release tagged 2.7.1_cvs6 is hard to build as it requires opam, a post-release patch introduced ocamlfind support as used by this builder
    rev = "e35e76bee3b06806256b5bfca108b7697267cd5c";
    sha256 = "1v9g0wh7rnjkrjrnw50145g6ry38plyjs8fq8w0nlzwizhf3qhff";
  };

  buildInputs = [ pkgconfig ocaml findlib dune ];
  propagatedBuildInputs = [ camlidl fuse ];
  buildPhase = "dune build @install";
  # Setting the prefix causes dune to output libraries to lib/, rather than the "correct" location for ocamlfind
  installPhase = "dune install --prefix $out --libdir $(ocamlfind printconf destdir)";
  createFindlibDestdir = true;

  meta = {
    homepage = https://sourceforge.net/projects/ocamlfuse;
    description = "OCaml bindings for FUSE";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
  };
}