open Ast
open Message

(* TODO functorize *)

let rec run ?(depth=0) u {src; cmd} =
  Printf.printf "%d %s>%s %s\n"
    depth (* otherwise, repeated x>y seem strange *)
    (string_of_user src) u
    (to_tokens cmd |> String.concat " ");
  match cmd with
  | Empty ->
    ()
  | In (d, cmd') ->
    Printf.printf "%s waits for %d seconds\n" u d;
    run ~depth:(depth+1) u {src; cmd=cmd'}
  | To (u', cmd') ->
    if src = `Local then
      send (`User u') {src=`User u; cmd=cmd'}
    else
      send (`User u') {src; cmd=cmd'}
  | Me cmd' -> (
    match src with
    | `Local ->
      (* If I run /me /message hi, only I get "hi" *)
      run u {src=`User u; cmd=cmd'}
    | `User u' ->
      send (`User u') {src=`User u; cmd=cmd'}
  )
  | Unmute ->
    if src = `Local then
      Printf.printf "%s unmutes\n" u
    else
      ()
  | _ when src=`Local ->
    send `All {src=`User u; cmd}
  | Message m ->
    Printf.printf "%s sees %s\n" u m
  | Clear ->
    Printf.printf "%s clears his/her screen.\n" u
  | Nick u' ->
    Printf.printf "%s discovers %s\n" u u'
  | Sound (s, cmd') ->
    Printf.printf "%s plays %s\n" u s;
    run u {src; cmd=cmd'}
  | Mute ->
    Printf.printf "%s mutes.\n" u
and send d m =
  match d with
  | `All ->
    run "Alice" m;
    run "Bob" m
  | `User u ->
    run u m


let () =
  let cmd = Lexer.of_string Sys.argv.(1) |> Parser.of_tokens in
  let msg = {src=`Local; cmd} in
  run "Alice" msg
  (*
  to_tokens |>
  List.iter print_endline
  *)
