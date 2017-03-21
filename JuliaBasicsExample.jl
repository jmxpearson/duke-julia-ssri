# Julia basics: Linear Algebra and Functions
# Here we will review some basics of Julia's linear algebra offerings.
# Arrays, Matrices, and Vectors
# Julia offers vectors (1-dimensional objects that are neither row nor column) and matrices (2-dimensional objects that can have 1 or more rows or columns)
# Vectors
# Vectors in Julia are one-dimensional:
x=rand(5)
size(x)
y=rand(5)
x.*y
x*y'
x'*y
dot(x,y)
# Key nuances:
# The element-wise product of two vectors is a vector.
# The matrix product is a 1-element vector, NOT a scalar
# The dot product is a scalar
# Matrices
# Initializing matrices
z = Array(Float64,3,2)
z = ones(Bool,3,2)
z = ones(3,2)
# Concatenation
z = [z;[1 2]]
x = cat(1,5,6,7)
y = cat(2,8,9,10)
# Indexing
# Index elements of a vector or matrix using brackets []
z[2,1]
z[2:end,1]
z[:,2]
z[1:2:end,2]
# You can also index with a boolean vector:
z[z[:,2].==1,:]
z[z[:,2].!=1,:]
# Linear Algebra
# Julia offers many of the same linear algebra functions as Matlab and R. Here, we'll cover some basic operations. More complex operations (e.g. singular value decomposition) are also supported.
# Addition + and subtraction - follow basic matrix rules. Note that adding a scalar to a matrix will add the scalar to each element.
z+1
z-z
# * in Julia represents matrix multiplication
z*repmat(y,2,1)
# Use \ or / to invert matrices
x= rand(3,3);
x\eye(3)
eye(3)/x
# Element-wise operations
# As in Matlab, a . in front of an operator causes it to be evaluated element-wise:
rand(3,3).*randn(3,3)
# Unlike Matlab, however, the . must precede any operator
# # # rand(3)>.5
# LoadError: MethodError: `isless` has no method matching isless(::Float64, ::Array{Float64,1})
# Closest candidates are:
# isless(::Float64, !Matched::Float64)
# isless(::AbstractFloat, !Matched::AbstractFloat)
# isless(::Real, !Matched::AbstractFloat)
# ...
# while loading In[41], in expression starting on line 1
# in > at operators.jl:34
rand(3).>.5
rand(3).==.5
# Comprehensions
# Comprehensions in Julia are a general and compact way to construct arrays. The general syntax is:
# A = [ F(x,y,...) for x=rx, y=ry, ... ]
# meaning that F(x,y,...) is evaluated with the variables x, y, etc. taking on each value in their given list of values.
# As an example, we can construct a "weighted-neighbor average" of elements in an a vector:
const zed = rand(8)
M=[ 0.25*zed[i-1] + 0.5*zed[i] + 0.25*zed[i+1] for i=2:length(zed)-1 ]
# Looping
# Looping in Julia has flexible syntax
zz = rand(5)
for i=1:length(zz)
    println(zz[i])
end
# We can identically evaluate the loop using the following syntax:
for i in 1:length(zz)
    println(zz[i])
end
# Vectorization
# While looping is fast in Julia, one can also quite easily perform matrix and vectorized operations in an intuitive way (unlike compiled languages like C and FORTRAN)
# Keep in mind that there are times when looping is faster than vectorization and vice versa. We will cover specifics later.
# Functions
# Functions in Julia follow these rules:
# function must be the first word
# inputs to the function are listed in parentheses after the function name
# outputs to the function are listed in the last line
# end must be the last word on its own line
function myfun(a,b)
    c=a*b;
    return c
end
myfun(5,6)
myfun([5;5],[6 1])
# Note that, because we used * to compute c in the function, it works with both scalars and conformable matrices.
function failer(r::Array)
    r = r + 1
end
function adder(r::Array)
    r[:] = r + 1
end
testarr = [0, 0]
failer(testarr)
println(testarr)
# Multiple outputs
# Functions with multiple outputs can be returned using tuples:
function myfun2(a,b)
    c=a*b;
    return c,a,b
end
product,in1,in2 = myfun2(5,6)
product
in1
in2
# If you forget to specify the multiple outputs and instead only return 1 output, the new output is a tuple:
product1 = myfun2(5,5)
product1
