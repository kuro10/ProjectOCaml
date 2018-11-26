open Graph 
open Printf 

type path = string

(* Input text file's format : 
 * 
 * S id cap        -> Source (Provider) 's id with its supply's capacity 
 * D id	cap		   -> Destination (Consumer) 's id with its demand's capacity
 * 
 * C id1 id2 cap -> Transport road between two points with its capacity 
 *)

(*-------------------------------------------------------------*)
let read_source line outfile =
  try Scanf.sscanf line "S %s \"%s@\"" (fun id label ->
  fprintf outfile "v %s\n" id;
  fprintf outfile "e \"%s\" S %s\n" label id;)
  with e ->
    Printf.printf "Cannot read source line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"  
	
(*-------------------------------------------------------------*)
let read_destination line outfile =
  try Scanf.sscanf line "D %s \"%s@\"" (fun id label ->
  fprintf outfile "v %s\n" id;
  fprintf outfile "e \"%s\" %s D\n" label id;)
  with e ->
    Printf.printf "Cannot read destination line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "from_file"  
 
(*-------------------------------------------------------------*)
let read_transport line outfile =
  try Scanf.sscanf line "C %s %s \"%s@\"" (fun id1 id2 label ->
  fprintf outfile "e \"%s\" %s %s" label id1 id2;)
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
  let rec loop () =
    try
      let line = input_line infile in
	  printf "[%s]\n%!" line;
      let () =
        (* Ignore empty lines *)
        if line = "" then ()

        (* The first character of a line determines its content : S, D or C.
         * Else it will be ignored *)
        else match line.[0] with
          | 'S' -> read_source line outfile
          | 'D' -> read_destination line outfile
          | 'C' -> read_transport line outfile 
          | _ -> ()
      in                 
      loop ()        
    with End_of_file -> ()
  in
  loop ();
  close_in infile ;
  close_out outfile ;
  ()
