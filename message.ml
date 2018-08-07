(* FIXME we never transmit messages from `Local! *)
type m = {
  src: [ `Local | `User of string ];
  cmd: Ast.t;
}

let string_of_user = function
  | `Local -> "."
  | `User u -> u
  | `All -> "*"
