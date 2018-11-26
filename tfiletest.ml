open Tfile

let () =

  if Array.length Sys.argv <> 3 then
    begin
      Printf.printf "\nUsage: %s infile outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;

  let infile = open_in(Sys.argv.(1))
  and outfile = open_out(Sys.argv.(2))
  
  in
  create_file infile graphfile;
  let graph = Gfile.from_file graphfile in
  let igraph = map graph int_of_string in 

  (* Rewrite the graph that has been read. *)
  let () = 
    
  	Printf.printf "List path from %s to %s : \n" "S" "D" ; 
  	Ffalgo.print_path (Ffalgo.find_path igraph "S" "D");
    Gfile.export outfile (map (Ffalgo.run_FF_algo igraph "S" "D") string_of_int );
	
  in
  ()