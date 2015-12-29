world: def:
let
	ocaml_version = (builtins.parseDrvName world.opamSelection.ocaml.name).version;
in {
	patches = [ ./ldconf.patch ./install_topfind.patch ];
	buildPhase = ''
		./configure \
			-bindir $out/bin \
			-mandir $out/share/man \
			-sitelib $out/lib \
			-config $out/etc/findlib.conf
		make all
		make opt
		make install
	'';

	setupHook = world.pkgs.writeText "setupHook.sh" ''
		addOCamlPath () {
			if test -d "''$1/lib"; then
					export OCAMLPATH="''${OCAMLPATH}''${OCAMLPATH:+:}''$1/lib"
			fi
			export OCAMLFIND_DESTDIR="''$out/lib/"
			mkdir -p "''$out/lib"
		}
		envHooks+=(addOCamlPath)
	'';
}

