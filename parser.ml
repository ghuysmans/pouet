open Ast

exception Syntax_error of string

let rec of_tokens = function
  | [] ->
    Empty
  | ["/c"] | ["/clear"] ->
    Clear
  | ["/nick"; n] ->
    Nick n
  | "/s" :: s :: r
  | "/sound" :: s :: r ->
    Sound (s, of_tokens r)
  | ["/m"] | ["/mute"] ->
    Mute
  | ["/u"] | ["/unmute"] ->
    Unmute
  | "/in" :: n :: r ->
    In (int_of_string n, of_tokens r)
  | "/to" :: t :: r
  | "/pm" :: t :: r ->
    To (t, of_tokens r)
  | "/me" :: r ->
    Me (of_tokens r)
  | (h :: r) as l ->
    if h.[0] = '/' then
      raise (Syntax_error h)
    else
      Message (String.concat " " l)
