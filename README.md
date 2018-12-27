# PROJECT : Funtionnal Programming in OCaml

This project is done by : [TRAN Trong Hieu](https://github.com/kuro10) & [TRAN Le Minh](https://github.com/tranleminh), a pair of students in 4IR, INSA Toulouse.

## Project Goal  

This project consists of implementing an algorithm computing the max-flow of a flow graph, based on Ford–Fulkerson algorithm, and optionally improve it to take into account other constraints (e.g. minimize cost).

## Compiling instruction
* Use `ocamlbuild ftest.byte` to build the bytecode executable, or `ocamlbuild ftest.native` to build the native executable. You might choose only one of these 2 methods.
* To run the executable, type on command line : `./ftest.byte` or `./ftest.native` according to chosen compiling method. 

## Discover the Project Modules 

The base project contains two modules and a main program: 

* `graph.mli` & `graph.ml` which define a module `Graph`
* `gfile.mli` & `gfile.ml` which define a module `Gfile`
* `ftest.ml`, the main program 

To generate an image from a dot file, type on command line: 

 `dot -Tpng your-dot-file > some-output-file` (if the png format is unrecognized, try svg)

## Part I : Ford-Fulkerson algorithm's implementation

In this part, we have to understand and implement the Ford-Fulkerson algorithm (in the module `Ffalgo`, which define a module Ffalgo), then test it on several examples and verify.

## Part II : Involving in real life use case - Transport problem

Find an use-case of this algorithm and writes a program that solves the problem (reference : [max flow page](https://en.wikipedia.org/wiki/Maximum_flow_problem)). 
In this part, we build a module named `Tfile` which allows user to "translate" a real life problem into a flow graph problem. 
In order to use module Tfile, user has to create an input file with the imposed format and precise the following elements :
- Source point with its supply capacity. By example, a source named "a" with supply capacity "25" is presented as : S a "25" 
- Destination point with its demand capacity. By example, a destination named "d" with demand capcity "30" is presented as : D d "30"
- Transport roads between points, as well as its maximal capacity. By example, if user is expecting a transport road between "a" and "d" with a maximal capacity of "20 products", it is presented as : C a d "20" 

In this part, the project contains : 

* `tfile.mli` & `tfile.ml` defining module `Tfile`.
* `tfiletest.ml`, part II's main program.

## Part III : Project's enhancement with max-flow min-cost algorithm

Advanced implementation of the basic Ford Fulkerson algorithm by considering other constraints - and implementing the max-flow min-cost algorithm.

The project contains : 

* `bgalgo.mli` & `bgalgo.ml` which define a module `Bgalfo`
* `gCostfile.mli` & `gCostfile.ml` which define a module `GCostfile`
* `demoGC.ml`, the main program 

## Project's validity testing 

In order to test the project's validity, we ran the programs on some examples and compared the results with those obtained by using other tools/programs, by calculating by hand and paper, etc. 


I. Ford Fulkerson algorithm testing : please type on the command line the following commands   

`ocamlbuild ftest.byte` to build the program.
 
`./ftest.byte graph1 0 5 test1` where `graph1` is the text-formatted input graph and `test1` is the result graph. Here we choose `0` and `5` as source and sink. 

`dot -Tpng test1 > test1.png` to visualize the text-formatted result graph by converting it into an image. 


II. Transport case testing : please type the following commands :

`ocamlbuild tfiletest.byte` to build the program

`./tfiletest.byte tab2 test2 graph2` where `tab2` is the transport's problem written in the correct format precised in part II, `test2` is the result graph and `graph2` is the input graph, obtained by translating the transport problem. 

`dot -Tpng graph2 > graph2.png` to visualize the starting graph

`dot -Tpng test2 > test2.png` to visualize the result graph


III. Max-flow Min-cost algorithm : to test the result, type : 

`ocamlbuild demoGC.byte` to build the program

`./demoGC.byte tab3 1 5 graph3 test3` with `tab3` as input file, `1` and `5` are source and sink, `graph3` as starting graph obtained by translating `tab3` into graph file, and `test3` as result graph. 

`dot -Tpng graph3 > graph3.png` to visualize the starting graph

`dot -Tpng test3 > test3.png` to visualize the result graph

