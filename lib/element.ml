open Base

let element name ?(attrs = []) nodes =
  let attrs_string =
    attrs
    |> List.map ~f:(fun (name, value) -> Printf.sprintf "%s=\"%s\"" name value)
    |> String.concat ~sep:" "
  in
  let nodes_string = nodes |> String.concat ~sep:"\n" in
  Printf.sprintf "<%s %s>%s</%s>" name attrs_string nodes_string name
;;

let doctype () = "<!DOCTYPE html>"
let html = element "html"
let head = element "head"
let body = element "body"
let title = element "title"
let meta ~attrs = element "meta" ~attrs []
let link ~attrs = element "link" ~attrs []
let script = element "script"
let div = element "div"
let span = element "span"
let p = element "p"
let a = element "a"
let h1 = element "h1"
let nav = element "nav"
let ul = element "ul"
let li = element "li"
let table = element "table"
let thead = element "thead"
let tfoot = element "tfoot"
let tbody = element "tbody"
let tr = element "tr"
let td = element "td"
let th = element "th"
let form = element "form"
let input = element "input"
let button = element "button"
let img = element "img"
let caption = element "caption"
let none = ""

