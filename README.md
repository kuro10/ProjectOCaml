# PROJECT : Funtionnal Programming in OCaml

This project is done by : [TRAN Trong Hieu](https://github.com/kuro10) & [TRAN Le Minh](https://github.com/tranleminh), a pair of students in 4IR, INSA Toulouse.

## How it goes ? 

The goal is to implement an algorithm computing the max-flow of a flow graph, using the Ford–Fulkerson algorithm, and optionally improve it to take into account other constraints (e.g. minimize cost).

## A few more thing about compilation
* Use `ocamlbuild ftest.byte` to build the bytecode executable, or `ocamlbuild ftest.native` to build the native executable (Only one of them)
* `./ftest.byte` or `./ftest.native` 

## Discover the Project Modules 

The base project contains two modules and a main program : 

* `graph.mli` & `graph.ml` which define a module `Graph`
* `gfile.mli` & `gfile.ml` which define a module `Gfile`
* `ftest.ml`, the main program 

To generate an image from a dot file, you can use: 

 `dot -Tpng your-dot-file > some-output-file` (if the png format is unrecognized, try svg)

## Part I : Minimal acceptable project

In this part, we have to understand and implement the Ford-Fulkerson algorithm (in the module `Ffalgo`), then test it on several examples and verify.

`ocamlbuild ftest.byte`
`./ftest.byte graph1 0 5 test1`
`dot -Tpng test1 > test1.png`

## Part II : Medium project

Find a use-case of this algorithm and writes a program that solves the problem (reference : [max flow page](https://en.wikipedia.org/wiki/Maximum_flow_problem)).
In order to use module Tfile, user has to create an input file with the imposed format and precise the following elements :
- Source point with its supply capacity. By example, a source named "a" with supply capacity "25" is presented as : S a "25" 
- Destination point with its demand capacity. By example, a destination named "d" with demand capcity "30" is presented as : D d "30"
- Transport roads between points, as well as its maximal capacity. By example, if user is expecting a transport road between "a" and "d" with a maximal capacity of "20 products", it is presented as : C a d "20" 
## Part III : Better project

Enhance the medium project by taking into account other constraints - and implementing the max-flow min-cost algorithm.



