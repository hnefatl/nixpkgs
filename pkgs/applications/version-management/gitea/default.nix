{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper
, git, bash, gzip, openssh
, sqliteSupport ? true
}:

with stdenv.lib;

buildGoPackage rec {
  pname = "gitea";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "go-gitea";
    repo = "gitea";
    rev = "v${version}";
    sha256 = "0g6ch85dq4vazxnr6g78wgqrnfa955395y1zws0a50h0wfxpdjis";
    # Required to generate the same checksum on MacOS due to unicode encoding differences
    # More information: https://github.com/NixOS/nixpkgs/pull/48128
    extraPostFetch = ''
      rm -rf $out/integrations
      rm -rf $out/vendor/github.com/Unknown/cae/tz/testdata
      rm -rf $out/vendor/github.com/Unknown/cae/zip/testdata
      rm -rf $out/vendor/gopkg.in/macaron.v1/fixtures
    '';
  };

  patches = [ ./static-root-path.patch ];

  postPatch = ''
    patchShebangs .
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildFlags = optional sqliteSupport "-tags sqlite";
  buildFlagsArray = ''
    -ldflags=
      -X=main.Version=${version}
      ${optionalString sqliteSupport "-X=main.Tags=sqlite"}
  '';

  outputs = [ "bin" "out" "data" ];

  postInstall = ''
    mkdir $data
    cp -R $src/{public,templates,options} $data
    mkdir -p $out
    cp -R $src/options/locale $out/locale

    wrapProgram $bin/bin/gitea \
      --prefix PATH : ${makeBinPath [ bash git gzip openssh ]}
  '';

  goPackagePath = "code.gitea.io/gitea";

  meta = {
    description = "Git with a cup of tea";
    homepage = "https://gitea.io";
    license = licenses.mit;
    maintainers = with maintainers; [ disassembler kolaente ];
  };
}
