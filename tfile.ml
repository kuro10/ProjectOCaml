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
  fprintf outfile "e \"%s\" S %s\n" label id)
  with e ->
    Printf.printf "Cannot read source line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "read_source"  
	
(*-------------------------------------------------------------*)
let read_destination line outfile =
  try Scanf.sscanf line "D %s \"%s@\"" (fun id label ->
  fprintf outfile "v %s\n" id;
  fprintf outfile "e \"%s\" %s D\n" label id;)
  with e ->
    Printf.printf "Cannot read destination line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "read_destination"  
 
(*-------------------------------------------------------------*)
let read_transport line outfile =
  try Scanf.sscanf line "C %s %s \"%s@\"" (fun id1 id2 label ->
  fprintf outfile "e \"%s\" %s %s\n" label id1 id2;)
  with e ->
    Printf.printf "Cannot read line - %s:\n%s\n" (Printexc.to_string e) line ;
    failwith "read_transport"
	
(*-------------------------------------------------------------*)	
let create_file infile outfile =

  let fx = open_in infile in
  let ff = open_out outfile in

  (* Create 2 points : Source and Destination*)
  fprintf ff "v S\n";
  fprintf ff "v D\n";
  
  (* Read all lines until end of file. *)
  let rec loop () =
    try
      let line = input_line fx in
      let () =
        (* Ignore empty lines *)
        if line = "" then ()

        (* The first character of a line determines its content : S, D or C.
         * Else it will be ignored *)
        else match line.[0] with
          | 'S' -> read_source line ff
          | 'D' -> read_destination line ff
          | 'C' -> read_transport line ff 
          | _ -> ()
      in                 
      loop ()        
    with End_of_file -> ()
  in
  loop ();
  close_out ff;
  close_in fx;
  ()
(*-------------------------------------------------------------*)	
let export path graph = 
  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "digraph finite_state_machine {\n" ;
  fprintf ff "  rankdir=LR;\n" ;
  fprintf ff "  size=\"8,5\"\n" ;
  fprintf ff "  node [shape = circle];\n";

  (* Write all arcs *)
  v_iter graph (fun id out -> if (id <> "S" && id <> "D") then List.iter (fun (id2, lbl) -> if (id2 <> "D" && id2 <> "S") then fprintf ff "  %s -> %s [ label = \"%s\" ]; \n" id id2 lbl) out) ;

  fprintf ff "}" ;
  
  close_out ff ;
  ()
