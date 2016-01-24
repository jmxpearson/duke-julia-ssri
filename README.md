Planning for the Duke SSRI Julia Short Course, February 11, 2016.

# Topics to be covered:
## Overview: Why Julia?
- Goals:
    - as easy to use as Python or R
    - within a factor of 2 of FORTRAN or C
- General-purpose language (web server, systems, etc.), but focused on technical computing
- Under what conditions should I consider switching to Julia?

## Julia basics
1. Interactive usage
    - running the REPL; running Jupyter and IJulia
    - getting help
        - ? mode

1. Basic data operations
    - matrices and vectors
    - linear algebra
    - comprehensions
    - it's okay to use loops
    - but it's also okay to vectorize (but be careful!)

1. Other data types
    - tuple
    - set
    - dict

## Plotting things
- PyPlot
- Winston
- Gadfly

## Theory: how Julia makes your code fast
1. Compilers and compilation
    - stages of compilation
2. Types and the type system
    - why types are important
    - grappling with type difficulties
    - the type hierarchy
        - super and subtypes
    - getting help: which, @which, methodswith, typeof
    - types vs objects
1. Multiple dispatch
    - multiple dispatch vs methods
    - type annotations: when you do and don't need them

## Other Topics
- Language similarites / Best coding practices / avoiding "gotchas"
    - Put everything in functions so as to avoid Julia's default global scoping
    - Basic syntax comparisons with sister languages (Matlab, Python, R, etc.)
    - Other "gotchas" might already be discussed above with the compilation details section
- Importing datasets from other languages
    - Matlab/R/Stata/SPSS/SAS datasets
    - CSV files
- DataFrames
    - How to use
    - How to convert to matrices and back
    - NA type
    - GLM package for basic data analysis
- optimization
    - JuliaOpt
    - JuMP
- distributions
    - distributions as objects
    - evaluating distributions
    - drawing from distributions
    - automated log transformations
