{ stdenv, fetchFromGitHub, zlib
, ocaml, dune, ocamlfuse, findlib, gapi_ocaml, ocaml_sqlite3, camlidl }:

stdenv.mkDerivation rec {
  name = "google-drive-ocamlfuse-${version}";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    sha256 = "0vn0s4lvjxbrc0n4naknh288cd1chy6yldqpsq0vyq0xm2ck9rxj";
  };

  nativeBuildInputs = [ dune ];

  buildInputs = [ zlib ocaml ocamlfuse findlib gapi_ocaml ocaml_sqlite3 camlidl ];

  buildPhase = "dune build @install";
  installPhase = "dune install --prefix $out --libdir $(ocamlfind printconf destdir)";

  meta = {
    homepage = http://gdfuse.forge.ocamlcore.org/;
    description = "A FUSE-based file system backed by Google Drive, written in OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ obadz ];
  };
}
