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
          ocaml = opamSelection.ocaml;
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
      name = "cppo-1.1.2";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = ./files;
        name = "cppo";
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
        sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
        url = "http://mjambon.com/releases/cppo/cppo-1.1.2.tar.gz";
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
