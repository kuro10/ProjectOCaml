open Graph

let () =

  if Array.length Sys.argv <> 4 then
    begin
      Printf.printf "\nUsage: %s infile outfile graphfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;

  let infile = Sys.argv.(1) 
  and outfile = Sys.argv.(2)
  and graphfile = Sys.argv.(3)
  
  in
  Tfile.create_file infile graphfile;
  let graph = Gfile.from_file graphfile in
  let igraph = map graph int_of_string in

  (* Rewrite the graph that has been read. *)
  let () = 
    Tfile.export graphfile graph; 
   	Tfile.export outfile (map (Ffalgo.run_FF_algo igraph "S" "D") string_of_int );
	
  in
  ()
