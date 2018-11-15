open Graph


(* Type of a path from a node to another node
 * A path is represented by a list of (id,id,label) *)
type path = (id * id * int) list    

(*exist_path g s d :  indicates if a path from source_node to destination_node exists in graph g.
 *@raise Graphe_error if s (ou d) is unknown in the graph *)
val exist_path : int graph -> id -> id -> bool 

(*find path g s d : finds in the graph a list that includes all of paths from soucre_node to destination_node 
 *@raise Graphe_error if s (ou d) is unknown in the graph *)
val find_path : int graph -> id -> id -> path

(*print_path path  : print this path in terminal*)
val print_path : path -> unit

(*update_graph g path : update the graph when having the value flot_min got by a path *)
val update_graph : int graph -> path -> int graph

(*run_FF_algo g s d : apply the Ford-Fulkerson algorithm for graph g
 *return a graph with flot max*)
val run_FF_algo : int graph -> id -> id -> int graph
