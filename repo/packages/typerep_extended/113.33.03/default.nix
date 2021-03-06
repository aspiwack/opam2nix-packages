world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      bin_prot = opamSelection.bin_prot;
      core_kernel = opamSelection.core_kernel;
      js-build-tools = opamSelection.js-build-tools;
      ocaml = opamSelection.ocaml;
      ocamlbuild = opamSelection.ocamlbuild;
      ocamlfind = opamSelection.ocamlfind;
      ppx_bin_prot = opamSelection.ppx_bin_prot;
      ppx_driver = opamSelection.ppx_driver;
      ppx_sexp_conv = opamSelection.ppx_sexp_conv;
      ppx_type_conv = opamSelection.ppx_type_conv;
      ppx_typerep_conv = opamSelection.ppx_typerep_conv;
      sexplib = opamSelection.sexplib;
      typerep = opamSelection.typerep;
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
  name = "typerep_extended-113.33.03";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "typerep_extended";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1hc8pvcq0yl62rfb21ypws03xzzviwi7nywvlg2pp49jjh81rc0a";
    url = "https://ocaml.janestreet.com/ocaml-core/113.33/files/typerep_extended-113.33.03.tar.gz";
  };
}

