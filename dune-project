(lang dune 3.7)

(name ocaml_htmx_example)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name ocaml_htmx_example)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends 
   ocaml 
   dune 
   dream 
   caqti-driver-postgresql)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
