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

