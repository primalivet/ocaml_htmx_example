open Base

module ExampleForm = struct
  let get ?(errors = []) ?(values = None) req =
    let open Element in
    let firstname, lastname = Option.value ~default:("", "") values in
    Dream.html
    @@ Page.Common.base_layout ~req ~header:"Form test" ~desc:"Form desc"
    @@ div
         [ form
             ~attrs:[ "action", "/form/submit"; "method", "POST" ]
             [ Dream.csrf_tag req
             ; div [ span [ "Errors: " ]; ul (List.map ~f:(fun e -> li [ e ]) errors) ]
             ; input ~attrs:[ "type", "text"; "name", "firstname"; "value", firstname ] []
             ; input ~attrs:[ "type", "text"; "name", "lastname"; "value", lastname ] []
             ; input ~attrs:[ "type", "submit"; "value", "Submit" ] []
             ]
         ]
  ;;

  let submit req =
    match%lwt Dream.form req with
    | `Ok [ ("firstname", firstname); ("lastname", lastname) ] ->
      Stdlib.print_endline (Printf.sprintf "%s %s" firstname lastname);
      if String.equal firstname "John" && String.equal lastname "Doe"
      then Dream.redirect req "/form/confirm"
      else
        get
          ~errors:[ "Invalid firstname or lastname" ]
          ~values:(Some (firstname, lastname))
          req
    | _ -> Dream.redirect req "/form?errors=invalidform"
  ;;

  let confirm req =
    let open Element in
    Dream.html @@ Page.Common.base_layout ~req ~header:"" ~desc:"" @@ div [ "Thanks " ]
  ;;
end

module Note = struct
  let edit_note req =
    let target = Dream.target req in
    match Dream.header req "HX-Request" with
    | Some _ ->
      Dream.html (Printf.sprintf "HX request for %s is not yet supported" target)
    | _ ->
      let id = Dream.param req "id" in
      let note = Note.find_by_id id in
      (match note with
       | Some note ->
         Dream.html
         @@ Page.Note.base_layout ~req ~header:"Edit note" ~desc:"Edit note"
         @@ Partials.Note.edit_note_form req note
       | None -> Dream.html "Not found")
  ;;

  let save_note req =
    let target = Dream.target req in
    match Dream.header req "HX-Request" with
    | Some _ ->
      Dream.html (Printf.sprintf "HX request for %s is not yet supported" target)
    | _ ->
      let id = Dream.param req "id" in
      let note = Mock_data.Note.find_by_id id in
      (match note with
       | Some note ->
         Stdlib.print_endline (Printf.sprintf "Saving note: %s" note.title);
         Dream.redirect req "/notes?messages=Successfully saved note"
       | None -> Dream.redirect req "/notes?errors=Failed to save note")
  ;;

  let get_notes req =
    let target = Dream.target req in
    match Dream.header req "HX-Request" with
    | Some _ ->
      Dream.html (Printf.sprintf "HX request for %s is not yet supported" target)
    | _ ->
      let page = Dream.query req "page" |> Option.value ~default:"1" |> Int.of_string in
      let per_page =
        Dream.query req "per_page" |> Option.value ~default:"5" |> Int.of_string
      in
      let%lwt notes_total_count = Dream.sql req Note.get_notes_total_count in
      let pagination = { Pagination.page; per_page; total_count = notes_total_count } in
      let limit, offset = Pagination.to_sql pagination in
      let%lwt notes = Dream.sql req (Note.get_notes (limit, offset)) in
      Dream.html
      @@ Page.Note.base_layout ~req ~header:"Notes" ~desc:"Notes"
      @@ Partials.Note.list_notes_table pagination notes_total_count notes
  ;;

  let delete_note req =
    let target = Dream.target req in
    match Dream.header req "HX-Request" with
    | Some _ ->
      Dream.html (Printf.sprintf "HX request for %s is not yet supported" target)
    | _ ->
      let id = Dream.param req "id" in
      let note = Note.find_by_id id in
      (match note with
       | Some note ->
         Stdlib.print_endline (Printf.sprintf "Deleting note: %s" note.title);
         Dream.redirect req "/notes?messages=Successfully deleted note"
       | None -> Dream.redirect req "/notes?errors=Failed to delete note")
  ;;
end
