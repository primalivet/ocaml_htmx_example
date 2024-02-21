open Base

type t =
  { id : string
  ; text : string
  ; title : string
  }

let note_caqtitype =
  let encode note = Ok (note.id, (note.title, note.text)) in
  let decode (id, (title, text)) = Ok { id; title; text } in
  Caqti_type.custom ~encode ~decode Caqti_type.(tup2 string (tup2 string string))
;;

let get_notes_total_count =
  let query =
    let open Caqti_request.Infix in
    (Caqti_type.unit ->! Caqti_type.int) "SELECT COUNT(*) FROM public.note"
  in
  fun (module Db : Caqti_lwt.CONNECTION) ->
    let%lwt count_or_error = Db.find query () in
    Caqti_lwt.or_fail count_or_error
;;

let get_notes (limit, offset) =
  let query =
    let open Caqti_request.Infix in
    (Caqti_type.unit ->* note_caqtitype)
      (Printf.sprintf
         "SELECT id, title, text FROM public.note ORDER BY id LIMIT %d OFFSET %d"
         limit
         offset)
  in
  fun (module Db : Caqti_lwt.CONNECTION) ->
    let%lwt notes_or_error = Db.collect_list query () in
    Caqti_lwt.or_fail notes_or_error
;;

let get_note id =
  let query =
    let open Caqti_request.Infix in
    (Caqti_type.int ->? note_caqtitype)
      (Printf.sprintf "SELECT id, title, text FROM public.note WHERE id = %d" id)
  in
  fun (module Db : Caqti_lwt.CONNECTION) ->
    let%lwt note_or_error = Db.find_opt query id in
    Caqti_lwt.or_fail note_or_error
;;
