open Graph 
open Printf 

type path = sting

(* Format of text files : lines of the form
 * 
 * P id            -> Provider 
 * C id			   -> Consumer 
 * 
 * T   id .. ..    -> Table of transport network
 * id  .. .. ..
 * id  .. .. ..
 *)

(*-------------------------------------------------------------*)
