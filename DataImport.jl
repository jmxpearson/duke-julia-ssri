# Pkg.add("DataRead") # calls ReadStat, which is an MIT-licensed C library for reading binary files from popular stats software packages
# using DataRead # only works on Mac OS!
# read_dta("auto.dta") # example usage

## Interface with Matlab Objects
# Pkg.add("MAT")
using MAT

# Read Matlab dataset
vars = matread("carbig.mat")
Weight       = vars["Weight"]
Acceleration = vars["Acceleration"]
Mfg          = vars["Mfg"]
cyl4         = vars["cyl4"]
Origin       = vars["Origin"]
when         = vars["when"]
Displacement = vars["Displacement"]
MPG          = vars["MPG"]
Model        = vars["Model"]
Cylinders    = vars["Cylinders"]
org          = vars["org"]
Model_Year   = vars["Model_Year"]
Horsepower   = vars["Horsepower"]

# Write Matlab dataset
X=rand(50000,5)
matwrite("tester.mat", {
    "X" => X,
    "Acceleration" => Acceleration,
    "Horsepower" => Horsepower
})

## Interface with CSVs
# Pkg.add("DataFrames")
using DataFrames

# import CSV to Data Frame (e.g. from Stata, R, Matlab, Python)
autoDF = readtable("auto.csv")
autoDF = readtable("auto.csv", nastrings=["", "na", "n/a", "missing"])

# export Data Frame to CSV (e.g. to Stata, R, Matlab, Python)
writetable("auto1.csv", autoDF)
writetable("auto1.csv", autoDF, separator = ',', header = false)

# export Data Frame to tab-delimited file (e.g. to Stata, R, Matlab, Python)
writetable("auto1.dat", autoDF, separator = '\t')

# import CSV to Data Frame (e.g. from Stata, R, Matlab, Python)
autoDF = readtable("auto.csv")
autoDF = readtable("auto.csv", nastrings=["", "na", "n/a", "missing"])

# import Julia array to tab-delimited file (e.g. to Stata, R, Matlab, Python)
writedlm("auto1.dat", autoDF, separator = '\t')

# export Julia array to tab-delimited file (e.g. to Stata, R, Matlab, Python)
writedlm("auto1.dat", autoDF, delim = '\t')
