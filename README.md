# TGW2D

Progetto **Topological Gift Wrapping 2D** per **Calcolo Parallelo e Distribuito** sviluppato da:

| Nome | Matricola | E-mail | Github Profile |  
|:---|:---|:---|:---|  
| Matteo Maraziti | 534932 | mat.maraziti@stud.uniroma3.it | [https://github.com/matteomaraziti](https://github.com/matteomaraziti)|  
| Federico Tocci | 533449 | fed.tocci@stud.uniroma3.it | [https://github.com/FTocci](https://github.com/FTocci) |  
| Giacomo Scordino | 533393 | gia.scordino1@stud.uniroma3.it | [https://github.com/GiacomoScordino](https://github.com/GiacomoScordino)| 

Documentazione: https://ftocci.github.io/TGW2D/build/  

## Packages

```julia
(@v1.6) pkg> add "https://github.com/cvdlab/ViewerGL.jl"
(@v1.6) pkg> add LinearAlgebraicRepresentation
(@v1.6) pkg> add DataStructures
(@v1.6) pkg> add SparseArrays
```

Notebooks:
 - `Studio Preliminare`: https://github.com/FTocci/TGW2D/blob/main/notebooks/NotebookPreliminare.ipynb
 - `Studio Esecutivo - Finale`: https://github.com/FTocci/TGW2D/blob/main/notebooks/NotebookFinale.ipynb
 
 
## TGW2D
`English Version`

The Topological Gift Wrapping repository contains functions for computing the arrangement on the given cellular complex 1-skeleton in 2D.
A cellular complex is arranged when the intersection of every possible pair of cell
of the complex is empty and the union of all the cells is the whole Euclidean space.
The basic method of the function without the `sigma`, `return_edge_map` and `multiproc` arguments
returns the full arranged complex `V`, `EV` and `FE`.

## Organizzazione cartelle

| Directory         | Contents                                                           |
| -                 | -                                                                  |
| `reports/`        | file in formato pdf                                                |
| `notebooks/`      | notebooks che spiegano il funzionamento delle singole funzioni     |
| `examples/`       | esempi di ogni funzione presente all'interno dei progetti LAR      |
| `src/`            | codice sorgente per TGW2D                                          |
| `test/`           | file di test                                                       |
