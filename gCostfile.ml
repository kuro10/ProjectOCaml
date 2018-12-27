open Graph
open Printf
    
type path = string

(* Format of text files: lines of the form 
 *
 *  v id                   (node with the given identifier)
 *  e "flow,cost" id1 id2    (arc with the given (string) flow & (string) cost. Goes from node id1 to node id2.)
 *
 *)

(*-------------------------------------------------*)
let write_file path graph =

  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "=== Graph file ===\n\n" ;

  (* Write all nodes *)
  v_iter graph (fun id _ -> fprintf ff "v %s\n" id) ;
  fprintf ff "\n" ;

  (* Write all arcs *)
  v_iter graph (fun id out -> List.iter (fun (id2, (flow,cost)) -> fprintf ff "e \"%s,%s\" %s %s\n" flow cost id id2) out) ;
  
  fprintf ff "\n=== End of graph ===\n" ;
  
  close_out ff ;
  ()

(*--------------------------------------------------------------------------*)
(* Reads a line with a node. *)
let read_node graph line =
  try Scanf.sscanf line "v %s" (fun id -> add_node graph id)
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a line with an arc. *)
let read_arc graph line =
  try Scanf.sscanf line "e \"%s@,%s@\" %s %s" (fun flow cost id1 id2 -> add_arc graph id1 id2 (flow,cost))
  with e ->
    Printf.printf "Cannot read arc in line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"


(*--------------------------------------------------------------------------*)
let from_file path =

  let infile = open_in path in

  (* Read all lines until end of file. *)
  let rec loop graph =
    try
      let line = input_line infile in
      let graph2 =
        (* Ignore empty lines *)
        if line = "" then graph

        (* The first character of a line determines its content : v or e.
         * Lines not starting with v or e are ignored. *)
        else match line.[0] with
          | 'v' -> read_node graph line
          | 'e' -> read_arc graph line
          | _ -> graph
      in                 
      loop graph2        
    with End_of_file -> graph
  in

  let final_graph = loop empty_graph in
  
  close_in infile ;
  final_graph

(*--------------------------------------------------------------------------*)
let export path graph = 
  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "digraph finite_state_machine {\n" ;
  fprintf ff "  rankdir=LR;\n" ;
  fprintf ff "  size=\"8,5\"\n" ;
  fprintf ff "  node [shape = circle];\n";

  (* Write all arcs *)
  v_iter graph (fun id out -> List.iter (fun (id2, (flow,cost)) -> fprintf ff "  %s -> %s [ label = \"(%s,%s)\" ]; \n" id id2 flow cost) out) ;

  fprintf ff "}" ;
  
  close_out ff ;
  ()

(*--------------------------------------------------------------------------*)

(*val sToi : string * string -> int * int *)
let sToi = fun (a,b) -> (int_of_string a, int_of_string b)

(*val iTos : int * int -> string * string*)
let iTos = fun (a,b) -> (string_of_int a, string_of_int b)
