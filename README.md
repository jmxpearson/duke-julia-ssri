Planning for the Duke SSRI Julia Short Course, March 22, 2017.

# Topics to be covered:
## Overview: Why Julia? (John)
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
    - defining functions (so we can do ... below)

3. Other data types (John)
    - tuple
        - tuples are collections of function arguments
        - splatting and slurping (...)
    - dict
        - introduction (for Matlab people)
        - type safety (for Python people)
        - cultural: keys are often symbols
    - set (time permitting)

## Plotting things (John/Tyler)
- PyPlot (John)
- Winston (Tyler) [Winston is basically like Matlab's plotting syntax ... I'd like to intersperse some plotting with the DataFrames discussion, since this is a natural application. Maybe you can show PyPlot for more pure-math plotting applications, and I can show Winston / Gadfly for data applications?] &mdash; **Sounds good. I will probably use this as an excuse to show off Python interoperability**
- Gadfly (Tyler): like ggplot for Julia

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
5. Macros & meta-programming
    - [This might be worth a brief mention, but nothing more]
    - if code is just another data structure, you can write code that writes code!

## Other Topics (Tyler, with input from John on gotchas)
1. Language similarites / Best coding practices / avoiding "gotchas"
    - Put everything in functions so as to avoid Julia's default global scoping
    - adding type info to list comprehensions
    - Basic syntax comparisons with sister languages (Matlab, Python, R, etc.)
    - Other "gotchas" might already be discussed above with the compilation details section
    - see [here](http://docs.julialang.org/en/release-0.4/manual/performance-tips/) for a more complete list
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
    - maybe worth noting that StatsFuns.jl logpdfs are automatically differentiable by ForwardDiff.jl [PR](https://github.com/JuliaDiff/ForwardDiff.jl/pull/73)
