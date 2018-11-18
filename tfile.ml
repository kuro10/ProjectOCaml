open Graph 
open Printf 

type path = sting

(* Input text file's format : 
 * 
 * S id cap        -> Source (Provider) 's id with its supply's capacity 
 * D id	cap		   -> Destination (Consumer) 's id with its demand's capacity
 * 
 * C id1 id2 flow cap -> Transport road between two points with its actual flow and its capacity 
 *)
(*------------------------------------------------------------*)
 let soi = string_of_int
 
 let ios = int_of_string
 
(*------------------------------------------------------------*)
(*let check_exist node file* --> A function that checks if a node under format "v %s" has already existed *) 
(*------------------------------------------------------------*)
let read_source outfile line =
  try Scanf.sscanf line "S %s" (fun id -> fprintf outfile "v %s\n" id)
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"
 
(*-------------------------------------------------------------*)
let get_source_flow id line = 
  try Scanf.sscanf line "C %s %s \"%s@\" \"%s@\"" (fun id1 id2 label1 label2 -> if id = id1 then ios label1 else 0)
  with e ->
    Printf.printf "Cannot read line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"
	
(*-------------------------------------------------------------*)
let get_destination_flow id line = 
  try Scanf.sscanf line "D %s %s \"%s@\" \"%s@\"" (fun id1 id2 label1 label2 -> if id = id2 then ios label1 else 0)
  with e ->
    Printf.printf "Cannot read line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"
	
(*-------------------------------------------------------------*)
let cap_calcul infile node = 
   
  let rec loop res =
    try 
	  let line = input_line infile in
	  let aux = match line.[0] with 
		| 'C' -> res + (get_source_flow node line) 
		| 'D' -> res + (get_destination_flow node line) 
		| _ -> res 
	  in 
	  loop aux
    with End_of_file -> res
  in

  let resultat = loop 0 in
  
  resultat
	
(*-------------------------------------------------------------*)
let read_source infile line outfile =
  try Scanf.sscanf line "S %s \"%s@\"" (fun id label ->
  let cap = cap_calcul infile id in
  let aux = if cap = (ios label) then fprintf outfile "e \"%s\" %s S\n" label id
  else fprintf outfile "e \"%s\" S %s\n" id (soi cap); fprintf outfile "e \"%s\" %s S\n" id (soi ((ios label) - cap))
  in 
  aux)
  with e ->
    Printf.printf "Cannot read line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"  
	
(*-------------------------------------------------------------*)
let read_destination infile line outfile =
  try Scanf.sscanf line "D %s \"%s@\"" (fun id label ->
  let cap = cap_calcul infile id in
  let aux = if cap = (ios label) then fprintf outfile "e \"%s\" D %s\n" label id
  else fprintf outfile "e \"%s\" %s D\n" id (soi cap); fprintf outfile "e \"%s\" D %s\n" id (soi ((ios label) - cap))
  in 
  aux)
  with e ->
    Printf.printf "Cannot read line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"  
 
(*-------------------------------------------------------------*)
let read_transport outfile line =
  try Scanf.sscanf line "C %s %s \"%s@\" \"%s@\"" (fun id1 id2 label1 label2 -> 
  fprintf outfile "v %s\n" id1;
  fprintf outfile "v %s\n" id2;
  fprintf outfile "e \"%s\" %s %s" label1 id1 id2;
  if ios label1 < ios label2 then fprintf outfile "e \"%s\" %s %s" (soi((ios label1) - (ios label2))) id2 id1) 
  with e ->
    Printf.printf "Cannot read line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"
	
(*-------------------------------------------------------------*)	
let create_file path1 path2 =

  let infile = open_in path1 in
  
  let outfile = open_out path2 in

  (* Create 2 points : Source and Destination*)
  fprintf outfile "v S\n";
  fprintf outfile "v D\n";
  
  (* Read all lines until end of file. *)
  let rec loop aux =
    try
      let line = input_line infile in
      let aux =
        (* Ignore empty lines *)
        if line = "" then ()

        (* The first character of a line determines its content : S, D or C.
         * Else it will be ignored *)
        else match line.[0] with
          | 'S' -> read_source infile line outfile
          | 'D' -> read_destination infile line outfile
          | 'C' -> read_transport outfile line
          | _ -> ()
      in                 
      loop aux        
    with End_of_file -> ()
  in

  close_in infile ;
  close_out outfile ;
  ()