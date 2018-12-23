open Graph

type label = int * int

type  path = (id * id * label) list  

(*-----------------------------------------------------------------------
val exist_path : label graph -> id -> id -> bool
This function verifies if it exists a path from s to d in graph g
------------------------------------------------------------------------*)
let exist_path g s d = 
	if not (node_exists g s) then raise (Graph_error ("Node " ^ s ^ " does not exists in the graph."))
	else if not (node_exists g d) then raise (Graph_error ("Node " ^ d ^ " does not exists in the graph."))
	else
		
		let rec loop acu s =
			(*For each node 'id' at which 's' can reach
			 *Check by recursive if it exist a path from 'id' to 'd' *)			 
			List.exists (fun (id,_) -> 
							if List.mem id acu then false
							else if id=d then true
							else loop (id::acu) id ) 
						(out_arcs g s)
		in loop [] s

(*-----------------------------------------------------------------------
val find_path : label graph -> id -> id -> path
This function finds a path having the min cost from s to d in graph g, return an empty list if it does not exist  
------------------------------------------------------------------------*)

(*This function finds a list which includes all of paths from a to b *)
let rec list_path g from_a marked b= match from_a with
	| [] -> assert false
	| (x,y,l)::tl -> 
		if y=b then [from_a] 
		else	
			let newmarked = y :: marked in
			let n = List.filter (fun (id,_) -> not (List.mem id newmarked) ) (out_arcs g y) in
			List.concat ( List.map (fun (id,l) -> list_path g ( (y,id,l)::from_a) newmarked b ) n)

(*This function returns the cost of a path*)
let find_cost path = List.fold_left (fun acu (_,_,(_,cost)) -> acu + cost) 0 path

(*This function returns a correct ordre path from a to b which having the min cost*)
let find_path_mincost g s d =
	if not (node_exists g s) then raise (Graph_error ("Node " ^ s ^ " does not exists in the graph."))
	else if not (node_exists g d) then raise (Graph_error ("Node " ^ d ^ " does not exists in the graph."))
	else
		assert (s<>d);
		(*Reverse the path, easier to verify the result*)
		let pathlist = list_path g [(s,s,(0,0))] [s]  d in 
		let rec loop min path = function	
			| [] -> path
			| p :: tl -> if find_cost p < min then loop (find_cost p) p tl else loop min path tl
		in match List.rev (loop 10000 [] pathlist) with
			| [] -> []
			| a :: tl -> tl

(*-----------------------------------------------------------------------
This function returns the value of flow_min from path, this value is used to update the graph
------------------------------------------------------------------------*)
let find_flow_min path = List.fold_left (fun min (_,_,(flow,_)) -> if flow < min then flow else min) 10000 path 


(*-----------------------------------------------------------------------
val print_path : (id * id * label) list -> unit
This function prints the path, helps to check the results (path,flow_min)
------------------------------------------------------------------------*)
let print_path path = 
	Printf.printf "{ ";
	List.iter (fun (id1,id2,_) -> Printf.printf "(%s,%s) " id1 id2 ) (path);
	Printf.printf " -> min flow = %d & cost = %d" (find_flow_min path) (find_cost path);
	Printf.printf " }\n"

(*-----------------------------------------------------------------------
val update_graph : label graph -> (id * id * label) list -> label graph
This function is used to update the graph by given a path
------------------------------------------------------------------------*)
let update_graph g path = 
	(* First, we have the flow_min that can be added*)
	let flow_min = find_flow_min path in
	(* Then, we update all the values on this path,by increasing the flow (or decreasing the capacity) of these arcs*)
	let rec update_path g path = match path with
		| [] -> g
		| (a,b,(flow,cost))::tl -> 
			if flow = flow_min
			then update_path (remove_arc g a b) tl  (*if the flow of an arc is zero, remove it *) 
			else let newlabel =  ((flow - flow_min),cost) in
				update_path (update_arc g a b newlabel ) tl (*otherwise, dercrease the flow and keep the cost*)	
	(* Finally, we update all the reverse arcs from this path*)	
	in 
	let rec update_rev_path g path = match path with
		| [] -> g
		| (a,b,(flow,cost))::tl -> 
			match find_arc g b a with 
				| None -> let newlabel = (flow_min, 0-cost) in 
					update_rev_path (add_arc g b a newlabel ) tl  (*if this arc does not exists, we add it into the graph with the flow_min and invert the cost *)
				| Some (x,cost) -> let newlabel = (x + flow_min, cost) in
					update_rev_path ( update_arc g b a newlabel ) tl (*if it already exists, increase this value by adding flow_min*)
	in update_rev_path (update_path g path) path


(*-----------------------------------------------------------------------
val update_output : label graph -> (id * id * label) list -> int graph
This function is used to update the output graph by given a deviation graph and a path
------------------------------------------------------------------------*)

let update_output g path = 
	let flow_min = find_flow_min path in 
	let rec update_path g path = match path with
		| [] -> g
		| (a,b,(flow,_))::tl -> 
			match (find_arc g a b,find_arc g b a) with 
				| (None,None) ->  update_path (add_arc g a b flow_min ) tl  (*if this arc does not exists, we add it into the graph *)
				| (None,Some x) -> update_path (if x>flow_min then add_arc g b a (x-flow_min) else remove_arc g b a  ) tl
				| (Some x,_) -> update_path ( update_arc g a b (x + flow_min) ) tl (*if it already exists, increase this value by adding flow_min  *)
	in update_path g path	



let initalize_output g =  
	List.fold_left add_node empty_graph (find_nodes g) 


(*-----------------------------------------------------------------------
val run_BG_algo : label graph -> id -> id -> int graph
This function helps to apply the Busacker-Gowen algorithm on the given graph
Return a graph with max flow  & min cost
Print the values of max flow & min cost
------------------------------------------------------------------------*)
let run_BG_algo g s p =
	let output = initalize_output g in
	(*While it exists a path from s to p, continue algo 
	 *cpt is used to count the number of loop *)
	let rec loop g cpt cost debit output= 
		if exist_path g s p then 
			(*find a path and its flow min*)
			let path = find_path_mincost g s p in
			let flow_min = find_flow_min path in 
			let newcost = cost + (find_cost path)*flow_min in
			let newdebit =  debit + flow_min in 
			print_path path; 
			let newOutput = update_output output path in 
			(*update the graph with this path *)
			let newg = update_graph g path in 
			(*Gfile.export (string_of_int cpt) newg;*)
			loop newg (cpt+1) newcost newdebit newOutput
		else (output,cost,debit) 
	in let (result,mincost,maxdebit) = loop g 0 0 0 output in
	begin
		Printf.printf "Result : min cost = %d &  max debit = %d\n" mincost maxdebit;
		result 
	end
