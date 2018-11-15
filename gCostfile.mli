open Graph

type path = string

(* Values are read as strings. *)
val from_file: path -> (string * string) graph

(* Similarly, we write only a string graph.
 * Use Graph.map if necessary to prepare the input graph. *)
val write_file: path -> (string * string) graph -> unit

(* This function writes a graph in dot format*)
val export : path -> (string * string) graph -> unit

val mapType : string * string -> int * int 

val rmapType : int * int -> string * string