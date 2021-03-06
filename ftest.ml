open Graph

let () =

  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;

  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  
  (* These command-line arguments are not used for the moment. *)
  and _source = Sys.argv.(2)
  and _sink = Sys.argv.(3)
  in

  (* Open file *)
  let graph = Gfile.from_file infile in
  let igraph = map graph int_of_string in 
  (*
  let aPath = Ffalgo.find_path igraph _source _sink in
  let out  = List.fold_left add_node empty_graph (find_nodes graph) in 
  *)

  (* Main program *)
  let () = 
    
    (*Printf.printf "Path from %s to %s : %b\n" _source _sink (Ffalgo.exist_path graph _source _sink);

    Printf.printf "List path from %s to %s : \n" _source _sink ;
     
  	Ffalgo.print_path (aPath);
    *)  
  	
	  (*List.iter (fun p -> Ffalgo.print_path p) (Ffalgo.find_path igraph _source _sink);*)
	    
	  (*Gfile.export outfile (Ffalgo.update_graph graph (List.nth  (Ffalgo.find_path igraph _source _sink) 6 ));*)
    
    (*List.iter (fun p -> Printf.printf " %s \n" p) (find_nodes graph);*)

    
    (*Gfile.export outfile (map (Ffalgo.update_output out aPath) string_of_int);*)


    Gfile.export outfile (map (Ffalgo.run_FF_algo igraph _source _sink) string_of_int );

  in
  ()
