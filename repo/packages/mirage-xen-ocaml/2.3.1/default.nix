let
    buildWithOverride = override:
    { fetchurl, opam2nix, opamSelection, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([  ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          conf-pkg-config = opamSelection.conf-pkg-config;
          mirage-xen-posix = opamSelection.mirage-xen-posix;
          ocaml = opamSelection.ocaml;
          ocaml-src = opamSelection.ocaml-src;
          ocamlfind = opamSelection.ocamlfind;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "mirage-xen-ocaml-2.3.1";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "mirage-xen-ocaml";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "1xly8565a40pbv509lbjn15bf4y9xrxg2s0p4bpzvy6fg6jrfmkf";
        url = "https://github.com/mirage/mirage-platform/archive/v2.3.1.tar.gz";
      };
    })
    
    ;
    identity = x: x;
    wrap = buildWithOverride:
    {
      impl = buildWithOverride identity;
      withOverride = override:
      wrap (additionalOverride:
      buildWithOverride (attrs:
      additionalOverride (override attrs)
      )
      )
      ;
    }
    ;
in
wrap buildWithOverride
