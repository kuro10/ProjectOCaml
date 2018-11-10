open Graph

let exist_path g s d = 
	if node_exists g d then 
		let rec loop acu s = 
			List.exists (fun (id,_) -> 
							if List.mem id acu then false
							else if id=d then true
							else loop (id::acu) id ) 
						(out_arcs g s)
		in loop [] s
	else raise (Graph_error ("Node " ^ d ^ " does not exists in the graph."))

let rec list_path g from_a marked b= match from_a with
	| [] -> assert false
	| (x,y,l)::tl -> 
		if y=b then [from_a] 
		else	
			let newmarked = x :: y :: marked in
			let n = List.filter (fun (id,_) -> not (List.mem id newmarked) ) (out_arcs g y) in
			List.concat ( List.map (fun (id,label) -> list_path g ( (y,id,label)::from_a) newmarked b ) n)

let find_path g s d =
	assert (s<>d);
	let res = list_path g [(s,s,"0")] [s] d in 
	List.map (fun path -> let invpath = List.rev path in match invpath with |[] -> [] |a::tl -> tl ) res 

let find_flot_min path = List.fold_left (fun min (_,_,label) -> if int_of_string label < min then int_of_string label else min) 10000 path 

let print_path path = 
	Printf.printf "[ ";
	List.iter (fun (id1,id2,label) -> Printf.printf "[%s,%s,%s] " id1 id2 label) (path);
	Printf.printf " -> min flot = %d" (find_flot_min path);
	Printf.printf " ]\n"


let update_graph g path = 
	let rec update_path g path = 
		let flot_min = find_flot_min path in
		match path with
			| [] -> g
			| (a,b,label)::tl -> 
				if int_of_string label = flot_min
				then remove_arc (update_path g tl) a b
				else update_arc (update_path g tl) a b (string_of_int (int_of_string label - flot_min)) 
	in
	let rec update_rev_path g path = 
		let flot_min = find_flot_min path in 
		match path with
			| [] -> g
			| (a,b,label)::tl -> 
				if find_arc g b a = None 
				then add_arc (update_rev_path g tl) b a label 
				else update_arc (update_rev_path g tl) b a (string_of_int (int_of_string label +flot_min)) 
	
	in update_rev_path (update_path g path) path

