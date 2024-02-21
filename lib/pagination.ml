type t =
  { page : int
  ; per_page : int
  ; total_count : int
  ; current_page : int
  }

let min_per_page = 3
let max_per_page = 9
let clamp n = Int.max min_per_page (Int.min n max_per_page)

let default_per_page = 6

(*
   Ensure we round up the total count
   - For example, if total_count = 100 and per_page = 10, then total_pages
     = (100 + 10 - 1) / 10 = 109 / 10 = 10.9, which in integer division
     results in 10, correctly reflecting the actual number of pages.
   - For instance, if total_count = 101 and per_page = 10, then without
     adjusting for rounding, you might incorrectly calculate total_pages =
     101 / 10 = 10.1, which would be 10 with integer division, ignoring the
     need for an 11th page to display the one item. With the formula,
     total_pages = (101 + 10 - 1) / 10 = 110 / 10 = 11, ensuring the last
     item gets its page.
*)
let total_pages p = (p.total_count + p.per_page - 1) / p.per_page

let to_sql p =
  let total_pages = total_pages p in
  let current_page = if p.page > total_pages then total_pages else p.page in
  let current_page = Int.max 1 current_page in
  let offset = if current_page <= 0 then 0 else (current_page - 1) * p.per_page in
  let limit = p.per_page in
  limit, offset
;;

let has_next p = p.page < total_pages p
let has_prev p = p.page > 1
