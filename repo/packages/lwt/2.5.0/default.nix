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
          base-no-ppx = opamSelection.base-no-ppx or null;
          base-threads = opamSelection.base-threads or null;
          base-unix = opamSelection.base-unix or null;
          camlp4 = opamSelection.camlp4 or null;
          conf-libev = opamSelection.conf-libev or null;
          lablgtk = opamSelection.lablgtk or null;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          ppx_tools = opamSelection.ppx_tools or null;
          react = opamSelection.react or null;
          ssl = opamSelection.ssl or null;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "lwt-2.5.0";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "lwt";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "0c31aigpfavb0zib3c6b9van68mxgyrn4igqgya15qf5dfjjibip";
        url = "https://github.com/ocsigen/lwt/archive/2.5.0.tar.gz";
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
