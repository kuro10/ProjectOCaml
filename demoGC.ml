open Graph

let () =

  if Array.length Sys.argv <> 6 then
    begin
      Printf.printf "\nUsage: %s infile source sink outfile resfile\n\n%!" Sys.argv.(0) ;
      exit 0
    end ;

  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  and resfile = Sys.argv.(5)

  (* These command-line arguments are not used for the moment. *)
  and _source = Sys.argv.(2)
  and _sink = Sys.argv.(3)
  in

  (* Open file *)
  let cgraph = GCostfile.from_file infile in 
  let icgraph = map cgraph GCostfile.sToi in
  (* Rewrite the graph that has been read. *)
  let () = 
    (*
    Printf.printf "Path from %s to %s : %b\n" _source _sink (Bgalgo.exist_path icgraph _source _sink);
    Printf.printf "Path with the min cost from %s to %s : \n" _source _sink ; 
  	Bgalgo.print_path (Bgalgo.find_path_mincost icgraph _source _sink);
	*) 
	GCostfile.export outfile cgraph;
    GCostfile.export resfile (map (Bgalgo.run_BG_algo icgraph _source _sink) GCostfile.iTos);
    

  in
  ()
