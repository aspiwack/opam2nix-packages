world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      atd = opamSelection.atd;
      biniou = opamSelection.biniou;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind;
      yojson = opamSelection.yojson;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  createFindlibDestdir = true;
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "atdgen-1.8.0";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = ./files;
    name = "atdgen";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  postUnpack = "cp -r ${./files}/* \"$sourceRoot/\"";
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "08mq30br34w48p1gc1kdi1xcwb1j0rhakmmjchis4s9phx3lib7w";
    url = "https://github.com/mjambon/atdgen/archive/v1.8.0.tar.gz";
  };
}
