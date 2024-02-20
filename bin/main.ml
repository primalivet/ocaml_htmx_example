open Base
open Ocaml_htmx_example

module type DB = Caqti_lwt.CONNECTION

module R = Caqti_request
module T = Caqti_type

let server () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool ~size:10 "postgres://dream:password@localhost:5432/dream"
  @@ Dream.memory_sessions
  @@ Dream.router
       [ Dream.get "/static/**" @@ Dream.static "www/static"
       ; Dream.get "/form" Handler.ExampleForm.get
       ; Dream.post "/form/submit" Handler.ExampleForm.submit
       ; Dream.get "/form/confirm" Handler.ExampleForm.confirm
       ; Dream.post "/notes/delete/:id" Handler.Note.delete_note
       ; Dream.post "/notes/save/:id" Handler.Note.save_note
       ; Dream.get "/notes/edit/:id" Handler.Note.edit_note
       ; Dream.get "/notes" Handler.Note.get_notes
       ; Dream.get "/" Handler.Note.get_notes
       ]
;;

let () = server ()
