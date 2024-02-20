open Base

type note =
  { id : string
  ; text : string
  ; title : string
  }

type database = { notes : note list }

let my_database : database =
  { notes =
      [ { id = "1"; text = "This is a note"; title = "Note 1" }
      ; { id = "2"; text = "This is another note"; title = "Note 2" }
      ; { id = "3"; text = "This is yet another note"; title = "Note 3" }
      ; { id = "4"; text = "This is yet another note"; title = "Note 4" }
      ; { id = "5"; text = "This is yet another note"; title = "Note 5" }
      ; { id = "6"; text = "This is yet another note"; title = "Note 6" }
      ; { id = "7"; text = "This is yet another note"; title = "Note 7" }
      ; { id = "8"; text = "This is yet another note"; title = "Note 8" }
      ; { id = "9"; text = "This is yet another note"; title = "Note 9" }
      ; { id = "10"; text = "This is yet another note"; title = "Note 10" }
      ; { id = "11"; text = "This is yet another note"; title = "Note 11" }
      ; { id = "12"; text = "This is yet another note"; title = "Note 12" }
      ; { id = "13"; text = "This is yet another note"; title = "Note 13" }
      ; { id = "14"; text = "This is yet another note"; title = "Note 14" }
      ; { id = "15"; text = "This is yet another note"; title = "Note 15" }
      ; { id = "16"; text = "This is yet another note"; title = "Note 16" }
      ; { id = "17"; text = "This is yet another note"; title = "Note 17" }
      ; { id = "18"; text = "This is yet another note"; title = "Note 18" }
      ; { id = "19"; text = "This is yet another note"; title = "Note 19" }
      ; { id = "20"; text = "This is yet another note"; title = "Note 20" }
      ; { id = "21"; text = "This is yet another note"; title = "Note 21" }
      ; { id = "22"; text = "This is yet another note"; title = "Note 22" }
      ; { id = "23"; text = "This is yet another note"; title = "Note 23" }
      ; { id = "24"; text = "This is yet another note"; title = "Note 24" }
      ; { id = "25"; text = "This is yet another note"; title = "Note 25" }
      ]
  }
;;

module Note = struct
  type t = note

  let notes = my_database.notes
  let find_by_id id = List.find ~f:(fun n -> String.equal n.id id) my_database.notes
end