# Simple example of how to use DataFrames in Julia

# Declare packages
using DataFrames
using GLM
using FreqTables

#----------------
# Data frame operations
#----------------
# 1. Exploring your data

# import some data (Stata's famed "auto" dataset)
auto = readtable("auto.csv"); #makefactors = true

# Show the variable names in our data frame and how they are stored
# Stata's describe command
showcols(auto)

# Count number of rows and columns in the data frame
size(auto,1)
size(auto,2)

# List all observations for variables price and mpg
# Stata's list command
auto[:,[:price,:mpg]]
# we can also reference variables by column number
auto[:,[2 3]]

# List first k  observations for entire data frame
# Stata's list command
head(auto,k)

# List last k  observations for entire data frame
# Stata's list command
tail(auto,k)

# List observations 1,2,5, and 16 for variables head and trunk
auto[[1,2,5,16],[:headroom,:trunk]]

# List observations of head and trunk such that mpg is less than 20
# Note that we need to put a . in front of the "<" operator!
auto[(auto[:,:mpg].<20),[:head,:trunk]]

# Summary stats
describe(auto)
mean(auto[:mpg])

# Frequency tables
# one-way tables
by(auto, :foreign, nrow)
countmap(auto[:foreign])
by(auto, :rep78, nrow)
countmap(auto[:rep78])
# two-way tables
freqtable(auto, :rep78, :foreign)

# 2. Manipulating your Data: Adding and Removing Varaiables; Sorting
# Drop observations where rep78 is missing
auto1 = auto[!isna(auto[:,:rep78]), :]

# Generate a dummy variable equaling 1 where rep78 is missing
auto[:m_rep78] = map( tempy -> isna(tempy), auto[:rep78])

# Generate a dummy variable equaling 1 where price is greater than 4000
auto[:z] = map( tempy -> tempy.<5, auto[:y])


# Generate a variable equaling the sum of mpg and price
auto[:mpg_plus_price] = map((tempx,tempy) -> tempx + tempy, auto[:mpg], auto[:price])

# Rename variables price and mpg as price1 and mpg1, respectively
rename!(auto, [:price,:mpg], [:price1,:mpg1])



# 3. Reshaping data
reshape1 = DataFrame(id = 1:3, sex = [0;1;0], 
                     inc1980 = [5000;2000;3000],
                     inc1981 = [5500;2200;2000],
                     inc1982 = [6000;4400;1000]);
longform1A = stack(reshape1, [:inc1980, :inc1981, :inc1982], [:id, :sex]);
sort!(longform1A, cols = [order(:id), order(:variable)])
wideform1A = unstack(longform1A, :variable, :value); 
longform1B = melt(reshape1, [:id, :sex]);
wideform1B = unstack(longform1B, :variable, :value);

reshape2 = DataFrame(id = 1:3, sex = [0;1;0], inc1980 = [5000;2000;3000], inc1981 = [5500;2200;2000],
                     inc1982 = [6000;4400;1000], ue1980 = [0;1;0], ue1981 = [1;0;0], ue1982 = [0;0;1]);
longform2A = stack(reshape2, [:inc1980, :inc1981, :inc1982], [:id, :sex]);
rename!(longform2A, :value, :inc)
longform2A[:year] = map(temp -> parse(Int,string(temp)[end-3:end]), longform2A[:variable])
delete!(longform2A, :variable)
longform2B = stack(reshape2, [:ue1980, :ue1981, :ue1982], [:id, :sex]);
rename!(longform2B, :value, :ue)
longform2B[:year] = map(temp -> parse(Int,string(temp)[end-3:end]), longform2B[:variable])
delete!(longform2B, :variable)

longform2 = join(longform2A,longform2B, on = [:id,:sex,:year], kind = :inner)

sort!(longform1A, cols = [order(:id), order(:variable)])


sort!(df, cols = [order(:x), order(:y)], rev=[true, false])


# grab a handful of rows of the first column:
println(auto[1:7,:A])
println(auto[2:6,:B])

# select rows of the frame such that the first column has an even-numbered value:
println(auto[auto[:A] % 2 .== 0, :])

# or use R-style "head" and "tail" functions:
println(head(auto,7))
println(tail(auto,2))

# Go through Stata examples of merges from their help site
# Merge (join) two data frames
names = DataFrame(ID = [1, 2, 3, 4, 5, 6], Name = ["John", "Jane", "Mark", "Ann", "Vlad", "Maria"])
jobs = DataFrame(ID = [1, 2, 3, 4, 5, 6], Job = ["Lawyer", "Doctor", "Mechanic", "Doctor", "Judge", "Pilot"])
println(names)
println(jobs)
mergedData = join(names,jobs, on = :ID, kind = :inner)
# various other kinds of joins (similar to Stata's 1:1, 1:m, m:1, m:m)




iris = dataset("datasets", "iris")
iris[:id] = 1:size(iris, 1)  # this makes it easier to unstack
d = stack(iris, [1:4]) # reshape columns 1-4 from wide to long; creates a new variable called "value" that stores the value of the given variable
println(d)
d = stack(iris, [:SepalLength, :SepalWidth], [:Species]) # control which variables get repeated when reshaping (similar to Stata's ", i(...) j(...)" nomenclature)
println(d)

# Representing factors (categories of variables)
# similar to R's as.factor and Stata's "i." and "c." notation
auto = DataFrame(id = [1, 2, 3, 4, 5, 6],
               B = ["X", "X", "X", "Y", "Y", "Y"])
println(auto)
pool!(auto, [:B]) # in R: auto$B <- as.factor(auto$B)
println(auto)

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
