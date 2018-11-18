(* Read a graph from a file,
 * Write a graph to a file. *)

open Graph

type path = string

(* Creating a gfile from a tfile *)
val create_file: path -> path -> unit

