open Graph

type  path = (id * id * int) list  

(*-----------------------------------------------------------------------
val exist_path : int graph -> id -> id -> bool
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
val find_path : int graph -> id -> id -> path
This function finds a path from s to d in graph g, return an empty list if it does not exist  
------------------------------------------------------------------------*)

(*This function finds a list which includes all of paths from a to b *)
(*
let rec list_path g from_a marked b= match from_a with
	| [] -> assert false
	| (x,y,l)::tl -> 
		if y=b then [from_a] 
		else	
			let newmarked = y :: marked in
			let n = List.filter (fun (id,_) -> not (List.mem id newmarked) ) (out_arcs g y) in
			List.concat ( List.map (fun (id,label) -> list_path g ( (y,id,label)::from_a) newmarked b ) n)
*)

(*This function finds only a path if it exits*)
let rec a_path g from_a marked b= match from_a with
	| [] -> assert false 
	| (x,y,l)::tl -> 
		(*if the path from_a already reached at b -> ok*)
		if y=b then from_a 
		else	
			(* otherwise, mark y*)
			let newmarked = y :: marked in
			(*check all of out_arcs from y and choose all the nodes which are not marked*)
			let n = List.filter (fun (id,_) -> not (List.mem id newmarked) ) (out_arcs g y) in
			(*find from these nodes a path to b
			 *if a path exists, return it 
			 *else check the next node *)			
			let rec loop l = match l with 
				| [] -> []
				| (id,label) :: tl -> 
					match a_path g ( (y,id,label)::from_a) newmarked b with   
						| [] -> loop tl 
						| path -> path  
			in loop n		

(*This function returns a correct ordre path from a to b*)
let find_path g s d =
	if not (node_exists g s) then raise (Graph_error ("Node " ^ s ^ " does not exists in the graph."))
	else if not (node_exists g d) then raise (Graph_error ("Node " ^ d ^ " does not exists in the graph."))
	else
		assert (s<>d);
		(*Reverse the path, easier to verify the result*)
		match List.rev (a_path g [(s,s,0)] [s] d) with
			| [] -> []
			| a :: tl -> tl 

(*-----------------------------------------------------------------------
This function returns the value of flow_min from path, this value is used to update the graph
------------------------------------------------------------------------*)
let find_flow_min path = List.fold_left (fun min (_,_,label) -> if label < min then label else min) 10000 path 

(*-----------------------------------------------------------------------
val print_path : (id * id * int) list -> unit
This function prints the path, helps to check the results (path,flow_min)
------------------------------------------------------------------------*)
let print_path path = 
	Printf.printf "{ ";
	List.iter (fun (id1,id2,label) -> Printf.printf "[from %s to %s,cap=%d] " id1 id2 label) (path);
	Printf.printf " -> min flow = %d" (find_flow_min path);
	Printf.printf " }\n"

(*-----------------------------------------------------------------------
val update_graph : int graph -> (id * id * int) list -> int graph
This function is used to update the graph by given a path
------------------------------------------------------------------------*)
let update_graph g path = 
	(* First, we have the flow_min that can be added*)
	let flow_min = find_flow_min path in
	(* Then, we update all the values on this path,by increasing the flow (or decreasing the capacity) of these arcs*)
	let rec update_path g path = match path with
		| [] -> g
		| (a,b,label)::tl -> 
			if label = flow_min
			then update_path (remove_arc g a b) tl  (*if the flow of an arc is zero, remove it *) 
			else update_path (update_arc g a b (label - flow_min) ) tl (*otherwise, dercrease it*)	
	(* Finally, we update all the reverse arcs from this path*)	
	in 
	let rec update_rev_path g path = match path with
		| [] -> g
		| (a,b,_)::tl -> 
			match find_arc g b a with 
				| None ->  update_rev_path (add_arc g b a flow_min ) tl  (*if this arc does not exists, we add it into the graph *)
				| Some x -> update_rev_path ( update_arc g b a (x + flow_min) ) tl (*if it already exists, increase this value by adding flow_min  *)
	in update_rev_path (update_path g path) path


(*-----------------------------------------------------------------------
val update_output : int graph -> (id * id * int) list -> int graph
This function is used to update the output graph by given a deviation graph and a path
------------------------------------------------------------------------*)

let update_output g path = 
	let flow_min = find_flow_min path in 
	let rec update_path g path = match path with
		| [] -> g
		| (a,b,_)::tl -> 
			match find_arc g a b with 
				| None ->  update_path (add_arc g a b flow_min ) tl  (*if this arc does not exists, we add it into the graph *)
				| Some x -> update_path ( update_arc g a b (x + flow_min) ) tl (*if it already exists, increase this value by adding flow_min  *)
	in update_path g path	



let initalize_output g =  
	List.fold_left add_node empty_graph (find_nodes g) 

(*-----------------------------------------------------------------------
val run_FF_algo : int graph -> id -> id -> int graph
This function helps to apply the Ford-Fulkerson algorithm on the given graph
Return a graph with flow max
------------------------------------------------------------------------*)
let run_FF_algo g s p =
	let output = initalize_output g in  
	(*While it exists a path from s to p, continue algo 
	 *cpt is used to count the number of loop *)
	let rec loop g cpt debit output = 
		if exist_path g s p then 
			(*find a path and its flow min*)
			let path = find_path g s p in
			let flow_min = find_flow_min path in 
			let newdebit =  debit + flow_min in
			print_path path;
			(*Update the output with this path*)
			let newOutput = update_output output path in
			(*update the deviation graph with this path *)
			let newg = update_graph g path in 
			(*Gfile.export (string_of_int cpt) newg;*)
			loop newg (cpt+1) newdebit newOutput 
		else (output,debit) 
	in let (result,maxdebit) = loop g 0 0 output in 
	begin
		Printf.printf "Result : max debit = %d\n" maxdebit;
		result 
	end

