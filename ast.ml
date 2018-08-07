type t =
  | Empty
  | Message of string
  | Clear
  | Nick of string
  | Sound of string * t
  | Mute
  | Unmute
  | In of int * t
  | To of string * t
  | Me of t

let rec to_tokens = function
  | Empty -> []
  | Message m -> [m]
  | Clear -> ["/c"]
  | Nick n -> ["/n"; n]
  | Sound (s, r) -> "/s" :: s :: to_tokens r
  | Mute -> ["/m"]
  | Unmute -> ["/u"]
  | In (s, r) -> "/in" :: string_of_int s :: to_tokens r
  | To (t, r) -> "/to" :: t :: to_tokens r
  | Me m -> "/me" :: to_tokens m
