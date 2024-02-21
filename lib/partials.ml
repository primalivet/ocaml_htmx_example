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

  let pagination hx_target url p =
    let open Pagination in
    let total_pages = Pagination.total_pages p in
    let page_range = List.range ~stop:`inclusive 1 total_pages in
    let has_prev = Pagination.has_prev p in
    let has_next = Pagination.has_next p in
    let prev_href = Printf.sprintf "%s?page=%d&per_page=%d" url (p.page - 1) p.per_page in
    let next_href = Printf.sprintf "%s?page=%d&per_page=%d" url (p.page + 1) p.per_page in
    let page_href n = Printf.sprintf "%s?page=%d&per_page=%d" url n p.per_page in
    let prev_link =
      if has_prev
      then
        Element.a
          ~attrs:
            [ "href", prev_href
            ; "hx-get", prev_href
            ; "hx-target", hx_target
            ; "hx-push-url", "true"
            ]
          [ "Previous" ]
      else Element.span [ "Previous" ]
    in
    let next_link =
      if has_next
      then
        Element.a
          ~attrs:
            [ "href", next_href
            ; "hx-get", next_href
            ; "hx-target", hx_target
            ; "hx-push-url", "true"
            ]
          [ "Next" ]
      else Element.span [ "Next" ]
    in
    let page_link n =
      if Int.equal n p.current_page
      then Element.span [ Int.to_string n ]
      else
        Element.a
          ~attrs:
            [ "href", page_href n
            ; "hx-get", page_href n
            ; "hx-target", hx_target
            ; "hx-push-url", "true"
            ]
          [ Int.to_string n ]
    in
    let list_items =
      List.concat
        [ [ Element.li [ prev_link ] ]
        ; page_range |> List.map ~f:(fun x -> Element.li [ page_link x ])
        ; [ Element.li [ next_link ] ]
        ]
    in
    Element.ul list_items
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
    let open Note in
    let open Element in
    let hx_target = "notes-table" in
    nav
      ~attrs:[ "aria-label", "Notes page navigation"; "class", hx_target ]
      [ Nav.pagination ("." ^ hx_target) "/notes" pagination
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
