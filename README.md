Planning for the Duke SSRI Julia Short Course, February 11, 2016.

# Topics to be covered:
## Overview: Why Julia? (Tyler)
- Goals:
    - as easy to use as Python, R, or Matlab
    - within a factor of 2 of FORTRAN or C
- General-purpose language (web server, systems, etc.), but focused on technical computing
- Under what conditions should I consider switching to Julia?

## Julia basics (John/Tyler)
1. Interactive usage (John)
    - running the REPL; running Jupyter and IJulia
    - getting help
        - ? mode

2. Basic data operations (Tyler)
    - matrices and vectors
    - linear algebra
    - comprehensions
    - it's okay to use loops
    - but it's also okay to vectorize (but be careful!)

3. Other data types (John)
    - tuple
    - set
    - dict

## Plotting things (John/Tyler)
- PyPlot (John)
- Winston (Tyler) [Winston is basically like Matlab's plotting syntax ... I'd like to intersperse some plotting with the DataFrames discussion, since this is a natural application. Maybe you can show PyPlot for more pure-math plotting applications, and I can show Winston / Gadfly for data applications?]
- Gadfly (Tyler)

## Theory: how Julia makes your code fast (John)
1. Compilers and compilation
    - stages of compilation
2. Types and the type system
    - why types are important
    - grappling with type difficulties
    - the type hierarchy
        - super and subtypes
    - getting help: which, @which, methodswith, typeof
    - types vs objects
3. Multiple dispatch
    - multiple dispatch vs methods
    - type annotations: when you do and don't need them
4. Enhancing your code's performance
    - @time
    - garbage collection; memory management
    - Debugging

## Other Topics (Tyler, with input from John on gotchas)
1. Language similarites / Best coding practices / avoiding "gotchas"
    - Put everything in functions so as to avoid Julia's default global scoping
    - Basic syntax comparisons with sister languages (Matlab, Python, R, etc.)
    - Other "gotchas" might already be discussed above with the compilation details section
2. Importing datasets from other languages
    - Matlab/R/Stata/SPSS/SAS datasets
    - CSV files
3. DataFrames
    - How to use
    - How to convert to matrices and back
    - NA type
    - GLM package for basic data analysis
4. Optimization
    - JuliaOpt
    - JuMP
5. Distributions
    - distributions as objects
    - evaluating distributions
    - drawing from distributions
    - automated log transformations for MLE applications
