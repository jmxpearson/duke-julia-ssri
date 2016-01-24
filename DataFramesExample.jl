# Simple example of how to use DataFrames in Julia

# Declare packages
using DataFrames
using RDatasets
using GLM

#----------------
# Data frame operations
#----------------
# create a data frame
mydata = DataFrame(A = 1:10, B = 2:2:20)
println(mydata)

# can index by column number of column name
println(mydata[1])
println(mydata[:A])

# grab a handful of rows of the first column:
println(mydata[1:7,:A])
println(mydata[2:6,:B])

# select rows of the frame such that the first column has an even-numbered value:
println(mydata[mydata[:A] % 2 .== 0, :])

# or use R-style "head" and "tail" functions:
println(head(mydata,7))
println(tail(mydata,2))

# Merge (join) two data frames
names = DataFrame(ID = [1, 2, 3, 4, 5, 6], Name = ["John", "Jane", "Mark", "Ann", "Vlad", "Maria"])
jobs = DataFrame(ID = [1, 2, 3, 4, 5, 6], Job = ["Lawyer", "Doctor", "Mechanic", "Doctor", "Judge", "Pilot"])
mergedData = join(names,jobs, on = :ID, kind = :inner)
# various other kinds of joins (similar to Stata's 1:1, 1:m, m:1, m:m)

# Reshape (pivot) data
iris = dataset("datasets", "iris")
iris[:id] = 1:size(iris, 1)  # this makes it easier to unstack
d = stack(iris, [1:4]) # reshape columns 1-4 from wide to long; creates a new variable called "value" that stores the value of the given variable
println(d)
d = stack(iris, [:SepalLength, :SepalWidth], [:Species]) # control which variables get repeated when reshaping (similar to Stata's ", i(...) j(...)" nomenclature)
println(d)

# Representing factors (categories of variables)
# similar to R's as.factor and Stata's "i." and "c." notation
df = DataFrame(id = [1, 2, 3, 4, 5, 6],
               B = ["X", "X", "X", "Y", "Y", "Y"])
println(df)
pool!(df, [:B]) # in R: df$B <- as.factor(df$B)
println(df)

#----------------
# Analyzing data
#----------------
# Summary statistics
describe(iris)
mean(iris[:SepalLength])

# Regression models (OLS; other GLMs also available)
OLS = fit(LinearModel,SepalLength~SepalWidth+PetalLength+PetalWidth,iris)
iris2 = iris
pool!(iris2, [:Species]) # convert species strings to factor levels

OLS2 = fit(LinearModel,SepalLength~SepalWidth+PetalLength+PetalWidth+Species,iris2) # analyze regression with dummy levels for Species
