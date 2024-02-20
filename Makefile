.PHONY: exec
exec: # Run project
	opam exec -- dune exec _build/default/bin/main.exe

.PHONY: exec-watch
exec-watch: # Run project and rerun upon changes in source files
	opam exec -- dune exec --watch _build/default/bin/main.exe

.PHONY: switch
switch: # Create OPAM switch and install dependencies
	opam switch create . 5.0.0 --no-install --repos pin_ocaml_htmx_example=git+https://github.com/ocaml/opam-repository#f34983a7f8c448578addc5ec02f9c22d2b32650c
	opam install -y ocamlformat=0.26.1 ocaml-lsp-server=1.17.0
	opam install -y --deps-only --with-test --with-doc .

.PHONY: build
build: # Build project
	opam exec -- dune build

.PHONY: watch
build-watch: # Build project and rebuild upon change in source files
	opam exec -- dune build --watch

.PHONY: test
test: # Test project
	opam exec -- dune runtest --force

.PHONY: test-watch
test-watch: # Test project
	opam exec -- dune runtest --force --watch
