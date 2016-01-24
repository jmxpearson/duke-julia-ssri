Pkg.add("DataRead") # calls ReadStat, which is an MIT-licensed C library for reading binary files from popular stats software packages
using DataRead

read_dta("auto.dta")
