open Base

module Nav = struct
  let topbar req_url links =
    let open Element in
    div
      [ nav
          [ ul
              (links
               |> List.map ~f:(fun (name, url) ->
                 li
                   [ a
                       ~attrs:
                         [ "href", url
                         ; ( "class"
                           , if String.is_prefix ~prefix:req_url url then "" else "" )
                         ]
                       [ name ]
                   ]))
          ]
      ]
  ;;
end

module Note = struct
  let edit_note_form req note =
    let open Note in
    let open Element in
    form
      ~attrs:[ "method", "POST"; "action", "/notes/save/" ^ note.id ]
      [ Dream.csrf_tag req
      ; input ~attrs:[ "type", "text"; "name", "title"; "value", note.title ] []
      ; input ~attrs:[ "type", "text"; "name", "text"; "value", note.text ] []
      ; input ~attrs:[ "type", "submit"; "name", "submit"; "value", "Submit" ] []
      ]
  ;;

  let list_notes_table pagination total_count notes =
    let open Pagination in
    let open Note in
    let open Element in
    let total_pages = Pagination.total_pages pagination in
    let prev_link =
      Printf.sprintf
        "/notes?page=%d&per_page=%d"
        (pagination.page - 1)
        pagination.per_page
    in
    let next_link =
      Printf.sprintf
        "/notes?page=%d&per_page=%d"
        (pagination.page + 1)
        pagination.per_page
    in
    let num_link n = Printf.sprintf "/notes?page=%d&per_page=%d" n pagination.per_page in
    let pagination_list_items =
      List.concat
        [ [ (if Pagination.has_prev pagination
             then li [ a ~attrs:[ "href", prev_link ] [ "Previous" ] ]
             else li [ span [ "Previous" ] ])
          ]
        ; List.range ~stop:`inclusive 1 total_pages
          |> List.map ~f:(fun x ->
            li [ a ~attrs:[ "href", num_link x ] [ Int.to_string x ] ])
        ; [ (if Pagination.has_next pagination
             then li [ a ~attrs:[ "href", next_link ] [ "Next" ] ]
             else li [ span [ "Next" ] ])
          ]
        ]
    in
    nav
      ~attrs:[ "aria-label", "Notes page navigation" ]
      [ ul pagination_list_items
      ; table
          [ caption [ Int.to_string total_count ]
          ; thead [ tr [ th [ "id" ]; th [ "title" ]; th [ "text" ] ] ]
          ; tfoot [ tr [ th [ "id" ]; th [ "title" ]; th [ "text" ] ] ]
          ; tbody
              (notes
               |> List.map ~f:(fun note ->
                 tr
                   [ td [ note.id ]
                   ; td [ note.title ]
                   ; td [ note.text ]
                   ; td [ a ~attrs:[ "href", "/notes/edit/" ^ note.id ] [ "Edit" ] ]
                   ; td
                       [ form
                           ~attrs:
                             [ "method", "POST"; "action", "/notes/delete/" ^ note.id ]
                           [ input ~attrs:[ "type", "submit"; "value", "Delete" ] [] ]
                       ]
                   ]))
          ]
      ]
  ;;
end
