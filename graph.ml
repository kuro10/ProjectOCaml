type id = string

type 'a out_arcs = (id * 'a) list

(* A graph is just a list of pairs: a node & its outgoing arcs. *)
type 'a graph = (id * 'a out_arcs) list

exception Graph_error of string

let empty_graph = []

let node_exists gr id = List.mem_assoc id gr

let out_arcs gr id =
  try List.assoc id gr
  with Not_found -> raise (Graph_error ("Node " ^ id ^ " does not exist in this graph."))

let find_arc gr id1 id2 =
  let out = out_arcs gr id1 in
  try Some (List.assoc id2 out)
  with Not_found -> None

let add_node gr id =
  if node_exists gr id then raise (Graph_error ("Node " ^ id ^ " already exists in the graph."))
  else (id, []) :: gr

let add_arc gr id1 id2 lbl =

  (* Existing out-arcs *)
  let outa = out_arcs gr id1 in

  (* Update out-arcs.
   * remove_assoc does not fail if id2 is not bound.  *)
  let outb = (id2, lbl) :: List.remove_assoc id2 outa in
  
  (* Replace out-arcs in the graph. *)
  let gr2 = List.remove_assoc id1 gr in
  (id1, outb) :: gr2

let v_iter gr f = List.iter (fun (id, out) -> f id out) gr

let v_fold gr f acu = List.fold_left (fun acu (id, out) -> f acu id out) acu gr

let map gr f = 
	let map_arcs outA = List.map (fun (id, x) -> (id,f x) ) outA in
	List.map (fun (id,al) -> (id, map_arcs al) ) gr
	  
let update_arc gr a b newlabel = 
 	List.map (fun (id1,out) ->  
                    (id1,List.map (fun (id2,label) -> if id1=a && id2=b 
                                    then (id2,newlabel) 
                                    else (id2,label) ) out)) gr

let remove_arc gr a b = match find_arc gr a b with 
	| None -> raise (Graph_error ("Arc from " ^ a ^ "to" ^ b ^ " does not exist in the graph."))
	| Some _ -> List.map (fun (id1,out) ->  
                              if id1=a && List.mem_assoc b out then (id1,List.remove_assoc b out) 
                              else (id1,out)) gr
