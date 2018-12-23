open Graph

(*Type of label of an arc, with a couple of flow & cost*)
type label = int * int

(* Type of a path from a node to another node
 * A path is represented by a list of (id,id,label) *)
type path = (id * id * label ) list    

(*exist_path g s d :  indicates if a path from source_node to destination_node exists in graph g.
 *@raise Graphe_error if s (ou d) is unknown in the graph *)
val exist_path : label graph -> id -> id -> bool 

(*find path g s d : finds in the graph a path from soucre_node to destination_node having min cost 
 *@raise Graphe_error if s (ou d) is unknown in the graph *)
val find_path_mincost : label graph -> id -> id -> path

(*print_path path  : print this path in terminal*)
val print_path : path -> unit

(*update_graph g path : update the graph when having the value flot_min got by a path *)
val update_graph : label graph -> path -> label graph

(*run_FF_algo g s d : apply the Busacker-Gowen algorithm for graph g
 *return a graph with max flow & min cost
 *and print the value of *)
val run_BG_algo : label graph -> id -> id -> int graph