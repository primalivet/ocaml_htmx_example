open! Base

module Common = struct
  let base_layout ~req ~header ~desc content =
    let target = Dream.target req in
    let open Element in
    String.concat
      ~sep:"\n"
      [ "<!DOCTYPE html>"
      ; html
          ~attrs:[ "lang", "en" ]
          [ head
              [ meta ~attrs:[ "viewport", "width=device-width, initial-scale=1.0" ]
              ; meta ~attrs:[ "charset", "UTF-8" ]
              ; title [ header ]
              ; meta ~attrs:[ "description", desc ]
              ; link ~attrs:[ "rel", "shortcut icon"; "href", "/static/favicon.ico" ]
              (* ; script ~attrs:[ "src", "/static/tailwind-3.4.1.min.js" ] [] *)
              ]
          ; body
              [ Partials.Nav.topbar
                  target
                  [ "Home", "/"; "About", "/about"; "Notes", "/notes" ]
              ; content
              ; script ~attrs:[ "src", "/static/htmx-1.9.10.min.js" ] []
              ]
          ]
      ]
  ;;
end

module Note = struct
  let base_layout ~req ~header ~desc content =
    let open Element in
    Common.base_layout ~req ~header ~desc (div [ h1 [ header ]; p [ desc ]; content ])
  ;;

  (* let note id note = *)
  (*   let open Element in *)
  (*   div [ h1 [ "Edit note" ]; Partials.Note.edit_note_form id note ] *)
  (* ;; *)

  (* let notes header desciption messages errors (notes : Mock_data.note list) = *)
  (*   let open Element in *)
  (*   div *)
  (*     [ h1 [ header ] *)
  (*     ; p [ desciption ] *)
  (*     ; div (messages |> List.map ~f:(fun m -> p [ m ])) *)
  (*     ; div (errors |> List.map ~f:(fun m -> p [ m ])) *)
  (*     ; Partials.Note.list_notes_table notes *)
  (*     ] *)
  (* ;; *)
end

let home header desciption =
  let open Element in
  div [ h1 [ header ]; p [ desciption ] ]
;;
